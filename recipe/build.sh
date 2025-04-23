#!/bin/bash

# Make the packages.
mvn package

# Move the built packages to the $PREFIX directory.
mkdir -p $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml/target/pmml-sparkml-3.1.0.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-evaluator/target/pmml-sparkml-evaluator-3.1.0.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-example/target/pmml-sparkml-example-3.1.0.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-lightgbm/target/pmml-sparkml-lightgbm-3.1.0.jar $PREFIX/share/java
cp $SRC_DIR/pmml-sparkml-xgboost/target/pmml-sparkml-xgboost-3.1.0.jar $PREFIX/share/java
