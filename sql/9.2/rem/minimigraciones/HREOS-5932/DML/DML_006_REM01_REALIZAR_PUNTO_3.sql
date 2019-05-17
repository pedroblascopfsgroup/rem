--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190412
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5932
--## PRODUCTO=NO
--## Finalidad: Punto 3
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'HREOS-5932-PUNTO3';
    V_MSQL VARCHAR2(4000 CHAR);
    V_MAX_PTO_ID NUMBER(16,0);
    V_EJE_ID NUMBER(16,0);
    V_COUNT NUMBER(16):= 0;
    V_COUNT2 NUMBER(16):= 0;
    
    
    CURSOR ACTIVOS_HISTORICO_APU IS  SELECT DISTINCT APU.ACT_ID FROM REM01.ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.USUARIOMODIFICAR = 'HREOS-5932-PUNTO3-VA';
											
	CURSOR ACTUALIZA_HISTORICO_PATRIMONIO IS SELECT ACT.ACT_ID FROM REM01.ACT_ACTIVO ACT 
												INNER JOIN REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA ON ACT.ACT_ID = PTA.ACT_ID
												WHERE ACT.USUARIOMODIFICAR = 'HREOS-5932-PUNTO3';
    						
    FILA ACTIVOS_HISTORICO_APU%ROWTYPE;
    
    FILA_HISTORICO ACTUALIZA_HISTORICO_PATRIMONIO%ROWTYPE;

BEGIN

  DBMS_OUTPUT.put_line('[INICIO] Ejecutando [PUNTO 3]  ...........');

/**************************	PUNTO 3	*********************************/

/**Se procede a marcar los activos del punto 3**/
		DBMS_OUTPUT.PUT_LINE('	[INFO] SE MARCAN LOS ACTIVOS DE LA EXCEL');  
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT 
					USING (SELECT AUX.ID_HAYA 
								FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
								INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
								INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO <> ''05'') T2
						ON (ACT.ACT_NUM_ACTIVO = T2.ID_HAYA)
					WHEN MATCHED THEN 
						UPDATE SET 
							ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3''
						, 	ACT.USUARIOBORRAR = ''HREOS-5932-PUNTO3''
						,   ACT.FECHAMODIFICAR = SYSDATE';
    
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
		
		DBMS_OUTPUT.put_line('	[INFO] SE INSERTA EL PERIMETRO EN LA TABLA AUX_HREOS_5932_PERIM ');
  		
  		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_HREOS_5932_PERIM  
						(SELECT 
							ACT_NUM_ACTIVO 
							FROM '||V_ESQUEMA||'.ACT_ACTIVO 
							WHERE USUARIOMODIFICAR = ''HREOS-5932-PUNTO3'' AND BORRADO = 0
						)';
  		
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');

/** 3.1. Incluirlos en el perímetro alquilable **/
		DBMS_OUTPUT.PUT_LINE('	[INFO] SE INCLUYEN LOS ACTIVOS EN PERIMETRO ALQUILABLE');  

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA USING (
							SELECT ACT.ACT_ID 
							FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							WHERE ACT.USUARIOMODIFICAR  = ''HREOS-5932-PUNTO3'' 
							)T2
					ON (PTA.ACT_ID = T2.ACT_ID)        
					WHEN MATCHED THEN 
						UPDATE SET 
							PTA.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3''
						,   PTA.FECHAMODIFICAR = SYSDATE';
			
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
    
/** 3.2. Actualizar los campos de la pestaña patrimonio con la información del Excel **/  
		
		DBMS_OUTPUT.put_line('	[INFO] ACTUALIZAR HISTORICO PATRIMONIO ');
		
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
						,	''HREOS-5932-PUNTO3''
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
			
			V_COUNT := V_COUNT + 1 ;
			V_COUNT2 := V_COUNT2 +1 ;
			
			IF V_COUNT2 = 100 THEN
				
				COMMIT;
				
				DBMS_OUTPUT.PUT_LINE('[INFO] Se comitean '||V_COUNT2||' registros ');
				V_COUNT2 := 0;
				
			END IF;
			
		END LOOP;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] SE ACTUALIZAN LOS CAMPOS DE LA PESTANYA PATRIMONIO');  

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA USING (
							SELECT      ACT.ACT_ID
									,   AUX.ID_HAYA
									,	AUX.TIPO_CONTRATO_ALQUILER
									,	AUX.ESTADO_ADECUACION
									,	AUX.SUBROGADO
									,	AUX.ALQUILADO
									,	AUX.INQUILINO_ANT_PROP
									,	AUX.RENTA_ANTIGUA
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
							INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON (AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO)
							WHERE ACT.USUARIOMODIFICAR  = ''HREOS-5932-PUNTO3'' 
							)T2
						ON (PTA.ACT_ID = T2.ACT_ID)        
					WHEN MATCHED THEN 
						UPDATE SET 
							PTA.CHECK_HPM = 1
						,   PTA.DD_ADA_ID = (SELECT ADA.DD_ADA_ID FROM '||V_ESQUEMA||'.DD_ADA_ADECUACION_ALQUILER ADA WHERE ADA.DD_ADA_CODIGO = T2.ESTADO_ADECUACION)   
						,   PTA.DD_EAL_ID = (SELECT EAL.DD_EAL_ID FROM '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER EAL WHERE EAL.DD_EAL_CODIGO = T2.ALQUILADO)
						,   PTA.DD_TPI_ID = (SELECT TPI.DD_TPI_ID FROM '||V_ESQUEMA||'.DD_TPI_TIPO_INQUILINO TPI WHERE TPI.DD_TPI_CODIGO = T2.INQUILINO_ANT_PROP)
						,   PTA.CHECK_SUBROGADO = T2.SUBROGADO
						,   PTA.PTA_RENTA_ANTIGUA = T2.RENTA_ANTIGUA
						,   PTA.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3''
						,   PTA.FECHAMODIFICAR = SYSDATE
					WHEN NOT MATCHED THEN 
						INSERT ( ACT_PTA_ID 
								,ACT_ID 
								,DD_ADA_ID 
								,CHECK_HPM 
								,VERSION 
								,USUARIOCREAR 
								,FECHACREAR 
								,BORRADO 
								,DD_ADA_ID_ANTERIOR 
								,DD_EAL_ID 
								,DD_TPI_ID 
								,CHECK_SUBROGADO 
								,PTA_RENTA_ANTIGUA )
						VALUES (
							REM01.S_ACT_PTA_PATRIMONIO_ACTIVO.NEXTVAL
						,   T2.ACT_ID
						,   (SELECT ADA.DD_ADA_ID FROM '||V_ESQUEMA||'.DD_ADA_ADECUACION_ALQUILER ADA WHERE ADA.DD_ADA_CODIGO = T2.ESTADO_ADECUACION)
						,   1
						,   0
						,   ''HREOS-5932-PUNTO3''
						,   SYSDATE
						,   0
						,   NULL
						,   (SELECT EAL.DD_EAL_ID FROM '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER EAL WHERE EAL.DD_EAL_CODIGO = T2.ALQUILADO)
						,   (SELECT TPI.DD_TPI_ID FROM '||V_ESQUEMA||'.DD_TPI_TIPO_INQUILINO TPI WHERE TPI.DD_TPI_CODIGO = T2.INQUILINO_ANT_PROP)
						,   T2.SUBROGADO
						,   T2.RENTA_ANTIGUA
						)';

		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
		
		
		DBMS_OUTPUT.put_line('	[INFO] ACTUALIZAR TIPO CONTRATO ALQUILER ');
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
					USING ( SELECT AUX.ID_HAYA,TAL.DD_TAL_ID
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX 
							INNER JOIN '||V_ESQUEMA||'.DD_TAL_TIPO_ALQUILER TAL on AUX.TIPO_CONTRATO_ALQUILER = TAL.DD_TAL_CODIGO
								LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO AND ACT.BORRADO = 0
								LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 
							WHERE SCM.DD_SCM_CODIGO <> ''05'') AUX
					ON (ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA)
					WHEN MATCHED THEN UPDATE SET
						ACT.DD_TAL_ID = AUX.DD_TAL_ID
					,   ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3''
					, 	ACT.USUARIOBORRAR = ''HREOS-5932-PUNTO3''
					,   ACT.FECHAMODIFICAR = SYSDATE';

		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

/** 3.3.1 Marcamos el perímetro **/
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] MARCAMOS PERIMETRO - REM VENTA - EXCEL ALQUILER');
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA''
					, 	USUARIOBORRAR = ''HREOS-5932-PUNTO3-VA''
					,   FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO IN (
						SELECT ACT.ACT_NUM_ACTIVO
						FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
						INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA
                        INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
						INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO <> ''05''
						INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCOAUX ON AUX.DESTINO_COMERCIAL = TCOAUX.DD_TCO_CODIGO
						INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCOACT ON APU.DD_TCO_ID = TCOACT.DD_TCO_ID
						WHERE TCOACT.DD_TCO_CODIGO = ''01'' AND TCOAUX.DD_TCO_CODIGO = ''03''
					)';
				
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
		
		DBMS_OUTPUT.put_line('	[INFO] SE INSERTA EL PERIMETRO EN LA TABLA AUX_HREOS_5932_PERIM ');
  		
  		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_HREOS_5932_PERIM  
						(SELECT 
							ACT_NUM_ACTIVO 
							FROM '||V_ESQUEMA||'.ACT_ACTIVO 
							WHERE USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA'' AND BORRADO = 0
						)';
  		
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

/** 3.3.1 A Modificar su destino comercial **/


		DBMS_OUTPUT.PUT_LINE('	[INFO] CAMBIA EL PERIMETRO DE VENTA A ALQUILER');
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						  DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''03'')
						, USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA''
						, FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO in (
							SELECT ACT.ACT_NUM_ACTIVO 
								FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							WHERE  ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA'')';
											
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

/** 3.3.1 B Quitar el gestor/supervisor comercial de venta. **/    

		DBMS_OUTPUT.put_line('	[INFO] QUITAR GESTORES DE LA GAC_GESTOR_ADD_ACTIVO');
		
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO WHERE GEE_ID IN ( 
							SELECT GEE.GEE_ID 
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932_GEE GEE
								INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE on TGE.DD_TGE_ID  = GEE.DD_TGE_ID 
								INNER JOIN '||V_ESQUEMA||'.AUX_HREOS_5932_GAC GAC on gee.gee_id = gac.gee_id
								inner join '||V_ESQUEMA||'.ACT_ACTIVO act on act.act_id = gac.act_id
							WHERE TGE.DD_TGE_CODIGO IN (''GCOM'','' SCOM'') and ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA'')';
		
		EXECUTE IMMEDIATE V_MSQL;  
				
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros.'); 


		DBMS_OUTPUT.put_line('	[INFO] QUITAR GESTORES DE LA GEE_GESTOR_ENTIDAD');
		
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD WHERE GEE_ID IN ( 
							SELECT GEE.GEE_ID 
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932_GEE GEE
								INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE on TGE.DD_TGE_ID  = GEE.DD_TGE_ID 
								INNER JOIN '||V_ESQUEMA||'.AUX_HREOS_5932_GAC GAC on gee.gee_id = gac.gee_id
								inner join '||V_ESQUEMA||'.ACT_ACTIVO act on act.act_id = gac.act_id
							WHERE TGE.DD_TGE_CODIGO IN (''GCOM'','' SCOM'') and ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA'')';
									
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros.');  		
  		
  		
  		DBMS_OUTPUT.put_line('	[INFO] QUITAR GESTORES DE LA GAH_GESTOR_ACTIVO_HISTORICO');
		
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO WHERE GEH_ID IN ( 
							SELECT GEE.GEH_ID 
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932_GEH GEE
							INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE on TGE.DD_TGE_ID  = GEE.DD_TGE_ID 
							INNER JOIN '||V_ESQUEMA||'.AUX_HREOS_5932_GAH GAC on gee.GEH_ID = gac.GEH_ID
							inner join '||V_ESQUEMA||'.ACT_ACTIVO act on act.act_id = gac.act_id
							WHERE TGE.DD_TGE_CODIGO IN (''GCOM'','' SCOM'') and ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA'')';
		
		EXECUTE IMMEDIATE V_MSQL;  
				
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros.'); 


		DBMS_OUTPUT.put_line('	[INFO] QUITAR GESTORES DE LA GEH_GESTOR_ENTIDAD_HIST');
		
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST WHERE GEH_ID IN ( 
							SELECT GEE.GEH_ID 
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932_GEH GEE
							INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE on TGE.DD_TGE_ID  = GEE.DD_TGE_ID 
							INNER JOIN '||V_ESQUEMA||'.AUX_HREOS_5932_GAH GAC on gee.GEH_ID = gac.GEH_ID
							inner join '||V_ESQUEMA||'.ACT_ACTIVO act on act.act_id = gac.act_id
							WHERE TGE.DD_TGE_CODIGO IN (''GCOM'','' SCOM'') and ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA'')';
									
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros.'); 
			
  		
/** 3.3.1 C Todo lo relacionado con publicación de venta de estos activos (si lo tiene) deja de visualizarse en REM y si están publicados en venta se ocultan**/

		DBMS_OUTPUT.put_line('	[INFO] QUITAR LOS CHECKS DE VENTA');

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU USING
						(SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA'') T2
					ON (APU.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN
					UPDATE SET 
						  APU.DD_EPV_ID = (SELECT EPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV WHERE EPV.DD_EPV_CODIGO = ''04'')
						, APU.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''03'')
						, APU.DD_MTO_V_ID = (SELECT MTO.DD_MTO_ID FROM '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO WHERE MTO.DD_MTO_CODIGO = ''08'')
						, APU.APU_CHECK_PUBLICAR_V = 0
						, APU.APU_CHECK_OCULTAR_PRECIO_V = 1
						, APU.APU_CHECK_PUB_SIN_PRECIO_V = 0
						, APU.DD_TPU_V_ID = NULL
						, APU.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA''
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
								AHP_FECHA_FIN_VENTA = SYSDATE
							,   USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA''
							,   FECHAMODIFICAR = SYSDATE
						WHERE   AHP_FECHA_INI_VENTA IS NOT NULL 
							AND AHP_FECHA_FIN_VENTA IS NULL
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
							,	''HREOS-5932-PUNTO3-VA''
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
