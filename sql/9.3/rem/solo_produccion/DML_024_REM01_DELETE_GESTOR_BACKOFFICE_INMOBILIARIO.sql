--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190801
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-4969
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   
    V_USUARIOMODIFICAR VARCHAR(100 CHAR) := 'REMVIP-4969'; -- Vble. para el usuario modificar.
    V_MSQL VARCHAR2(32000 CHAR); -- Vble. auxiliar para almacenar la sentencia a ejecutar.
	V_GEE_ID VARCHAR2(16 CHAR); -- Vble. auxiliar para almacenar el GEE_ID a borrar.
	V_ID_HAYA VARCHAR2(16 CHAR) := '5961905'; -- Vble. para almacenar el ID_Haya del activo

BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
	DBMS_OUTPUT.PUT_LINE('	[INFO]	Borrado de las tablas de gestores: GAC_GESTOR_ADD_ACTIVO y GEE_GESTOR_ENTIDAD');

   	V_MSQL := 'SELECT GEE.GEE_ID 
				FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
				JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
				JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND DD_TGE_CODIGO = ''HAYAGBOINM''
				WHERE ACT.ACT_NUM_ACTIVO = '||V_ID_HAYA||'';
	EXECUTE IMMEDIATE V_MSQL INTO V_GEE_ID;
    
	V_MSQL := 'DELETE '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO WHERE GEE_ID = '||V_GEE_ID||'';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'DELETE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD WHERE GEE_ID = '||V_GEE_ID||'';
    EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('	[INFO]	Finalizado el periodo en la tabla histórica GEH_GESTOR_ENTIDAD_HIST');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST T1
				USING (
					SELECT GEE.GEH_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAC ON GAC.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEE ON GEE.GEH_ID = GAC.GEH_ID
					JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND DD_TGE_CODIGO = ''HAYAGBOINM''
					WHERE ACT.ACT_NUM_ACTIVO = '||V_ID_HAYA||'
				) T2
				ON (T1.GEH_ID = T2.GEH_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.GEH_FECHA_HASTA = SYSDATE
					,T1.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
					,FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
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
