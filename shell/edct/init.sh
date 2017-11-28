#!/bin/bash
read -p "Enter server IP separated by 'space' : " nodes


for node in ${nodes[@]}
do
   echo "User entered node :" \"$node\",
done
