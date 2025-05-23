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

# Make the pmml-sparkml JARs.
cd $HOME
export VERSION=2.3.2
curl -L -o $VERSION.tar.gz \
    https://github.com/jpmml/jpmml-sparkml/archive/refs/tags/$VERSION.tar.gz
tar -xzvf $VERSION.tar.gz
rm $VERSION.tar.gz
cd jpmml-sparkml-$VERSION
mvn package

# Move the built JARs to the $PREFIX/share/java directory.
mkdir -p $PREFIX/share/java
cp pmml-sparkml/target/pmml-sparkml-$VERSION.jar $PREFIX/share/java
cp pmml-sparkml-example/target/pmml-sparkml-example-$VERSION.jar $PREFIX/share/java
cp pmml-sparkml-lightgbm/target/pmml-sparkml-lightgbm-$VERSION.jar $PREFIX/share/java
cp pmml-sparkml-xgboost/target/pmml-sparkml-xgboost-$VERSION.jar $PREFIX/share/java

# Finally install the pyspark2pmml package.
cd $SRC_DIR
$PYTHON -m pip install --no-deps --no-build-isolation . -vv
