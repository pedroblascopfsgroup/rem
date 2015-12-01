## Configuración del cliente y Locales
export CLIENTE=EXAMPLE
export CONTAINER_NAME=example-db
export CUSTOM_NLS_LANG=SPANISH_SPAIN.AL32UTF8
export CUSTOM_LANG=es_ES.UTF-8

# Estado de la BD
export CURRENT_DUMP_NAME=example-db-empty.dmp
export STARTING_TAG=HEAD

# Opciones para DUMP minimizado
export OPTIONAL_IMPDP_OPTIONS='schemas=MY_EXAMPLE,MY_EXAMPLEMASTER'