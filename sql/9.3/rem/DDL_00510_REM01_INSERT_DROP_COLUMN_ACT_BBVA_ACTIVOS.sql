--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17050
--## PRODUCTO=NO
--## Finalidad: insertar datos en ACT_BBVA_UIC y borrar columna BBVA_UIC de ACT_BBVA_ACTIVOS
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_BBVA_UIC'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    
  --Array que contiene los registros que se van a crear
  TYPE T_COL IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL IS TABLE OF T_COL;
  V_COL T_ARRAY_COL := T_ARRAY_COL(
    T_COL('ACT_BBVA_ACTIVOS', 'BBVA_UIC')
  );  
  V_TMP_COL T_COL;

 
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar registros');
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEXT_TABLA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN

		DBMS_OUTPUT.PUT_LINE('[INSERTAR EN '||V_TEXT_TABLA||']');
		V_SQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
					 UIC_ID  
					,ACT_ID  
					,BBVA_UIC
					,VERSION
					,USUARIOCREAR
					,FECHACREAR
					,BORRADO
				) SELECT
					'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL     
					,BBVA.ACT_ID
					,BBVA.BBVA_UIC
					,0
					,''HREOS-17050''
					,SYSDATE
					,0
				FROM '||V_ESQUEMA||'.ACT_BBVA_ACTIVOS BBVA 
				WHERE BBVA.BORRADO = 0
				AND BBVA.BBVA_UIC IS NOT NULL
				';

		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado ('|| sql%rowcount ||') registros en '||V_TEXT_TABLA||'');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('[LA TABLA '||V_TEXT_TABLA||' NO EXISTE]');
    END IF;

    DBMS_OUTPUT.PUT_LINE('[INFO] Borrar campo');
    
    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);

            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(1)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                -- Verificar si el campo ya existe
                V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(1)||''' AND COLUMN_NAME = '''||V_TMP_COL(2)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                
                IF V_NUM_TABLAS = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Borrando Columna '||V_TMP_COL(2)||'');  
                    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(1)||' DROP COLUMN '||V_TMP_COL(2)||'';
                    EXECUTE IMMEDIATE V_MSQL;   
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(1)||'.'||V_TMP_COL(2)||'... No existe.');
                END IF;    
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TMP_COL(1)||'... No existe.');  
            END IF;
    
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
  
    
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

EXIT;
