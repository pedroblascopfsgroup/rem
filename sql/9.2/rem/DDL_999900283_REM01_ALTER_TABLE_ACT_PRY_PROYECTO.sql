--/*
--##########################################
--## AUTOR=Sergio Beleña Boix
--## FECHA_CREACION=20180723
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4294
--## PRODUCTO=NO
--## Finalidad: Campo en agrupacion proyecto
--##           
--## INSTRUCCIONES: Inserta la columna PRY_GESTOR_COMERCIAL en la tabla ACT_PRY_PROYECTO
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_COLUMN_NAME VARCHAR2(2400 CHAR) := 'PRY_GESTOR_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la columna a añadir.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PRY_PROYECTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    --Array para crear las claves foraneas
    TYPE T_FK IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
    ------ ESQUEMA_ORIGEN ---- TABLA_ORIGEN -------- CAMPO_ORIGEN ---------------- ESQUEMA_DESTINO ------- TABLA_DESTINO --- CAMPO_DESTINO --- NOMBRE_F -------------------------
    T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'PRY_GESTOR_COMERCIAL'       ,''||V_ESQUEMA_M||''    ,'USU_USUARIOS'    ,'USU_ID'         ,'FK_ACT_PRY_GESTOR_COMERCIAL')
  );      
  V_TMP_FK T_FK;

BEGIN

 	-- Comprobamos si ya existe la columna que se va a añadir
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||V_COLUMN_NAME||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 1 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||V_COLUMN_NAME||'''... Ya existe');
    ELSE
      EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME||' NUMBER(16,0))';
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||'... Creada');        
    END IF;

	-- Creamos comentarios columnas
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||' IS ''Gestor comercial de la agrupación de tipo proyecto.'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    --Creamos claves foraneas
    
    DBMS_OUTPUT.PUT_LINE('[INICIO CLAVES FORANEAS]');

    FOR J IN V_FK.FIRST .. V_FK.LAST
    LOOP
        V_TMP_FK := V_FK(J);
        
        EXECUTE IMMEDIATE '
          SELECT COUNT(1)
          FROM ALL_CONSTRAINTS CONS
            INNER JOIN ALL_CONS_COLUMNS COL ON COL.CONSTRAINT_NAME = CONS.CONSTRAINT_NAME
          WHERE CONS.OWNER = '''||V_TMP_FK(1)||''' 
            AND CONS.TABLE_NAME = '''||V_TMP_FK(2)||''' 
            AND CONS.CONSTRAINT_TYPE = ''R''
            AND COL.COLUMN_NAME = '''||V_TMP_FK(3)||'''
        '
        INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('  [INFO] La FK '||V_TMP_FK(7)||'... Ya existe.');                 
        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO] Creando '||V_TMP_FK(7)||'...');           
            
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_TMP_FK(1)||'.'||V_TMP_FK(2)||' 
                ADD (CONSTRAINT '||V_TMP_FK(7)||' FOREIGN KEY ('||V_TMP_FK(3)||') 
                REFERENCES '||V_TMP_FK(4)||'.'||V_TMP_FK(5)||' ('||V_TMP_FK(6)||') ON DELETE SET NULL)
            '
            ;               
        END IF;
    
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE('[FIN CLAVES FORANEAS]');
  
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
