--/*
--#########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20200914
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10585
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla auxiliar para eliminar índices
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

	TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO							 
		T_ALTER(  'IDX_GLD_TBJ_TEG')
	);
    V_T_ALTER T_ALTER;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INFO] BORRAR INDICES.');

	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);
	
			V_MSQL := 'SELECT count(*) FROM USER_INDEXES WHERE INDEX_NAME = '''||V_T_ALTER(1)||''' ';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
			
			IF V_NUM > 0 THEN
				V_MSQL := 'DROP INDEX '||V_T_ALTER(1)||' ';
				DBMS_OUTPUT.PUT_LINE(V_MSQL);
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
			
		END LOOP;
				
	DBMS_OUTPUT.PUT_LINE('[INFO] INDICES BORRADOS.');
		
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
EXIT;
