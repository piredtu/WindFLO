P=python
current_dir=$(shell pwd)
base_dir=${current_dir}/..

default: build clean test

# Build locally the package
# This will create a .so file that can be imported as a python module
build:
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

# Create a Docker image called windflo_python
docker_image:
	docker build -t windflo_python .

# Run the docker image in Jupyther sever mode
# You can access the server using your browser at the address http://127.0.0.1:81
# On linux and windows the IP address is different and can be found using the command
# 	$ boot2docker ip
# The password is `windflo`
jupyter_start:
	docker run -d -p 81:8888 -e 'PASSWORD=windflo' -e 'USE_HTTP=1' -v ${base_dir}:/install/WindFLO --name windflo windflo_python /notebook.sh

# Stop the jupyter server
jupyter_stop:
	docker stop windflo

# Start the jupyter server
jupyter_restart:
	docker restart windflo

jupyter_rm:
	docker rm windflo

# Run the docker image in bash mode (the container will be erased)
bash_run:
	docker run -it --rm -v ${base_dir}:/install/WindFLO windflo_python /bin/bash

.PHONY: build_ext install pip_install test clean ubuntu docker_image jupyter_start jupyter_stop jupyter_restart bash

