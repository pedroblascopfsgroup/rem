LOAD DATA
TRUNCATE INTO TABLE TMP_PER_PERSONAS
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(TMP_PER_ID                           SEQUENCE,
TMP_PER_FECHA_EXTRACCION              DATE "DDMMYYYY"  nullif (TMP_PER_FECHA_EXTRACCION=BLANKS),
TMP_PER_COD_ENTIDAD,
TMP_PER_COD_CLIENTE_ENTIDAD,
TMP_PER_TIPO_PERSONA,
TMP_PER_TIPO_DOCUMENTO               "trim(:TMP_PER_TIPO_DOCUMENTO)",
TMP_PER_NIF_CIF                      "trim(:TMP_PER_NIF_CIF )",
TMP_PER_NOMBRE                       "trim(:TMP_PER_NOMBRE)",
TMP_PER_NOM50                        "trim(:TMP_PER_NOM50)",
TMP_PER_SEGMENTO                     "trim(:TMP_PER_SEGMENTO)",
TMP_PER_APELLIDO1                    "trim(:TMP_PER_APELLIDO1)",
TMP_PER_APELLIDO2                    "trim(:TMP_PER_APELLIDO2)",
TMP_PER_ECV                          "trim(:TMP_PER_ECV)",
TMP_PER_FECHA_CREACION               DATE "DDMMYYYY" nullif (TMP_PER_FECHA_CREACION=BLANKS),
TMP_PER_TELEFONO_1,
TMP_PER_TELEFONO_2,
TMP_PER_MOVIL_1,
TMP_PER_MOVIL_2,
TMP_PER_EMAIL                       "trim(:TMP_PER_EMAIL)",
TMP_PER_TELEFONO_5,
TMP_PER_TELEFONO_6,
TMP_PER_VR_OTRAS_ENT                "to_number(:TMP_PER_VR_OTRAS_ENT)/100",
TMP_PER_VR_DANIADO_OTRAS_ENT        "to_number(:TMP_PER_VR_DANIADO_OTRAS_ENT)/100",
TMP_PER_NRO_SOCIOS ,
TMP_PER_NRO_EMPLEADOS ,
TMP_PER_RIESGO                      "to_number(:TMP_PER_RIESGO)/100",
TMP_PER_EXTRA_1                     "to_number(:TMP_PER_EXTRA_1)/100",
TMP_PER_EXTRA_2                     "to_number(:TMP_PER_EXTRA_2)/100",
TMP_PER_EXTRA_3                     "to_number(:TMP_PER_EXTRA_3)/100",
TMP_PER_EXTRA_4                     "to_number(:TMP_PER_EXTRA_4)/100",
TMP_PER_EXTRA_5                     DATE "DDMMYYYY" nullif (TMP_PER_EXTRA_5=BLANKS),
TMP_PER_EXTRA_6                     DATE "DDMMYYYY" nullif (TMP_PER_EXTRA_6=BLANKS),
TMP_PER_EXTRA_7                     "to_number(:TMP_PER_EXTRA_7)/100",
TMP_PER_EXTRA_8                     "to_number(:TMP_PER_EXTRA_8)/100",
TMP_PER_EXTRA_9                     "to_number(:TMP_PER_EXTRA_9)/100",
TMP_PER_EXTRA_10                    "to_number(:TMP_PER_EXTRA_10)/100",
TMP_PER_CONTACTO                    "trim(:TMP_PER_CONTACTO)",
TMP_PER_NACIONALIDAD                "trim(:TMP_PER_NACIONALIDAD)",
TMP_PER_PAIS_NACIMIENTO             "trim(:TMP_PER_PAIS_NACIMIENTO)",
TMP_PER_SEXO                        "trim(:TMP_PER_SEXO)",
TMP_DD_TIPO_TELEFONO_1              "trim(:TMP_DD_TIPO_TELEFONO_1)",
TMP_DD_TIPO_TELEFONO_2              "trim(:TMP_DD_TIPO_TELEFONO_2)",
TMP_DD_TIPO_TELEFONO_3              "trim(:TMP_DD_TIPO_TELEFONO_3)",
TMP_DD_TIPO_TELEFONO_4              "trim(:TMP_DD_TIPO_TELEFONO_4)",
TMP_DD_TIPO_TELEFONO_5              "trim(:TMP_DD_TIPO_TELEFONO_5)",
TMP_DD_TIPO_TELEFONO_6              "trim(:TMP_DD_TIPO_TELEFONO_6)",
TMP_OFI_CODIGO,
TMP_ZON_NUM_CENTRO,
TMP_PEF_ID,
TMP_USU_USERNAME                    "trim(:TMP_USU_USERNAME)",
TMP_DD_GGE_CODIGO                   "trim(:TMP_DD_GGE_CODIGO)",
TMP_DD_POL_CODIGO                   "trim(:TMP_DD_POL_CODIGO)",
TMP_DD_REX_CODIGO                   "trim(:TMP_DD_REX_CODIGO)",
TMP_DD_RAX_CODIGO                   "trim(:TMP_DD_RAX_CODIGO)",
TMP_DD_PER_EXTRA_3_CODIGO           "trim(:TMP_DD_PER_EXTRA_3_CODIGO)",
TMP_PER_FECHA_CONSTITUCION          DATE "DDMMYYYY" nullif (TMP_PER_FECHA_CONSTITUCION=BLANKS),
TMP_PER_DATE_EXTRA1                 DATE "DDMMYYYY" nullif (TMP_PER_DATE_EXTRA1=BLANKS),
TMP_PER_DATE_EXTRA2                 DATE "DDMMYYYY" nullif (TMP_PER_DATE_EXTRA2=BLANKS),
TMP_PER_DATE_EXTRA3                 DATE "DDMMYYYY" nullif (TMP_PER_DATE_EXTRA3=BLANKS),
TMP_PER_DATE_EXTRA4                 DATE "DDMMYYYY" nullif (TMP_PER_DATE_EXTRA4=BLANKS),
TMP_PER_DATE_EXTRA5                 DATE "DDMMYYYY" nullif (TMP_PER_DATE_EXTRA5=BLANKS),
TMP_PER_DATE_EXTRA6                 DATE "DDMMYYYY" nullif (TMP_PER_DATE_EXTRA6=BLANKS),
TMP_PER_DATE_EXTRA7                 DATE "DDMMYYYY" nullif (TMP_PER_DATE_EXTRA7=BLANKS),
TMP_PER_DATE_EXTRA8                 DATE "DDMMYYYY" nullif (TMP_PER_DATE_EXTRA8=BLANKS),
TMP_PER_DATE_EXTRA9                 DATE "DDMMYYYY" nullif (TMP_PER_DATE_EXTRA9=BLANKS),
TMP_PER_DATE_EXTRA10                DATE "DDMMYYYY" nullif (TMP_PER_DATE_EXTRA10=BLANKS),
TMP_PER_FLAG_EXTRA1                 "trim(:TMP_PER_FLAG_EXTRA1)",
TMP_PER_FLAG_EXTRA2                 "trim(:TMP_PER_FLAG_EXTRA2)",
TMP_PER_FLAG_EXTRA3                 "trim(:TMP_PER_FLAG_EXTRA3)",
TMP_PER_FLAG_EXTRA4                 "trim(:TMP_PER_FLAG_EXTRA4)",
TMP_PER_FLAG_EXTRA5                 "trim(:TMP_PER_FLAG_EXTRA5)",
TMP_PER_FLAG_EXTRA6                 "trim(:TMP_PER_FLAG_EXTRA6)",
TMP_PER_FLAG_EXTRA7                 "trim(:TMP_PER_FLAG_EXTRA7)",
TMP_PER_FLAG_EXTRA8                 "trim(:TMP_PER_FLAG_EXTRA8)",
TMP_PER_FLAG_EXTRA9                 "trim(:TMP_PER_FLAG_EXTRA9)",
TMP_PER_FLAG_EXTRA10                "trim(:TMP_PER_FLAG_EXTRA10)",
TMP_PER_CHAR_EXTRA1                 "trim(:TMP_PER_CHAR_EXTRA1)",
TMP_PER_CHAR_EXTRA2                 "trim(:TMP_PER_CHAR_EXTRA2)",
TMP_PER_CHAR_EXTRA3                 "trim(:TMP_PER_CHAR_EXTRA3)",
TMP_PER_CHAR_EXTRA4                 "trim(:TMP_PER_CHAR_EXTRA4)",
TMP_PER_CHAR_EXTRA5                 "trim(:TMP_PER_CHAR_EXTRA5)",
TMP_PER_CHAR_EXTRA6                 "trim(:TMP_PER_CHAR_EXTRA6)",
TMP_PER_CHAR_EXTRA7                 "trim(:TMP_PER_CHAR_EXTRA7)",
TMP_PER_CHAR_EXTRA8                 "trim(:TMP_PER_CHAR_EXTRA8)",
TMP_PER_CHAR_EXTRA9                 "trim(:TMP_PER_CHAR_EXTRA9)",
TMP_PER_CHAR_EXTRA10                "trim(:TMP_PER_CHAR_EXTRA10)",
TMP_PER_LCHAR_EXTRA1                "trim(:TMP_PER_LCHAR_EXTRA1)",
TMP_PER_LCHAR_EXTRA2                "trim(:TMP_PER_LCHAR_EXTRA2)",
TMP_PER_LCHAR_EXTRA3                "trim(:TMP_PER_LCHAR_EXTRA3)",
TMP_PER_LCHAR_EXTRA4                "trim(:TMP_PER_LCHAR_EXTRA4)",
TMP_PER_LCHAR_EXTRA5                "trim(:TMP_PER_LCHAR_EXTRA5)",
TMP_PER_LCHAR_EXTRA6                "trim(:TMP_PER_LCHAR_EXTRA6)",
TMP_PER_LCHAR_EXTRA7                "trim(:TMP_PER_LCHAR_EXTRA7)",
TMP_PER_LCHAR_EXTRA8                "trim(:TMP_PER_LCHAR_EXTRA8)",
TMP_PER_LCHAR_EXTRA9                "trim(:TMP_PER_LCHAR_EXTRA9)",
TMP_PER_LCHAR_EXTRA10               "trim(:TMP_PER_LCHAR_EXTRA10)",
TMP_PER_RIESGO_IND                  "to_number(:TMP_PER_RIESGO_IND)/100",
TMP_PER_FECHA_CARGA                 SYSDATE,
TMP_PER_FICHERO_CARGA               "to_char('XXXXXXXX')",
USUARIOCREAR                        "to_char('BATCH_USER')",
FECHACREAR                          "cast(sysdate as timestamp)",
VERSION "0",
BORRADO  "0")













































