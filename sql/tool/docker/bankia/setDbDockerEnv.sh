## Configuración del cliente y Locales
export CLIENTE=BANKIA
export CONTAINER_NAME=bankia-db
export CUSTOM_NLS_LANG=SPANISH_SPAIN.WE8ISO8859P15
export CUSTOM_LANG=es_ES.iso885915@euro

# Estado de la BD
export CURRENT_DUMP_NAME=9.2.4-rc02.dmp
export STARTING_TAG=9.2.4-rc02

# Opciones para DUMP minimizado
export OPTIONAL_IMPDP_OPTIONS='schemas=BANK01,BANKMASTER'