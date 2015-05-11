if [ ! -f ~/batch-integration/setEnv.sh ]; then
	echo "ERROR: setEnv.sh no se ha encontrado, no se puede setear en entorno"
	exit 1
fi

. ~/batch-integration/setEnv.sh

./ejecutarMarcadoExpedientes.sh

[ $? -ne 0 ] && exit 2

sleep 2

./ejecutarLimpiezaExpedientes.sh

[ $? -ne 0 ] && exit 2

sleep 2

./ejecutarRevisionExpedientesActivos.sh

[ $? -ne 0 ] && exit 2

sleep 2

./ejecutarRearquetipacionExpedientes.sh

[ $? -ne 0 ] && exit 2

sleep 2

./ejecutarArquetipado.sh

[ $? -ne 0 ] && exit 2

sleep 2


./ejecutarGeneracionExpedientes.sh


[ $? -ne 0 ] && exit 2

sleep 2

./ejecutarReparto.sh


[ $? -ne 0 ] && exit 2

sleep 2
