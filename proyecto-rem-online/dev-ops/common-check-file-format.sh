#!/bin/bash +x
set -e # Para errores
errors=no
if [ -f /var/jenkins/qa/find_wrong_chars.sh ]; then
	/var/jenkins/qa/find_wrong_chars.sh || errors=yes
fi
# Esto ya lo hace el SENCHA-CMD
if [ -f /var/jenkins/qa/find_comas.sh ]; then 
	/var/jenkins/qa/find_comas.sh || errors=yes
fi
if [ "$errors" == "yes" ]; then
	exit 1
fi
