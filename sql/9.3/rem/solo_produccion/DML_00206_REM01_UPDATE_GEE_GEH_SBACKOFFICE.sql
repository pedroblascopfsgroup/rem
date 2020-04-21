--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200410
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6930
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica GEE y GEH para cambiar el usuario al tipo de gestor HAYASBOINM
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
    V_ID_COD_REM NUMBER(16);
    V_ID_PVC NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_BOOLEAN NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'REMVIP-6930';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMENZAMOS ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS USUARIOS');  

    V_MSQL := '
                MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
                USING
                (
                    SELECT GEH.GEH_ID, (SELECT SQLI.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS SQLI WHERE SQLI.USU_USERNAME = ''grusbackoffman'' AND SQLI.BORRADO = 0)  USU_ID
                    FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
                    JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GEH.GEH_ID = GAH.GEH_ID
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAH.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON ACT.DD_SCR_ID = SCR.DD_SCR_ID
                    LEFT JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEH.DD_TGE_ID
                    LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON GEH.USU_ID = USU.USU_ID
                    WHERE 
                      GEH.BORRADO = 0 
                      AND GEH.GEH_FECHA_HASTA IS NULL 
                      AND SCR.DD_SCR_CODIGO IN (''151'',''152'') 
                      AND TGE.DD_TGE_CODIGO = ''HAYASBOINM''
                ) AUX ON (GEH.GEH_ID = AUX.GEH_ID)
                WHEN MATCHED THEN UPDATE SET 
                    GEH.USU_ID = AUX.USU_ID
                    , GEH.USUARIOCREAR = ''REMVIP-6930''
              ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN GEH: ' ||sql%rowcount);

    V_MSQL := '
                MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
                USING
                (
                    SELECT GEE.GEE_ID, (SELECT SQLI.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS SQLI WHERE SQLI.USU_USERNAME = ''grusbackoffman'' AND SQLI.BORRADO = 0)  USU_ID
                    FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
                    JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GEE.GEE_ID = GAC.GEE_ID
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAC.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON ACT.DD_SCR_ID = SCR.DD_SCR_ID
                    LEFT JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
                    LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID
                    WHERE 
                      GEE.BORRADO = 0 
                      AND SCR.DD_SCR_CODIGO IN (''151'',''152'') 
                      AND TGE.DD_TGE_CODIGO = ''HAYASBOINM''
                ) AUX ON (GEE.GEE_ID = AUX.GEE_ID)
                WHEN MATCHED THEN UPDATE SET 
                    GEE.USU_ID = AUX.USU_ID
                    , GEE.USUARIOCREAR = ''REMVIP-6930''
              ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN GEH: ' ||sql%rowcount);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]:  MODIFICADO CORRECTAMENTE ');
   

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
