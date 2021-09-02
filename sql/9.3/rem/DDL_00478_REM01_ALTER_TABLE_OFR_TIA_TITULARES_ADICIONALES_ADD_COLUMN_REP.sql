--/*
--##########################################
--## AUTOR= Lara Pablo 
--## FECHA_CREACION=20210902
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14308
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
    V_USR VARCHAR2(30 CHAR) := 'HREOS-14308'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'OFR_TIA_TITULARES_ADICIONALES';
    V_LETRAS_TABLA VARCHAR2(2400 CHAR) := 'OFR_TIA';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('IAP_ID_REP',                    'NUMBER(16,0)'       , 'clave ajena del representable a la tabla IAP_INFO_ADC_PERSONA'),
        T_TIPO_DATA('TIA_FECHA_NACIMIENTO_REP',      'DATE'               , 'Fecha de nacimiento del representante'),
        T_TIPO_DATA('DD_LOC_NAC_ID_REP',             'NUMBER(16,0)'       , 'Localidad de nacimiento del representante'),
        T_TIPO_DATA('DD_PAI_NAC_ID_REP',             'NUMBER(16,0)'       , 'Pais de nacimiento del representante')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION OFR_TIA_TITULARES_ADICIONALES');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP_TIPO_DATA(1)||'''
														 and TABLE_NAME = ''OFR_TIA_TITULARES_ADICIONALES''
														 and OWNER = '''||V_ESQUEMA||'''';

		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS = 0 THEN

			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES
					   ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';

			EXECUTE IMMEDIATE V_MSQL;

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';

			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2));

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' YA EXISTE');

		END IF;

	END LOOP;

		-- Creamos FK
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_'||V_LETRAS_TABLA||'_IAP_ID_REP FOREIGN KEY (IAP_ID_REP) REFERENCES '||V_ESQUEMA|| '.IAP_INFO_ADC_PERSONA (IAP_ID))';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada.');
	
	-- Creamos FK
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_'||V_LETRAS_TABLA||'_DD_LOC_NAC_ID_REP FOREIGN KEY (DD_LOC_NAC_ID_REP) REFERENCES '||V_ESQUEMA_M|| '.DD_LOC_LOCALIDAD (DD_LOC_ID))';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada.');

	-- Creamos FK
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_'||V_LETRAS_TABLA||'_DD_PAI_NAC_ID_REP FOREIGN KEY (DD_PAI_NAC_ID_REP) REFERENCES '||V_ESQUEMA|| '.DD_PAI_PAISES (DD_PAI_ID))';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada.');



	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA OFR_TIA_TITULARES_ADICIONALES');

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
