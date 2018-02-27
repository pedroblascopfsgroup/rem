#!/bin/bash
version=$($(dirname $0)/showversion.sh)

echo ""
cat $(dirname $0)/banner.txt
echo "Versión: $version"