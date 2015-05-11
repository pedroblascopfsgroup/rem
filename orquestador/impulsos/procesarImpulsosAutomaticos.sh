#!/bin/bash
#devon:type=MSVBusquedaImpulsos
#port 2199
java -jar cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2199 devon:type=MSVBusquedaImpulsos recorrerConfImpulsos=9999
