--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20220309
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.14
--## INCIDENCIA_LINK=REMVIP
--## PRODUCTO=NO
--## 
--## Finalidad:  Se modifica el SP ya que ha cambiado la tabla OFERTAS_REPOSICIONAR
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 REMVIP-11103 - Juan José Sanjuan - Actualizar asignaciones de usuarios
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE REPOSICIONAMIENTO_TRAMITE (USUARIO VARCHAR2
		, LIST_EXP_REP VARCHAR2
		, TRAM_DESTINO IN REM01.TAP_TAREA_PROCEDIMIENTO.TAP_CODIGO%TYPE
		, LIST_EXP_EEC VARCHAR2 DEFAULT NULL
		, EEC_DESTINO IN REM01.DD_EEC_EST_EXP_COMERCIAL.DD_EEC_CODIGO%TYPE DEFAULT NULL
		, PL_OUTPUT OUT VARCHAR2) AUTHID CURRENT_USER AS

	/*
	USUARIO es únicamente para auditoría, es obligatorio.
	LIST_EXP_REP es la lista de números de expedientes comerciales, separados por comas, que queramos reposicionar. Es obligatorio.
	TRAM_DESTINO es el trámite al que se quiere avanzar cada expediente comercial. Es obligatorio.
	LIST_EXP_EEC es la lista de números de expediente comerciales, separados por comas, que queramos cambiar su estado. No es obligatorio, si se deja vacío no hará ese paso.
	EEC_DESTINO es el estado en el que se quiere poner el expediente o expedientes comerciales que se pasen en la lista anterior. No es obligatorio, si se deja vacío no hará ese paso.
	*/
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';			-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';	-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR);
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    COD_ITEM VARCHAR2(50 CHAR);
    PL_OUTPUT2 VARCHAR2(32000 CHAR);
    V_TABLA_REP VARCHAR2(30 CHAR) := 'OFERTAS_REPOSICIONAR';
    V_TABLA VARCHAR2(40 CHAR) := 'MIG2_TRAMITES_OFERTAS_REP'; -- Vble. Tabla pivote
    V_OFR_ID NUMBER(16) := 0; -- Vble. para almacenar el OFR_ID
    S_TBJ NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_ID
    S_NUM NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_NUM_TRABAJO
    S_TRA NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TRA_ID
    S_TAR NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TAR_ID
    S_TEX NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TEX_ID
    CURSOR CURSOR_OFERTAS IS
    SELECT DISTINCT OFR_ID FROM REM01.MIG2_TRAMITES_OFERTAS_REP TRA;
    V_TABLA_TBJ 	VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';
    V_TABLA_ACT_TBJ VARCHAR2(30 CHAR) := 'ACT_TBJ';
    V_TABLA_ECO 	VARCHAR2(30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
    V_TABLA_TRA 	VARCHAR2(30 CHAR) := 'ACT_TRA_TRAMITE';
    V_TABLA_TAR 	VARCHAR2(30 CHAR) := 'TAR_TAREAS_NOTIFICACIONES';
    V_TABLA_ETN 	VARCHAR2(30 CHAR) := 'ETN_EXTAREAS_NOTIFICACIONES';
    V_TABLA_TEX 	VARCHAR2(30 CHAR) := 'TEX_TAREA_EXTERNA';
    V_TABLA_TAC 	VARCHAR2(30 CHAR) := 'TAC_TAREAS_ACTIVOS';
    V_UPDATE 		NUMBER(16);
    
BEGIN

    PL_OUTPUT := '[INICIO] Inicio del proceso de reposicionamiento de trámites de ofertas.';
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '';

    V_USUARIO := USUARIO;
    COD_ITEM := V_USUARIO;
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR ';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'INSERT INTO REM01.OFERTAS_REPOSICIONAR (OFR_ID, ECO_ID, TBJ_ID, TAR_ID, TEX_ID, TRA_ID, DD_TOF_CODIGO, ACT_ID)
        SELECT OFR.OFR_ID, ECO.ECO_ID, TBJ.TBJ_ID, TAR.TAR_ID, TEX.TEX_ID, TRA.TRA_ID, TOF.DD_TOF_CODIGO, ACT.ACT_ID
        FROM REM01.ECO_EXPEDIENTE_COMERCIAL ECO
        JOIN REM01.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
        JOIN REM01.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OFR.DD_TOF_ID AND TOF.BORRADO = 0
        JOIN REM01.ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID
        JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID AND ACT.BORRADO = 0
        LEFT JOIN REM01.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = ECO.TBJ_ID
        LEFT JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
        LEFT JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
        LEFT JOIN REM01.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
        LEFT JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
        LEFT JOIN REM01.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ECO.TBJ_ID
        WHERE ECO.ECO_NUM_EXPEDIENTE IN (' ||LIST_EXP_REP|| ')';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] '|| SQL%ROWCOUNT||' trámites a reposicionar.';

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TRA_ID = T2.TRA_ID AND T1.TAR_ID = T2.TAR_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] Borrados '||SQL%ROWCOUNT||' tareas/activos.';
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TEX_ID = T2.TEX_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] Borrados '||SQL%ROWCOUNT||' tareas externas.';
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TEX_ID = T2.TEX_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] Borrados '||SQL%ROWCOUNT||' tareas externas.';
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ETN_EXTAREAS_NOTIFICACIONES T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TAR_ID = T2.TAR_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] Borrados '||SQL%ROWCOUNT||' ETNs.';
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TAR_ID = T2.TAR_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] Borrados '||SQL%ROWCOUNT||' tareas.';
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TRA_ID = T2.TRA_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] Borrados '||SQL%ROWCOUNT||' trámites.';
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T1 SET T1.TBJ_ID = NULL WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.ECO_ID = T2.ECO_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] Actualizados '||SQL%ROWCOUNT||' expedientes.';
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_TBJ T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TBJ_ID = T2.TBJ_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] Borrados '||SQL%ROWCOUNT||' relaciones activos/trabajos.';
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.HIST_ENVIO_STOCK_TRABAJO T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TBJ_ID = T2.TBJ_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] Borrados '||SQL%ROWCOUNT||' relaciones envío stock/trabajos.';
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TBJ_ID = T2.TBJ_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] Borrados '||SQL%ROWCOUNT||' trabajos.';

    PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] APROVISIONANDO LA TABLA AUXILIAR '||V_TABLA||'...';
      EXECUTE IMMEDIATE 'DELETE FROM  REM01.MIG2_TRAMITES_OFERTAS_REP';
      EXECUTE IMMEDIATE '
            INSERT INTO REM01.MIG2_TRAMITES_OFERTAS_REP (OFR_ID, ACT_ID, TPO_ID, TAP_ID, USU_ID, SUP_ID)
            SELECT ORE.OFR_ID, ORE.ACT_ID
                , CASE ORE.DD_TOF_CODIGO
                      WHEN ''01'' THEN TAP.DD_TPO_ID
                      WHEN ''02'' THEN (SELECT DD_TPO_ID FROM REM01.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T014'' AND BORRADO = 0)
                END AS TPO_ID, TAP.TAP_ID, NULL AS USU_ID, NULL AS SUP_ID
            FROM REM01.OFERTAS_REPOSICIONAR ORE
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_CODIGO = '''||TRAM_DESTINO||''' AND BORRADO = 0';

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.';

            V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID
            FROM REM01.MIG2_TRAMITES_OFERTAS_REP MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO IN (''T013_PosicionamientoYFirma'')
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GIAFORM'') T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.USU_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM REM01.GEE_GESTOR_ENTIDAD GEE
          JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GIAFORM'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.USU_ID = T2.USU_ID
        WHERE T1.USU_ID IS NULL AND T1.TAP_ID IN (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO IN (''T013_PosicionamientoYFirma''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Gestoría comercialización). '||V_UPDATE||' Filas.';

      V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID, TGE.DD_TGE_CODIGO
            FROM REM01.MIG2_TRAMITES_OFERTAS_REP MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO IN (''T013_PosicionamientoYFirma'')
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GFORM'') T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.SUP_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM REM01.GEE_GESTOR_ENTIDAD GEE
          JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GFORM'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.SUP_ID = T2.USU_ID
        WHERE T1.SUP_ID IS NULL AND T1.TAP_ID IN (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO IN (''T013_PosicionamientoYFirma''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Gestor comercial). '||V_UPDATE||' Filas.';

      V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID
            FROM REM01.MIG2_TRAMITES_OFERTAS_REP MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO IN (''T013_DefinicionOferta'',''T013_InstruccionesReserva'',''T013_RespuestaOfertante'',''T013_ResolucionComite'',''T013_CierreEconomico'',''T013_ResolucionExpediente'',''T014_DefinicionOferta'')
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GCOM'') T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.USU_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM REM01.GEE_GESTOR_ENTIDAD GEE
          JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GCOM'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.USU_ID = T2.USU_ID
        WHERE T1.USU_ID IS NULL AND T1.TAP_ID IN (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO IN (''T013_DefinicionOferta'',''T013_InstruccionesReserva'',''T013_RespuestaOfertante'',''T013_ResolucionComite'',''T013_CierreEconomico'',''T013_ResolucionExpediente'',''T014_DefinicionOferta''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Gestor comercial). '||V_UPDATE||' Filas.';

      V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID, TGE.DD_TGE_CODIGO
            FROM REM01.MIG2_TRAMITES_OFERTAS_REP MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO IN (''T013_DefinicionOferta'',''T013_InstruccionesReserva'',''T013_RespuestaOfertante'',''T013_ResolucionComite'',''T013_CierreEconomico'',''T013_ResolucionExpediente'',''T014_DefinicionOferta'')
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SCOM'') T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.SUP_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM REM01.GEE_GESTOR_ENTIDAD GEE
          JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SCOM'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.SUP_ID = T2.USU_ID
        WHERE T1.SUP_ID IS NULL AND T1.TAP_ID IN (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO IN (''T013_DefinicionOferta'',''T013_InstruccionesReserva'',''T013_RespuestaOfertante'',''T013_ResolucionComite'',''T013_CierreEconomico'',''T013_ResolucionExpediente'',''T014_DefinicionOferta''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Supervisor comercial). '||V_UPDATE||' Filas.';

      V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID, TGE.DD_TGE_CODIGO
            FROM REM01.MIG2_TRAMITES_OFERTAS_REP MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO = ''T013_ResultadoPBC''
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GFORM'') T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.USU_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM REM01.GEE_GESTOR_ENTIDAD GEE
          JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GFORM'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.USU_ID = T2.USU_ID
        WHERE T1.USU_ID IS NULL AND T1.TAP_ID = (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = (''T013_ResultadoPBC''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Gestor formalización). '||V_UPDATE||' Filas.';

      V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID
            FROM REM01.MIG2_TRAMITES_OFERTAS_REP MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO = ''T013_ResultadoPBC''
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SFORM'') T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.SUP_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM REM01.GEE_GESTOR_ENTIDAD GEE
          JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SFORM'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.SUP_ID = T2.USU_ID
        WHERE T1.SUP_ID IS NULL AND T1.TAP_ID = (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = (''T013_ResultadoPBC''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING REMMASTER.USU_USUARIOS T2
        ON (T2.USU_USERNAME = ''SUPFORM'')
        WHEN MATCHED THEN UPDATE SET
          T1.SUP_ID = T2.USU_ID
        WHERE T1.SUP_ID IS NULL AND T1.TAP_ID = (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = (''T013_ResultadoPBC''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Supervisor formalización). '||V_UPDATE||' Filas.';

      V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRAMITES_OFERTAS_REP T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID, TGE.DD_TGE_CODIGO
            FROM REM01.MIG2_TRAMITES_OFERTAS_REP MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO IN (''T013_DefinicionOferta'',''T017_DefinicionOferta'')
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = MIG.ACT_ID AND ACT.BORRADO = 0
            JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''HAYAGBOINM''
            WHERE CRA.DD_CRA_CODIGO IN (''01'', ''07'')) T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.USU_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Gestor Comercial Backoffice Inmobiliario). '||V_UPDATE||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE MIG2_TRAMITES_OFERTAS_REP (TBJ_ID, TRA_ID, TAR_ID, TEX_ID) --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] GENERANDO TBJ_ID, TRA_ID, TAR_ID, TEX_ID...';

      OPEN CURSOR_OFERTAS;

      LOOP
            FETCH CURSOR_OFERTAS INTO V_OFR_ID;
            EXIT WHEN CURSOR_OFERTAS%NOTFOUND;

                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_ACT_TBJ_TRABAJO.NEXTVAL FROM DUAL' INTO S_TBJ;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TBJ_NUM_TRABAJO.NEXTVAL FROM DUAL' INTO S_NUM;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_ACT_TRA_TRAMITE.NEXTVAL FROM DUAL' INTO S_TRA;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL' INTO S_TAR;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL FROM DUAL' INTO S_TEX;

                  EXECUTE IMMEDIATE '
                        UPDATE '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP TRA
                        SET TRA.TBJ_ID = '||S_TBJ||'
                              , TRA.TBJ_NUM_TRABAJO = '||S_NUM||'
                              , TRA.TRA_ID = '||S_TRA||'
                              , TRA.TAR_ID = '||S_TAR||'
                              , TRA.TEX_ID = '||S_TEX||'
                        WHERE OFR_ID = '||V_OFR_ID||'
                  '
                  ;

      END LOOP;

      CLOSE CURSOR_OFERTAS;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada.';

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] COMIENZA EL VOLCADO A LAS TABLAS DEFINITIVAS';

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO TRABAJOS...';

      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TBJ||' (
                  TBJ_ID
                  , AGR_ID
                  , TBJ_NUM_TRABAJO
                  , USU_ID
                  , DD_TTR_ID
                  , DD_STR_ID
                  , DD_EST_ID
                  , TBJ_FECHA_SOLICITUD
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
            )
            SELECT DISTINCT
                  MIG2.TBJ_ID                                             AS TBJ_ID
                  , OFR.AGR_ID                                           AS AGR_ID
                  , MIG2.TBJ_NUM_TRABAJO                         AS TBJ_NUM_TRABAJO
                  , (SELECT USU_ID
                          FROM '||V_ESQUEMA_M||'.USU_USUARIOS
                          WHERE USU_USERNAME = ''MIGRACION''
                          AND BORRADO = 0
                    )                                                          AS USU_ID
                  , (SELECT DD_TTR_ID
                          FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO
                          WHERE DD_TTR_CODIGO = ''06''
                          AND BORRADO = 0
                    )                                                           AS DD_TTR_ID
                  , CASE TOF.DD_TOF_CODIGO
                          WHEN ''01''
                                THEN (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = ''56'' AND BORRADO = 0)
                          WHEN ''02''
                                THEN (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = ''55'' AND BORRADO = 0)
                    END                                                     AS DD_STR_ID
                  , (SELECT DD_EST_ID
                          FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO
                          WHERE DD_EST_CODIGO = ''04''
                          AND BORRADO = 0
                    )                                                           AS DD_EST_ID
                  , SYSDATE                                              AS TBJ_FECHA_SOLICITUD
                  , 0                                                          AS VERSION
                  , '''||V_USUARIO||'''                               AS USUARIOCREAR
                  , SYSDATE                                              AS FECHACREAR
                  , 0                                                           AS BORRADO
            FROM '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP MIG2
                  INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = MIG2.OFR_ID
                  INNER JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OFR.DD_TOF_ID
      '
      ;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TBJ||' cargada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ACT_TBJ --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO RELACION ACTIVOS-TRABAJOS...';

      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ACT_TBJ||' (
                  ACT_ID
                  ,TBJ_ID
                  ,ACT_TBJ_PARTICIPACION
                  ,VERSION
            )
            WITH PARTICIPACION AS (
                  SELECT
                        MIG2.TBJ_ID              AS TBJ_ID
                        , COUNT(1)              AS TOTAL
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  GROUP BY MIG2.TBJ_ID
            )
            SELECT DISTINCT
                  MIG2.ACT_ID                                         AS ACT_ID
                  , MIG2.TBJ_ID                                        AS TBJ_ID
                  , ROUND(100/NVL(TOTAL,1),2)             AS ACT_TBJ_PARTICIPACION
                  , 0                                                       AS VERSION
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN PARTICIPACION PAR ON PAR.TBJ_ID = MIG2.TBJ_ID
      '
      ;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ACT_TBJ||' cargada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE ECO_EXPEDIENTE_COMERCIAL (TBJ_ID) --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] ACTUALIZANDO EL TRABAJO DE LOS EXPEDIENTES COMERCIALES...';

      EXECUTE IMMEDIATE '
            MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ECO||' ECO
            USING
            (
                  SELECT DISTINCT OFR_ID, TBJ_ID
                  FROM '||V_ESQUEMA||'.'||V_TABLA||'
            ) AUX
            ON (AUX.OFR_ID = ECO.OFR_ID)
            WHEN MATCHED THEN UPDATE
                  SET ECO.TBJ_ID = AUX.TBJ_ID
                    
           '
      ;
            EXECUTE IMMEDIATE '
            MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ECO||' ECO
            USING
            (
                  SELECT DISTINCT OFR_ID, TBJ_ID
                  FROM '||V_ESQUEMA||'.'||V_TABLA||'
            ) AUX
            ON (AUX.OFR_ID = ECO.OFR_ID)
            WHEN MATCHED THEN UPDATE
                  SET ECO.TBJ_ID = AUX.TBJ_ID
                    , ECO.ECO_CONFLICTO_INTERESES = 0 
            WHERE ECO.ECO_CONFLICTO_INTERESES IS NULL         
           '
      ;
            EXECUTE IMMEDIATE '
            MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ECO||' ECO
            USING
            (
                  SELECT DISTINCT OFR_ID, TBJ_ID
                  FROM '||V_ESQUEMA||'.'||V_TABLA||'
            ) AUX
            ON (AUX.OFR_ID = ECO.OFR_ID)
            WHEN MATCHED THEN UPDATE
                  SET ECO.TBJ_ID = AUX.TBJ_ID
                    , ECO.ECO_RIESGO_REPUTACIONAL = 0 
            WHERE ECO.ECO_RIESGO_REPUTACIONAL IS NULL                      
           '
      ;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ECO||' cargada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ACT_TRA_TRAMITE --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO TRAMITES...';

      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TRA||'
            (
                  TRA_ID
                  ,TBJ_ID
                  ,DD_TPO_ID
                  ,DD_EPR_ID
                  ,TRA_DECIDIDO
                  ,TRA_PROCESS_BPM
                  ,TRA_PARALIZADO
                  ,TRA_FECHA_INICIO
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
                  ,DD_TAC_ID
            )
            SELECT DISTINCT
                  MIG2.TRA_ID                                                                         AS TRA_ID
                  , MIG2.TBJ_ID                                                                        AS TBJ_ID
                  , MIG2.TPO_ID                                                                       AS DD_TPO_ID
                  , (SELECT DD_EPR_ID
                        FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO
                        WHERE DD_EPR_CODIGO = ''10''
                        AND BORRADO = 0
                  )                                                                                           AS DD_EPR_ID
                  , 0                                                                                        AS TRA_DECIDIDO
                  , NULL                                                                                  AS TRA_PROCESS_BPM
                  , 0                                                                                        AS TRA_PARALIZADO
                  , SYSDATE                                                                           AS TRA_FECHA_INICIO
                  , 1                                                                                        AS VERSION
                  , '''||V_USUARIO||'''                                                            AS USUARIOCREAR
                  , SYSDATE                                                                           AS FECHACREAR
                  , 0                                                                                        AS BORRADO
                  , (SELECT DD_TAC_ID
                          FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION
                          WHERE DD_TAC_CODIGO = ''GES''
                          AND BORRADO = 0
                  )                                                                                           AS DD_TAC_ID
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
      '
      ;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TRA||' cargada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAR_TAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO TAREAS NOTIFICACIONES...';

      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAR||'
            (
                  TAR_ID
                  , DD_EIN_ID
                  , DD_STA_ID
                  , TAR_CODIGO
                  , TAR_TAREA
                  , TAR_DESCRIPCION
                  , TAR_FECHA_INI
                  , TAR_EN_ESPERA
                  , TAR_ALERTA
                  , TAR_TAREA_FINALIZADA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TAR_FECHA_VENC
                  , DTYPE
                  , NFA_TAR_REVISADA
            )
            SELECT DISTINCT
                  MIG2.TAR_ID                                                                               AS TAR_ID
                  , (SELECT EIN.DD_EIN_ID
                          FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN
                          WHERE EIN.DD_EIN_CODIGO = ''61''
                          AND BORRADO = 0
                  )                                                                                                 AS DD_EIN_ID
                  , STA.DD_STA_ID                                                                         AS DD_STA_ID
                  , 1                                                                                              AS TAR_CODIGO
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_TAREA
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_DESCRIPCION
                  , SYSDATE                                                                                 AS TAR_FECHA_INI
                  , 0                                                                                             AS TAR_EN_ESPERA
                  , 0                                                                                              AS TAR_ALERTA
                  , 0                                                                                             AS TAR_TAREA_FINALIZADA
                  , 0                                                                                             AS VERSION
                  , '''||V_USUARIO||'''                                                                       AS USUARIOCREAR
                  , SYSDATE                                                                                 AS FECHACREAR
                  , 0                                                                                             AS BORRADO
                  , (SELECT SYSDATE + 3 FROM DUAL)                                          AS TAR_FECHA_VENC
                  , ''EXTTareaNotificacion''                                                               AS DTYPE
                  , 0                                                                                             AS NFA_TAR_REVISADA
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
                  INNER JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_ID = TAP.DD_STA_ID
      '
      ;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAR||' cargada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ETN_EXTAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO TAREAS EXTERNAS NOTIFICACIONES...';

      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ETN||'
            (
                  TAR_ID
                  ,TAR_FECHA_VENC_REAL
            )
            SELECT DISTINCT
                  MIG2.TAR_ID
                  ,(SELECT SYSDATE + 3 FROM DUAL) AS TAR_FECHA_VENC_REAL
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
      '
      ;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ETN||' cargada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TEX_TAREA_EXTERNA --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO TAREAS EXTERNAS...';

      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TEX||'
            (
                  TEX_ID
                  , TAR_ID
                  , TAP_ID
                  , TEX_TOKEN_ID_BPM
                  , TEX_DETENIDA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TEX_NUM_AUTOP
                  , DTYPE
            )
            SELECT DISTINCT
                  MIG2.TEX_ID             AS TEX_ID
                  , MIG2.TAR_ID          AS TAR_ID
                  , MIG2.TAP_ID           AS TAP_ID
                  , NULL                     AS TEX_TOKEN_ID_BPM
                  , 0                           AS TEX_DETENIDA
                  , 0                           AS VERSION
                  , '''||V_USUARIO||'''     AS USUARIOCREAR
                  , SYSDATE               AS FECHACREAR
                  , 0                              AS BORRADO
                  , 0                             AS TEX_NUM_AUTOP
                  , ''EXTTareaExterna''     AS DTYPE
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
      '
      ;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TEX||' cargada. '||SQL%ROWCOUNT||' Filas.';

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAC_TAREAS_ACTIVOS --
      ---------------------------------------------------------------------------------------------------------------

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] CREANDO RELACION TAREAS ACTIVOS...';

      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAC||'
            (
                  TAR_ID
                  , TRA_ID
                  , ACT_ID
                  , USU_ID
                  , SUP_ID
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
            )
            WITH UNICO_ACTIVO AS (
                  SELECT DISTINCT
                        MIG2.TAR_ID
                        , MIG2.TRA_ID
                        , MIG2.ACT_ID
                        , MIG2.USU_ID
                        , MIG2.SUP_ID
                        , ROW_NUMBER () OVER (PARTITION BY MIG2.TAR_ID ORDER BY MIG2.ACT_ID DESC) AS ORDEN
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
            )
            SELECT
                  UA.TAR_ID             AS TAR_ID
                  , UA.TRA_ID           AS TRA_ID
                  , UA.ACT_ID           AS ACT_ID
                  , UA.USU_ID           AS USU_ID
                  , UA.SUP_ID           AS SUP_ID
                  , 0                       AS VERSION
                  , '''||V_USUARIO||''' AS USUARIOCREAR
                  , SYSDATE           AS FECHACREAR
                  ,0                        AS BORRADO
            FROM UNICO_ACTIVO UA
            WHERE UA.ORDEN = 1
      '
      ;

      PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAC||' cargada. '||SQL%ROWCOUNT||' Filas.';

    IF LIST_EXP_EEC IS NOT NULL AND EEC_DESTINO IS NOT NULL THEN

    	PL_OUTPUT := PL_OUTPUT ||chr(10) || '';
    	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ECO||' T1
    		USING '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL T2
    		ON (T2.DD_EEC_CODIGO = '''||EEC_DESTINO||''')
    		WHEN MATCHED THEN UPDATE SET
    			T1.DD_EEC_ID = T2.DD_EEC_ID, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
    		WHERE T1.ECO_NUM_EXPEDIENTE IN ('||LIST_EXP_EEC||')';
    	EXECUTE IMMEDIATE V_MSQL;
    	PL_OUTPUT := PL_OUTPUT ||chr(10) || '   [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ECO||' actualizada. '||SQL%ROWCOUNT||' Filas.';

    END IF;

    PL_OUTPUT := PL_OUTPUT ||chr(10) || '';
    PL_OUTPUT := PL_OUTPUT ||chr(10) || '[FIN] Reposicionamiento de trámites de expedientes comerciales.';

    REM01.ALTA_BPM_INSTANCES(V_USUARIO,PL_OUTPUT2);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE);
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '-----------------------------------------------------------';
      PL_OUTPUT := PL_OUTPUT ||chr(10) || SQLERRM;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || V_MSQL;
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
