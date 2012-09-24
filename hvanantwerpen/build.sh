#!/bin/sh

mkdir -p classes
scalac -d classes Types.scala Read.scala Plot.scala ReductionV1.scala ReductionV2.scala ReductionV3.scala Main.scala
