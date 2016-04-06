## Configuración del cliente y Locales
export CLIENTE=HAYA
export CONTAINER_NAME=haya-db
export CUSTOM_NLS_LANG=SPANISH_SPAIN.AL32UTF8
export CUSTOM_LANG=es_ES.UTF-8

# Estado de la BD
export CURRENT_DUMP_NAME=expdp_HAYAs_PRO_20160323.dmp
export STARTING_TAG=9.2.1-hy-patch01

# Opciones para DUMP minimizado
export OPTIONAL_IMPDP_OPTIONS='schemas=HAYAMASTER,HAYA01,HAYA02,MINIREC remap_schema=MINIREC:MINIREC_HAYA PARALLEL=2'
