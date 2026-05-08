#!/bin/bash

output=$(echo $1 | sed 's/geo/msh/g')

gmsh $1 -$2 -clscale $3 -o $output

echo 'created as' $output
