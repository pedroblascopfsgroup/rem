--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210907
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15101
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza la tabla ECO_EXPEDIENTE_COMERCIAL.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(50 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COL_SEC VARCHAR2(50 CHAR) := 'DD_SEC_ID';
    
    
    
 BEGIN
	
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 1 THEN 

        -- Insertamos nuevo valor para el diccionario DD_SEC_SUBEST_EXP_COMERCIAL
        V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_SEC||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
	
        IF V_COUNT = 0 THEN 
            V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD '||V_COL_SEC||' NUMBER (16,0)';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadido el campo '||V_COL_SEC||'');

            V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_SEC||' IS ''FK del diccionario DD_SEC_SUBEST_EXP_COMERCIAL''';
			EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadido comentario en '||V_COL_SEC||'');

            V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD 
                            CONSTRAINT FK_DD_SEC FOREIGN KEY ('||V_COL_SEC||') 
                            REFERENCES '||V_ESQUEMA||'.DD_SEC_SUBEST_EXP_COMERCIAL ('||V_COL_SEC||') ON DELETE SET NULL';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadida FK '||V_COL_SEC||' sobre DD_SEC_SUBEST_EXP_COMERCIAL');
            
            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizada la tabla '||V_TABLA);
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo '||V_COL_SEC||' en la tabla '||V_TABLA);
        END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tabla '||V_TABLA);		
	END IF;

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
