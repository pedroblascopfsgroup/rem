## Configuración del cliente y Locales
export CLIENTE=CAJAMAR
export CONTAINER_NAME=cajamar-bbdd
export CUSTOM_NLS_LANG=SPANISH_SPAIN.AL32UTF8
export CUSTOM_LANG=es_ES.UTF-8

# Estado de la BD
export CURRENT_DUMP_NAME=export_cajamar_19Oct2015.dmp
export STARTING_TAG=cj-dmp-19oct

# Opciones para DUMP minimizado
export OPTIONAL_IMPDP_OPTIONS='schemas=CM01,CMMASTER remap_tablespace=BANK01:DRECOVERYONL8M,TEMPORAL:TEMP'
