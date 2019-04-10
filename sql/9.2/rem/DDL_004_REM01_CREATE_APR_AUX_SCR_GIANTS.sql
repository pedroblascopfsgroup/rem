--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190325
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.2.0
--## INCIDENCIA_LINK=HREOS-5955
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla auxiliar para la carga de activo con su subcartera desde el DWH de Haya
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

	V_TABLA VARCHAR2(30 CHAR):= 'APR_AUX_SCR_GIANTS';


BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO.');
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM != 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '''||V_TABLA||''' YA EXISTE.');
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
		EXECUTE IMMEDIATE V_MSQL;
		
	END IF;	

	EXECUTE IMMEDIATE '
	CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
		ID_ACTIVO_HAYA 		 VARCHAR2(50 CHAR),
		ID_TIPO_ACTIVO 		 VARCHAR2(50 CHAR),
		DE_CARTERA			 VARCHAR2(50 CHAR),
		DE_SUBCARTERA_ACTUAL VARCHAR2(50 CHAR),
		ID_SUBCARTERA_ACTUAL VARCHAR2(50 CHAR),
		DE_SUBCARTERA_REO_REM VARCHAR2(50 CHAR),
		ID_SUBCARTERA_REO_REM VARCHAR2(50 CHAR)
	)';

	DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '''||V_TABLA||''' HA SIDO CREADA CON EXITO.');
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
