# TEMPLATE
# Reemplazar los valores entre corchetes

#ESQUEMA es donde se va a gestionar la tabla de registro de ejecución


export VARIABLES_SUSTITUCION='#ESQUEMA#;BANK01,#ESQUEMA_MASTER#;BANKMASTER,#ESQUEMA_MINIREC#;MINIREC,#ESQUEMA_DWH#;RECOVERY_BANKIA_DWH,#ESQUEMA_DATASTAGE#;RECOVERY_BANKIA_DATASTAGE,#AUTOR#;[NOMBRE_APELLIDOS],#TABLESPACE_INDEX#;BANK01,#ESQUEMA02#:BANK01,#TABLESPACE_INDEX_M#;BANKMASTER'

export MD='RECOVERY_MD'
export DWH='RECOVERY_BANKIA_DWH'
export DS='RECOVERY_BANKIA_DATASTAGE'

export GENERATE_BAT='false'

export UNIFIED_PACKAGE='false'
