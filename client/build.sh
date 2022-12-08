#!/usr/bin/bash

fpc src/bugattiserv.pas -FE"out/" -Fu"inc/" -O4
cp src/bugattiserv ./bugatiiserv
