#!/bin/bash

# Download and install LightGBM, this is required for building the package using glibc 2.17.
# See https://lightgbm.readthedocs.io/en/stable/Installation-Guide.html#build-java-wrapper
cd $HOME
export CMAKE_C_COMPILER=$CC
export CMAKE_CXX_COMPILER=$CXX
curl -L -o LightGBM-complete_source_code_tar_gz.tar.gz \
    https://github.com/microsoft/LightGBM/releases/download/v3.3.5/LightGBM-complete_source_code_tar_gz.tar.gz
mkdir LightGBM
tar -xzvf LightGBM-complete_source_code_tar_gz.tar.gz -C LightGBM
rm LightGBM-complete_source_code_tar_gz.tar.gz
cd LightGBM
cmake -B build -S . -DUSE_SWIG=ON
cmake --build build -j $(nproc)
cp lib_lightgbm.so /lib64
cp lib_lightgbm_swig.so /lib64

# Make the JARs.
cd $SRC_DIR
mvn package

# Move the built JARs to the $PREFIX directory.
export VERSION=2.5.3
mkdir -p $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml/target/pmml-sparkml-$VERSION.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-example/target/pmml-sparkml-example-$VERSION.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-lightgbm/target/pmml-sparkml-lightgbm-$VERSION.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-xgboost/target/pmml-sparkml-xgboost-$VERSION.jar $PREFIX/share/java
