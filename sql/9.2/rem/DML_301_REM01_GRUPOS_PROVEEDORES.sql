--/*
--##########################################
--## AUTOR=DANIEL GUTIÉRREZ
--## FECHA_CREACION=20160523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a un grupo a todos los usuarios de proveedores
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
        
    -- Selecciona la lista de usuarios a los que hay que crearles un grupo.
    CURSOR GRUPOS IS
    	SELECT DISTINCT USU.USU_ID, USU.USU_USERNAME FROM REM01.ACT_PVC_PROVEEDOR_CONTACTO PVC
    		JOIN REMMASTER.USU_USUARIOS USU ON USU.USU_ID = PVC.USU_ID;
    	
    FILA GRUPOS%ROWTYPE;
    
    

BEGIN	
    -- LOOP Insertando valores en FUN_PEF
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.USU_USUARIOS... Empezando a actualizar usuarios y crear grupos');
    
    OPEN GRUPOS;
    
    FETCH GRUPOS INTO FILA;
    
    WHILE GRUPOS%FOUND
      LOOP

      	DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO USUARIO: ' || FILA.USU_USERNAME);
      			V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET USU_GRUPO = 1 WHERE USU_ID = '|| FILA.USU_ID;
		EXECUTE IMMEDIATE V_MSQL;
      	
      	DBMS_OUTPUT.PUT_LINE('CREANDO GRUPO PARA: ' || FILA.USU_USERNAME);
				V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS' ||
						' (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
						' SELECT '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL,' ||
						' '|| FILA.USU_ID||',' || FILA.USU_ID ||
						', 0, ''DML'',SYSDATE,0 FROM DUAL';
						
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS insertados correctamente.');
			
		FETCH GRUPOS INTO FILA;
      END LOOP;
    COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;