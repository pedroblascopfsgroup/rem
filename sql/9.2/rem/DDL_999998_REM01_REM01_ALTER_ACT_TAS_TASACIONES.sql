--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4265
--## PRODUCTO=NO
--## Finalidad: INCLUSION DE COLUMNAS
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_TAS_TASACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
			T_TIPO_DATA('TAS_VALOR_MERCADO', 'NUMBER','(16,2)', 'Específico Liberbank. Valor de Mercado del activo'),
			T_TIPO_DATA('TAS_VALOR_SEGURO', 'NUMBER','(16,2)', 'Específico Liberbank. Valor de Seguro del activo'),
			T_TIPO_DATA('TAS_VALOR_LIQUIDATIVO', 'NUMBER','(16,2)', 'Específico Liberbank. Valor Liquidativo del activo'),
			T_TIPO_DATA('TAS_PORCENTAJE_AJUSTE', 'NUMBER','(5,2)', 'Específico Liberbank. Porcentaje de ajuste'),
			T_TIPO_DATA('TAS_TASACION_MODIFICADA', 'NUMBER','(5,2)', 'Específico Liberbank. Tasación modificada'),
			T_TIPO_DATA('TAS_CIF_TASADOR', 'VARCHAR2','(15 CHAR)', 'Específico Liberbank. Cif de la Empresa Tasadora'),
			T_TIPO_DATA('TAS_EXPEDIENTE_EXTERNO', 'VARCHAR2','(30 CHAR)', 'Específico Liberbank. Expediente'),
			T_TIPO_DATA('TAS_TECNICO_TASADOR', 'VARCHAR2','(50 CHAR)', 'Específico Liberbank. Tasador'),
			T_TIPO_DATA('TAS_FECHA_CADUCIDAD', 'DATE','', 'Específico Liberbank. Fecha de Caducidad'),
			T_TIPO_DATA('TAS_TASACION_ACTIVA', 'VARCHAR2','(1 CHAR)', 'Específico Liberbank. Tasación Activa'),
			T_TIPO_DATA('TAS_FECHA_VIGENCIA_INI', 'DATE','', 'Específico Liberbank. Fecha de Vigencia desde'),
			T_TIPO_DATA('TAS_FECHA_VIGENCIA_FIN', 'DATE','', 'Específico Liberbank. Fecha de Vigencia hasta'),
			T_TIPO_DATA('TAS_CONDICIONANTE', 'VARCHAR2','(1 CHAR)', 'Específico Liberbank. Condicionantes'),
			T_TIPO_DATA('TAS_CONDICIONANTE_OBS', 'VARCHAR2','(100 CHAR)', 'Específico Liberbank. Observaciones de los condicionantes'),
			T_TIPO_DATA('TAS_ORDEN_ECO', 'VARCHAR2','(1 CHAR)', 'Específico Liberbank. Orden Eco'),
			T_TIPO_DATA('TAS_ORDEN_ECO_OBS', 'VARCHAR2','(100 CHAR)', 'Específico Liberbank. Observaciones del orden Eco'),
			T_TIPO_DATA('TAS_ADVERTENCIAS', 'VARCHAR2','(1 CHAR)', 'Específico Liberbank. Advertencias'),
			T_TIPO_DATA('TAS_ADVERTENCIAS_OBS', 'VARCHAR2','(100 CHAR)', 'Específico Liberbank. Observaciones de las advertencias'),
			T_TIPO_DATA('TAS_PORCENTAJE_PARTICIPACION', 'NUMBER','(5,2)', 'Específico Liberbank. Porcentaje de Participación del Inmueble')
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
		
		IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||TRIM(V_TMP_TIPO_DATA(1))||'''... Ya existe');
		ELSE
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||V_TMP_TIPO_DATA(3)||')';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(4)||'''';
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... Creada');        
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
