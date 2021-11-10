--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-13884
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
    V_USR VARCHAR2(30 CHAR) := 'HREOS-13884'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('ID_PARTIDA')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION APR_AUX_I_RU_FACT_SIN_PROV');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP_TIPO_DATA(1)||''' 
														 and TABLE_NAME = ''APR_AUX_I_RU_FACT_SIN_PROV''';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 1 THEN
		
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.APR_AUX_I_RU_FACT_SIN_PROV
					   MODIFY '||V_TMP_TIPO_DATA(1)||' VARCHAR2(24 CHAR)';
					   
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADA '||V_TMP_TIPO_DATA(1));
		
		ELSE 
		
			DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA '||V_TMP_TIPO_DATA(1)||' NO EXISTE');
		
		END IF;
		
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA APR_AUX_I_RU_FACT_SIN_PROV');
	
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
