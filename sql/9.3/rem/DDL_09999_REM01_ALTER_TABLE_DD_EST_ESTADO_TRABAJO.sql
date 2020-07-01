--/*
--##########################################
--## AUTOR=Pablo Garcia Pallas
--## FECHA_CREACION=20200629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10436
--## PRODUCTO=NO
--## Finalidad: CREACION DE COLUMNA Y MODIFICACION DE LOS REGISTROS POBLANDO 
--##	LA NUEVA COLUMNA Y AÑADIENDO REGISTROS.
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
    V_MSQL_2 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_DOS VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla dos.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_TABLAS_DOS NUMBER(16); -- Vble. para validar la existencia de una tabla 2.
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TABLA VARCHAR2(2400 CHAR) := 'DD_EST_ESTADO_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COL VARCHAR2(256 CHAR) := 'FLAG_ACTIVO';
    V_TYPE VARCHAR2(256 CHAR) := 'NUMBER(1,0)';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('CUR','En curso','En curso','0','HREOS-10436','SYSDATE','1'),
    	T_TIPO_DATA('FIN','Finalizado','Finalizado','0','HREOS-10436','SYSDATE','1'),
    	T_TIPO_DATA('REJ','Rechazado','Rechazado','0','HREOS-10436','SYSDATE','1'),
    	T_TIPO_DATA('CAN','Cancelado','Cancelado','0','HREOS-10436','SYSDATE','1'),
    	T_TIPO_DATA('SUB','Subsanado','Subsanado','0','HREOS-10436','SYSDATE','1'),
    	T_TIPO_DATA('PCI','Pdte Cierre','Pdte Cierre','0','HREOS-10436','SYSDATE','1'),
    	T_TIPO_DATA('CIE','Cierre','Cierre','0','HREOS-10436','SYSDATE','1')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
BEGIN
	
	  DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');  

--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN                     
            -- Verificar si el campo ya existe
	
			V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS <= 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Modificando '||V_COL||'');
                 -- Modificamos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COL||' NUMBER(1,0)';   
                V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO.'||V_COL||' IS ''Indica si el campo o no esta activo.''';
				EXECUTE IMMEDIATE V_MSQL;
				
				DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_COL||' creada.');
            END IF;
            
            EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET FLAG_ACTIVO = 0';
			DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_COL||' poblada para todos los registros antiguos.');	
			
            --Se comprueba si se han insertado los nuevos registros
            -- LOOP para insertar los valores --
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA);
			FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
			  LOOP
			      
			      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			      --Comprobar el dato a insertar.
			      V_SQL_DOS := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_EST_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
			      EXECUTE IMMEDIATE V_SQL_DOS INTO V_NUM_TABLAS_DOS;
			      
			      IF V_NUM_TABLAS_DOS <= 0 THEN				
			          -- Si no existe se crea.
			          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
			          V_MSQL_2 := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (DD_EST_ID, DD_EST_CODIGO ,DD_EST_DESCRIPCION ,DD_EST_DESCRIPCION_LARGA, DD_EST_ESTADO_CONTABLE, USUARIOCREAR, FECHACREAR, FLAG_ACTIVO) 
						VALUES (
						S_'||V_TABLA||'.NEXTVAL,
						'''||V_TMP_TIPO_DATA(1)||''',
						'''||V_TMP_TIPO_DATA(2)||''',
						'''||V_TMP_TIPO_DATA(3)||''',
						'''||V_TMP_TIPO_DATA(4)||''',
						'''||V_TMP_TIPO_DATA(5)||''',
						SYSDATE,
						1)';
			          DBMS_OUTPUT.PUT_LINE(V_MSQL_2);
			          EXECUTE IMMEDIATE V_MSQL_2;
			          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
				  END IF;      
			END LOOP;
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