Automated testing and orchestration framework for benchmarking parameter estimation solvers. Generates structured inputs, runs the solvers, and compiles numerical results.

# installation

To install required python libraries, you must have already installed 

* python3
* python3 virtualenv

Then run

```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

# format

## system format

A system has

* A name, which is used to distinguish it from the other systems.
* State variables
* Parameter variables, which will be specified in each instance
* A system which involve state variables, parameters, and partial derivatives of the state variables wrt time.
* Measurements

# running

The parameterized partial differential equation systems are stored in
the file `systems.json`.

The code provided can evaluate the systems with specified parameters

## generate
