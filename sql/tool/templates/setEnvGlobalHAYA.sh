# TEMPLATE
# Reemplazar los valores entre corchetes

#ESQUEMA es donde se va a gestionar la tabla de registro de ejecución

export VARIABLES_SUSTITUCION='#ESQUEMA#;HAYA01,#ESQUEMA_MASTER#;HAYAMASTER,#ESQUEMA_MINIREC#;MINIREC,#ESQUEMA_DWH#;RECOVERY_HAYA_DWH,#ESQUEMA_DATASTAGE#;RECOVERY_HAYA_DATASTAGE,#AUTOR#;[NOMBRE_APELLIDOS],#TABLESPACE_INDEX#;HAYA_IDX,#ESQUEMA02#:HAYA02,#TABLESPACE_INDEX_M#;HAYA_IDX'
#Indicar en MULTIENTIDAD las que se desee que se consideren para la ejecución de los scripts
export MULTIENTIDAD='BCC,SAREB' 

export SAREB='HAYA01'
export BCC='HAYA02'

export GENERATE_BAT='false'

export UNIFIED_PACKAGE='true'
