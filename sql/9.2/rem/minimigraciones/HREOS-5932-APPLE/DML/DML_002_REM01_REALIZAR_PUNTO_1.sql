--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190412
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5932
--## PRODUCTO=NO
--## Finalidad: ELiminar Ofertas y tramites del perímetro 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'HREOS-5932-PUNTO1';
    V_MSQL VARCHAR2(4000 CHAR);
    V_MAX_PTO_ID NUMBER(16,0);
    V_EJE_ID NUMBER(16,0);
    V_COUNT NUMBER(16):= 0;
    V_COUNT2 NUMBER(16):= 0;
    
    
    CURSOR ACTIVOS_HISTORICO_APU IS  SELECT DISTINCT APU.ACT_ID FROM REM01.ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.USUARIOMODIFICAR = 'HREOS-5932-PUNTO1';
    
    CURSOR ACTUALIZA_HISTORICO_PATRIMONIO IS SELECT ACT.ACT_ID FROM REM01.ACT_ACTIVO ACT 
												INNER JOIN REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA ON ACT.ACT_ID = PTA.ACT_ID
												WHERE ACT.USUARIOMODIFICAR = 'HREOS-5932-PUNTO1';
    						
    FILA ACTIVOS_HISTORICO_APU%ROWTYPE;
    
    FILA_HISTORICO ACTUALIZA_HISTORICO_PATRIMONIO%ROWTYPE;

BEGIN

  DBMS_OUTPUT.put_line('[INICIO] Ejecutando [PUNTO 1]  ...........');

/**************************	PUNTO 1	*********************************/

/**
1.2. Modificar su destino comercial a “Venta”
**/

		DBMS_OUTPUT.put_line('	[INFO] CAMBIA EL PERIMETRO DE ALQUILER A VENTA');
	
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING 
							(SELECT ACT.ACT_NUM_ACTIVO 
								FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
								INNER JOIN '||V_ESQUEMA||'.dd_scr_subcartera scr on act.dd_scr_id = scr.dd_scr_id
								INNER JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON ACT.ACT_ID = PTA.ACT_ID
								LEFT JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU on ACT.ACT_ID = apu.act_id
								LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION tco on tco.dd_tco_id = APU.DD_TCO_ID
								INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO <> ''05''
								WHERE ACT.ACT_NUM_ACTIVO NOT IN (SELECT ACT.ACT_NUM_ACTIVO 
																	FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX 
																	INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA)
								AND (PTA.CHECK_HPM = 1 OR TCO.DD_TCO_CODIGO in (''02'',''03''))
								AND ACT.BORRADO = 0 AND ACT.DD_TTA_ID <> 41
								AND SCR.DD_SCR_CODIGO = ''138'') T2
					ON (ACT.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
					WHEN MATCHED THEN
					UPDATE SET 
					      ACT.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
					    , ACT.USUARIOBORRAR = '''||V_USUARIOMODIFICAR||'''
						, ACT.FECHAMODIFICAR = SYSDATE';
					
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
  		
  		DBMS_OUTPUT.put_line('	[INFO] CAMBIA EL PERIMETRO DE ALQUILER A VENTA');
	
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING 
							(SELECT ACT.ACT_NUM_ACTIVO 
								FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
								INNER JOIN '||V_ESQUEMA||'.dd_scr_subcartera scr on act.dd_scr_id = scr.dd_scr_id
								INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
								INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO on apu.dd_tco_id = TCO.dd_tco_id
								INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO <> ''05''
								WHERE ACT.ACT_NUM_ACTIVO NOT IN (SELECT ACT.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA)
								AND tco.dd_tco_codigo in (''02'',''03'') AND ACT.BORRADO = 0 AND ACT.DD_TTA_ID <> 41
								AND SCR.DD_SCR_CODIGO = ''138''
								) T2
					ON (ACT.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
					WHEN MATCHED THEN
					UPDATE SET 
						  ACT.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
						, ACT.USUARIOBORRAR = '''||V_USUARIOMODIFICAR||'''
						, ACT.FECHAMODIFICAR = SYSDATE';
					
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
  		
  		DBMS_OUTPUT.put_line('	[INFO] SE INSERTA EL PERIMETRO EN LA TABLA AUX_HREOS_5932_PERIM ');
  		
  		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_HREOS_5932_PERIM  
						(SELECT 
							ACT_NUM_ACTIVO
							,'''||V_USUARIOMODIFICAR||''' 
							,0 
							FROM '||V_ESQUEMA||'.ACT_ACTIVO 
							WHERE USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''' AND BORRADO = 0
						)';
  		
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
  		
/**
1.1. Desmarcarlos de dicho perímetro
**/
		DBMS_OUTPUT.put_line('	[INFO] ACTUALIZAR HISTORICO PATRIMONIO Y CHECKS PATRIMONIO');
		
		OPEN ACTUALIZA_HISTORICO_PATRIMONIO;
		
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
			FETCH ACTUALIZA_HISTORICO_PATRIMONIO INTO FILA_HISTORICO;
			EXIT WHEN ACTUALIZA_HISTORICO_PATRIMONIO%NOTFOUND;
			
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.HIST_PTA_PATRIMONIO_ACTIVO 
						(SELECT 
							'||V_ESQUEMA||'.S_HIST_PTA_PATRIMONIO_ACTIVO.NEXTVAL
						,	ACT_ID
						,	DD_ADA_ID
						,	CHECK_HPM
						,	FECHACREAR
						,	SYSDATE
						,	FECHACREAR
						,	SYSDATE
						,	VERSION
						,	''HREOS-5932-PUNTO1''
						,	SYSDATE
						,	NULL
						,	NULL
						,	NULL
						,	NULL
						,	0
						,	DD_EAL_ID
						,	DD_TPI_ID
						,	CHECK_SUBROGADO
						,	PTA_RENTA_ANTIGUA

				FROM '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO WHERE ACT_ID = '||FILA_HISTORICO.ACT_ID||' )';	
			
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO SET 
							CHECK_HPM = 0 
						,	DD_ADA_ID = NULL
						,	DD_ADA_ID_ANTERIOR = (SELECT PTA.DD_ADA_ID FROM '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA WHERE PTA.ACT_ID = '||FILA_HISTORICO.ACT_ID||')
						,	DD_EAL_ID = NULL
						,	DD_TPI_ID = NULL
						,	CHECK_SUBROGADO = NULL
						,	PTA_RENTA_ANTIGUA = NULL
						,   USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
						,   FECHAMODIFICAR = SYSDATE
					WHERE ACT_ID = '||FILA_HISTORICO.ACT_ID||'';
		
		EXECUTE IMMEDIATE V_MSQL;
		
			V_COUNT := V_COUNT + 1 ;
			V_COUNT2 := V_COUNT2 +1 ;
			
			IF V_COUNT2 = 100 THEN
				
				COMMIT;
				
				DBMS_OUTPUT.PUT_LINE('	[INFO] Se comitean '||V_COUNT2||' registros ');
				V_COUNT2 := 0;
				
			END IF;
			
		END LOOP;
		

/**
1.3. Si están marcados como “Ocupado SI”, “Con título SI” pasan a estar marcados como “Ocupado NO”, “Con título Vacío” actualizando los discleimer correspondientes (cabecera del activo y publicación)
**/

		DBMS_OUTPUT.put_line('	[INFO] CAMBIA SITUACION POSESORIA');
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS USING
						(SELECT ACT.ACT_ID 
							FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
							INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS on ACT.ACT_ID = SPS.ACT_ID
							WHERE ACT.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
								AND SPS.SPS_OCUPADO = 1
								AND SPS.DD_TPA_ID = (SELECT TPA.DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_TITULO_ACT TPA WHERE DD_TPA_CODIGO = ''01'')) T2
					ON (SPS.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN
					UPDATE SET 
						  SPS.SPS_OCUPADO = 0
						, SPS.DD_TPA_ID = NULL
						, SPS.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
						, SPS.FECHAMODIFICAR = SYSDATE';
		
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
	
	
/**
1.4. Todo lo relacionado con publicación de alquiler de estos activos (si lo tiene) deja de visualizarse en REM y si están publicados en alquiler se ocultan.
**/

		DBMS_OUTPUT.put_line('	[INFO] QUITAR LOS CHECKS DE ALQUILER');
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING
						(SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''') T2
					ON (ACT.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN
					UPDATE SET 
						  ACT.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''01'')
						, ACT.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
						, ACT.FECHAMODIFICAR = SYSDATE';
		
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU USING
						(SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''') T2
					ON (APU.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN
					UPDATE SET 
				
						  APU.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''01'')
						, APU.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
						, APU.FECHAMODIFICAR = SYSDATE';
		
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
		
		/*

		DBMS_OUTPUT.PUT_LINE('	[INFO] SE ACTUALIZA EL HISTORICO DE PUBLICACIONES'); 
		
		OPEN ACTIVOS_HISTORICO_APU;
		
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
			FETCH ACTIVOS_HISTORICO_APU INTO FILA;
			EXIT WHEN ACTIVOS_HISTORICO_APU%NOTFOUND;
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
								AHP_FECHA_FIN_ALQUILER = SYSDATE
							,   USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
							,   FECHAMODIFICAR = SYSDATE
						WHERE   AHP_FECHA_INI_ALQUILER IS NOT NULL 
							AND AHP_FECHA_FIN_ALQUILER IS NULL
							AND ACT_ID = '||FILA.ACT_ID||'';
  		
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION 
						(SELECT 
								'||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL
							,   ACT_ID
							,	DD_TPU_ID
							,	DD_EPV_ID
							,	DD_EPA_ID
							,	DD_TCO_ID
							,	DD_MTO_V_ID
							,	APU_MOT_OCULTACION_MANUAL_V
							,	APU_CHECK_PUBLICAR_V
							,	APU_CHECK_OCULTAR_V
							,	APU_CHECK_OCULTAR_PRECIO_V
							,	APU_CHECK_PUB_SIN_PRECIO_V
							,	DD_MTO_A_ID
							,	APU_MOT_OCULTACION_MANUAL_A
							,	APU_CHECK_PUBLICAR_A
							,	APU_CHECK_OCULTAR_A
							,	APU_CHECK_OCULTAR_PRECIO_A
							,	APU_CHECK_PUB_SIN_PRECIO_A
							,	APU_FECHA_INI_VENTA
							,	NULL
							,	APU_FECHA_INI_ALQUILER
							,	SYSDATE
							,	VERSION
							,	'''||V_USUARIOMODIFICAR||'''
							,	SYSDATE
							,   NULL
							,   NULL
							,   NULL
							,   NULL
							,   0
							,	ES_CONDICONADO_ANTERIOR
							,	DD_TPU_V_ID
							,	DD_TPU_A_ID
						FROM  '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION  WHERE ACT_ID = '||FILA.ACT_ID||')';
						
			EXECUTE IMMEDIATE V_MSQL;
			
			V_COUNT := V_COUNT + 1 ;
			V_COUNT2 := V_COUNT2 +1 ;
			
			IF V_COUNT2 = 100 THEN
				
				COMMIT;
				
				DBMS_OUTPUT.PUT_LINE('	[INFO] Se comitean '||V_COUNT2||' registros ');
				V_COUNT2 := 0;
				
			END IF;
			
		END LOOP;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||V_COUNT||' registros.'); 

		*/
		
/**
1.5. Quitarles el gestor/supervisor comercial de alquiler y reasignar el doble gestor de activo eliminando el de alquiler y viendo si hay que poner el de suelo, edificación o ninguno.
**/    

		DBMS_OUTPUT.put_line('	[INFO] QUITAR GESTORES DE LA GAC_GESTOR_ADD_ACTIVO');
		
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO WHERE GEE_ID IN ( 
							SELECT GEE.GEE_ID 
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932_GEE GEE
								INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE on TGE.DD_TGE_ID  = GEE.DD_TGE_ID 
								INNER JOIN '||V_ESQUEMA||'.AUX_HREOS_5932_GAC GAC on gee.gee_id = gac.gee_id
								inner join '||V_ESQUEMA||'.ACT_ACTIVO act on act.act_id = gac.act_id
							WHERE TGE.DD_TGE_CODIGO IN (''GALQ'',''SUALQ'',''GESTCOMALQ'',''SUPCOMALQ'') and ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO1'' )';
		
		EXECUTE IMMEDIATE V_MSQL;  
				
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros.'); 


		DBMS_OUTPUT.put_line('	[INFO] QUITAR GESTORES DE LA GEE_GESTOR_ENTIDAD');
		
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD WHERE GEE_ID IN ( 
							SELECT GEE.GEE_ID 
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932_GEE GEE
								INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE on TGE.DD_TGE_ID  = GEE.DD_TGE_ID 
								INNER JOIN '||V_ESQUEMA||'.AUX_HREOS_5932_GAC GAC on gee.gee_id = gac.gee_id
								inner join '||V_ESQUEMA||'.ACT_ACTIVO act on act.act_id = gac.act_id
							WHERE TGE.DD_TGE_CODIGO IN (''GALQ'',''SUALQ'',''GESTCOMALQ'',''SUPCOMALQ'') and ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO1'' )';
									
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros.');  		
  		
  		
  		DBMS_OUTPUT.put_line('	[INFO] QUITAR GESTORES DE LA GAH_GESTOR_ACTIVO_HISTORICO');
		
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO WHERE GEH_ID IN ( 
							SELECT GEE.GEH_ID 
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932_GEH GEE
							INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE on TGE.DD_TGE_ID  = GEE.DD_TGE_ID 
							INNER JOIN '||V_ESQUEMA||'.AUX_HREOS_5932_GAH GAC on gee.GEH_ID = gac.GEH_ID
							inner join '||V_ESQUEMA||'.ACT_ACTIVO act on act.act_id = gac.act_id
							WHERE TGE.DD_TGE_CODIGO IN (''GALQ'',''SUALQ'',''GESTCOMALQ'',''SUPCOMALQ'') and ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO1'')';
		
		EXECUTE IMMEDIATE V_MSQL;  
				
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros.'); 


		DBMS_OUTPUT.put_line('	[INFO] QUITAR GESTORES DE LA GEH_GESTOR_ENTIDAD_HIST');
		
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST WHERE GEH_ID IN ( 
							SELECT GEE.GEH_ID 
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932_GEH GEE
							INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE on TGE.DD_TGE_ID  = GEE.DD_TGE_ID 
							INNER JOIN '||V_ESQUEMA||'.AUX_HREOS_5932_GAH GAC on gee.GEH_ID = gac.GEH_ID
							inner join '||V_ESQUEMA||'.ACT_ACTIVO act on act.act_id = gac.act_id
							WHERE TGE.DD_TGE_CODIGO IN (''GALQ'',''SUALQ'',''GESTCOMALQ'',''SUPCOMALQ'') and ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO1'')';
									
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros.'); 


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
