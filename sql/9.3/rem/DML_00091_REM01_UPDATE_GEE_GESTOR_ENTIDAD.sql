--/*
--##########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=202000206
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9179
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza en GEE_GESTOR_ENTIDAD 
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
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'GEE_GESTOR_ENTIDAD'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_AUX VARCHAR2(2400 CHAR) := 'AUX_GESTOR'; -- Vble. auxiliar para almacenar el nombre de la tabla auxiliar.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-9179';

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 
    -- LOOP para actualizar los valores en GEE_GESTOR_ENTIDAD -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN GEE_GESTOR_ENTIDAD');
    
        --Modificamos los valores
		    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
        USING (
            SELECT GAC.GEE_ID, ACT.ACT_NUM_ACTIVO, GEE.USU_ID FROM GAC_GESTOR_ADD_ACTIVO GAC 
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAC.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO IN (''05'',''06'')
            JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GAC.GEE_ID = GEE.GEE_ID AND GEE.BORRADO = 0
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GACT''
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''02''
        ) T2 
        ON (T1.GEE_ID =  T2.GEE_ID)
        WHEN MATCHED THEN UPDATE SET 
        T1.BORRADO = 1, T1.FECHABORRAR = SYSDATE, T1.USUARIOBORRAR = '''||V_INCIDENCIA||'''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL:= 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX||'';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX||' (ACT, USU, TGE) (SELECT ACT_ID, ''grupgact'', ''GACT'' FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''02''
        JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO NOT IN (''05'', ''06'') 
    )';
    EXECUTE IMMEDIATE V_MSQL;
COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA GEE_GESTOR_ENTIDAD MODIFICADA CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT