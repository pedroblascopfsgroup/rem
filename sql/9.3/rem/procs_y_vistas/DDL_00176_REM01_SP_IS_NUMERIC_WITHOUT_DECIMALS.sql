--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210810
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14649
--## PRODUCTO=NO
--## Finalidad: Función para validar importesa, devuelve 0 o 1 con el resultado.
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
CREATE OR REPLACE FUNCTION IS_NUMERIC_WITHOUT_DECIMALS (VALUE_NUMERIC IN VARCHAR) RETURN NUMBER AS

    TEST_IMPORTE NUMBER(16,0);
    
	BEGIN
    
        IF VALUE_NUMERIC LIKE ''%.%'' OR VALUE_NUMERIC LIKE ''%,%'' THEN

            RETURN 0;

        ELSE 

            TEST_IMPORTE := TO_NUMBER(VALUE_NUMERIC);

            RETURN 1;

        END IF;

		EXCEPTION
		WHEN OTHERS THEN
        RETURN 0;

	END IS_NUMERIC_WITHOUT_DECIMALS;';
  
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
