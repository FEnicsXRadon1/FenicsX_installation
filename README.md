# Spack for FEniCS on Radon1 

This should also be useful for other clusters where you want to use
components (e.g. MPI, compilers) from the `module` system.

## Setting up Spack
    

Clone and setup spack in `$HOME`,
    
    cd $HOME
    git clone -c feature.manyFiles=true https://github.com/spack/spack.git
    cd spack

Consider checking out Spack on a stable branch - default is `develop`

    cd spack
    git checkout v0.23 
    source $HOME/spack/share/spack/setup-env.sh


We want to use the cluster provided GCC compiler and OpenMPI with spack.

    module load compiler/gcc/13.3.1
    spack compiler find # You should see gcc@13.3.1 
    cat $HOME/.spack/linux/compilers.yaml # inspect

The file compiler.yalm should contains the following content 
```bash 
compilers:
- compiler:
    spec: clang@=18.1.8
    paths:
      cc: /usr/bin/clang
      cxx: /usr/bin/clang++
      f77: null
      fc: null
    flags: {}
    operating_system: almalinux8
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths: []
- compiler:
    spec: gcc@=13.3.1
    paths:
      cc: /opt/rh/gcc-toolset-13/root/usr/bin/gcc
      cxx: /opt/rh/gcc-toolset-13/root/usr/bin/g++
      f77: /opt/rh/gcc-toolset-13/root/usr/bin/gfortran
      fc: /opt/rh/gcc-toolset-13/root/usr/bin/gfortran
    flags: {}
    operating_system: almalinux8
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths: []
- compiler:
    spec: gcc@=8.5.0
    paths:
      cc: /usr/bin/gcc
      cxx: /usr/bin/g++
      f77: /usr/bin/gfortran
      fc: /usr/bin/gfortran
    flags: {}
    operating_system: almalinux8
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths: []
```    
Load openmpi and python 

    module load mpi/openmpi/5.0.7
    module load python/311

Then create `$HOME/.spack/packages.yaml` where we add all packages which are already installed in the system

    touch $HOME/.spack/packages.yaml

with the following contents:
```bash     
packages:
  krb5:
    externals:
    - spec: krb5@1.18.2
      prefix: /usr
  berkeley-db:
    externals:
    - spec: berkeley-db@5.3.28
      prefix: /usr
    - spec: berkeley-db@4.6.21
      prefix: /usr/local/berkeleydb
  autoconf:
    externals:
    - spec: autoconf@2.69
      prefix: /usr
  perl:
    externals:
    - spec: perl@5.26.3~cpanm+opcode+open+shared+threads
      prefix: /usr
  doxygen:
    externals:
    - spec: doxygen@1.8.14+graphviz~mscgen
      prefix: /usr
  subversion:
    externals:
    - spec: subversion@1.10.2
      prefix: /usr
  cmake:
    externals:
    - spec: cmake@3.26.5
      prefix: /usr
  binutils:
    externals:
    - spec: binutils@2.40.21~gold~headers
      prefix: /opt/rh/gcc-toolset-13/root/usr
    - spec: binutils@2.30.125~gold+headers
      prefix: /usr
  pkgconf:
    externals:
    - spec: pkgconf@1.4.2
      prefix: /usr
  gawk:
    externals:
    - spec: gawk@4.2.1
      prefix: /usr
  curl:
    externals:
    - spec: curl@7.61.1+gssapi+ldap+nghttp2
      prefix: /usr
  openssl:
    externals:
    - spec: openssl@1.1.1k
      prefix: /usr
  cvs:
    externals:
    - spec: cvs@1.11.23
      prefix: /usr
  automake:
    externals:
    - spec: automake@1.16.1
      prefix: /usr
  bison:
    externals:
    - spec: bison@3.0.4
      prefix: /usr
  ninja:
    externals:
    - spec: ninja@1.8.2
      prefix: /usr
  m4:
    externals:
    - spec: m4@1.4.18
      prefix: /usr
  groff:
    externals:
    - spec: groff@1.22.3
      prefix: /usr
  flex:
    externals:
    - spec: flex@2.6.1+lex
      prefix: /usr
  gettext:
    externals:
    - spec: gettext@0.19.8.1
      prefix: /usr
  libtool:
    externals:
    - spec: libtool@2.4.6
      prefix: /usr
  gmake:
    externals:
    - spec: gmake@4.2.1
      prefix: /usr
  git:
    externals:
    - spec: git@2.43.5+tcltk
      prefix: /usr
  swig:
    externals:
    - spec: swig@3.0.12
      prefix: /usr
  meson:
    externals:
    - spec: meson@0.58.2
      prefix: /usr
  findutils:
    externals:
    - spec: findutils@4.6.0
      prefix: /usr
  zlib:
    externals:
    - spec: zlib@1.2.11
      prefix: /usr
  sed:
    externals:
    - spec: sed@4.5
      prefix: /usr
  coreutils:
    externals:
    - spec: coreutils@8.30
      prefix: /usr
  tar:
    externals:
    - spec: tar@1.30
      prefix: /usr
  diffutils:
    externals:
    - spec: diffutils@3.6
      prefix: /usr
  openssh:
    externals:
    - spec: openssh@8.0p1
      prefix: /usr
  ncurses:
    externals:
    - spec: ncurses@6.1.20180224+termlib abi=6
      prefix: /usr
  xz:
    externals:
    - spec: xz@5.2.4
      prefix: /usr
  openblas:
    externals:
    - spec: openblas@0.3.15
      prefix: /usr
  bzip2:
    externals:
    - spec: bzip2@1.0.6
      prefix: /usr
  openmpi:
    externals:
    - spec: openmpi@5.0.7%gcc@=8.5.0~cuda~java~memchecker~static~wrapper-rpath fabrics=psm2,ucx
        schedulers=none
      prefix: /cluster/mpi/openmpi/5.0.7
  gcc:
    externals:
    - spec: gcc@13.3.1 languages='c,c++,fortran'
      prefix: /opt/rh/gcc-toolset-13/root/usr
      extra_attributes:
        compilers:
          c: /opt/rh/gcc-toolset-13/root/usr/bin/gcc
          cxx: /opt/rh/gcc-toolset-13/root/usr/bin/g++
          fortran: /opt/rh/gcc-toolset-13/root/usr/bin/gfortran
    - spec: gcc@8.5.0 languages='c,c++,fortran'
      prefix: /usr
      extra_attributes:
        compilers:
          c: /usr/bin/gcc
          cxx: /usr/bin/g++
          fortran: /usr/bin/gfortran
```
Create an environment and install FEniCS

    cd ~
    spack env create -d fenicsx-090
    spack env activate fenicsx-090

Edit the file fenicsx-090/spack.yalm   with the following content 
```bash

  # This is a Spack Environment file.
  #
  # It describes a set of packages to be installed, along with
  # configuration settings.
  spack:
    # add package specs to the `specs` list
    specs:
    - adios2%gcc@13.3.1+python
    - petsc%gcc@13.3.1+mumps
    - py-fenics-dolfinx@0.9.0%gcc@13.3.1 cflags=-O3 fflags=-O3
    - fenics-dolfinx@0.9.0%gcc@13.3.1+adios2
    - py-nanobind@2.2.0%gcc@13.3.1
    view: true
    concretizer:
      unify: true
    packages:
      sqlite:
        externals:
        - spec: sqlite@3.26.0+fts~functions+rtree
          prefix: /usr
      meson:
        externals: []
      python:
        externals:
        - spec: python@3.11.11+bz2+crypt+ctypes+dbm+lzma+nis+pyexpat+pythoncmd+readline+sqlite3+ssl+tix+tkinter+uuid+zlib
          prefix: /cluster/python/311
      openmpi:
        externals:
        - spec: openmpi@5.0.7~cuda~java~memchecker~static~wrapper-rpath fabrics=psm2,ucx
            schedulers=none
          prefix: /cluster/mpi/openmpi/5.0.7
    compilers: []
```

If you would have dolfinx with slepc library 
```bash

  # This is a Spack Environment file.
  #
  # It describes a set of packages to be installed, along with
  # configuration settings.
  spack:
    # add package specs to the `specs` list
    specs:
    - slepc%gcc@13.3.1
    - adios2%gcc@13.3.1+python
    - petsc%gcc@13.3.1+mumps
    - py-fenics-dolfinx@0.9.0%gcc@13.3.1 cflags=-O3 fflags=-O3
    - fenics-dolfinx@0.9.0%gcc@13.3.1+adios2+slepc
    - py-nanobind@2.2.0%gcc@13.3.1
    view: true
    concretizer:
      unify: true
    packages:
      sqlite:
        externals:
        - spec: sqlite@3.26.0+fts~functions+rtree
          prefix: /usr
      meson:
        externals: []
      python:
        externals:
        - spec: python@3.11.11+bz2+crypt+ctypes+dbm+lzma+nis+pyexpat+pythoncmd+readline+sqlite3+ssl+tix+tkinter+uuid+zlib
          prefix: /cluster/python/311
      openmpi:
        externals:
        - spec: openmpi@5.0.7~cuda~java~memchecker~static~wrapper-rpath fabrics=psm2,ucx
            schedulers=none
          prefix: /cluster/mpi/openmpi/5.0.7
    compilers: []
```

To resolve the dependency and install on login node 

    spack concretize 
    spack install -j4 

The following are also commonly used in FEniCSX scripts and may be useful

    spack add gmsh+opencascade py-numba py-scipy py-matplotlib salome-configuration@9.13.0
After adding these spec you have to resolve dependency and install them    

    spack concretize
    spack install -j4

To deactiavate the enviroment despactactivate

# Using the build


    #!/bin/bash -l
    source $HOME/spack/share/spack/setup-env.sh
    spack env activate fenicsx-090

# know issue for adios2

Workaround for broken Python module find for adios2 (seems broken in Spack)

    export PYTHONPATH=$(find $SPACK_ENV/.spack-env -type d -name 'site-packages' | grep venv):$PYTHONPATH

Other way is to  add in python script before adios2 

    import sys
    sys.path.append("/home/yourusername/spack/opt/spack/linux-almalinux8-cascadelake/gcc-13.3.1/adios2-2.10.2-sq33ctbacliucny24dtae33d55kwm5mb/lib/python3.11/site-packages")

# Slurm file 
```bash

  #!/bin/bash
  
  #SBATCH --job-name=ID_dolfinXtest
  #SBATCH --partition=compute-purley
  #SBATCH --ntasks=8
  #SBATCH --nodes=1
  ##SBATCH --tasks-per-node=1
  ##SBATCH --mem-per-cpu=32GB
  ##SBATCH --mem=0
  #
  ## Suggested batch arguments
  ##SBATCH --mail-type=ALL
  ##SBATCH --mail-user=myneme@gmail.com
  #
  ## Logging arguments (IMPORTANT)
  #SBATCH --output=slurm_%x-%j.out
  #SBATCH --error=slurm_%x-%j.err
  
  . $HOME/spack/share/spack/setup-env.sh 
  module load compiler/gcc/13.3.1
  module load mpi/openmpi/5.0.7
  module load python/311
  
  
  spack env activatefenicsx-090  
  
  srun --mpi=pmix  -n $SLURM_NTASKS python nameoffile.py
```
  

