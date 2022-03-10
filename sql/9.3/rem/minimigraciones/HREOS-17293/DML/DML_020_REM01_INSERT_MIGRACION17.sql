--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-17293
--## PRODUCTO=NO
--## 
--## Finalidad:
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



	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-17293';
	V_SQL VARCHAR2(4500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
	V_TABLA VARCHAR2 (30 CHAR) := 'ACT_PTO_PRESUPUESTO';
	V_TABLA_2 VARCHAR2 (30 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION';
	V_TABLA_3 VARCHAR2 (30 CHAR) := 'ACT_AHP_HIST_PUBLICACION';
	V_TABLA_4 VARCHAR2 (30 CHAR) := 'ACT_AGA_AGRUPACION_ACTIVO';
	V_TABLA_5 VARCHAR2 (30 CHAR) := 'ACT_AGR_AGRUPACION';
	V_TABLA_6 VARCHAR2 (30 CHAR) := 'ACT_ICM_INF_COMER_HIST_MEDI';
	V_TABLA_7 VARCHAR2 (30 CHAR) := 'ACT_PTA_PATRIMONIO_ACTIVO';
	V_TABLA_8 VARCHAR2 (30 CHAR) := 'ACT_COE_CONDICION_ESPECIFICA';
	V_TABLA_9 VARCHAR2 (30 CHAR) := 'ACT_HFP_HIST_FASES_PUB';
	V_TABLA_AUX_MIG VARCHAR2 (30 CHAR) := 'AUX_SEGUIR_MIGRACION';
	V_TABLA_AUX_2 VARCHAR2 (30 CHAR) := 'AUX_AGA_AGR';

	

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');

     V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AUX_MIG||' WHERE SEGUIR_MIGRACION = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 0  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA HAY ACTIVOS INSERTADOS EN ACT_ACTIVO DE LOS QUE SE QUIEREN INSERTAR');
        
    ELSE 

--INSERTAMOS EN AUX_AGA_AGR

V_SQL := 'INSERT INTO     '||V_ESQUEMA||'.AUX_AGA_AGR 
			(AGR_ID_VIEJO,
			AGR_ID_NUEVO,
			AGR_NUM_AGRUP_REM
			)
				SELECT 
				AGR_ID AGR_ID_VIEJO
				,'||V_ESQUEMA||'.S_ACT_AGR_AGRUPACION.NEXTVAL 		AGR_ID_NUEVO
				,'||V_ESQUEMA||'.S_AGR_NUM_AGRUP_REM.NEXTVAL      	AGR_NUM_AGRUP_REM
				
				FROM(
				WITH NUM_ACT_TOT
					AS( SELECT	
							AGA.AGR_ID,
							AGR.AGR_FECHA_BAJA,
							COUNT(ACT.ACT_ID) AS TOT
								FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
								JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID
								JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND (AGR.AGR_FECHA_BAJA IS NULL OR AGR.AGR_FECHA_BAJA > TRUNC(SYSDATE)+1)
								LEFT JOIN '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT AND aga.BORRADO = 0 group by AGA.AGR_ID, AGR.AGR_FECHA_BAJA
								HAVING AGA.AGR_ID IN (SELECT
												AGA.AGR_ID
												FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
													JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID
													JOIN '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT AND aga.BORRADO = 0)
			),


			NUM_ACT_TOT_AUX
					AS( SELECT	
						AGA.AGR_ID,
						COUNT(ACT.ACT_ID) AS TOT
						
						FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
						JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID
						JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND (AGR.AGR_FECHA_BAJA IS NULL OR AGR.AGR_FECHA_BAJA > TRUNC(SYSDATE)+1)
						JOIN '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT AND aga.BORRADO = 0 group by AGA.AGR_ID
						
						HAVING AGA.AGR_ID IN (SELECT
							AGA.AGR_ID
							FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
								JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID
								JOIN '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT AND aga.BORRADO = 0)
								
								
			)   
				
				
				
				SELECT DISTINCT 
					
					AGA.AGR_ID

					FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
					JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND aga.BORRADO = 0  
					JOIN NUM_ACT_TOT ACT_TOT ON ACT_TOT.AGR_ID = AGA.AGR_ID
					JOIN NUM_ACT_TOT_AUX ACT_TOT_AUX ON ACT_TOT_AUX.AGR_ID = AGA.AGR_ID
					WHERE ACT_TOT.TOT = ACT_TOT_AUX.TOT
					)';
      EXECUTE IMMEDIATE V_SQL;
      
 	  -------------------------------------------------
      --insercion en ACT_PTO_PRESUPUESTO--
      -------------------------------------------------

      
      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_PTO_PRESUPUESTO'',''2''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO (PTO_ID, ACT_ID, EJE_ID, PTO_IMPORTE_INICIAL, PTO_FECHA_ASIGNACION, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_PTO_PRESUPUESTO.NEXTVAL
            , ACT2.ACT_ID, PTO.EJE_ID, PTO.PTO_IMPORTE_INICIAL
            , SYSDATE, '''||V_USUARIO||''', SYSDATE
        	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
			JOIN '||V_ESQUEMA||'.'||V_TABLA||' PTO ON PTO.ACT_ID = ACT.ACT_ID';
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO creados. '||SQL%ROWCOUNT||' Filas.');
     

      
      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_APU_ACTIVO_PUBLICACION'',''2''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION (APU_ID,
									ACT_ID,
									DD_TPU_ID,
									DD_EPV_ID,
									DD_EPA_ID,
									DD_TCO_ID,
									DD_MTO_V_ID,
									APU_MOT_OCULTACION_MANUAL_V,
									APU_CHECK_PUBLICAR_V,
									APU_CHECK_OCULTAR_V,
									APU_CHECK_OCULTAR_PRECIO_V,
									APU_CHECK_PUB_SIN_PRECIO_V,
									DD_MTO_A_ID,
									APU_MOT_OCULTACION_MANUAL_A,
									APU_CHECK_PUBLICAR_A,
									APU_CHECK_OCULTAR_A,
									APU_CHECK_OCULTAR_PRECIO_A,
									APU_CHECK_PUB_SIN_PRECIO_A,
									APU_FECHA_INI_VENTA,
									APU_FECHA_INI_ALQUILER,
									ES_CONDICONADO_ANTERIOR,
									DD_TPU_V_ID,
									DD_TPU_A_ID,
									APU_MOTIVO_PUBLICACION,
									APU_MOTIVO_PUBLICACION_ALQ,
									APU_FECHA_CAMB_PUBL_VENTA,
									APU_FECHA_CAMB_PUBL_ALQ,
									APU_FECHA_CAMB_PREC_VENTA,
									APU_FECHA_CAMB_PREC_ALQ,
									APU_FECHA_REVISION_PUB_VENTA,
									APU_FECHA_REVISION_PUB_ALQ,
									DD_POR_ID,
									VERSION,
									USUARIOCREAR,
									FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_APU_ACTIVO_PUBLICACION.NEXTVAL		APU_ID,
        ACT2.ACT_ID,
		APU.DD_TPU_ID,

		(SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''03'') DD_EPV_ID,
        
        CASE
        WHEN (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''10'') = ACT.DD_SCM_ID 
        THEN (SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''03'')
        ELSE (SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''01'')
        END DD_EPA_ID,

		APU.DD_TCO_ID,
		APU.DD_MTO_V_ID,
		APU.APU_MOT_OCULTACION_MANUAL_V,
		APU.APU_CHECK_PUBLICAR_V,
		APU.APU_CHECK_OCULTAR_V,
		APU.APU_CHECK_OCULTAR_PRECIO_V,
		APU.APU_CHECK_PUB_SIN_PRECIO_V,
		APU.DD_MTO_A_ID,
		APU.APU_MOT_OCULTACION_MANUAL_A,
		APU.APU_CHECK_PUBLICAR_A,
		APU.APU_CHECK_OCULTAR_A,
		APU.APU_CHECK_OCULTAR_PRECIO_A,
		APU.APU_CHECK_PUB_SIN_PRECIO_A,
		APU.APU_FECHA_INI_VENTA,
		APU.APU_FECHA_INI_ALQUILER,
		APU.ES_CONDICONADO_ANTERIOR,
		APU.DD_TPU_V_ID,
		APU.DD_TPU_A_ID,
		APU.APU_MOTIVO_PUBLICACION,
		APU.APU_MOTIVO_PUBLICACION_ALQ,
		APU.APU_FECHA_CAMB_PUBL_VENTA,
		APU.APU_FECHA_CAMB_PUBL_ALQ,
		APU.APU_FECHA_CAMB_PREC_VENTA,
		APU.APU_FECHA_CAMB_PREC_ALQ,
		APU.APU_FECHA_REVISION_PUB_VENTA,
		APU.APU_FECHA_REVISION_PUB_ALQ,
		APU.DD_POR_ID,
                0,'''||V_USUARIO||''', SYSDATE
        	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
			JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' APU ON APU.ACT_ID = ACT.ACT_ID';
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION creados. '||SQL%ROWCOUNT||' Filas.');
     
      
      COMMIT; 



DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_3||'. [HISTORICO VALORACIONES ]');


	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_3||' HPUB (
	AHP_ID,
	ACT_ID,
	DD_TPU_ID,
	DD_EPV_ID,
	DD_EPA_ID,
	DD_TCO_ID,
	DD_MTO_V_ID,
	AHP_MOT_OCULTACION_MANUAL_V,
	AHP_CHECK_PUBLICAR_V,
	AHP_CHECK_OCULTAR_V,
	AHP_CHECK_OCULTAR_PRECIO_V,
	AHP_CHECK_PUB_SIN_PRECIO_V,
	DD_MTO_A_ID,
	AHP_MOT_OCULTACION_MANUAL_A,
	AHP_CHECK_PUBLICAR_A,
	AHP_CHECK_OCULTAR_A,
	AHP_CHECK_OCULTAR_PRECIO_A,
	AHP_CHECK_PUB_SIN_PRECIO_A,
	AHP_FECHA_INI_VENTA,
	AHP_FECHA_FIN_VENTA,
	AHP_FECHA_INI_ALQUILER,
	AHP_FECHA_FIN_ALQUILER,

	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO,

	ES_CONDICONADO_ANTERIOR,
	DD_TPU_V_ID,
	DD_TPU_A_ID,
	DD_POR_ID
	)
	SELECT
	  '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL   		                AHP_ID,
	ACT2.ACT_ID,
	ACT_HPUB.DD_TPU_ID												DD_TPU_ID,
	ACT_HPUB.DD_EPV_ID												DD_EPV_ID,
	ACT_HPUB.DD_EPA_ID												DD_EPA_ID,
	ACT_HPUB.DD_TCO_ID												DD_TCO_ID,
	ACT_HPUB.DD_MTO_V_ID												DD_MTO_V_ID,
	ACT_HPUB.AHP_MOT_OCULTACION_MANUAL_V								AHP_MOT_OCULTACION_MANUAL_V,
	ACT_HPUB.AHP_CHECK_PUBLICAR_V									AHP_CHECK_PUBLICAR_V,
	ACT_HPUB.AHP_CHECK_OCULTAR_V										AHP_CHECK_OCULTAR_V,
	ACT_HPUB.AHP_CHECK_OCULTAR_PRECIO_V								AHP_CHECK_OCULTAR_PRECIO_V,
	ACT_HPUB.AHP_CHECK_PUB_SIN_PRECIO_V								AHP_CHECK_PUB_SIN_PRECIO_V,
	ACT_HPUB.DD_MTO_A_ID												DD_MTO_A_ID,
	ACT_HPUB.AHP_MOT_OCULTACION_MANUAL_A								AHP_MOT_OCULTACION_MANUAL_A,
	ACT_HPUB.AHP_CHECK_PUBLICAR_A									AHP_CHECK_PUBLICAR_A,
	ACT_HPUB.AHP_CHECK_OCULTAR_A										AHP_CHECK_OCULTAR_A,
	ACT_HPUB.AHP_CHECK_OCULTAR_PRECIO_A								AHP_CHECK_OCULTAR_PRECIO_A,
	ACT_HPUB.AHP_CHECK_PUB_SIN_PRECIO_A								AHP_CHECK_PUB_SIN_PRECIO_A,
	ACT_HPUB.AHP_FECHA_INI_VENTA										AHP_FECHA_INI_VENTA,
	ACT_HPUB.AHP_FECHA_FIN_VENTA										AHP_FECHA_FIN_VENTA,
	ACT_HPUB.AHP_FECHA_INI_ALQUILER									AHP_FECHA_INI_ALQUILER,
	ACT_HPUB.AHP_FECHA_FIN_ALQUILER									AHP_FECHA_FIN_ALQUILER,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   	  USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	0                                                         BORRADO,
	ACT_HPUB.ES_CONDICONADO_ANTERIOR							ES_CONDICONADO_ANTERIOR,
	ACT_HPUB.DD_TPU_V_ID										DD_TPU_V_ID,
	ACT_HPUB.DD_TPU_A_ID										DD_TPU_A_ID,
	ACT_HPUB.DD_POR_ID											DD_POR_ID

	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_3||' ACT_HPUB ON ACT.ACT_ID = ACT_HPUB.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_3||' cargada. '||SQL%ROWCOUNT||' Filas.');
  

  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_3||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_3||' ANALIZADA.');




DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_4||'. [ACT_AGA_AGRUPACION_ACTIVO ]');

EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA_4||' disable constraint FK_RELAGRACT_AGRUPACION');

	

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_4||' (

	AGA_ID,
	AGR_ID,
	ACT_ID,
	AGA_FECHA_INCLUSION,
	AGA_PRINCIPAL,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO,
	ACT_AGA_PARTICIPACION_UA,
	ACT_AGA_ID_PRINEX_HPM,
	PISO_PILOTO
	)
	WITH NUM_ACT_TOT
			AS( 
				SELECT AUX.AGR_ID, COUNT(ACT_NUM_ACTIVO) AS TOT
				FROM (
					SELECT DISTINCT AGA.AGR_ID
					FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT 
					JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND aga.BORRADO = 0
					JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
					WHERE AGR.DD_TAG_ID IN (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO IN (''01'',''02'',''14'',''15''))
					AND (AGR.AGR_FECHA_BAJA IS NULL OR AGR.AGR_FECHA_BAJA > TRUNC(SYSDATE)+1)
				) AUX
				JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AUX.AGR_ID
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID
				WHERE AGA.BORRADO = 0
				GROUP BY (AUX.AGR_ID)
	),
			NUM_ACT_TOT_AUX
			AS( 
				SELECT AGR.AGR_ID, COUNT(ACT_NUM_ACTIVO) AS TOT
				FROM (
					SELECT DISTINCT AGA.AGR_ID
					FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT 
					JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND aga.BORRADO = 0
					JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
					WHERE AGR.DD_TAG_ID IN (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO IN (''01'',''02'',''14'',''15''))
					AND (AGR.AGR_FECHA_BAJA IS NULL OR AGR.AGR_FECHA_BAJA > TRUNC(SYSDATE)+1)
				) AGR
				JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID
				JOIN '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
				WHERE AGA.BORRADO = 0
				GROUP BY (AGR.AGR_ID)
	
				
	)   
	SELECT
		'||V_ESQUEMA||'.S_'||V_TABLA_4||'.NEXTVAL   		 	AGA_ID,
        AUX_AGA_AGR.AGR_ID_NUEVO 								AGR_ID,
		ACT2.ACT_ID												ACT_ID,
		AGA.AGA_FECHA_INCLUSION                                    AGA_FECHA_INCLUSION,
		AGA.AGA_PRINCIPAL                                         AGA_PRINCIPAL,
		''0''                                                    VERSION,
		'''||V_USUARIO||'''                                  	  USUARIOCREAR,
		SYSDATE                                                   FECHACREAR,
		NULL                                                      USUARIOMODIFICAR,
		NULL                                                      FECHAMODIFICAR,
		NULL                                                      USUARIOBORRAR,
		NULL                                                      FECHABORRAR,
		AGA.BORRADO                                                         BORRADO,
		AGA.ACT_AGA_PARTICIPACION_UA                               ACT_AGA_PARTICIPACION_UA,
		AGA.ACT_AGA_ID_PRINEX_HPM                                  ACT_AGA_ID_PRINEX_HPM,
		AGA.PISO_PILOTO                                             PISO_PILOTO


		FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
		JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
		JOIN '||V_ESQUEMA||'.'||V_TABLA_4||' AGA ON ACT.ACT_ID = AGA.ACT_ID AND aga.BORRADO = 0
		JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
        JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX_2||' AUX_AGA_AGR ON AUX_AGA_AGR.AGR_ID_VIEJO = AGA.AGR_ID
		JOIN NUM_ACT_TOT ACT_TOT ON ACT_TOT.AGR_ID = AGA.AGR_ID
        JOIN NUM_ACT_TOT_AUX ACT_TOT_AUX ON ACT_TOT_AUX.AGR_ID = AGA.AGR_ID
        WHERE ACT_TOT.TOT = ACT_TOT_AUX.TOT
	')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_4||' cargada. '||SQL%ROWCOUNT||' Filas.');


  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_4||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_4||' ANALIZADA.');





DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_5||'. [ACT_AGR_AGRUPACION ]');

	

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_5||' (

	AGR_ID,
	DD_TAG_ID,
	AGR_NOMBRE,
	AGR_DESCRIPCION,
	AGR_NUM_AGRUP_REM,
	AGR_NUM_AGRUP_UVEM,
	AGR_FECHA_ALTA,
	AGR_ELIMINADO,
	AGR_FECHA_BAJA,
	AGR_URL,
	AGR_PUBLICADO,
	AGR_SEG_VISITAS,
	AGR_TEXTO_WEB,
	AGR_ACT_PRINCIPAL,
	AGR_GESTOR_ID,
	AGR_MEDIADOR_ID,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO,
	AGR_INI_VIGENCIA,
	AGR_FIN_VIGENCIA,
	AGR_IS_FORMALIZACION,
	AGR_UVEM_COAGIW,
	DD_TAL_ID,
	AGR_NUM_AGRUP_PRINEX_HPM,
	AGR_EMPRESA_PROMOTORA,
	AGR_EMPRESA_COMERCIALIZADORA,
	AGR_COMERCIALIZABLE_CONS_PLANO,
	AGR_EXISTE_PISO_PILOTO,
	AGR_VISITABLE
	)

	  WITH  AUX_AGR_ACT_PRINCIPAL
           AS( 	
           SELECT DISTINCT
                AGR.AGR_ACT_PRINCIPAL
                ,ACT2.ACT_ID AGR_ACT_PRINCIPAL_NV
            
                FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO 
                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID
                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND agr.BORRADO=0
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA2 ON ACT2.ACT_ID = AGA2.ACT_ID
                JOIN '||V_ESQUEMA||'.AUX_AGA_AGR AUX_AGA_AGR ON AUX_AGA_AGR.AGR_ID_VIEJO = AGR.AGR_ID
                WHERE AGR.AGR_ACT_PRINCIPAL IS NOT NULL
                AND ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL
)
	SELECT DISTINCT
	AUX_AGA_AGR.AGR_ID_NUEVO  		                AGR_ID,
	AGR.DD_TAG_ID                       DD_TAG_ID,
	AGR.AGR_NOMBRE                      AGR_NOMBRE,
	AGR.AGR_DESCRIPCION                 AGR_DESCRIPCION,
	AUX_AGA_AGR.AGR_NUM_AGRUP_REM       AGR_NUM_AGRUP_REM,
	AGR.AGR_NUM_AGRUP_UVEM              AGR_NUM_AGRUP_UVEM,
	AGR.AGR_FECHA_ALTA                  AGR_FECHA_ALTA,
	AGR.AGR_ELIMINADO                   AGR_ELIMINADO,
	AGR.AGR_FECHA_BAJA                  AGR_FECHA_BAJA,
	AGR.AGR_URL                         AGR_URL,
	AGR.AGR_PUBLICADO                   AGR_PUBLICADO,
	AGR.AGR_SEG_VISITAS                 AGR_SEG_VISITAS,      
	AGR.AGR_TEXTO_WEB                   AGR_TEXTO_WEB,
	AUX_AGR_ACT.AGR_ACT_PRINCIPAL_NV    AGR_ACT_PRINCIPAL,
	AGR.AGR_GESTOR_ID                   AGR_GESTOR_ID,
	AGR.AGR_MEDIADOR_ID                 AGR_MEDIADOR_ID,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                 	  USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	AGR.BORRADO                                                         BORRADO,
	AGR.AGR_INI_VIGENCIA                AGR_INI_VIGENCIA,
	AGR.AGR_FIN_VIGENCIA                AGR_FIN_VIGENCIA,
	AGR.AGR_IS_FORMALIZACION            AGR_IS_FORMALIZACION,
	AGR.AGR_UVEM_COAGIW                 AGR_UVEM_COAGIW,
	AGR.DD_TAL_ID                       DD_TAL_ID,
	AGR.AGR_NUM_AGRUP_PRINEX_HPM        AGR_NUM_AGRUP_PRINEX_HPM,
	AGR.AGR_EMPRESA_PROMOTORA           AGR_EMPRESA_PROMOTORA,
	AGR.AGR_EMPRESA_COMERCIALIZADORA    AGR_EMPRESA_COMERCIALIZADORA,
	AGR.AGR_COMERCIALIZABLE_CONS_PLANO  AGR_COMERCIALIZABLE_CONS_PLANO,
	AGR.AGR_EXISTE_PISO_PILOTO          AGR_EXISTE_PISO_PILOTO,
	AGR.AGR_VISITABLE                   AGR_VISITABLE


	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_4||' AGA ON ACT.ACT_ID = AGA.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_5||' AGR ON AGR.AGR_ID = AGA.AGR_ID AND agr.BORRADO=0
    JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
    JOIN '||V_ESQUEMA||'.'||V_TABLA_4||' AGA2 ON ACT2.ACT_ID = AGA2.ACT_ID
    JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX_2||' AUX_AGA_AGR ON AUX_AGA_AGR.AGR_ID_VIEJO = AGR.AGR_ID
	LEFT JOIN AUX_AGR_ACT_PRINCIPAL AUX_AGR_ACT ON AUX_AGR_ACT.AGR_ACT_PRINCIPAL = AGR.AGR_ACT_PRINCIPAL
	')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_5||' cargada. '||SQL%ROWCOUNT||' Filas.');


  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_5||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_5||' ANALIZADA.');




DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_6||'. [HISTORICO MEDIADORES]');



	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_6||' HMED (
	ICM_ID,
	ACT_ID,
	ICO_MEDIADOR_ID,
	ICM_FECHA_DESDE,
	ICM_FECHA_HASTA,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO,
	DD_TRL_ID
	)
	SELECT
	  '||V_ESQUEMA||'.S_ACT_ICM_INF_COMER_HIST_MEDI.NEXTVAL   		                ICM_ID,
	ACT2.ACT_ID												ACT_ID,
	ACT_HMED.ICO_MEDIADOR_ID								ICO_MEDIADOR_ID,
	ACT_HMED.ICM_FECHA_DESDE								ICM_FECHA_DESDE,
	ACT_HMED.ICM_FECHA_HASTA								ICM_FECHA_HASTA,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   	  USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	ACT_HMED.BORRADO                                                         BORRADO,
	ACT_HMED.DD_TRL_ID													DD_TRL_ID

	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_6||' ACT_HMED ON ACT.ACT_ID = ACT_HMED.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_6||' cargada. '||SQL%ROWCOUNT||' Filas.');
  

  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_6||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_6||' ANALIZADA.');



DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_7||'. [PATRIMONIO]');


	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA (
	ACT_PTA_ID,
    ACT_ID,
    DD_ADA_ID,
    CHECK_HPM,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    USUARIOMODIFICAR,
    FECHAMODIFICAR,
    USUARIOBORRAR,
    FECHABORRAR,
    BORRADO,
    DD_ADA_ID_ANTERIOR,
    DD_EAL_ID,
    DD_TPI_ID,
    CHECK_SUBROGADO,
    PTA_RENTA_ANTIGUA,
    DD_CDU_ID,
    PTA_TRAMITE_ALQ_SOCIAL
	)
	SELECT
	  '||V_ESQUEMA||'.S_ACT_PTA_PATRIMONIO_ACTIVO.NEXTVAL   		     ACT_PTA_ID,
	ACT2.ACT_ID												ACT_ID,
	ACT_PTA.DD_ADA_ID										DD_ADA_ID,
	ACT_PTA.CHECK_HPM										CHECK_HPM,

	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                  	  USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	ACT_PTA.BORRADO                                                         BORRADO,
	ACT_PTA.DD_ADA_ID_ANTERIOR									DD_ADA_ID_ANTERIOR,
    ACT_PTA.DD_EAL_ID											DD_EAL_ID,
    ACT_PTA.DD_TPI_ID											DD_TPI_ID,
    ACT_PTA.CHECK_SUBROGADO										CHECK_SUBROGADO,
    ACT_PTA.PTA_RENTA_ANTIGUA									PTA_RENTA_ANTIGUA,
    ACT_PTA.DD_CDU_ID											DD_CDU_ID,
    ACT_PTA.PTA_TRAMITE_ALQ_SOCIAL								PTA_TRAMITE_ALQ_SOCIAL

	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_7||' ACT_PTA ON ACT.ACT_ID = ACT_PTA.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	WHERE ACT.DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''10'')
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_7||' cargada. '||SQL%ROWCOUNT||' Filas.');
  

  COMMIT;
  
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_7||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_7||' ANALIZADA.');
      
      
      EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA_4||' enable constraint FK_RELAGRACT_AGRUPACION');



DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_8||'. [CONDICION ESPECIFICA]');


	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_8||' COE (
	COE_ID,
	ACT_ID,
	COE_TEXTO,
	COE_FECHA_DESDE,
	COE_FECHA_HASTA,
	COE_USUARIO_ALTA,
	COE_USUARIO_BAJA,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO,
	COE_CODIGO
	)
	SELECT
	  '||V_ESQUEMA||'.S_ACT_COE_CONDICION_ESPECIFICA.NEXTVAL   		                COE_ID,
	ACT2.ACT_ID												ACT_ID,
	ACT_COE.COE_TEXTO										COE_TEXTO,
	ACT_COE.COE_FECHA_DESDE								COE_FECHA_DESDE,
	ACT_COE.COE_FECHA_HASTA								COE_FECHA_HASTA,
	ACT_COE.COE_USUARIO_ALTA								COE_USUARIO_ALTA,
	ACT_COE.COE_USUARIO_BAJA								COE_USUARIO_BAJA,

	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   	  USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	ACT_COE.BORRADO                                                         BORRADO,
	ACT_COE.COE_CODIGO													COE_CODIGO

	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_8||' ACT_COE ON ACT.ACT_ID = ACT_COE.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_8||' cargada. '||SQL%ROWCOUNT||' Filas.');


V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_8||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_8||' ANALIZADA.');




DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_9||'. [ACT_HFP_HIST_FASES_PUB]');


	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_9||'  (
    HFP_ID,
    ACT_ID,
    DD_FSP_ID,
    DD_SFP_ID,
    USU_ID,
    HFP_FECHA_INI,
    HFP_FECHA_FIN,
    HFP_COMENTARIO,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO
	)
	SELECT
	  '||V_ESQUEMA||'.S_ACT_HFP_HIST_FASES_PUB.NEXTVAL    	HFP_ID,
	ACT2.ACT_ID												ACT_ID,
  	HFP.DD_FSP_ID,
    HFP.DD_SFP_ID,
    HFP.USU_ID,
    HFP.HFP_FECHA_INI,
    HFP.HFP_FECHA_FIN,
    HFP.HFP_COMENTARIO,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                   	  USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	NULL                                                      USUARIOMODIFICAR,
	NULL                                                      FECHAMODIFICAR,
	NULL                                                      USUARIOBORRAR,
	NULL                                                      FECHABORRAR,
	HFP.BORRADO                                                BORRADO

	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_9||' HFP ON ACT.ACT_ID = HFP.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_9||' cargada. '||SQL%ROWCOUNT||' Filas.');

 V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_9||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_9||' ANALIZADA.');


  
  END IF;
  COMMIT;
  
      



      DBMS_OUTPUT.PUT_LINE('[FIN]');
      
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