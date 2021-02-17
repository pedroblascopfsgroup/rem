--/*
--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20200114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-12352
--## PRODUCTO=NO
--## Finalidad: Anyadir campos a la nueva columna de la tabla DD_CCS_CAMPOS_CONV_SAREB
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'DD_CCS_CAMPOS_CONV_SAREB';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-12352'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	

		DBMS_OUTPUT.PUT_LINE('[INFO] Se va a modificar el DD_CTD_ID.');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                    SET DD_CTD_ID = (SELECT DD_CTD_ID FROM '||V_ESQUEMA||'.DD_CTD_CAMPO_TIPO_DATO WHERE DD_CTD_CODIGO = ''01''),
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE DD_COS_ID IN (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO IN 
                    (''024'',	
                    ''029''	,
                    ''016''	,
                    ''007'' ,
                    ''009'' ,
                    ''008''	,	
                    ''064''	,
                    ''073''	,
                    ''119''	,
                    ''141''	,
                    ''013''	,
                    ''096''	,
                    ''012''	,
                    ''015''	,
                    ''078''	,
                    ''079''	,
                    ''084''	,
                    ''081''	,
                    ''083''	,		
                    ''139''	,
                    ''080''	,
                    ''092''	,
                    ''102''	,
                    ''117''	,
                    ''094''	,
                    ''118''	,
                    ''121''))';

        EXECUTE IMMEDIATE V_MSQL;

         V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                    SET DD_CTD_ID = (SELECT DD_CTD_ID FROM '||V_ESQUEMA||'.DD_CTD_CAMPO_TIPO_DATO WHERE DD_CTD_CODIGO = ''02''),
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE DD_COS_ID IN (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO IN 
                    (''018'',
                    ''021'',
                    ''025'',
                    ''026'',
                    ''027'',
                    ''037'',
                    ''038'',
                    ''039'',
                    ''082'',
                    ''093'',
                    ''095'',
                    ''098'',
                    ''103'',
                    ''104'',
                    ''105'',
                    ''110'',
                    ''111'',
                    ''113'',
                    ''114'',
                    ''126'',
                    ''127''))';

        EXECUTE IMMEDIATE V_MSQL;

                 V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                    SET DD_CTD_ID = (SELECT DD_CTD_ID FROM '||V_ESQUEMA||'.DD_CTD_CAMPO_TIPO_DATO WHERE DD_CTD_CODIGO = ''03''),
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE DD_COS_ID IN (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO IN 
                    (''060''	,
                    ''062''	,
                    ''077''	,
                    ''076''	,
                    ''061''	,
                    ''063''	,
                    ''034''	,
                    ''075''	,
                    ''134''	,
                    ''107''	,
                    ''115''))';

        EXECUTE IMMEDIATE V_MSQL;

                 V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                    SET DD_CTD_ID = (SELECT DD_CTD_ID FROM '||V_ESQUEMA||'.DD_CTD_CAMPO_TIPO_DATO WHERE DD_CTD_CODIGO = ''04''),
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE DD_COS_ID IN (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO IN 
                    (''001'' ,
                    ''022''	,
                    ''030''	,
                    ''125''	,
                    ''135''	,
                    ''120''	))';

        EXECUTE IMMEDIATE V_MSQL;

                 V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                    SET DD_CTD_ID = (SELECT DD_CTD_ID FROM '||V_ESQUEMA||'.DD_CTD_CAMPO_TIPO_DATO WHERE DD_CTD_CODIGO = ''05''),
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE DD_COS_ID IN (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO IN 
                    (''002'',
                    ''003'',
                    ''004'',
                    ''005'',
                    ''006'',                 
                    ''011'',
                    ''017'',
                    ''019'',
                    ''020'',
                    ''023'',
                    ''031'',
                    ''032'',
                    ''035'',
                    ''036'',
                    ''040'',
                    ''041'',
                    ''052'',
                    ''053'',
                    ''054'',
                    ''055'',
                    ''056'',
                    ''057'',
                    ''065'',
                    ''066'',
                    ''085'',
                    ''086'',
                    ''097'',
                    ''099'',
                    ''100'',
                    ''101'',
                    ''106'',
                    ''108'',
                    ''109'',
                    ''112'',
                    ''123'',
                    ''128'',
                    ''129'',
                    ''137'',
                    ''138'',
                    ''140''))';

        EXECUTE IMMEDIATE V_MSQL;

                 V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                    SET DD_CTD_ID = (SELECT DD_CTD_ID FROM '||V_ESQUEMA||'.DD_CTD_CAMPO_TIPO_DATO WHERE DD_CTD_CODIGO = ''06''),
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE DD_COS_ID IN (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO IN 
                    (''091'',
                    ''028'',
                    ''059'',
                    ''047'',
                    ''043''	,
                    ''045''	,
                    ''049''	,
                    ''051'',
                    ''033'',
                    ''070''	,
                    ''069'',
                    ''071''	,
                    ''067'',
                    ''074''	,
                    ''068'',
                    ''058''	,
                    ''046''	,
                    ''044'',
                    ''048'',
                    ''050''	,
                    ''042''	,
                    ''014''))';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] DD_CCS_CAMPOS_CONV_SAREB modificado correctamente.');
        
        COMMIT;
  
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT