## Configuración del cliente y Locales
export CLIENTE=REM
export CONTAINER_NAME=rem-migracion
export CUSTOM_NLS_LANG=SPANISH_SPAIN.AL32UTF8
export CUSTOM_LANG=es_ES.UTF-8

# Estado de la BD
export CURRENT_DUMP_NAME=dump_REM_empty_20160329.dmp
export STARTING_TAG=HEAD

# Opciones para DUMP minimizado
export OPTIONAL_IMPDP_OPTIONS='schemas=REM01,REMMASTER'
