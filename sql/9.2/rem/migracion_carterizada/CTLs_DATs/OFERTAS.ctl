OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/OFERTAS.dat'
BADFILE './CTLs_DATs/bad/OFERTAS.bad'
DISCARDFILE './CTLs_DATs/rejects/OFERTAS.bad'
INTO TABLE REM01.MIG2_OFR_OFERTAS
TRUNCATE
TRAILING NULLCOLS
(
	OFR_COD_OFERTA					POSITION(1:17)		INTEGER EXTERNAL												"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_OFERTA),';',' '), '\"',''),'''',''),2,16))",
	OFR_COD_AGRUPACION				POSITION(18:34)		INTEGER EXTERNAL NULLIF(OFR_COD_AGRUPACION=BLANKS)				"DECODE( TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_AGRUPACION),';',' '), '\"',''),'''',''),2,16)), '0',NULL, TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_AGRUPACION),';',' '), '\"',''),'''',''),2,16)))",
	OFR_IND_LOTE_RESTRINGIDO		POSITION(35:36)		INTEGER EXTERNAL NULLIF(OFR_IND_LOTE_RESTRINGIDO=BLANKS)		"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_IND_LOTE_RESTRINGIDO),';',' '), '\"',''),'''',''),2,1))",
	OFR_IMPORTE						POSITION(37:53)		INTEGER EXTERNAL NULLIF(OFR_IMPORTE=BLANKS)						"CASE WHEN (:OFR_IMPORTE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:OFR_IMPORTE,1,15)||','||SUBSTR(:OFR_IMPORTE,16,2)),';',' '), '\"',''),'''','')) END",
	OFR_IMPORTE_APROBADO			POSITION(54:70)		INTEGER EXTERNAL NULLIF(OFR_IMPORTE_APROBADO=BLANKS)			"CASE WHEN (:OFR_IMPORTE_APROBADO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:OFR_IMPORTE_APROBADO,1,15)||','||SUBSTR(:OFR_IMPORTE_APROBADO,16,2)),';',' '), '\"',''),'''','')) END",
	OFR_COD_CLIENTE_WEBCOM			POSITION(71:87)		INTEGER EXTERNAL NULLIF(OFR_COD_CLIENTE_WEBCOM=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_CLIENTE_WEBCOM),';',' '), '\"',''),'''',''),2,16))",
	OFR_COD_ESTADO_OFERTA			POSITION(88:107)	CHAR NULLIF(OFR_COD_ESTADO_OFERTA=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_ESTADO_OFERTA),';',' '), '\"',''),'''','')",
	OFR_ESTADO_FECHA				POSITION(108:122)	DATE 'YYYYMMDDHH24MISS' NULLIF(OFR_ESTADO_FECHA=BLANKS)			"REPLACE(:OFR_ESTADO_FECHA, '00000000 000000', '')",
	OFR_COD_TIPO_OFERTA				POSITION(123:142)	CHAR NULLIF(OFR_COD_TIPO_OFERTA=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_TIPO_OFERTA),';',' '), '\"',''),'''','')",
	OFR_COD_MOTIVO_ANULACION		POSITION(143:162)	CHAR NULLIF(OFR_COD_MOTIVO_ANULACION=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_MOTIVO_ANULACION),';',' '), '\"',''),'''','')",
	OFR_COD_VISITA_WEBCOM			POSITION(163:181)	INTEGER EXTERNAL NULLIF(OFR_COD_VISITA_WEBCOM=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_VISITA_WEBCOM),';',' '), '\"',''),'''',''),2,18))",
	OFR_COD_ESTADO_VISITA_OFR		POSITION(182:201)	CHAR NULLIF(OFR_COD_ESTADO_VISITA_OFR=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_ESTADO_VISITA_OFR),';',' '), '\"',''),'''','')",
	OFR_FECHA_ALTA					POSITION(202:216)	DATE 'YYYYMMDDHH24MISS' NULLIF(OFR_FECHA_ALTA=BLANKS)			"REPLACE(:OFR_FECHA_ALTA, '00000000 000000', '')",
	OFR_FECHA_NOTIFICACION			POSITION(217:224)	DATE 'YYYYMMDD' NULLIF(OFR_FECHA_NOTIFICACION=BLANKS)			"REPLACE(:OFR_FECHA_NOTIFICACION, '00000000', '')",
	OFR_IMPORTE_CONTRAOFERTA		POSITION(225:241)	INTEGER EXTERNAL NULLIF(OFR_IMPORTE_CONTRAOFERTA=BLANKS)		"CASE WHEN (:OFR_IMPORTE_CONTRAOFERTA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:OFR_IMPORTE_CONTRAOFERTA,1,15)||','||SUBSTR(:OFR_IMPORTE_CONTRAOFERTA,16,2)),';',' '), '\"',''),'''','')) END",
	OFR_FECHA_CONTRAOFERTA			POSITION(242:249)	DATE 'YYYYMMDD' NULLIF(OFR_FECHA_CONTRAOFERTA=BLANKS)			"REPLACE(:OFR_FECHA_CONTRAOFERTA, '00000000', '')",
	OFR_COD_USUARIO_LDAP_ACCION		POSITION(250:299)	CHAR NULLIF(OFR_COD_USUARIO_LDAP_ACCION=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_USUARIO_LDAP_ACCION),';',' '), '\"',''),'''','')",
	OFR_FECHA_RECHAZO				POSITION(300:307)	DATE 'YYYYMMDD' NULLIF(OFR_FECHA_RECHAZO=BLANKS)				"REPLACE(:OFR_FECHA_RECHAZO, '00000000', '')",
	OFR_IND_BLOQUEADA				POSITION(308:309)	INTEGER EXTERNAL NULLIF(OFR_IND_BLOQUEADA=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_IND_BLOQUEADA),';',' '), '\"',''),'''',''),2,1))",
	OFR_COD_PRESCRIPTOR_UVEM		POSITION(310:326)	INTEGER EXTERNAL NULLIF(OFR_COD_PRESCRIPTOR_UVEM=BLANKS)		"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_PRESCRIPTOR_UVEM),';',' '), '\"',''),'''',''),2,16))",
	OFR_COD_API_RESPONSABLE_UVEM	POSITION(327:343)	INTEGER EXTERNAL NULLIF(OFR_COD_API_RESPONSABLE_UVEM=BLANKS)	"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_API_RESPONSABLE_UVEM),';',' '), '\"',''),'''',''),2,16))",
	OFR_COD_CUSTODIO_UVEM			POSITION(344:360)	INTEGER EXTERNAL NULLIF(OFR_COD_CUSTODIO_UVEM=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_CUSTODIO_UVEM),';',' '), '\"',''),'''',''),2,16))",
	OFR_COD_FDV_UVEM				POSITION(361:376)	INTEGER EXTERNAL NULLIF(OFR_COD_FDV_UVEM=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_COD_FDV_UVEM),';',' '), '\"',''),'''',''),2,16))",
	OFR_OFICINA_TRAMITACION			POSITION(377:381)	CHAR NULLIF(OFR_OFICINA_TRAMITACION=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:OFR_OFICINA_TRAMITACION),';',' '), '\"',''),'''','')",
	OFR_FECHA_ANULACION				POSITION(382:389)	DATE 'YYYYMMDD' NULLIF(OFR_FECHA_ANULACION=BLANKS)				"REPLACE(:OFR_FECHA_ANULACION, '00000000', '')",
	OFR_COMITE_SANCION				POSITION(390:409)	CHAR NULLIF(OFR_COMITE_SANCION=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:OFR_COMITE_SANCION),';',' '), '\"',''),'''','')",
	OFR_FECHA_SANCION_COMITE		POSITION(410:417)	DATE 'YYYYMMDD' NULLIF(OFR_FECHA_SANCION_COMITE=BLANKS)			"REPLACE(:OFR_FECHA_SANCION_COMITE, '00000000', '')",
VALIDACION CONSTANT "0")
