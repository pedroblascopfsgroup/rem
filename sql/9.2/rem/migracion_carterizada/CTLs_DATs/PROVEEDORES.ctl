OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/PROVEEDORES.dat'
BADFILE './CTLs_DATs/bad/PROVEEDORES.bad'
DISCARDFILE './CTLs_DATs/rejects/PROVEEDORES.bad'
INTO TABLE REM01.MIG2_PVE_PROVEEDORES
TRUNCATE
TRAILING NULLCOLS
(       
        PVE_COD_UVEM                                    POSITION(1:17)                  INTEGER EXTERNAL                                                "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_UVEM),';',' '), '\"',''),'''',''),2,16))",
        PVE_COD_TIPO_PROVEEDOR                          POSITION(18:37)                 CHAR                                                            "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_TIPO_PROVEEDOR),';',' '), '\"',''),'''','')",
        PVE_NOMBRE                                      POSITION(38:287)                CHAR                                                            "REPLACE(REPLACE(REPLACE(TRIM(:PVE_NOMBRE),';',' '), '\"',''),'''','')",
        PVE_NOMBRE_COMERCIAL                            POSITION(288:537)               CHAR                                                            "REPLACE(REPLACE(REPLACE(TRIM(:PVE_NOMBRE_COMERCIAL),';',' '), '\"',''),'''','')",
        PVE_COD_TIPO_DOCUMENTO                          POSITION(538:557)               CHAR NULLIF(PVE_COD_TIPO_DOCUMENTO=BLANKS)                      "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_TIPO_DOCUMENTO),';',' '), '\"',''),'''','')",
        PVE_DOCUMENTO_ID                                POSITION(558:577)               CHAR NULLIF(PVE_DOCUMENTO_ID=BLANKS)                            "REPLACE(REPLACE(REPLACE(TRIM(:PVE_DOCUMENTO_ID),';',' '), '\"',''),'''','')",
        PVE_CON_ZONA_GEOGRAFICA                         POSITION(578:597)               CHAR NULLIF(PVE_CON_ZONA_GEOGRAFICA=BLANKS)                     "REPLACE(REPLACE(REPLACE(TRIM(:PVE_CON_ZONA_GEOGRAFICA),';',' '), '\"',''),'''','')",
        PVE_COD_PROVINCIA                               POSITION(598:617)               CHAR NULLIF(PVE_COD_PROVINCIA=BLANKS)                           "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_PROVINCIA),';',' '), '\"',''),'''','')",
        PVE_COD_LOCALIDAD                               POSITION(618:637)               CHAR NULLIF(PVE_COD_LOCALIDAD=BLANKS)                           "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_LOCALIDAD),';',' '), '\"',''),'''','')",
        PVE_COD_POSTAL                                  POSITION(638:646)               INTEGER EXTERNAL NULLIF(PVE_COD_POSTAL=BLANKS)                  "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_POSTAL),';',' '), '\"',''),'''',''),2,8))",     
        PVE_DIRECCION                                   POSITION(647:896)               CHAR NULLIF(PVE_DIRECCION=BLANKS)                               "REPLACE(REPLACE(REPLACE(TRIM(:PVE_DIRECCION),';',' '), '\"',''),'''','')",
        PVE_TELEFONO1                                   POSITION(897:916)               CHAR NULLIF(PVE_TELEFONO1=BLANKS)                               "REPLACE(REPLACE(REPLACE(TRIM(:PVE_TELEFONO1),';',' '), '\"',''),'''','')",
        PVE_TELEFONO2                                   POSITION(917:936)               CHAR NULLIF(PVE_TELEFONO2=BLANKS)                               "REPLACE(REPLACE(REPLACE(TRIM(:PVE_TELEFONO2),';',' '), '\"',''),'''','')",
        PVE_FAX                                         POSITION(937:956)               CHAR NULLIF(PVE_FAX=BLANKS)                                     "REPLACE(REPLACE(REPLACE(TRIM(:PVE_FAX),';',' '), '\"',''),'''','')",
        PVE_EMAIL                                       POSITION(957:1006)              CHAR NULLIF(PVE_EMAIL=BLANKS)                                   "REPLACE(REPLACE(REPLACE(TRIM(:PVE_EMAIL),';',' '), '\"',''),'''','')",
        PVE_PAGINA_WEB                                  POSITION(1007:1056)             CHAR NULLIF(PVE_PAGINA_WEB=BLANKS)                              "REPLACE(REPLACE(REPLACE(TRIM(:PVE_PAGINA_WEB),';',' '), '\"',''),'''','')",
        PVE_IND_FRANQUICIA                              POSITION(1057:1058)             INTEGER EXTERNAL NULLIF(PVE_IND_FRANQUICIA=BLANKS)              "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PVE_IND_FRANQUICIA),';',' '), '\"',''),'''',''),2,1))",
        PVE_IND_IVA_CAJA                                POSITION(1059:1060)             INTEGER EXTERNAL NULLIF(PVE_IND_IVA_CAJA=BLANKS)                "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PVE_IND_IVA_CAJA),';',' '), '\"',''),'''',''),2,1))",
        PVE_NUM_CUENTA                                  POSITION(1061:1110)             CHAR NULLIF(PVE_NUM_CUENTA=BLANKS)                              "REPLACE(REPLACE(REPLACE(TRIM(:PVE_NUM_CUENTA),';',' '), '\"',''),'''','')",
        PVE_COD_TIPO_COLABORADOR                        POSITION(1111:1130)             CHAR NULLIF(PVE_COD_TIPO_COLABORADOR=BLANKS)                    "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_TIPO_COLABORADOR),';',' '), '\"',''),'''','')",
        PVE_COD_TIPO_PERSONA                            POSITION(1131:1150)             CHAR NULLIF(PVE_COD_TIPO_PERSONA=BLANKS)                        "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_TIPO_PERSONA),';',' '), '\"',''),'''','')",
        PVE_RAZON_SOCIAL                                POSITION(1151:1170)             CHAR NULLIF(PVE_RAZON_SOCIAL=BLANKS)                            "REPLACE(REPLACE(REPLACE(TRIM(:PVE_RAZON_SOCIAL),';',' '), '\"',''),'''','')",
        PVE_FECHA_ALTA                                  POSITION(1171:1178)             DATE 'YYYYMMDD' NULLIF(PVE_FECHA_ALTA=BLANKS)                   "REPLACE(:PVE_FECHA_ALTA, '00000000', '')",
        PVE_FECHA_BAJA                                  POSITION(1179:1186)             DATE 'YYYYMMDD' NULLIF(PVE_FECHA_BAJA=BLANKS)                   "REPLACE(:PVE_FECHA_BAJA, '00000000', '')",
        PVE_IND_LOCALIZADO                              POSITION(1187:1188)             INTEGER EXTERNAL NULLIF(PVE_IND_LOCALIZADO=BLANKS)              "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PVE_IND_LOCALIZADO),';',' '), '\"',''),'''',''),2,1))",
        PVE_COD_ESTADO                                  POSITION(1189:1208)             CHAR NULLIF(PVE_COD_ESTADO=BLANKS)                              "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_ESTADO),';',' '), '\"',''),'''','')",
        PVE_FECHA_CONSTITUCION                          POSITION(1209:1216)             DATE 'YYYYMMDD' NULLIF(PVE_FECHA_CONSTITUCION=BLANKS)   		"REPLACE(:PVE_FECHA_CONSTITUCION, '00000000', '')",
        PVE_AMBITO                                      POSITION(1217:1316)             CHAR NULLIF(PVE_AMBITO=BLANKS)                                  "REPLACE(REPLACE(REPLACE(TRIM(:PVE_AMBITO),';',' '), '\"',''),'''','')",
        PVE_OBSERVACIONES                               POSITION(1317:1516)             CHAR NULLIF(PVE_OBSERVACIONES=BLANKS)                           "REPLACE(REPLACE(REPLACE(TRIM(:PVE_OBSERVACIONES),';',' '), '\"',''),'''','')",
        PVE_IND_HOMOLOGADO                              POSITION(1517:1518)             INTEGER EXTERNAL NULLIF(PVE_IND_HOMOLOGADO=BLANKS)              "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PVE_IND_HOMOLOGADO),';',' '), '\"',''),'''',''),2,1))",
        PVE_COD_CALIFICACION                            POSITION(1519:1538)             CHAR NULLIF(PVE_COD_CALIFICACION=BLANKS)                        "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_CALIFICACION),';',' '), '\"',''),'''','')",
        PVE_TOP                                         POSITION(1539:1540)             INTEGER EXTERNAL NULLIF(PVE_TOP=BLANKS)                         "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PVE_TOP),';',' '), '\"',''),'''',''),2,1))",
        PVE_TITULAR                                     POSITION(1541:1740)             CHAR NULLIF(PVE_TITULAR=BLANKS)                                 "REPLACE(REPLACE(REPLACE(TRIM(:PVE_TITULAR),';',' '), '\"',''),'''','')",
        PVE_IND_RETENER                                 POSITION(1741:1742)             INTEGER EXTERNAL NULLIF(PVE_IND_RETENER=BLANKS)                 "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PVE_IND_RETENER),';',' '), '\"',''),'''',''),2,1))",
        PVE_COD_MOTIVO_RETENCION                        POSITION(1743:1762)             CHAR NULLIF(PVE_COD_MOTIVO_RETENCION=BLANKS)                    "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_MOTIVO_RETENCION),';',' '), '\"',''),'''','')",
        PVE_FECHA_RETENCION                             POSITION(1763:1770)             DATE 'YYYYMMDD' NULLIF(PVE_FECHA_RETENCION=BLANKS)              "REPLACE(:PVE_FECHA_RETENCION, '00000000', '')",
        PVE_FECHA_PBC                                   POSITION(1771:1778)             DATE 'YYYYMMDD' NULLIF(PVE_FECHA_PBC=BLANKS)                    "REPLACE(:PVE_FECHA_PBC, '00000000', '')",
        PVE_COD_RES_PROCESO_BLANQUEO                    POSITION(1779:1798)             CHAR NULLIF(PVE_COD_RES_PROCESO_BLANQUEO=BLANKS)                "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_RES_PROCESO_BLANQUEO),';',' '), '\"',''),'''','')",
        PVE_COD_API_PROVEEDOR                           POSITION(1799:1802)             CHAR NULLIF(PVE_COD_API_PROVEEDOR=BLANKS)                       "REPLACE(REPLACE(REPLACE(TRIM(:PVE_COD_API_PROVEEDOR),';',' '), '\"',''),'''','')",
VALIDACION CONSTANT "0")
