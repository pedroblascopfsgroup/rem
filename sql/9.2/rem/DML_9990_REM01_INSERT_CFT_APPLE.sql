--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20190408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CFT_CONFIG_TARIFA la configuración de otra cartera
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

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en ACT_CFT_CONFIG_TARIFA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_CFT_CONFIG_TARIFA] ');
      			
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'') AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'') AND USUARIOCREAR = ''REMNIVDOS-4237''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		--Si existe lo modificamos
		IF V_NUM_TABLAS > 0 THEN				
		
			DBMS_OUTPUT.PUT_LINE('[INFO]: LA CONFIGURACIÓN DE APPLE A PARTIR DE SAREB YA ESTÁ INSERTADA');
		--Si no existe, lo insertamos   
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LA CONFIGURACION');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA CFT (CFT.CFT_ID, CFT.DD_TTF_ID, CFT.DD_TTR_ID, CFT.DD_STR_ID, CFT.DD_CRA_ID, CFT.CFT_PRECIO_UNITARIO, CFT.CFT_UNIDAD_MEDIDA, CFT.VERSION, CFT.USUARIOCREAR, CFT.FECHACREAR, CFT.PVE_ID, CFT.DD_SCR_ID)
						SELECT '||V_ESQUEMA||'.S_ACT_CFT_CONFIG_TARIFA.NEXTVAL AS CFT_ID
						, CFT2.DD_TTF_ID AS DD_TTF_ID
						, CFT2.DD_TTR_ID AS DD_TTR_ID
						, CFT2.DD_STR_ID AS DD_STR_ID
						, (SELECT CRA2.DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA2 WHERE CRA2.DD_CRA_CODIGO = ''07'') AS DD_CRA_ID
						, CFT2.CFT_PRECIO_UNITARIO AS CFT_PRECIO_UNITARIO
						, CFT2.CFT_UNIDAD_MEDIDA AS CFT_UNIDAD_MEDIDA
						, 0 AS VERSION
						, ''REMNIVDOS-4237'' AS USUARIOCREAR
						, SYSDATE AS FECHACREAR
						, CFT2.PVE_ID AS PVE_ID
						, (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'') AS DD_SCR_ID
						FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA CFT2
						JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CFT2.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''02''';
									
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: '||sql%rowcount||' FILAS INSERTADAS');
		
		END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO ACT_CFT_CONFIG_TARIFA ACTUALIZADO CORRECTAMENTE ');
   

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



   
