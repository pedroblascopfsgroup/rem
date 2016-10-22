--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=867
--## PRODUCTO=NO
--## Finalidad: MODIFICACION DE COLUMNAS
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    v_fk_count number(16);

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PDV_PLAN_DIN_VENTAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('PDV_ACREEDOR_NUM_EXP', 'VARCHAR2(20 CHAR)','', 'Número de expediente de riesgo de la sociedad acreedora.'),
        T_TIPO_DATA('TIPO_PRODUCTO_ACTIVO', 'VARCHAR2(20 CHAR)','', 'Tipo de producto del activo.')
     
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
BEGIN

	 -- LOOP para AÑADIR LAS COLUMNAS DE V_TIPO_DATA-----------------------------------------------------------------
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	    -- Comprobamos si existe columna 
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||TRIM(V_TMP_TIPO_DATA(1))||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||TRIM(V_TMP_TIPO_DATA(1))||'''... Ya existe');
		ELSE
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||V_TMP_TIPO_DATA(3)||')';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(4)||'''';
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... Creada');        
       	END IF;
      END LOOP;
	
    -- Comprobamos si ya existe la UK
    V_MSQL := 'SELECT count(1) CONSTRAINT_NAME FROM all_constraints where CONSTRAINT_NAME = ''UK_PDV_ACTIVO'' 
                        AND TABLE_NAME= '''||V_TEXT_TABLA||'''
                        and owner = '''||V_ESQUEMA||'''
                        ';
    EXECUTE IMMEDIATE V_MSQL INTO v_fk_count;

    IF v_fk_count = 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... No existe la UK UK_PDV_ACTIVO EN LA TABLA '||V_TEXT_TABLA||' ');
    ELSE
      EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TEXT_TABLA||' DROP CONSTRAINT UK_PDV_ACTIVO';
              
      DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'... UK UK_PDV_ACTIVO eliminada ');
    END IF;
 
    -- Comprobamos si ya existe la INDEX
    V_MSQL := 'SELECT count(1) INDEX_NAME FROM ALL_INDEXES where INDEX_NAME = ''UK_PDV_ACTIVO'' 
                        AND TABLE_NAME= '''||V_TEXT_TABLA||'''
                        and owner = '''||V_ESQUEMA||'''
                        ';
    EXECUTE IMMEDIATE V_MSQL INTO v_fk_count;

    IF v_fk_count = 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... No existe la INDEX UK_PDV_ACTIVO EN LA TABLA '||V_TEXT_TABLA||' ');
    ELSE
      
      EXECUTE IMMEDIATE ' DROP INDEX UK_PDV_ACTIVO';
              
      DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'... INDEX UK_PDV_ACTIVO eliminada ');
    END IF;
    
    COMMIT;  
  
  
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
