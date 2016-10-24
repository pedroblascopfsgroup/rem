--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20161022
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en ACT_PVE_PROVEEDOR el Código proveedor unico de REM.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_REGISTRO NUMBER(16); -- Vble. para validar la existencia de un registro. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PVE_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    
    CURSOR CURSOR_COD IS SELECT PVE_COD_REM from ACT_PVE_PROVEEDOR;
    V_CONS CURSOR_COD%ROWTYPE;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_SQL := 'SELECT COUNT(*) FROM ACT_PVE_PROVEEDOR ACTPVE where ACTPVE.PVE_COD_REM IS NULL';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
		
		IF V_NUM_REGISTRO > 0 THEN
		   OPEN CURSOR_COD;
		   LOOP
		    	FETCH CURSOR_COD INTO V_CONS;
				EXIT WHEN CURSOR_COD%NOTFOUND;
					
					V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
			                    'SET PVE_COD_REM =' ||V_ESQUEMA||'.S_PVE_COD_REM.NEXTVAL WHERE PVE_COD_REM IS NULL';
			        
			      EXECUTE IMMEDIATE V_MSQL;
		          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
		               
			                    
		    END LOOP;
   		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE NINGÚN REGISTRO PVE_COD_REM VACIO');
			END IF;
    
    COMMIT;


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



   