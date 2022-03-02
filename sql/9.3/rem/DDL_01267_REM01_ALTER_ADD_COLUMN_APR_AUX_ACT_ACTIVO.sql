--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20220120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10039
--## PRODUCTO=NO
--## Finalidad: Añadir columnas a la APR_AUX_ACT_ACTIVO
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO			    TIPO CAMPO		
    	T_ALTER(  'TIPO_CONTRATO_BANKIA',   'VARCHAR2(20 CHAR)'),
        T_ALTER(  'ESTADO_ACTIVO',   'VARCHAR2(20 CHAR)'),
        T_ALTER(  'TRAMITE_ALQ_SOCIAL',   'NUMBER(1,0)'),
        T_ALTER(  'CESION_USO',   'VARCHAR2(20 CHAR)'),
        T_ALTER(  'RENUNCIA_TANTEO',   'NUMBER(1,0)'),
        T_ALTER(  'PRECIO_COMPRA',   'NUMBER(16,2)'),
        T_ALTER(  'ALTA_PRIMA_PRECIO',   'NUMBER(1,0)'),
        T_ALTER(  'TIPO_ALTA_ARRENDAMIENTO',   'VARCHAR2(20 CHAR)'),
        T_ALTER(  'OBLIGADO_CUMPLIMIENTO',   'DATE'),
        T_ALTER(  'FIANZA_OBLIGATORIA',   'NUMBER(16,2)'),
        T_ALTER(  'FECHA_REGISTRO',   'DATE'),
        T_ALTER(  'IMPORTE_GARANTIA_AVAL',   'NUMBER(16,2)'),
        T_ALTER(  'TIPO_INQUILINO',   'VARCHAR2(20 CHAR)'),
        T_ALTER(  'IMPORTE_GARANTIA_DEPOSITO',   'NUMBER(16,2)')

	);
    V_T_ALTER T_ALTER;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *************************************************');

	-- Renombramos columna, para luego copiar sus datos en la nueva columna, y borrarla finalmente.

	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);

		-- Verificar si la columna ya existe.
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN -- Si no existe la columna la creamos
			
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] ADD COLUMN------------------------------');
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   ADD ('||V_T_ALTER(1)||' '||V_T_ALTER(2)||')
			';

			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna INSERTADA en tabla, con tipo '||V_T_ALTER(2));
			
			
		ELSE 
			DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna existe en tabla, con tipo '||V_T_ALTER(2));
		END IF;

	END LOOP;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
	DBMS_OUTPUT.PUT_LINE('[INFO] Columnas añadidas correctamente');
	


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('[ERROR] ...KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
