#!/bin/bash

hora_actual=`date +"%H%M" | tr -d ':'`

hora_limite=16:28

hora_limite=`echo $hora_limite | tr -d ':'`

echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

if [ "$hora_actual" -lt "$hora_limite" ] ; then
	echo "A tiempo"
else 
	echo "Demasiado tarde"
fi
