--/*
--##########################################
--## AUTOR=CLV
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-1554
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

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    USUARIO varchar2(20 CHAR) := 'RECOVERY-1554';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] LAMINACION DE TAREAS DE LA MIGRACION');

	SELECT COUNT(1)
	INTO V_NUM_TABLAS
	FROM ALL_TABLES
	WHERE TABLE_NAME = 'TMP_MIG_LAM_CONFDES';

	IF V_NUM_TABLAS = 0 THEN

	  EXECUTE IMMEDIATE 'CREATE TABLE '||v_esquema||'.TMP_MIG_LAM_CONFDES 
							   (DES_CODIGO VARCHAR2(20 CHAR) NOT NULL ENABLE, 
								TARS_FIRST_10 NUMBER(16,0) NOT NULL ENABLE, 
								TARS_RESTO NUMBER(16,0) NOT NULL ENABLE, 
								MAX_DAYS NUMBER(16,0) NOT NULL ENABLE
							   )';
                 
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA TMP_MIG_LAM_CONFDES CREADA');

	  EXECUTE IMMEDIATE 'INSERT INTO '||v_esquema||'.TMP_MIG_LAM_CONFDES VALUES (''ALL'',30,40,90)';

		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA TMP_MIG_LAM_CONFDES PARAMETRIZADA');

	ELSE

	  EXECUTE IMMEDIATE 'DELETE FROM '||v_esquema||'.TMP_MIG_LAM_CONFDES';

	  EXECUTE IMMEDIATE 'INSERT INTO '||v_esquema||'.TMP_MIG_LAM_CONFDES VALUES (''ALL'',30,40,90)';

		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA TMP_MIG_LAM_CONFDES PARAMETRIZADA');

	END IF;


    v_sql := 'MERGE INTO '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES TAR
	    USING (
              WITH DES_LETRADOS AS
              ( SELECT DISTINCT GAA.ASU_ID, USD.DES_ID,  DES.DES_CODIGO,  DES.DES_DESPACHO, TGE.DD_TGE_CODIGO , TGE.DD_TGE_DESCRIPCION
              FROM '||v_esquema||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA
              JOIN '||v_esquema_master||'.DD_TGE_TIPO_GESTOR TGE ON GAA.DD_TGE_ID = TGE.DD_TGE_ID
              JOIN '||v_esquema||'.USD_USUARIOS_DESPACHOS USD ON GAA.USD_ID = USD.USD_ID AND USD.BORRADO=0
              JOIN '||v_esquema||'.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID AND DES.BORRADO=0
              JOIN '||v_esquema_master||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
              JOIN '||v_esquema||'.ASU_ASUNTOS ASU ON ASU.ASU_ID = GAA.ASU_ID
              WHERE TGE.DD_TGE_CODIGO IN (''GEXT'')
                  AND GAA.BORRADO=0
              )
              
              , TAREAS_A_LAMINAR AS (
              SELECT TAR.TAR_ID, TAR.TAR_FECHA_VENC, DES.DES_ID, DES.DES_CODIGO, DES.DES_DESPACHO
              FROM '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES TAR
              JOIN '||v_esquema||'.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
              JOIN '||v_esquema||'.PRC_PROCEDIMIENTOS PRC ON TAR.PRC_ID = PRC.PRC_ID
              JOIN '||v_esquema||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
              JOIN DES_LETRADOS DES ON PRC.ASU_ID = DES.ASU_ID
              WHERE (TAR.TAR_TAREA_FINALIZADA IS NULL OR TAR.TAR_TAREA_FINALIZADA = 0)
              AND TAR.BORRADO = 0
              AND TAP.TAP_CODIGO NOT IN (
               ''H001_RegistrarComparecencia''
              ,''H024_RegistrarAudienciaPrevia''
              ,''H024_RegistrarJuicio''
              ,''H026_RegistrarJuicio''
              ,''H007_RegistrarCelebracionVista''
              ,''H020_RegistrarCelebracionVista''
              ,''H018_RegistrarVista''
              ,''H016_registrarJuicioComparecencia''
              ,''H028_RegistrarJuicioVerbal''
              ,''CJ004_PrepararInformeSubasta''
              ,''H002_PrepararInformeSubasta''
              ,''H002_LecturaConfirmacionInstrucciones''
              ,''CJ004_CelebracionSubasta''
              ,''H002_CelebracionSubasta''
              ,''H006_RealizacionCesionRemate''
              ,''H066_registrarPresentacionHacienda''
              ,''H015_RegistrarPosesionYLanzamiento''
              ,''H015_RegistrarLanzamientoEfectuado''
              ,''H048_RegistrarCelebracionVista''
              )
              )
              , DESPACHOS_TAREAS AS (
              SELECT DES_ID, DES_CODIGO, DES_DESPACHO,  COUNT(TAR_ID) NUM_TAR
              FROM TAREAS_A_LAMINAR
              GROUP BY DES_ID, DES_CODIGO, DES_DESPACHO
              )
              
              , REPARTO_DESPACHOS AS
              (SELECT DT.DES_ID, DT.DES_CODIGO, DT.NUM_TAR, CD.TARS_FIRST_10, CD.TARS_RESTO, CD.MAX_DAYS
              FROM DESPACHOS_TAREAS DT
              LEFT JOIN HAYA02.TMP_MIG_LAM_CONFDES CD ON CD.DES_CODIGO = ''ALL''
              )
              , AUXILIAR_LAMINACION AS
              (SELECT TAR.TAR_ID, DT.DES_CODIGO, DT.DES_DESPACHO, TAR.DES_ID, TAR.TAR_FECHA_VENC,
              ROW_NUMBER() OVER(PARTITION BY TAR.DES_ID ORDER BY TAR.TAR_ID) TAR_ORD,
              DT.NUM_TAR
              FROM TAREAS_A_LAMINAR TAR
              JOIN DESPACHOS_TAREAS DT ON TAR.DES_ID = DT.DES_ID
              )
              , LAMINACION AS (
              SELECT L.TAR_ID, L.DES_ID, L.DES_CODIGO, L.DES_DESPACHO, L.TAR_FECHA_VENC VENC_ORIGINAL, L.TAR_ORD,
              L.NUM_TAR, R.TARS_FIRST_10, R.TARS_RESTO, R.MAX_DAYS ,
              CASE
              WHEN (L.TAR_ORD <= (30 * R.TARS_FIRST_10))  THEN MOD(L.TAR_ORD, 30)
              WHEN 30 + FLOOR((L.TAR_ORD - (30 * R.TARS_FIRST_10)) / R.TARS_RESTO) <= R.MAX_DAYS THEN 30 + FLOOR((L.TAR_ORD - (30 * R.TARS_FIRST_10)) / R.TARS_RESTO)
              WHEN R.MAX_DAYS <= 30 THEN 30 + MOD(L.TAR_ORD, (ROUND(L.NUM_TAR / (ROUND(L.NUM_TAR / (R.MAX_DAYS))))))
              ELSE 30 + MOD(L.TAR_ORD, (ROUND(L.NUM_TAR / (ROUND(L.NUM_TAR / (R.MAX_DAYS - 10))))))
              END DIA_TAR
              FROM AUXILIAR_LAMINACION L
              LEFT JOIN REPARTO_DESPACHOS R ON L.DES_CODIGO = R.DES_CODIGO
              )
	            select distinct L.*, TO_DATE(sysdate,''DD/MM/YYYY'') + L.DIA_TAR AS FECHA_VENC_NUEVA
	              from LAMINACION L
	  ) DATA
	  ON (TAR.TAR_ID = DATA.TAR_ID)
	WHEN MATCHED THEN UPDATE SET TAR.TAR_FECHA_VENC = DATA.FECHA_VENC_NUEVA
                              , TAR.TAR_FECHA_VENC_REAL = DATA.FECHA_VENC_NUEVA
                              , USUARIOMODIFICAR = '''||USUARIO||'''
                              , FECHAMODIFICAR = SYSDATE';


    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - FECHA_VENC DE TAR_TAREAS_NOTIFICACIONES Actualizada '||SQL%ROWCOUNT||' Filas');
    

    v_sql := 'TRUNCATE TABLE '||v_esquema||'.TMP_GUID_TAR_TAREAS_BCC ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('Truncate');
    v_sql := 'insert into '||v_esquema||'.TMP_GUID_TAR_TAREAS_BCC values (SYS_GUID,TAR_TAREA) 
                  select tar.tar_id, tar.SYS_GUID from '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES TAR where tar.usuarioborrar ='''||USUARIO||'' ;
    execute immediate v_sql;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Inserts en TMP_GUID_TAREAS_BCC '||SQL%ROWCOUNT||' Filas');    
    
    commit;

DBMS_OUTPUT.PUT_LINE('[FIN] LAMINACION DE TAREAS');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/


EXIT;
