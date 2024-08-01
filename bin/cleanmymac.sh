#!/bin/bash

docker system prune -a
docker volume prune
docker network prune

rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Developer/Xcode/Archives/*
