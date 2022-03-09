--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17208
--## PRODUCTO=NO
--## Finalidad: Cambiar longitud ELEMENTO_PEP en las tablas PEP2022
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
	TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLA IS TABLE OF T_TABLA;
	
    M_TABLA T_ARRAY_TABLA := T_ARRAY_TABLA(		
   		T_TABLA('APR_AUX_I_RU_LFACT_SIN_PROV'),
   		T_TABLA('APR_AUX_I_RU_FACT_PROV'),
   		T_TABLA('GLD_GASTOS_LINEA_DETALLE'),
   		T_TABLA('GLD_ENT'),
   		T_TABLA('DD_ETG_EQV_TIPO_GASTO')

	); 
		V_TMP_TABLA T_TABLA;


BEGIN
	FOR I IN M_TABLA.FIRST .. M_TABLA.LAST
    LOOP
	V_TMP_TABLA := M_TABLA(I);	


		DBMS_OUTPUT.PUT_LINE('********' ||V_TMP_TABLA(1)|| '********'); 
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TMP_TABLA(1)||'... Comprobaciones previas *************************************************');

		--  MODIFICA la nueva ELEMENTO_PEP

			-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
			V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = ''ELEMENTO_PEP'' and TABLE_NAME = '''||V_TMP_TABLA(1)||''' and owner = '''||V_ESQUEMA||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
			IF V_NUM_TABLAS = 0 THEN
				--No existe la columna y la creamos
				DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TMP_TABLA(1)||'[ELEMENTO_PEP] -------------------------------------------');
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_TABLA(1)|| ' 
						ADD (ELEMENTO_PEP VARCHAR2(30 CHAR) ) 
				';

				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ... ELEMENTO_PEP Columna INSERTADA en tabla, con tipo VARCHAR2(30 CHAR)');

				-- Creamos comentario	
				V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TMP_TABLA(1)||'.ELEMENTO_PEP IS ''Elemento PEP''';		
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TMP_TABLA(1)||'... Comentario en columna creado.');

			ELSE
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_TABLA(1)|| ' 
						MODIFY ELEMENTO_PEP VARCHAR2(30 CHAR)
				';

				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ... ELEMENTO_PEP modificado con tipo VARCHAR2(30 CHAR) ');
			END IF;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TMP_TABLA(1)||' ... OK *************************************************');
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
	
	END LOOP;

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