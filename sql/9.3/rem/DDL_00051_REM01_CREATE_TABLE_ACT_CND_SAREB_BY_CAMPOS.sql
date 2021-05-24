--/*
--#########################################
--## AUTOR=Joaquin Arnal
--## FECHA_CREACION=20200914
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11246
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla temporal de rechazos para el proceso de convivencia de Sareb
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

	V_MSQL VARCHAR2(32000 CHAR); 
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
	V_SQL VARCHAR2(4000 CHAR);
	V_NUM NUMBER(16);
	ERR_NUM NUMBER(25);  
	ERR_MSG VARCHAR2(1024 CHAR); 
	V_TABLA VARCHAR2(50 CHAR):= 'ACT_CND_SAREB_BY_CAMPOS';


BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO.');
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM = 1 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '''||V_TABLA||''' YA EXISTE.');
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
		EXECUTE IMMEDIATE V_MSQL;
		
	END IF;	

	EXECUTE IMMEDIATE '
	CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
		ACT_ID			NUMBER(38,0)
		, DD_CND_CODIGO		VARCHAR2(20 CHAR)
		, ACT_NUM_ACTIVO	VARCHAR2(250 CHAR)
		, ORIGEN		VARCHAR2(250 CHAR)
		, VALOR_ACTUAL		VARCHAR2(250 CHAR)
		, VALOR_NUEVO		VARCHAR2(250 CHAR)
		, SUBTIPO_REGISTRO 	VARCHAR2(3500 CHAR)
		, ID_REGISTRO 		NUMBER(16)
	)';

	DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '''||V_TABLA||''' HA SIDO CREADA CON ÉXITO.');
  COMMIT;
 
  
  DBMS_OUTPUT.PUT_LINE('[INFO] PROCESO FINALIZADO.');

         
EXCEPTION

   WHEN OTHERS THEN
   
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;
/
EXIT
