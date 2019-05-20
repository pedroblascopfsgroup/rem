--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160928
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2204
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración de Usuarios.
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

  V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  USUARIO_MIGRACION VARCHAR2(50 CHAR):= '#USUARIO_MIGRACION#';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de ACTIVOS GESTORES-ACTIVO');


      -------------------------------------------------
      --INSERCION EN GEE_GESTOR_ENTIDAD--
      -------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN GEE_GESTOR_ENTIDAD');
          
      V_SQL := '
        INSERT INTO /*+ APPEND */ '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD (GEE_ID, USU_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR)
        SELECT 
			'||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL, 
			USU.USU_ID, 
			TGE.DD_TGE_ID, 
			'''||USUARIO_MIGRACION||''', 
			SYSDATE, 
			ACT.ACT_ID
        FROM '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS 		GEA
        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO 				ACT ON ACT.ACT_NUM_ACTIVO = GEA.GEA_NUMERO_ACTIVO AND ACT.BORRADO = 0
        INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS 			USU ON USU.USU_USERNAME = GEA.GEA_GESTOR_ACTIVO AND USU.BORRADO = 0
        INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR 	TGE ON TGE.DD_TGE_CODIGO = GEA.GEA_TIPO_GESTOR AND TGE.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO 	GAC ON GAC.ACT_ID = ACT.ACT_ID
        LEFT JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD 		GEE ON GEE.USU_ID = USU.USU_ID AND GEE.DD_TGE_ID = TGE.DD_TGE_ID AND GEE.GEE_ID = GAC.GEE_ID
        WHERE GEA.VALIDACION = 0 
          AND GEE.GEE_ID IS NULL
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD cargada. '||SQL%ROWCOUNT||' Filas.');     
      COMMIT;
      
      
      -------------------------------------------------
      --INSERCION EN GAC_GESTOR_ADD_ACTIVO--
      -------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN GAC_GESTOR_ADD_ACTIVO');
      
      V_SQL := '
        INSERT INTO /*+ APPEND */ '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO (GEE_ID, ACT_ID)
        SELECT 
			GEE.GEE_ID, 
			TO_NUMBER(GEE.USUARIOMODIFICAR)
        FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD 				GEE
        LEFT JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO 		GAC ON GAC.GEE_ID = GEE.GEE_ID AND TO_CHAR(GAC.ACT_ID) = GEE.USUARIOMODIFICAR
        WHERE GEE.USUARIOCREAR = '''||USUARIO_MIGRACION||''' 
          AND GEE.USUARIOMODIFICAR IS NOT NULL 
          AND GAC.GEE_ID IS NULL
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO cargada. '||SQL%ROWCOUNT||' Filas.'); 
      COMMIT;
      
      
      -------------------------------------------------
      --INSERCION EN GEH_GESTOR_ENTIDAD_HIST--
      -------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN GEH_GESTOR_ENTIDAD_HIST');
  
      V_SQL := '
		INSERT INTO /*+ APPEND */ '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR)
		SELECT 
			'||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL, 
			USU.USU_ID, 
			TGE.DD_TGE_ID, 
			SYSDATE, 
			'''||USUARIO_MIGRACION||''', 
			SYSDATE, 
			ACT.ACT_ID
		FROM '||V_ESQUEMA||'.MIG2_GEA_GESTORES_ACTIVOS 			GEA
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO 					ACT ON ACT.ACT_NUM_ACTIVO = GEA.GEA_NUMERO_ACTIVO AND ACT.BORRADO = 0
		INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS 				USU ON USU.USU_USERNAME = GEA.GEA_GESTOR_ACTIVO AND USU.BORRADO = 0
		INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR 		TGE ON TGE.DD_TGE_CODIGO = GEA.GEA_TIPO_GESTOR AND TGE.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO 	GAH ON GAH.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST 		GEE ON GEE.USU_ID = USU.USU_ID AND GEE.DD_TGE_ID = TGE.DD_TGE_ID AND GEE.GEH_ID = GAH.GEH_ID
		WHERE GEA.VALIDACION = 0 
		  AND GEE.GEH_ID IS NULL
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST cargada. '||SQL%ROWCOUNT||' Filas.'); 
      COMMIT;
      
      
      -------------------------------------------------
      --INSERCION EN GAH_GESTOR_ACTIVO_HISTORICO--
      -------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN GAH_GESTOR_ACTIVO_HISTORICO');
      
      V_SQL := '
        INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO (GEH_ID, ACT_ID)
        SELECT 
			GEH.GEH_ID, 
			TO_NUMBER(GEH.USUARIOMODIFICAR)
        FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST 			GEH
        LEFT JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO 	GAH ON GAH.GEH_ID = GEH.GEH_ID AND TO_CHAR(GAH.ACT_ID) = GEH.USUARIOMODIFICAR
        WHERE GEH.USUARIOCREAR = '''||USUARIO_MIGRACION||''' 
          AND GEH.USUARIOMODIFICAR IS NOT NULL 
          AND GAH.GEH_ID IS NULL
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO cargada. '||SQL%ROWCOUNT||' Filas.');
      COMMIT;  


      DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de ACTIVOS GESTORES-ACTIVO');
      
      
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;
/
EXIT;
