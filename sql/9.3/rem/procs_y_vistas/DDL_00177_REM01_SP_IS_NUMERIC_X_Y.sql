--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211007
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15423
--## PRODUCTO=NO
--## Finalidad: Función para validar coordenadas, latitud y longitud.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN
DBMS_OUTPUT.PUT_LINE('[INFO] Función FUNCTION IS_NUMERIC_WITHOUT_DECIMALS: INICIANDO...');   	 
EXECUTE IMMEDIATE '	
CREATE OR REPLACE FUNCTION IS_NUMERIC_X_Y (VALUE_NUMERIC IN VARCHAR) RETURN NUMBER AS

    V_MSQL VARCHAR2(4000 CHAR);
    TEST_NUMBER NUMBER(16,0);
    LONGITUD_ENTERO NUMBER(1,0);
    LONGITUD_DECIMALES NUMBER(1,0);
    ES_NUMERICO NUMBER(1,0);
    SIGNO_NEGATIVO NUMBER(1,0);
    SIGNO_POSITIVO NUMBER(1,0);

	BEGIN
        
        V_MSQL := ''SELECT CASE WHEN LENGTH(SUBSTR(''''''||VALUE_NUMERIC||'''''', INSTR(''''''||VALUE_NUMERIC||'''''',''''-''''), INSTR(''''''||VALUE_NUMERIC||'''''','''','''') - 1)) <= 6 OR ''''''||VALUE_NUMERIC||'''''' IS NULL THEN 1 ELSE 0 END LONGITUD_ENTERO
        , CASE WHEN LENGTH(SUBSTR(''''''||VALUE_NUMERIC||'''''', INSTR(''''''||VALUE_NUMERIC||'''''','''','''') + 1, LENGTH(''''''||VALUE_NUMERIC||''''''))) <= 15 OR ''''''||VALUE_NUMERIC||'''''' IS NULL THEN 1 ELSE 0 END LONGITUD_DECIMALES
        , CASE WHEN ISNUMERIC(REPLACE(''''''||VALUE_NUMERIC||'''''','''','''','''','''')) = 1 OR ''''''||VALUE_NUMERIC||'''''' IS NULL THEN 1 ELSE 0 END ES_NUMERICO
        , CASE WHEN INSTR(''''''||VALUE_NUMERIC||'''''',''''-'''') IN (0, 1) OR ''''''||VALUE_NUMERIC||'''''' IS NULL THEN 1 ELSE 0 END SIGNO_NEGATIVO
        , CASE WHEN INSTR(''''''||VALUE_NUMERIC||'''''',''''+'''') IN (0, 1) OR ''''''||VALUE_NUMERIC||'''''' IS NULL THEN 1 ELSE 0 END SIGNO_POSITIVO
        FROM DUAL'';
        EXECUTE IMMEDIATE V_MSQL INTO LONGITUD_ENTERO, LONGITUD_DECIMALES, ES_NUMERICO, SIGNO_NEGATIVO, SIGNO_POSITIVO;

        IF LONGITUD_ENTERO = 0 OR LONGITUD_DECIMALES = 0 OR ES_NUMERICO = 0 OR SIGNO_NEGATIVO = 0 OR SIGNO_POSITIVO = 0 THEN

            RETURN 0;

        ELSE

            TEST_NUMBER := TO_NUMBER(VALUE_NUMERIC);

            RETURN 1;

        END IF;

		EXCEPTION
		WHEN OTHERS THEN
        RETURN 0;

	END IS_NUMERIC_X_Y;';
  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Function creada.');
	
COMMIT;

EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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
