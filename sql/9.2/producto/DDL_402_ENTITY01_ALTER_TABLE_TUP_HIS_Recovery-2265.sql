--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160630
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2265
--## PRODUCTO=SI
--##
--## Finalidad: 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN
	
		    	 -- ******** CRI_CONTRATO_RIESGOOPERACIONAL - Añadir campos *******
	 
    DBMS_OUTPUT.PUT_LINE('******** TUP_HIS_HISTORICO - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''TUP_HIS_HISTORICO'' and owner = '''||V_ESQUEMA||''' and (column_name = ''ASU_ID'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS >= 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TUP_HIS_HISTORICO... El campo ASU_ID ya existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TUP_HIS_HISTORICO ADD(ASU_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TUP_HIS_HISTORICO... Añadidos los campos ASU_ID');
	END IF;
	
	
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''TUP_HIS_HISTORICO'' and owner = '''||V_ESQUEMA||''' and (column_name = ''USU_ID_REAL'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS >= 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TUP_HIS_HISTORICO... El campo USU_ID_REAL ya existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TUP_HIS_HISTORICO ADD(USU_ID_REAL NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TUP_HIS_HISTORICO... Añadidos los campos USU_ID_REAL');
	END IF;
	
	--** Comprobamos si existe la tabla FK
    V_SQL := 'select count(1) from ALL_CONSTRAINTS where constraint_name = ''TUP_HIS_ASU_FK'' and owner = upper('''||V_ESQUEMA||''')';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    IF V_NUM_TABLAS = 1 THEN 
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TUP_HIS_ASU_FK... FK ya existe');
    ELSE
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TUP_HIS_HISTORICO
	         ADD CONSTRAINT TUP_HIS_ASU_FK FOREIGN KEY (ASU_ID) REFERENCES '||V_ESQUEMA||'.ASU_ASUNTOS (ASU_ID) '; 
      	EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_HIS_ASU_FK CREADA...');
    END IF;
	
	--** Comprobamos si existe la tabla FK
    V_SQL := 'select count(1) from ALL_CONSTRAINTS where constraint_name = ''TUP_HIS_USU_FK'' and owner = upper('''||V_ESQUEMA||''')';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    IF V_NUM_TABLAS = 1 THEN 
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TUP_HIS_USU_FK... FK ya existe');
    ELSE
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TUP_HIS_HISTORICO
	         ADD CONSTRAINT TUP_HIS_USU_FK FOREIGN KEY (USU_ID_REAL) REFERENCES '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID) '; 
    	EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_HIS_USU_FK CREADA...');
    END IF;
        
           
    
    
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