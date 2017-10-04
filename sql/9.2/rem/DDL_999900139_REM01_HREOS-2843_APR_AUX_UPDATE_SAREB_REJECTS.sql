--/*
--#########################################
--## AUTOR=PABLO MESEGUER
--## FECHA_CREACION=20170926
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2843
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla desnormalizada para la carga de bienes rechazados en el proceso de actualizacion activos de sareb
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

	V_TABLA VARCHAR2(30 CHAR):= 'APR_AUX_UPDATE_SAREB_REJECTS';


BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO.');
	
	V_MSQL := '
	SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''
	'
	;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM != 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '''||V_TABLA||''' YA EXISTE.');
		
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '||V_TABLA||' NO EXISTE. SE CREARÁ.');		
	

	EXECUTE IMMEDIATE '
	CREATE TABLE '||V_TABLA||' (
	ERRORCODE VARCHAR2(255 CHAR),
	ERRORMESSAGE VARCHAR2(2048 CHAR),
	ROWREJECTED VARCHAR2(2048 CHAR)
	)
	'
	;

	DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '''||V_TABLA||''' HA SIDO CREADA CON EXITO.');
  COMMIT;
  END IF;
  
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
