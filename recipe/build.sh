#!/bin/bash

# Download and install LightGBM, this is required for building the package using glibc 2.17.
# See https://lightgbm.readthedocs.io/en/stable/Installation-Guide.html#build-java-wrapper
cd $HOME
git clone --recursive https://github.com/microsoft/LightGBM
cd LightGBM
git fetch --tags
git checkout tags/stable -b stable
cmake -B build -S . -DUSE_SWIG=ON
cmake --build build -j $(nproc)
cp lib_lightgbm.so /lib64
cp lib_lightgbm_swig.so /lib64

# Make the JARs.
cd $SRC_DIR
mvn package

# Move the built JARs to the $PREFIX directory.
mkdir -p $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml/target/pmml-sparkml-3.1.0.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-evaluator/target/pmml-sparkml-evaluator-3.1.0.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-example/target/pmml-sparkml-example-3.1.0.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-lightgbm/target/pmml-sparkml-lightgbm-3.1.0.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-xgboost/target/pmml-sparkml-xgboost-3.1.0.jar $PREFIX/share/java
