--/*
--##########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20200117
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9143
--## PRODUCTO=NO
--## Finalidad: MODIFICACION DE COLUMNAS
--##           
--## INSTRUCCIONES:
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'VIS_VISITAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
			T_TIPO_DATA('PVE_ID_PRES_OPORTUNIDAD', 'NUMBER(16,0)', 'Proveedor prescriptor de la oportunidad')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
BEGIN

	 -- LOOP para AÑADIR LAS COLUMNAS DE V_TIPO_DATA-----------------------------------------------------------------
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP      
      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
          
        -- Comprobamos si existe columna 
      V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||TRIM(V_TMP_TIPO_DATA(1))||''' and DATA_TYPE = '''||TRIM(V_TMP_TIPO_DATA(2))||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
      DBMS_OUTPUT.PUT_LINE(V_MSQL);
      IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||TRIM(V_TMP_TIPO_DATA(1))||'''... Ya existe');
        ELSE
          V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... Creada');

          V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_PVE_ID_PRES_OPORTUNIDAD FOREIGN KEY (PVE_ID_PRES_OPORTUNIDAD) REFERENCES '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR (PVE_ID))';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Constraint Creada');     

          EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';   
      END IF;
    END LOOP;
	
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