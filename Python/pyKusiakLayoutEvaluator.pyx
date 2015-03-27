# distutils: language = c++
# distutils: include_dirs = ../C++
# distutils: sources = ../C++/tinyxml2.cpp ../C++/WindScenario.cpp ../C++/WindFarmLayoutEvaluator.cpp ../C++/KusiakLayoutEvaluator.cpp

import numpy as np
cimport numpy as np
from libcpp.vector cimport vector

## Interface to the Matrix class ----------------------------------------
cdef extern from "Matrix.hpp":
    cdef cppclass Matrix[T]:
        Matrix()
        Matrix(int, int, vector[T] elements)
        int rows
        int cols
        vector[T] getElements() # <- Added function to extract elements

cdef matrixdouble2array(Matrix[double] m):
    """ Creates an ndarray from a Matrix[double]
    This requires a modification of Matrix.hpp to add the `getElements` 
    method.
    """
    return np.array(m.getElements()).reshape(m.rows, m.cols)

cdef Matrix[double] array2matrixdouble(np.ndarray a):
    """Creates a Matrix[double] from an array"""
    return Matrix[double](a.shape[0], a.shape[1], a.flatten().tolist())

## Interface to the WindScenario class ----------------------------------
cdef extern from "WindScenario.h":
    cdef cppclass WindScenario:
        WindScenario(char*)
        WindScenario()
        int nturbines
        Matrix[double] ks
        Matrix[double] c
        Matrix[double] omegas
        Matrix[double] thetas
        Matrix[double] obstacles
        double CT
        double PRated
        double R
        double eta
        double k
        #double lambda  # Conflict with python `lambda` function
        double vCin
        double vCout
        double vRated
        double wakeFreeEnergy
        double width
        double height

## Cython implementation of the WindScenario C++ class ------------------
cdef class PyWindScenario:
    cdef WindScenario *thisptr # pointer to the C++ instance wrapped
    def __cinit__(self, char* sc):
        self.thisptr = new WindScenario(sc)
    def __dealloc__(self):
        del self.thisptr

    property nturbines:
        def __get__(self): return self.thisptr.nturbines
    property ks:
        def __get__(self): return matrixdouble2array(self.thisptr.ks)
        def __set__(self, x): self.thisptr.ks = array2matrixdouble(x)
    property c:
        def __get__(self): return matrixdouble2array(self.thisptr.c)
        def __set__(self, x): self.thisptr.c = array2matrixdouble(x)
    property omegas:
        def __get__(self): return matrixdouble2array(self.thisptr.omegas)
        def __set__(self, x): self.thisptr.omegas = array2matrixdouble(x)
    property thetas:
        def __get__(self): return matrixdouble2array(self.thisptr.thetas)
        def __set__(self, x): self.thisptr.thetas = array2matrixdouble(x)
    property obstacles:
        def __get__(self): return matrixdouble2array(self.thisptr.obstacles)
        def __set__(self, x): self.thisptr.obstacles = array2matrixdouble(x)
    property CT:
        def __get__(self): return self.thisptr.CT
        def __set__(self, x): self.thisptr.CT = x
    property PRated:
        def __get__(self): return self.thisptr.PRated
        def __set__(self, x): self.thisptr.PRated = x
    property R:
        def __get__(self): return self.thisptr.R
        def __set__(self, x): self.thisptr.R = x
    property eta:
        def __get__(self): return self.thisptr.eta
        def __set__(self, x): self.thisptr.eta = x
    property k:
        def __get__(self): return self.thisptr.k
        def __set__(self, x): self.thisptr.k = x
    #property lambda:
    #    def __get__(self): return self.thisptr.lambda
    #    def __set__(self, x): self.thisptr.lambda = x
    property vCin:
        def __get__(self): return self.thisptr.vCin
        def __set__(self, x): self.thisptr.vCin = x
    property vCout:
        def __get__(self): return self.thisptr.vCout
        def __set__(self, x): self.thisptr.vCout = x
    property vRated:
        def __get__(self): return self.thisptr.vRated
        def __set__(self, x): self.thisptr.vRated = x
    property wakeFreeEnergy:
        def __get__(self): return self.thisptr.wakeFreeEnergy
        def __set__(self, x): self.thisptr.wakeFreeEnergy = x
    property width:
        def __get__(self): return self.thisptr.width
        def __set__(self, x): self.thisptr.width = x
    property height:
        def __get__(self): return self.thisptr.height
        def __set__(self, x): self.thisptr.height = x


## Interface to the KusiakLayoutEvaluator class -------------------------
cdef extern from "KusiakLayoutEvaluator.h":
    cdef cppclass KusiakLayoutEvaluator:
        KusiakLayoutEvaluator()
        void initialize(WindScenario&)
        double evaluate(Matrix[double]*)
        double evaluate_2014(Matrix[double]*)
        Matrix[double] getEnergyOutputs()
        Matrix[double] getTurbineFitnesses()
        double getEnergyOutput()
        double getWakeFreeRatio()
        WindScenario scenario

## Cython implementation of the KusiakLayoutEvaluator C++ class ---------
cdef class PyKusiakLayoutEvaluator:
    cdef KusiakLayoutEvaluator *thisptr  # pointer to the C++ instance wrapped
    cdef PyWindScenario scenario

    def __cinit__(self, char* sc):
        self.thisptr = new KusiakLayoutEvaluator()
        cdef WindScenario wsc = WindScenario(sc)
        self.thisptr.initialize(wsc)
        self.scenario = PyWindScenario(sc)

    def __dealloc__(self):
        del self.thisptr

    def getEnergyOutputs(self):
        return matrixdouble2array(self.thisptr.getEnergyOutputs())

    def getTurbineFitnesses(self):
        return matrixdouble2array(self.thisptr.getTurbineFitnesses())

    def getEnergyOutput(self):
        return self.thisptr.getEnergyOutput()

    def getWakeFreeRatio(self):
        return self.thisptr.getWakeFreeRatio()

    def evaluate(self, a):
        cdef Matrix[double] *m = new Matrix[double](a.shape[0], a.shape[1], a.flatten().tolist())
        return self.thisptr.evaluate(m)

    property scenario:
        def __get__(self):
            """
            TODO: get the real scenario of the thisptr C++ instance instead of 
            creating another parallel one in the __cinit__ method
            """
            return self.scenario
