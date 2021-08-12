--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210810
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14649
--## PRODUCTO=NO
--## Finalidad: Función para validar fechas mediante la introducción de una fecha y la máscara, devuelve 0 o 1 con el resultado.
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
DBMS_OUTPUT.PUT_LINE('[INFO] Función FUNCTION IS_VALIDATE_DATE: INICIANDO...');   	 
EXECUTE IMMEDIATE '	
CREATE OR REPLACE FUNCTION IS_VALIDATE_DATE (VALUE_DATE IN VARCHAR, VALUE_MASK IN VARCHAR) RETURN NUMBER AS

    TEST_DATE DATE;
    
	BEGIN

        TEST_DATE := TO_DATE(VALUE_DATE, VALUE_MASK);

        RETURN 1;

		EXCEPTION
		WHEN OTHERS THEN
        RETURN 0;

	END IS_VALIDATE_DATE;';
  
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
