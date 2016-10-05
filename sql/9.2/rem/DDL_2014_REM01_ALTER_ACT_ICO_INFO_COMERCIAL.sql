--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20160920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Ampliar la tabla que contiene los datos del informe comercial.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ICO_INFO_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.

    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO						TIPO CAMPO							DESCRIPCION
    	T_ALTER(  'ICO_FECHA_RECEP_LLAVES_HAYA',	'DATE',								'Fecha recepción de llaves HAYA.'),
    	T_ALTER(  'ICO_FECHA_ENVIO_LLAVES_API',		'DATE',								'Fecha recepción de envío llaves a Api.'),
    	T_ALTER(  'ICO_RECIBIO_IMPORTE_ADM',		'NUMBER(16,2)',						'Importe recibido datos administración.'),
    	T_ALTER(  'ICO_IBI_IMPORTE_ADM',			'NUMBER(16,2)',						'Importe Ibi datos administración.'),
    	T_ALTER(  'ICO_DERRAMA_IMPORTE_ADM',		'NUMBER(16,2)',						'Importe derrama datos administración.'),
    	T_ALTER(  'ICO_DET_DERRAMA_IMPORTE_ADM',	'VARCHAR2(500 CHAR)',				'Detalle derrama datos administración.'),
    	
    	T_ALTER(  'DD_TVP_ID',						'NUMBER(16,0)',						'Tipo de vpo.'),
    	T_ALTER(  'ICO_VALOR_MAX_VPO',				'NUMBER(16,2)',						'Valor máximo vpo.'),
    	T_ALTER(  'ICO_VALOR_ESTIMADO_VENTA',		'NUMBER(16,2)',						'Valor estimado para venta.'),
    	T_ALTER(  'ICO_VALOR_ESTIMADO_RENTA',		'NUMBER(16,2)',						'Valor estimado para renta.'),
    	T_ALTER(  'ICO_OCUPADO',					'NUMBER(1,0)',						'Si el activo esta ocupado o no.'),
    	
    	T_ALTER(  'ICO_NUM_TERRAZA_DESCUBIERTA',	'NUMBER(16,0)',						'Número de terrazas descubiertas.'),
    	T_ALTER(  'ICO_DESC_TERRAZA_DESCUBIERTA',	'VARCHAR2(150 CHAR)',				'Descripción de terrazas descubiertas.'),
		T_ALTER(  'ICO_NUM_TERRAZA_CUBIERTA',		'NUMBER(16,0)',						'Número de terrazas cubiertas.'),
		T_ALTER(  'ICO_DESC_TERRAZA_CUBIERTA',		'VARCHAR2(150 CHAR)',				'Descripción de terrazas cubiertas.'),
		T_ALTER(  'ICO_DESPENSA_OTRAS_DEP',			'NUMBER(1,0)',						'Indica si el activo tiene despensa.'),
		T_ALTER(  'ICO_LAVADERO_OTRAS_DEP',			'NUMBER(1,0)',						'Indica si el activo tiene lavadero.'),
		T_ALTER(  'ICO_AZOTEA_OTRAS_DEP',			'NUMBER(1,0)',						'Indica si el activo tiene azotea.'),
		T_ALTER(  'ICO_OTROS_OTRAS_DEP',			'VARCHAR2(150 CHAR)',				'Descripción de otras dependencias.'),
		
		T_ALTER(  'ICO_PRESIDENTE_NOMBRE',			'VARCHAR2(100 CHAR)',				'Nombre del presidente comunidad propietarios.'),
		T_ALTER(  'ICO_PRESIDENTE_TELF',			'VARCHAR2(20 CHAR)',				'Teléfono del presidente comunidad propietarios.'),
		T_ALTER(  'ICO_ADMINISTRADOR_NOMBRE',		'VARCHAR2(100 CHAR)',				'Nombre del administrador comunidad propietarios.'),
		T_ALTER(  'ICO_ADMINISTRADOR_TELF',			'VARCHAR2(20 CHAR)',				'Teléfono del administrador comunidad propietarios.')
	
		);
    V_T_ALTER T_ALTER;
    

     /* TABLA: ACT_ICO_INFO_COMERCIAL -- ARRAY CON NUEVAS FOREIGN KEYS */
    TYPE T_FK IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
    			--NOMBRE FK 							CAMPO FK 				TABLA DESTINO FK 							CAMPO DESTINO FK
    	T_FK(	'FK_INFORME_DDTIPOVPO',				'DD_TVP_ID',		V_ESQUEMA||'.DD_TVP_TIPO_VPO',					'DD_TVP_ID'			)
    );
    V_T_FK T_FK;

    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *************************************************');

	
	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);

		-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			--No existe la columna y la creamos
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] -------------------------------------------');
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   ADD ('||V_T_ALTER(1)||' '||V_T_ALTER(2)||' )
			';

			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna INSERTADA en tabla, con tipo '||V_T_ALTER(2));

			-- Creamos comentario	
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(1)||' IS '''||V_T_ALTER(3)||'''';		
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[2] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario en columna creado.');
		END IF;

	END LOOP;


	-- Solo si esta activo el indicador de creacion FK, el script creara tambien las FK
	IF V_CREAR_FK = 'SI' THEN

		-- Bucle que CREA las FK de las nuevas columnas del INFORME COMERCIAL
		FOR I IN V_FK.FIRST .. V_FK.LAST
		LOOP

			V_T_FK := V_FK(I);	

			-- Verificar si la FK ya existe. Si ya existe la FK, no se hace nada.
			V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = '''||V_T_FK(1)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
			IF V_NUM_TABLAS = 0 THEN
				--No existe la FK y la creamos
				DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_FK(1)||'] -------------------------------------------');
				V_MSQL := '
					ALTER TABLE '||V_TEXT_TABLA||'
					ADD CONSTRAINT '||V_T_FK(1)||' FOREIGN KEY
					(
					  '||V_T_FK(2)||'
					)
					REFERENCES '||V_T_FK(3)||'
					(
					  '||V_T_FK(4)||' 
					)
					ON DELETE SET NULL ENABLE
				';

				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE('[3] '||V_MSQL);
				DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_FK(1)||' creada en tabla: FK en columna '||V_T_FK(2)||' hacia '||V_T_FK(3)||'.'||V_T_FK(4)||'... OK');

			END IF;

		END LOOP;

	END IF;
	
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' AMPLIADA CON COLUMNAS NUEVAS Y FKs ... OK *************************************************');
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
	


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