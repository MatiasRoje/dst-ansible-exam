#!/bin/bash

timestamp=$(date +"%d-%m-%Y %H:%M:%S")

# Clear previous logs
> logs.txt

echo "Running tests... It can take a while"
echo "Running MySQL Tests at $timestamp" >> logs.txt
py.test --hosts='ansible://db?force_ansible=True' --ansible-inventory=inventory.yml test_mysql.py >> logs.txt 2>&1
echo "Finished MySQL Tests at $timestamp" >> logs.txt

echo "Running WordPress Tests at $timestamp" >> logs.txt
py.test --hosts='ansible://web?force_ansible=True' --ansible-inventory=inventory.yml test_wordpress.py >> logs.txt 2>&1
echo "Finished WordPress Tests at $timestamp" >> logs.txt