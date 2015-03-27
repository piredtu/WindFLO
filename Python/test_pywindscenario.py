from pyKusiakLayoutEvaluator import PyWindScenario, PyKusiakLayoutEvaluator
scenario = '../Scenarios/02.xml'
sc = PyWindScenario(scenario)

for k in dir(sc):
    print k, ':', getattr(sc, k)

t = sc.omegas

print 'ks', sc.omegas

t[0,0] = 12.

print 'new_t', t
print 'ks', sc.omegas

sc.omegas = t
print 'new_ks', sc.omegas


print 'sc.wakeFreeEnergy', sc.wakeFreeEnergy
sc.wakeFreeEnergy = 100
print 'sc.wakeFreeEnergy', sc.wakeFreeEnergy

print 'runnningt the test case'

ev = PyKusiakLayoutEvaluator(scenario)

from numpy import loadtxt
layout = loadtxt('layout.dat')
#print layout
print 'COE:', ev.evaluate(layout)
print 'Energy Capture', ev.getEnergyOutput()
print 'WakeFreeRatio', ev.getWakeFreeRatio()

print 'omegas', ev.scenario.omegas

print 'n_eval', ev.getNumberOfEvaluation()