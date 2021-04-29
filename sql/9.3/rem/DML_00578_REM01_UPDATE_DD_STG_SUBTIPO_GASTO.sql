--/*
--##########################################
--## AUTOR=SERGIO SALT
--## FECHA_CREACION=20210421
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13615
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar la columna DD_EEC_DESCRIPCION de la tabla DD_EEC_EST_EXP_COMERCIAL
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_STG_SUBTIPOS_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(20 CHAR) := 'HREOS-9390';
    VALIDACION VARCHAR2(2400 CHAR);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_NUM NUMBER(16); -- Vble. auxiliar
    
    
BEGIN
	
	
	 -- Verificar si la tabla ya existe
  	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  	IF V_NUM_TABLAS = 1 THEN
  	
  	
        DBMS_OUTPUT.PUT_LINE('Actualizar descripción de los conceptos'||V_TEXT_TABLA);

        -- BAS
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET DD_STG_CONCEPTO_FAC = ''BAS''
            WHERE  DD_STG_CODIGO = ''08''';
        EXECUTE IMMEDIATE V_MSQL;


        -- COM
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET DD_STG_CONCEPTO_FAC = ''COM''
            WHERE  DD_STG_CODIGO IN (''48'',''93'')';
        EXECUTE IMMEDIATE V_MSQL;


        -- ENG
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET DD_STG_CONCEPTO_FAC = ''ENG''
            WHERE  DD_STG_CODIGO = ''62''';
        EXECUTE IMMEDIATE V_MSQL;


        --GTC
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET DD_STG_CONCEPTO_FAC = ''GTC''
            WHERE  DD_STG_CODIGO IN (''30'',''32'')';
        EXECUTE IMMEDIATE V_MSQL;

        --IBI
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET DD_STG_CONCEPTO_FAC = ''IBI''
            WHERE  DD_STG_CODIGO IN (''01'',''02'')';
        EXECUTE IMMEDIATE V_MSQL;



       --OTR
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET DD_STG_CONCEPTO_FAC = ''OTR''
            WHERE  DD_STG_CODIGO IN (''15'',''59'',''60'',''61'',''63'',''69'',''70'',''71'',''79'',''80'',''81
						'',''82'',''86'',''94'',''03'',''04'',''05'',''06'',''07'',''11'',''12'',''13'',''14'',''16'',''17'',''18'',''19'',''20'',''21'',''22'',''23
						'',''24'',''25'',''34'',''38'',''39'',''40'',''41'',''42'',''43'',''44'',''45'',''46'',''47'',''49'',''50'',''51'',''52'',''53'',''54'',''55
						'',''56'',''57'',''58'',''64'',''65'',''66'',''67'',''68'',''72'',''73'',''74'',''75'',''76'',''77'',''78'',''83'',''84'',''85'',''87'',''88
						'',''89'',''90'',''91'',''92'',''95'',''96'',''97'',''98'',''99'')';
        EXECUTE IMMEDIATE V_MSQL;


     --RTA
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET DD_STG_CONCEPTO_FAC = ''RTA''
            WHERE  DD_STG_CODIGO IN (''26'',''28'',''31'',''33'')';
        EXECUTE IMMEDIATE V_MSQL;


        --RTE
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET DD_STG_CONCEPTO_FAC = ''RTE''
            WHERE  DD_STG_CODIGO IN (''27'',''29'')';
        EXECUTE IMMEDIATE V_MSQL;


        --SUM
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET DD_STG_CONCEPTO_FAC = ''SUM''
            WHERE  DD_STG_CODIGO IN (''09'',''10'',''35'',''36'',''37'')';
        EXECUTE IMMEDIATE V_MSQL;


        COMMIT;

    	
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO][FIN] NO EXISTE LA TABLA '||V_TEXT_TABLA);
	END IF;
	
	
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