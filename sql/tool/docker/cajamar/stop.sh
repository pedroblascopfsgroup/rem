#!/bin/bash

echo "Parando entorno oracle-cajamar"
docker stop oracle-cajamar
docker rm oracle-cajamar
