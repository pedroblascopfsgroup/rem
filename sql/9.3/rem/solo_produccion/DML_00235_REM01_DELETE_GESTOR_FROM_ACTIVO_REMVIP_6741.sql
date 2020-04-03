--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200403
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6741
--## PRODUCTO=NO
--## Finalidad: Elimina gestor e histórico del mismo vinculado a un activo.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
    V_USUARIO VARCHAR2(20 CHAR) := 'REMVIP-6741';
    V_NUM_ACTIVO VARCHAR(20 CHAR) := '6971956';
    V_COD_GESTOR VARCHAR(20 CHAR) := 'HAYAGBOINM';
    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO... ELIMINANDO datos de la tabla');
    --- Borrando gestor
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T1
            WHERE EXISTS (
                SELECT  ACT.ACT_ID
                FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
                JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
                JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID
                WHERE TGE.DD_TGE_CODIGO  = '''||V_COD_GESTOR||'''
                AND ACT.ACT_NUM_ACTIVO = '||V_NUM_ACTIVO||'
                AND T1.ACT_ID = GAC.ACT_ID
                AND T1.GEE_ID = GAC.GEE_ID
            )';
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||sql%rowcount||' registros eliminados de '||V_ESQUEMA_M||'.GAC_GESTOR_ADD_ACTIVO');
    COMMIT;

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
