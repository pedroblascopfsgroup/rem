## Configuración del cliente y Locales
export CLIENTE=REM
export CONTAINER_NAME=rem-db
export CUSTOM_NLS_LANG=SPANISH_SPAIN.AL32UTF8
export CUSTOM_LANG=es_ES.UTF-8

# Estado de la BD
export CURRENT_DUMP_NAME=expdp_REMs_20160524.dmp
export STARTING_TAG=HEAD

# Opciones para DUMP minimizado
export OPTIONAL_IMPDP_OPTIONS='schemas=REM01,REMMASTER'