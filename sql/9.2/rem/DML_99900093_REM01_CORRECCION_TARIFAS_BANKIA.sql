--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20170307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1529
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra en ACT_CFT_CONFIG_TARIFA correspondientes a entidad 03 y tipo trabajo 01
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
	
    V_CRA_COD VARCHAR2(10 CHAR):='03'; -- CODIGO CARTERA
    V_TTR_COD VARCHAR2(10 CHAR):='01'; -- CODIGO TIPO TRABAJO
    
BEGIN	
	-- Como no existen tarifas de bankia para el tipo de trabajo 01 (Tasaciones), borramos todas aquellas correspondencias a dd_cra_codigo = 03 y dd_ttr_codigo = 01
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO EN ACT_CFT_CONFIG_TARIFA] ');
	
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_CRA_COD||''') AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||V_TTR_COD||''') ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		--Si existe lo modificamos
		IF V_NUM_TABLAS > 0 THEN				
		
			DBMS_OUTPUT.PUT_LINE('[INFO]: BORRANDO REGISTROS DE CARTERA '''|| V_CRA_COD ||''' Y TIPO TRABAJO '''|| V_TTR_COD ||''' ');   
			V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_CFT_CONFIG_TARIFA '||
			'WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_CRA_COD||''') AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||V_TTR_COD||''') ';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: OK');
  
		--Si no existe, NO HACEMOS NADA
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]: NINGÚN REGISTRO QUE BORRAR');
		
		END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   

EXCEPTION
     WHEN OTHERS THEN
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
   