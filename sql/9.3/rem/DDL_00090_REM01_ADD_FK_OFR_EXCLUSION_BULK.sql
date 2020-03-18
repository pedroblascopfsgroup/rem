
--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200318
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-9848
--## PRODUCTO=NO
--##
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-9848'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_SQL_VALOR VARCHAR2(2400 CHAR);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('OFR_EXCLUSION_BULK', 'NUMBER(16,0)', 'FK a diccionario SINO que indica si la oferta está excluida del Bulk','FK_OFR_EXCLUSION_BULK','DD_SIN_SINO','DD_SIN_ID')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION OFR_OFERTAS');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP_TIPO_DATA(1)||''' 
														 and TABLE_NAME = ''OFR_OFERTAS'' 
														 and OWNER = '''||V_ESQUEMA||'''';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 1 THEN

        	V_SQL := 'SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02''';
			EXECUTE IMMEDIATE V_SQL INTO V_SQL_VALOR;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_SQL_VALOR||'');
		
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.OFR_OFERTAS
					   MODIFY ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' DEFAULT '|| V_SQL_VALOR ||')';
					   
			EXECUTE IMMEDIATE V_MSQL;

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.OFR_OFERTAS.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';

			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2));
		
		ELSE 
		
			DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' YA EXISTE');
		
		END IF;
		
	END LOOP;



    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
		V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_TMP_TIPO_DATA(4)||'''';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR SET
            OFR.'||V_TMP_TIPO_DATA(1)||' = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02'')
            WHERE OFR.'||V_TMP_TIPO_DATA(1)||' IS NULL';
            EXECUTE IMMEDIATE V_MSQL;
		
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.OFR_OFERTAS
					   ADD CONSTRAINT '||V_TMP_TIPO_DATA(4)||' FOREIGN KEY ('||V_TMP_TIPO_DATA(1)||')
                       REFERENCES '||V_ESQUEMA_M||'.'||V_TMP_TIPO_DATA(5)||' ('||V_TMP_TIPO_DATA(6)||')';
					   
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA '||V_TMP_TIPO_DATA(4));
		
		ELSE 
		
			DBMS_OUTPUT.PUT_LINE('[INFO] LA FK '||V_TMP_TIPO_DATA(4)||' YA EXISTE');
		
		END IF;
		
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA COE_CONDICIONANTES_EXPEDIENTE');
	
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;