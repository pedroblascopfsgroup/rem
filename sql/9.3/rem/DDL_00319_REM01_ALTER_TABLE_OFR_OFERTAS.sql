--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210825
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14968
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza la tabla OFR_OFERTAS.
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
    V_TABLA VARCHAR2(50 CHAR) := 'OFR_OFERTAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COL_OLD VARCHAR2(50 CHAR) := 'OFR_NECESITA_FINANCIACION';
    V_COL_TFN VARCHAR2(50 CHAR) := 'DD_TFN_ID';
    V_COL_ETF VARCHAR2(50 CHAR) := 'DD_ETF_ID';
    V_DDSNS_ID NUMBER(16):= 0; --Variable para data default a NO del diccionario
    
    
    
 BEGIN
	
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 1 THEN 

        --Modificamos COE_SOLICITA_FINANCIACION para que sea FK de DD_SNS_SINONOSABE
        V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_OLD||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
	
        IF V_COUNT = 1 THEN 

            V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_OLD||'''
                        AND DATA_PRECISION = 16';
            EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 

            V_SQL := 'SELECT DD_SNS_ID FROM '||V_ESQUEMA||'.DD_SNS_SINONOSABE WHERE DD_SNS_CODIGO = ''02''';
            EXECUTE IMMEDIATE V_SQL INTO V_DDSNS_ID;
        
            IF V_COUNT = 0 AND V_DDSNS_ID != 0 THEN
                V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' MODIFY '||V_COL_OLD||' NUMBER (16,0) DEFAULT '||V_DDSNS_ID||'';
                EXECUTE IMMEDIATE V_SQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] Modificado el tipo de datos de '||V_COL_OLD||'');

                V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_OLD||' IS ''FK del diccionario DD_SNS_SINONOSABE''';
                EXECUTE IMMEDIATE V_SQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] Añadido comentario en '||V_COL_OLD||'');

                --La FK se crea despues de la migracion de datos porque si no da error de datos
                --DML_00855_REM01_UPDATE_OFR_OFERTAS.sql
                --V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD 
                --          CONSTRAINT FK_DD_SNS_SINONOSABE FOREIGN KEY ('||V_COL_OLD||') 
                --        REFERENCES '||V_ESQUEMA||'.DD_SNS_SINONOSABE (DD_SNS_ID) ON DELETE SET NULL';
                --EXECUTE IMMEDIATE V_SQL;

                --DBMS_OUTPUT.PUT_LINE('[INFO] Añadida FK '||V_COL_OLD||' sobre DD_SNS_SINONOSABE');
            
                DBMS_OUTPUT.PUT_LINE('[INFO] Actualizada la tabla '||V_TABLA);
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] Campo '||V_COL_OLD||' ya tiene longitud 16 y es FK de DD_SNS_SINONOSABE');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo '||V_COL_OLD||' en la tabla '||V_TABLA);
        END IF;

        -- Insertamos nuevo valor para el diccionario DD_TFN_TIPO_FINANCIACION
        V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_TFN||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
	
        IF V_COUNT = 0 THEN 
            V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD '||V_COL_TFN||' NUMBER (16,0)';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadido el campo '||V_COL_TFN||'');

            V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_TFN||' IS ''FK del diccionario DD_TFN_TIPO_FINANCIACION''';
			EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadido comentario en '||V_COL_TFN||'');

            V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD 
                            CONSTRAINT FK_DD_TFN FOREIGN KEY ('||V_COL_TFN||') 
                            REFERENCES '||V_ESQUEMA||'.DD_TFN_TIPO_FINANCIACION ('||V_COL_TFN||') ON DELETE SET NULL';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadida FK '||V_COL_TFN||' sobre DD_TFN_TIPO_FINANCIACION');
            
            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizada la tabla '||V_TABLA);
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo '||V_COL_TFN||' en la tabla '||V_TABLA);
        END IF;


        -- Insertamos nuevo valor para el diccionario DD_ETF_ENTIDAD_FINANCIERA
        V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_ETF||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
	
        IF V_COUNT = 0 THEN 
            V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD '||V_COL_ETF||' NUMBER (16,0)';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadido el campo '||V_COL_ETF||'');

            V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_ETF||' IS ''FK del diccionario DD_ETF_ENTIDAD_FINANCIERA''';
			EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadido comentario en '||V_COL_ETF||'');

            V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD 
                            CONSTRAINT FK_DD_ETF FOREIGN KEY ('||V_COL_ETF||') 
                            REFERENCES '||V_ESQUEMA||'.DD_ETF_ENTIDAD_FINANCIERA ('||V_COL_ETF||') ON DELETE SET NULL';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadida FK '||V_COL_ETF||' sobre DD_ETF_ENTIDAD_FINANCIERA');
            
            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizada la tabla '||V_TABLA);
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo '||V_COL_ETF||' en la tabla '||V_TABLA);
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
