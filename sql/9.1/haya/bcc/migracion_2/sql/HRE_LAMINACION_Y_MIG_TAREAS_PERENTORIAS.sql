WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA02'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    USUARIO varchar2(20 CHAR) := 'MIGRA2HAYA02PCO';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] CAJAMAR LAMINACION DE TAREAS DE LA MIGRACION');

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

	  EXECUTE IMMEDIATE 'INSERT INTO '||v_esquema||'.TMP_MIG_LAM_CONFDES VALUES (''ALL'',10,40,90)';

		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA TMP_MIG_LAM_CONFDES PARAMETRIZADA');

	ELSE

	  EXECUTE IMMEDIATE 'DELETE FROM '||v_esquema||'.TMP_MIG_LAM_CONFDES';

	  EXECUTE IMMEDIATE 'INSERT INTO '||v_esquema||'.TMP_MIG_LAM_CONFDES VALUES (''ALL'',10,40,90)';

		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA TMP_MIG_LAM_CONFDES PARAMETRIZADA');

	END IF;


    v_sql := 'MERGE INTO '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES TAR
	    USING (
	    WITH DES_LETRADOS AS
	    ( SELECT DISTINCT GAA.ASU_ID, USD.DES_ID,  DES.DES_CODIGO,  DES.DES_DESPACHO, TGE.DD_TGE_CODIGO , TGE.DD_TGE_DESCRIPCION
	    FROM '||v_esquema||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA
	      JOIN '||v_esquema_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON GAA.DD_TGE_ID = TGE.DD_TGE_ID
	      JOIN '||v_esquema||'.USD_USUARIOS_DESPACHOS USD ON GAA.USD_ID = USD.USD_ID
	      JOIN '||v_esquema||'.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID
	      JOIN '||v_esquema_MASTER||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
	      JOIN '||v_esquema||'.ASU_ASUNTOS ASU ON ASU.ASU_ID = GAA.ASU_ID
	    WHERE TGE.DD_TGE_CODIGO IN (''GEXT'')
	    ) 
	  , TAREAS_A_LAMINAR AS (
	    SELECT TAR.TAR_ID, TAR.TAR_FECHA_VENC, DES.DES_ID, DES.DES_CODIGO, DES.DES_DESPACHO
	    FROM '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES TAR
	      JOIN '||v_esquema||'.PRC_PROCEDIMIENTOS PRC ON TAR.PRC_ID = PRC.PRC_ID
	      JOIN DES_LETRADOS DES ON PRC.ASU_ID = DES.ASU_ID
	    WHERE (TAR.TAR_TAREA_FINALIZADA IS NULL OR TAR.TAR_TAREA_FINALIZADA = 0)
	      AND TAR.BORRADO = 0 AND PRC.USUARIOCREAR in (''MIGRA2HAYA02PCO'', ''MIGRA2HAYA02'')
	    )
	  , DESPACHOS_TAREAS AS (
	    SELECT DES_ID, DES_CODIGO, DES_DESPACHO,  COUNT(TAR_ID) NUM_TAR
	    FROM TAREAS_A_LAMINAR
	    GROUP BY DES_ID, DES_CODIGO, DES_DESPACHO
	    )
	  , REPARTO_DESPACHOS AS
	    (SELECT DT.DES_ID, DT.DES_CODIGO, DT.NUM_TAR, CD.TARS_FIRST_10, CD.TARS_RESTO, CD.MAX_DAYS
	    FROM DESPACHOS_TAREAS DT
	      LEFT JOIN TMP_MIG_LAM_CONFDES CD ON CD.DES_CODIGO = ''ALL'' --DT.DES_CODIGO = CD.DES_CODIGO
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
		WHEN (L.TAR_ORD <= (10 * R.TARS_FIRST_10))  THEN MOD(L.TAR_ORD, 10)
		WHEN 10 + FLOOR((L.TAR_ORD - (10 * R.TARS_FIRST_10)) / R.TARS_RESTO) <= R.MAX_DAYS THEN 10 + FLOOR((L.TAR_ORD - (10 * R.TARS_FIRST_10)) / R.TARS_RESTO)
		WHEN R.MAX_DAYS <= 10 THEN 10 + MOD(L.TAR_ORD, (ROUND(L.NUM_TAR / (ROUND(L.NUM_TAR / (R.MAX_DAYS))))))
		ELSE 10 + MOD(L.TAR_ORD, (ROUND(L.NUM_TAR / (ROUND(L.NUM_TAR / (R.MAX_DAYS - 10))))))
	      END DIA_TAR
	    FROM AUXILIAR_LAMINACION L
	      LEFT JOIN REPARTO_DESPACHOS R ON L.DES_CODIGO = R.DES_CODIGO
	    )
	  select L.*, TO_DATE(''18/04/2016'',''DD/MM/YYYY'') + L.DIA_TAR AS FECHA_VENC_NUEVA
	  from LAMINACION L
	  ) DATA
	  ON (TAR.TAR_ID = DATA.TAR_ID)
	WHEN MATCHED THEN UPDATE SET TAR.TAR_FECHA_VENC = DATA.FECHA_VENC_NUEVA
                              , TAR.TAR_FECHA_VENC_REAL = DATA.FECHA_VENC_NUEVA
                              , USUARIOMODIFICAR = ''MIGRA2HAYA02LAMIN''
                              , FECHAMODIFICAR = SYSDATE';


    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - FECHA_VENC DE TAR_TAREAS_NOTIFICACIONES Actualizada '||SQL%ROWCOUNT||' Filas');
    Commit;


DBMS_OUTPUT.PUT_LINE('[FIN] CAJAMAR LAMINACION DE TAREAS');

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
create or replace PROCEDURE MIG_TAR_TAREAS_PERENTORIAS AS
  
  C_PRIMER_DIA DATE;
  C_USUARIOMODIFICAR VARCHAR2(20 CHAR);
  C_COD_TAREA_PERENTORIA VARCHAR2(50 CHAR);
  C_COD_TAREA_FECHA VARCHAR2(50 CHAR);
  C_CAMPO_FECHA VARCHAR2(50 CHAR);
  
  TYPE T_TAR_PER IS TABLE OF VARCHAR2(50);
  TYPE T_ARRAY_PER IS TABLE OF T_TAR_PER;
       
  V_TIPO_PER T_ARRAY_PER := T_ARRAY_PER(
      T_TAR_PER('H001_RegistrarComparecencia','H001_ConfirmarSiExisteOposicion','fechaComparecencia'),
      T_TAR_PER('H024_RegistrarAudienciaPrevia','H024_ConfirmarOposicion','fechaAudiencia'),
      T_TAR_PER('H024_RegistrarJuicio','H024_RegistrarAudienciaPrevia','fechaJuicio'),
      T_TAR_PER('H026_RegistrarJuicio','H026_ConfirmarNotifiDemanda','fechaJuicio'),
      T_TAR_PER('H007_RegistrarCelebracionVista','H007_Impugnacion','vistaImpugnacion'),
      T_TAR_PER('H020_RegistrarCelebracionVista','H020_ConfirmarVista','fechaVista'),
      T_TAR_PER('H018_RegistrarVista','H018_HayVista','fechaVista'),
      T_TAR_PER('H016_registrarJuicioComparecencia','H016_registrarDemandaOposicion','fechaVista'),
      T_TAR_PER('H028_RegistrarJuicioVerbal','H022_ConfirmarOposicionCuantia','fechaJuicio'),
      T_TAR_PER('CJ004_PrepararInformeSubasta','CJ004_SenyalamientoSubasta','fechaSenyalamiento'),
      T_TAR_PER('H002_PrepararInformeSubasta','H002_SenyalamientoSubasta','fechaSenyalamiento'),
      T_TAR_PER('H002_LecturaConfirmacionInstrucciones','H002_SenyalamientoSubasta','fechaSenyalamiento'),
      T_TAR_PER('CJ004_CelebracionSubasta','CJ004_SenyalamientoSubasta','fechaSenyalamiento'),
      T_TAR_PER('H002_CelebracionSubasta','H002_SenyalamientoSubasta','fechaSenyalamiento'),
      T_TAR_PER('H006_RealizacionCesionRemate','H006_ResenyarFechaComparecencia','fecha'),
      T_TAR_PER('H066_registrarPresentacionHacienda','H066_registrarEntregaTitulo','fecha'),
      T_TAR_PER('H015_RegistrarPosesionYLanzamiento','H015_RegistrarSenyalamientoPosesion','fechaSenyalamiento'),
      T_TAR_PER('H015_RegistrarLanzamientoEfectuado','H015_RegistrarSenyalamientoLanzamiento','fecha'),
      T_TAR_PER('H048_RegistrarCelebracionVista','H048_ConfirmarVista','fechaVista')
    );
		
  V_TMP_TIPO_PER T_TAR_PER;
  
	BEGIN
	  C_PRIMER_DIA := TO_DATE('18/04/2016','dd/mm/yyyy');
	  C_USUARIOMODIFICAR := 'MIGRA2HAYA02PEREN';
	  
	  FOR I IN V_TIPO_PER.FIRST .. V_TIPO_PER.LAST 
	  LOOP		
		V_TMP_TIPO_PER := V_TIPO_PER(I);
	  
		C_COD_TAREA_PERENTORIA := V_TMP_TIPO_PER(1);
		C_COD_TAREA_FECHA := V_TMP_TIPO_PER(2);
		C_CAMPO_FECHA := V_TMP_TIPO_PER(3);
		
		MERGE INTO TAR_TAREAS_NOTIFICACIONES TAR
		USING (
		  WITH TAREAS AS (
			SELECT /*+ MATERIALIZE */ TAR_ID, PRC_ID, TAR_FECHA_VENC, BORRADO, TAR_TAREA_FINALIZADA FROM TAR_TAREAS_NOTIFICACIONES
		  ), VALORES AS (
			SELECT TAR.PRC_ID, TO_DATE(VAL.TEV_VALOR, 'dd-mm-yyyy') FECHA_VENC
			FROM MIG_MAESTRA_HITOS_VALORES VAL 
			  JOIN TAREAS TAR ON VAL.TAR_ID = TAR.TAR_ID
			WHERE VAL.TAP_CODIGO = C_COD_TAREA_FECHA AND VAL.TEV_NOMBRE = C_CAMPO_FECHA AND VAL.TEV_VALOR IS NOT NULL
		  )
		  SELECT DISTINCT TAR.TAR_ID, TAR.PRC_ID, TAR.TAR_FECHA_VENC, VAL.FECHA_VENC
		  FROM TAREAS TAR 
			JOIN TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
			JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
			JOIN VALORES VAL ON TAR.PRC_ID = VAL.PRC_ID
		  WHERE TAP.TAP_CODIGO = C_COD_TAREA_PERENTORIA
			AND (TAR.TAR_TAREA_FINALIZADA IS NULL OR TAR.TAR_TAREA_FINALIZADA = 0)
			AND TAR.BORRADO = 0
			AND VAL.FECHA_VENC >= C_PRIMER_DIA
		  ) TMP
		  ON (TAR.TAR_ID = TMP.TAR_ID)
		  WHEN MATCHED THEN UPDATE SET TAR.TAR_FECHA_VENC = TMP.FECHA_VENC
									  , TAR.TAR_FECHA_VENC_REAL = TMP.FECHA_VENC
									  , TAR.USUARIOMODIFICAR = C_USUARIOMODIFICAR
									  , TAR.FECHAMODIFICAR = SYSDATE
		;
	  
	  DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO: ' || V_TMP_TIPO_PER(1) ||' - '||SQL%ROWCOUNT||' Filas...');
	   
	  END LOOP;
  
  COMMIT;
    
	DBMS_OUTPUT.PUT_LINE('[FIN] CAJAMAR TAREAS PERENTORIAS');

    EXCEPTION
     WHEN OTHERS THEN
        
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(SQLERRM);
          
          ROLLBACK;
          RAISE;

end MIG_TAR_TAREAS_PERENTORIAS;
/

EXEC haya02.MIG_TAR_TAREAS_PERENTORIAS;
/


EXIT;
