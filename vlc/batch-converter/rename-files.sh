#!/bin/bash
for filename in *.transcoded; do mv "$filename" "${filename%%.*}.mpg"; done
