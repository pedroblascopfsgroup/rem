--/*
--##########################################
--## AUTOR=PIER GOTTA 
--## FECHA_CREACION=20181004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=rREMVIP-2080
--## PRODUCTO=NO
--##
--## Finalidad: Reasginar gestores GCOM
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-2080';
    
 BEGIN
 
 V_SQL := 'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC WHERE GAC.GEE_ID IN (SELECT GEE.GEE_ID FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE WHERE GEE.USUARIOCREAR = ''REMVIP-2080'')';

  EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han eliminado '||SQL%ROWCOUNT||' registros en la tabla GAC_GESTOR_ADD_ACTIVO');

 V_SQL := 'DELETE FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE WHERE GEE.USUARIOCREAR = ''REMVIP-2080''';

  EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han eliminado '||SQL%ROWCOUNT||' registros en la tabla GEE_GESTOR_ENTIDAD');

 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T1
			USING(
				SELECT DISTINCT GEE.GEE_ID, GEE.USU_ID
				FROM TMP_2080 TMP
				JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = TMP.ACT_ID
				JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.DD_TGE_ID = TMP.DD_TGE_ID AND GAC.GEE_ID = GEE.GEE_ID) T2
			ON (T1.GEE_ID = T2.GEE_ID)
			WHEN MATCHED THEN UPDATE SET
			T1.USU_ID = T2.USU_ID,
			T1.USUARIOMODIFICAR = ''REMVIP-2080'',
			T1.FECHAMODIFICAR = SYSDATE';
		  

  EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado '||SQL%ROWCOUNT||' registros en la tabla GEE_GESTOR_ENTIDAD');

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
