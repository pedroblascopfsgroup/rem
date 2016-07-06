--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20160623
--## ARTEFACTO=proc_salida_inform_precon
--## VERSION_ARTEFACTO=1.10
--## INCIDENCIA_LINK=RECOVERY-1204
--## PRODUCTO=NO
--##
--## Finalidad: Creamos las tablas de salida de precontencioso
--## INSTRUCCIONES: Definir las variables de esquema antes de ejecutarlo.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count_copy number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_column_count_fk number(3); -- Vble. para validar la existencia de las Columnas deFK.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    v_constraint_name varchar2(32 char); -- Vble. para trabajar con una Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    TABLA VARCHAR2(30 CHAR) :='';
	
BEGIN 
	-- 1 tabla RCV_PRECON_EXPE
	TABLA := 'RCV_PRECON_EXPE';	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'||TABLA||' ...');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TRIM(UPPER(table_name)) =TRIM(UPPER('''||TABLA||'''))'; 
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF (table_count = 1) THEN
		V_MSQL := 'DROP TABLE '||TABLA;
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||'
		( 
			COD_ENTIDAD_CONTRATO		NUMBER(4,0),
			SOC_PREP					VARCHAR2(50 CHAR), 
			PRC_ID						NUMBER(16,0),
			TIPO_ASUNTO					VARCHAR2(100 CHAR),
			PCO_PRC_NOM_EXP_JUD 		VARCHAR2(250 CHAR),
			TOTAL_CNTS					NUMBER(16,0),
			IND_PER_EN_OTRO_PRC_PCO 	VARCHAR2(2 CHAR),
			IND_PER_EN_OTRO_PRC_NO_PRC 	VARCHAR2(2 CHAR),
			MIN_FECHA_POS_VENCIDA 		DATE,
			S_POS_VENCIDA 				NUMBER(32,2),
			S_POS_NO_VENCIDA			NUMBER(32,2),
			TIPO_PRC_PROPUESTO 			VARCHAR2(100 CHAR),
			TIPO_PRC_PREPARADO 			VARCHAR2(100 CHAR),
			DEMANDA_POR 				VARCHAR2(50 CHAR),
			FECHA_ALTA_PREPARACION		DATE,
			ESTADO_ACTUAL 				VARCHAR2(50 CHAR),
			DIAS_EN_GESTION 			NUMBER(16,0),
			TOTAL_DAYS_PREPARA     		NUMBER(16,0),
			FECHA_CONF_PETICION_BAJA 	DATE, 
			PROVINCIA_GARANTIA 			VARCHAR2(50 CHAR),
			PRETURNADO 					VARCHAR2(2 CHAR),
			DES_DESPACHO 				VARCHAR2(100 CHAR),
			MOTIVO_PETICION_BAJA 		VARCHAR2(50 CHAR),
			USUARIO_PETICION_BAJA		VARCHAR2(10 CHAR),
			FECHA_INICIO_ESTADO_ACTUAL 	DATE,
			FECHA_FIN_ESTADO_ACTUAL		DATE,	
			CONSTRAINT PK_'||TABLA||' PRIMARY KEY (PRC_ID)
		)
	'; 
	EXECUTE IMMEDIATE V_MSQL;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLA||'... Se ha creado la tabla auxiliar.');
		
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.'||TABLA||'... Crear tabla auxiliar.');


	-- 2 tabla RCV_PRECON_CONT
	TABLA:='RCV_PRECON_CONT';	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'||TABLA||' ...');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TRIM(UPPER(table_name)) =TRIM(UPPER('''||TABLA||'''))'; 
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF (table_count = 1) THEN
		V_MSQL := 'DROP TABLE '||TABLA;
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||'
		( 
			PRC_ID					NUMBER(16,0),
			PCO_PRC_NOM_EXP_JUD 	VARCHAR2(250 CHAR),
			FECHA_POS_VENCIDA 		DATE,
			POS_VENCIDA 			NUMBER(16,2),
			POS_NO_VENCIDA 			NUMBER(16,2),
			PRODUCTO_URSUS 			VARCHAR2(5 CHAR),		
			NUM_CONTRATO 			VARCHAR2(17 CHAR),	
			NUMERO_ESPEC 			VARCHAR2(15 CHAR),
			CNT_COD_OFICINA 		NUMBER(11,0),
			MATRIZ_ORIGEN_CNT  		VARCHAR2(50 CHAR),
			ENTIDAD_ORIGEN_CNT 		VARCHAR2(50 CHAR),
			TITULIZADO_CNT 			VARCHAR2(50 CHAR),
			FONDO_CNT 				VARCHAR2(50 CHAR)
		)
	'; 
	EXECUTE IMMEDIATE V_MSQL;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLA||'... Se ha creado la tabla auxiliar.');
		
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.'||TABLA||'... Crear tabla auxiliar.');

	-- 3 tabla RCV_PRECON_DOCU
	TABLA :='RCV_PRECON_DOCU';	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'||TABLA||' ...');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TRIM(UPPER(table_name)) =TRIM(UPPER('''||TABLA||'''))'; 
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF (table_count = 1) THEN
		V_MSQL := 'DROP TABLE '||TABLA;
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||'
		( 
			PRC_ID 					NUMBER(16,0),
			PCO_PRC_NOM_EXP_JUD 	VARCHAR2(250 CHAR),
			PRODUCTO_URSUS  		VARCHAR2(5 CHAR),
			NUM_CONTRATO 			VARCHAR2(17 CHAR),
			NUMERO_ESPEC 			VARCHAR2(15 CHAR),
			ENTIDAD_ORIGEN_CNT 		VARCHAR2(50 CHAR),
			DOCUMENTO_SOLICITADO 	VARCHAR2(250 CHAR),
			ESTADO_DOCUMENTO 		VARCHAR2(250 CHAR),
			ADJUNTOS 				VARCHAR2(2 CHAR),
			EJECUTIVO  				VARCHAR2(2 CHAR),
			TIPO_ACTOR  			VARCHAR2(250 CHAR),	
			ACTOR 					VARCHAR2(250 CHAR),
			SOLICITUD 				DATE,
			ENVIO 					DATE,
			RESULTADO 				DATE,
			RECEPCION 				DATE,
			OBSERVACIONES 			VARCHAR2(250 CHAR),
			PROTOCOLO 				VARCHAR2(50 CHAR),
			ASIENTO 				VARCHAR2(50 CHAR),
			NOTARIO 				VARCHAR2(50 CHAR),
			PLAZA_FIRMA_ESCRITURA  	VARCHAR2(50 CHAR),
			FECHA_ESCRITURA 		DATE,
			FINCA 					VARCHAR2(50 CHAR),
			TOMO 					VARCHAR2(50 CHAR),
			LIBRO 					VARCHAR2(50 CHAR),
			FOLIO 					VARCHAR2(50 CHAR),
			IDUFIR 					VARCHAR2(50 CHAR),
			NRO_REGISTRO 			VARCHAR2(50 CHAR)
		)
	'; 
	EXECUTE IMMEDIATE V_MSQL;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLA||'... Se ha creado la tabla auxiliar.');
		
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.'||TABLA||'... Crear tabla auxiliar.');

	-- 4 tabla RCV_PRECON_PERS
	TABLA :='RCV_PRECON_PERS';	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'||TABLA||' ...');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TRIM(UPPER(table_name)) =TRIM(UPPER('''||TABLA||'''))'; 
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF (table_count = 1) THEN
		V_MSQL := 'DROP TABLE '||TABLA;
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||'
		( 
			PRC_ID 			    NUMBER(16,0),
			NOMBRE_EXP_JUD  VARCHAR2(250 CHAR),
			TIPO_DOC 		    VARCHAR2(250 CHAR),
			PER_DOC_ID 		  VARCHAR2(20 CHAR),
			NOM_INTER 		  VARCHAR2(50 CHAR),
			TIPO_INTER      VARCHAR2(250 CHAR)
		)
	'; 
	EXECUTE IMMEDIATE V_MSQL;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLA||'... Se ha creado la tabla auxiliar.');
		
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.'||TABLA||'... Crear tabla auxiliar.');
	
EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(ERR_MSG);
		ROLLBACK;
		RAISE;	  
END;

/
 
EXIT;
