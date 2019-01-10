#!/bin/bash

if [[ "$#" != "2" ]] ; then
	echo "Uso: $0 <cadena_conexion> <nombre_bpm>"
	exit 1
fi

CADENA="$1"
NOMBPM="$2"

exit | sqlplus -S -L "$CADENA" <<EOF
	whenever sqlerror exit sql.code;
	set trimspool on
	set trimout on
	set linesize 200
	select max(version_) "ULTIMA VERSION DE ${NOMBPM}" from jbpm_processdefinition where name_='${NOMBPM}';
	quit
EOF

if [[ "$?" != "0" ]] ; then
	echo "Error en la conexión a sqlplus. No le mola la cadena de conexión $CADENA"
	exit 1
fi
