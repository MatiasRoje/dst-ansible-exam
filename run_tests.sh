#!/bin/bash

timestamp=$(date +"%Y-%m-%d %H:%M:%S")

echo "Running MySQL Tests at $timestamp" >> logs.txt
molecule test -s default >> logs.txt 2>&1
echo "Finished MySQL Tests at $timestamp" >> logs.txt

echo "Running WordPress Tests at $timestamp" >> logs.txt
molecule test -s default >> logs.txt 2>&1
echo "Finished WordPress Tests at $timestamp" >> logs.txt