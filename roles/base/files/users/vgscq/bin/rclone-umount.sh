#!/bin/bash


for dir in ~/cloud/*
do
  fusermount -u "$dir"
  #echo "$dir"
done
