## Configuración del cliente y Locales
export CLIENTE=HAYA
export CONTAINER_NAME=haya-db
export CUSTOM_NLS_LANG=SPANISH_SPAIN.AL32UTF8
export CUSTOM_LANG=es_ES.UTF-8

# Estado de la BD
export CURRENT_DUMP_NAME=expdp_HAYAS_VALIDACION_DESARROLLO_20151130.dmp
export STARTING_TAG=02a6de09505a696ed37cd87ce7259a53b0c5e488

# Opciones para DUMP minimizado
export OPTIONAL_IMPDP_OPTIONS='schemas=HAYA01,HAYAMASTER remap_schema=HAYA02:HAYA01,MINIREC:HAYA01'
