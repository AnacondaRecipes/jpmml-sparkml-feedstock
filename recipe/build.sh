#!/bin/bash

# Install LightGBM, this is required for building the package using glibc 2.17.
# See https://lightgbm.readthedocs.io/en/stable/Installation-Guide.html#build-java-wrapper
cd $SRC_DIR/lightgbm
export CMAKE_C_COMPILER=$CC
export CMAKE_CXX_COMPILER=$CXX
cmake -B build -S . -DUSE_SWIG=ON
cmake --build build -j $(nproc)
cp lib_lightgbm.so /lib64
cp lib_lightgbm_swig.so /lib64

# Make the pmml-sparkml JARs and move them to the $PREFIX/share/java directory.
cd $SRC_DIR/jars
mvn clean package shade:shade
export VERSION=2.3.5
mkdir -p $PREFIX/share/java
cp $SRC_DIR/jars/pmml-sparkml/target/pmml-sparkml-$VERSION.jar $PREFIX/share/java
cp $SRC_DIR/jars/pmml-sparkml-example/target/pmml-sparkml-example-$VERSION.jar $PREFIX/share/java
cp $SRC_DIR/jars/pmml-sparkml-lightgbm/target/pmml-sparkml-lightgbm-$VERSION.jar $PREFIX/share/java
cp $SRC_DIR/jars/pmml-sparkml-xgboost/target/pmml-sparkml-xgboost-$VERSION.jar $PREFIX/share/java

# Finally install the pyspark2pmml package.
cd $SRC_DIR
$PYTHON -m pip install --no-deps --no-build-isolation . -vv
