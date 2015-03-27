P=python

default: build_ext test clean

# Build locally the package
# This will create a .so file that can be imported as a python module
build_ext:
	$(P) setup.py build_ext --inplace

# Install the package
install:
	$(P) setup.py install

# Install everything including the python pre-requisits
# Pre-requisits are listed in the requirements.txt file
pip_install:
	pip install -r requirements.txt

# Run the test files
test:
	$(P) test_*.py

# Clean-up the extra files created
clean:
	rm -rf build *.egg-info
	rm pyKusiakLayoutEvaluator.cpp

# Clean install on a virgin ubuntu image
clean_install_ubuntu:
	sudo apt-get update && apt-get install -y -q \
		build-essential \
		make \
		gcc \
		git \
		python \
		python-dev \
		python-pip

.PHONY: build_ext install pip_install test clean ubuntu
