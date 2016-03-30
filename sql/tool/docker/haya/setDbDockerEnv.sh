## Configuración del cliente y Locales
export CLIENTE=HAYA
export CONTAINER_NAME=haya-db
export CUSTOM_NLS_LANG=SPANISH_SPAIN.AL32UTF8
export CUSTOM_LANG=es_ES.UTF-8

# Estado de la BD
export CURRENT_DUMP_NAME=expdp_HAYAS_VALIDACION_DESARROLLO_20151130.dmp
export STARTING_TAG=9.1.3-hy-rc01

# Opciones para DUMP minimizado
export OPTIONAL_IMPDP_OPTIONS='schemas=HAYAMASTER,HAYA01,HAYA02,MINIREC'
