--/*
--#########################################
--## AUTOR=VICENTE MARTINEZ CIFRE
--## FECHA_CREACION=20171017
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2872
--## PRODUCTO=NO
--## 
--## Finalidad: Ampliación de longitud del campo texto para Condiciones Específicas.
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

	V_TABLA VARCHAR2(30 CHAR):= 'ACT_COE_CONDICION_ESPECIFICA';
	V_COLUMNA VARCHAR2(30 CHAR) :='COE_TEXTO';
	TIPO VARCHAR2(30 CHAR) := 'VARCHAR2 (4000 CHAR)';

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO.');
	
	V_MSQL := '
	SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM != 0 THEN
	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY '||V_COLUMNA||' '||TIPO||'';

		EXECUTE IMMEDIATE V_MSQL;

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
