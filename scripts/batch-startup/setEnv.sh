################################
# ENTORNO DE EJECUCIÓN DEL BATCH
################################

# INICIO CONFIGURACIÓN
# Variable BASE_DIR.
# Se supone lo siguiente
#     * el directorio de instalación del batch es $BASE_DIR/batch
#     * el fichero devon.properties está en $BASE_DIR/devon.properties
export BASE_DIR=MY_BASE_DIR
# FIN CONFIGURACIÓN

export DEVON_HOME=$(echo $BASE_DIR | sed "s/^\///")
export BATCH_INSTALL_DIR=$BASE_DIR/batch
export BATCH_USER=$(whoami)


echo "PFS-BATCH Config"
echo "   batch instalado en: $BATCH_INSTALL_DIR"
echo "   config entorno    : /$DEVON_HOME/devon.properties"
