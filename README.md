# DynamicalSampling

## Dynamical Sampling &mdash; Official Matlab Implementation

Toolbox for dynamical sampling.


### (Online demo)

Numerical Experiment Preview:
**&#9733;&#9733;&#9733; NEW: [Human motion data set](http://mocap.cs.cmu.edu/) is now available &#9733;&#9733;&#9733;**

### Update

- 2021.3.22 ---  A basic framework for dynamical sampling.

### Requirements

* macOS Big Sur is supported. 
* Matlab R2020b installation. 
* [Symbolic Math Toolbox](https://www.mathworks.com/products/symbolic.html) and [Graph Signal Processing Toolbox](https://epfl-lts2.github.io/gspbox-html/) are required. 

### Features

1. We provide <Data_Mode> = "Toy Example", "Ring Graph", "Sphere Graph", "LIP", "Human walk motion".
2. We implement \<Method\>= "Prony", "ESPRIT", "Matrix Pencil" for constructing polynomial from the "hankel-form" linear system and solving its roots.
3. About \<method\>="Root_MUSIC".Note that the spectrum is formed from the product of a polynomial and its conjugated and reversed version, every root of D inside the unit circle, will have a "reflected" version outside the unit circle. We choose to use the ones inside the unit circle, because the distance from them to the unit circle will be smaller than the corresponding distance for the "reflected" root. But note that they may not be the desired spectrum. Feel free to modify the code.

### Quick Start

Before you use this repository, make sure you correctly download [Graph Signal Processing Toolbox](https://epfl-lts2.github.io/gspbox-html/) and run `gsp_start` script. 

#### How to run experiments on different prepared dataset

1. Modify the parameters in the **settings.json** file. The changable parameters are listed below.
   - Data_Mode
   - Method
   - viewpoints
2. Run **main.m** file. The program should return the Data_Mode and Method you use, and the recovered spectrum of the matrix.

### Acknowledgement

