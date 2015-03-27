# Python Wrapper for WindFLO
This is an unofficial python wrapper for the WindFLO competition.
The pyKusiakLayoutEvaluator.pyx is providing interfaces and wrapping classes to the C++ source files available in the ../C++ directory.

## Docker Image
There is an [automated build docker image](https://registry.hub.docker.com/u/piredtu/windflo) including an IPython (Jupyter) server and direct bash access. If you have [Docker](http://www.docker.com) installed, this is probably the easiest way to install everything, except if you happen to have windows 7 32bit (or older).

### Pull the image:
    
```bash
make docker_pull
```

### Build the image locally:
    
```bash
make docker_image
```

### Run the Jupyter server

```bash
make jupyter_run
```

You can access the server using your browser at the address http://127.0.0.1:81
On linux and windows the IP address is different and can be found using the command

```bash
boot2docker ip
```

The default password is `windflo`

### Stop the Jupyter server

```bash
make jupyter_stop
```

### Restart the Jupyter server

```bash
make jupyter_restart
```

### Access the container in bash mode

```bash
make bash_run
```

## Building and running locally
If you already have a working python distrib installed locally,
running `make` will build locally and run a test script file

```bash
make
```

### Installing the package
run 

```bash
make install
```

or

```bash
python setup.py install
```



