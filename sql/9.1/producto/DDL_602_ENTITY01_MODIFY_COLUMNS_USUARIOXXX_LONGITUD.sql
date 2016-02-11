--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1588
--## PRODUCTO=SI
--## Finalidad: DDL
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

	-- Se van a insertar los roles creados en DML_143_ENTITY01_INSERT_ROLES_VER_TABS.sql
	-- a todos los perfiles existentes. 

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
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_PEF
    TYPE COL_ARRAY IS VARRAY(9) OF VARCHAR2(128);
    V_COLUMNA COL_ARRAY := COL_ARRAY(
     	'USUARIOCREAR','USUARIOBORRAR','USUARIOMODIFICAR'
    );
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** CMA_CAMBIOS_MASIVOS_ASUNTOS ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CMA_CAMBIOS_MASIVOS_ASUNTOS... Comprobaciones previas'); 

    FOR I IN V_COLUMNA.FIRST .. V_COLUMNA.LAST
      LOOP
		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''CMA_CAMBIOS_MASIVOS_ASUNTOS'' and owner = '''||V_ESQUEMA||''' and column_name = '''||TRIM(V_COLUMNA(I))||'''';
	    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	    -- Si existe los valores
	    IF V_NUM_TABLAS = 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe la columna '||TRIM(V_COLUMNA(I))||' en la tabla '||V_ESQUEMA||'.CMA_CAMBIOS_MASIVOS_ASUNTOS...no se modifica nada.');
		ELSE
			IF TRIM(V_COLUMNA(I)) = 'USUARIOCREAR' THEN
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.CMA_CAMBIOS_MASIVOS_ASUNTOS' ||
						' MODIFY '||TRIM(V_COLUMNA(I))||' VARCHAR2(50 CHAR)';
			ELSE
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.CMA_CAMBIOS_MASIVOS_ASUNTOS' ||
						' MODIFY '||TRIM(V_COLUMNA(I))||' VARCHAR2(50 CHAR)';
	    	END IF;
	    	
			EXECUTE IMMEDIATE V_MSQL;
	    END IF;	
     END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.CMA_CAMBIOS_MASIVOS_ASUNTOS insertados correctamente.');

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