--/*
--##########################################
--## AUTOR=CARLOS FELIU
--## FECHA_CREACION=20160511
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a un perfil o a todos los perfiles, las funciones añadidas en T_ARRAY_FUNCION
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
        
    -- Selecciona la lista de funciones que no están en el listado de funciones del perfil super.
    CURSOR FUNCIONES IS
    	SELECT DISTINCT FUN.FUN_ID AS FUN FROM REMMASTER.FUN_FUNCIONES FUN 
    		WHERE FUN.FUN_ID NOT IN (
		        SELECT FUN2.FUN_ID FROM REMMASTER.FUN_FUNCIONES FUN2 
    				JOIN REM01.FUN_PEF FP2 ON FP2.FUN_ID = FUN2.FUN_ID 
    				JOIN REM01.PEF_PERFILES PEF2 ON PEF2.PEF_ID = FP2.PEF_ID
    				WHERE PEF2.PEF_CODIGO = 'HAYASUPER'
    			)
          AND FUN.FECHACREAR >= TO_TIMESTAMP('30/10/2015 00:00:00.000000', 'DD/MM/YYYY fmHH24fm:MI:SS.FF')
          AND FUN.FECHACREAR < TO_TIMESTAMP('01/01/2020 00:00:00.000000', 'DD/MM/YYYY fmHH24fm:MI:SS.FF')
          AND FUN.FUN_DESCRIPCION != 'MENU_DASHBOARD'
          ORDER BY FUN.FUN_ID;
    	
    FILA FUNCIONES%ROWTYPE;
    
    

BEGIN	
    -- LOOP Insertando valores en FUN_PEF
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_PEF... Empezando a insertar datos en la tabla');
    
    OPEN FUNCIONES;
    
    FETCH FUNCIONES INTO FILA;
    
    WHILE FUNCIONES%FOUND
      LOOP

		DBMS_OUTPUT.PUT_LINE('INSERTANDO PROCURADOR: ' || FILA.FUN);
		
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
						' (FP_ID, PEF_ID, FUN_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
						' SELECT '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL,' ||
						' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYASUPER''),' || FILA.FUN ||
						', ''DML'',SYSDATE,0 FROM DUAL'; 	
						
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.FUN_PEF insertados correctamente.');
			
		FETCH FUNCIONES INTO FILA;
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