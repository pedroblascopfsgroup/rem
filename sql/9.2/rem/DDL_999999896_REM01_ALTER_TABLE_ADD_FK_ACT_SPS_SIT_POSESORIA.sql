--/*
--##########################################
--## AUTOR=SERGIO SALT
--## FECHA_CREACION=20181226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK= HREOS-4887
--## PRODUCTO=NO
--##
--## Finalidad:
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLUMNAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_CONSTRAINT NUMBER(16); -- Vble. para validar la existencia de una constraint en la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN

    -------------------------------COLUMNA ACT_SPS_SIT_POSESORIA.DD_TPA_ID-------------------------

    V_SQL := 'SELECT COUNT(1)
                FROM ALL_TAB_COLUMNS
                WHERE OWNER = '''||V_ESQUEMA||'''
                AND TABLE_NAME = ''ACT_SPS_SIT_POSESORIA''
                AND COLUMN_NAME = ''DD_TPA_ID''
             ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLUMNAS;

    IF V_NUM_COLUMNAS = 0 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO NUEVA COLUMNA...');
        
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA
                	ADD DD_TPA_ID NUMBER(16,0)';
                	
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] OK. LA COLUMNA ACT_SPS_SIT_POSESORIA.DD_TPA_ID HA SIDO CREADA');
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE LA COLUMNA ACT_SPS_SIT_POSESORIA.DD_TPA_ID');
    END IF;
	
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.DD_TPA_ID IS ''CLAVE AJENA DD_TPA_TIPO_TITULO_ACT.DD_TPA_ID .''';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TPA_ID creado.');

    --------------------------------COLUMNA ACT_SPS_SIT_POSESORIA.DD_TPA_ID CONSTRAINT--------------------------

    V_SQL := 'SELECT COUNT(1)
                FROM ALL_TAB_COLUMNS
                WHERE OWNER = '''||V_ESQUEMA||'''
                AND TABLE_NAME = ''ACT_SPS_SIT_POSESORIA''
                AND COLUMN_NAME = ''DD_TPA_ID''
             ';
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLUMNAS;

    IF V_NUM_COLUMNAS = 1 THEN

        V_SQL := ' SELECT count(1)
                    FROM USER_CONS_COLUMNS
                    WHERE COLUMN_NAME = ''DD_TPA_ID'' AND
                            TABLE_NAME = ''ACT_SPS_SIT_POSESORIA'' AND
                            CONSTRAINT_NAME = ''FK_DD_TPA_ID''

                    ';

        EXECUTE IMMEDIATE V_SQL INTO V_NUM_CONSTRAINT;

        IF V_NUM_CONSTRAINT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO LA CLAVE AJENA EN DD_TPA_ID...');

            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA
                        ADD CONSTRAINT FK_DD_TPA_ID 
                        FOREIGN KEY (DD_TPA_ID)
                        REFERENCES DD_TPA_TIPO_TITULO_ACT (DD_TPA_ID)
                        ';
            
            DBMS_OUTPUT.PUT_LINE('[INFO] SE HA CREADO LA CLAVE AJENA (FK_SPS_TPA_DD_TPA_ID) SOBRE LA COLUMNA ACT_SPS_SIT_POSESORIA.DD_TPA_ID');                    	

            EXECUTE IMMEDIATE V_MSQL;
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] LA CLAVE AJENA YA EXISTE');

        END IF ;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA COLUMNA ACT_SPS_SIT_POSESORIA.DD_TPA_ID');                    	
    END IF;
    
    ---------------------------------------------------ERROR HANDLER--------------------------------------------

EXCEPTION
  	WHEN OTHERS THEN 
    	DBMS_OUTPUT.PUT_LINE('KO!');
    	err_num := SQLCODE;
   		err_msg := SQLERRM;    
   		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
   		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
   		DBMS_OUTPUT.PUT_LINE(err_msg);
   		ROLLBACK;
   		RAISE;          
END;

/

EXIT;
