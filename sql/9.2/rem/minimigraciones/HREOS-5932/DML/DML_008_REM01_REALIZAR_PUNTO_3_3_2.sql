--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190326
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
    									
    						
    FILA ACTIVOS_HISTORICO_APU%ROWTYPE;

BEGIN

  DBMS_OUTPUT.put_line('[INICIO] Ejecutando [PUNTO 3]  ...........');

/**************************	PUNTO 3	*********************************/

/**Se procede a marcar los activos del punto 3.3.2 **/
		DBMS_OUTPUT.PUT_LINE('	[INFO] SE MARCAN LOS ACTIVOS DE LA EXCEL - REM VENTA - EXCEL ALQUILER Y VENTA');  
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA-V''
					,   FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO IN (
						SELECT ACT.ACT_NUM_ACTIVO
						FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
						INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA
						INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCOAUX ON AUX.DESTINO_COMERCIAL = TCOAUX.DD_TCO_CODIGO
						INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCOACT ON AUX.DESTINO_COMERCIAL = TCOACT.DD_TCO_CODIGO
						WHERE TCOACT.DD_TCO_CODIGO = ''01'' AND TCOAUX.DD_TCO_CODIGO = ''02''
					)';
    
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');

/** 3.3.2 A Modificar su destino comercial **/


		DBMS_OUTPUT.PUT_LINE('	[INFO] SE MODIFICA EL DESTINO COMERCIAL DE VENTA A ALQUILER Y VENTA');
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						  DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''02'')
						, USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA-V''
						, FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO in (
							SELECT ACT.ACT_NUM_ACTIVO 
								FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							WHERE  ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-VA-V'')';
											
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

/** 3.3.4 Marcamos el perímetro **/

		DBMS_OUTPUT.PUT_LINE('	[INFO] SE MARCAN LOS ACTIVOS DE LA EXCEL - REM ALQUILER - EXCEL ALQUILER Y VENTA');  
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-AA-V''
					,   FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO IN (
						SELECT ACT.ACT_NUM_ACTIVO
						FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
						INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA
						INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCOAUX ON AUX.DESTINO_COMERCIAL = TCOAUX.DD_TCO_CODIGO
						INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCOACT ON AUX.DESTINO_COMERCIAL = TCOACT.DD_TCO_CODIGO
						WHERE TCOACT.DD_TCO_CODIGO = ''03'' AND TCOAUX.DD_TCO_CODIGO = ''02''
					)';

		EXECUTE IMMEDIATE V_MSQL;
		
/** 3.3.4 A Modificar su destino comercial **/


		DBMS_OUTPUT.PUT_LINE('	[INFO] SE MODIFICA EL DESTINO COMERCIAL DE ALQUILER A ALQUILER Y VENTA');
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						  DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''02'')
						, USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-AA-V''
						, FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO in (
							SELECT ACT.ACT_NUM_ACTIVO 
								FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							WHERE  ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-AA-V'')';
											
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

/** 3.3.5 Marcamos el perímetro **/

		DBMS_OUTPUT.PUT_LINE('	[INFO] SE MARCAN LOS ACTIVOS DE LA EXCEL - REM ALQUILER Y VENTA - EXCEL ALQUILER');  
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-A-VA''
					,   FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO IN (
						SELECT ACT.ACT_NUM_ACTIVO
						FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
						INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA
						INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCOAUX ON AUX.DESTINO_COMERCIAL = TCOAUX.DD_TCO_CODIGO
						INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCOACT ON AUX.DESTINO_COMERCIAL = TCOACT.DD_TCO_CODIGO
						WHERE TCOACT.DD_TCO_CODIGO = ''02'' AND TCOAUX.DD_TCO_CODIGO = ''03''
					)';

		EXECUTE IMMEDIATE V_MSQL;
		
/** 3.3.5 A Modificar su destino comercial **/


		DBMS_OUTPUT.PUT_LINE('	[INFO] SE MODIFICA EL DESTINO COMERCIAL DE ALQUILER Y VENTA A ALQUILER');
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						  DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''03'')
						, USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-A-VA''
						, FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO in (
							SELECT ACT.ACT_NUM_ACTIVO 
								FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							WHERE  ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-A-VA'')';
											
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
  		
  		
/** 3.3.5 B Quitar el gestor/supervisor comercial de venta. **/    

		DBMS_OUTPUT.put_line('	[INFO] QUITAR GESTORES DE LA GEE_GESTOR_ENTIDAD');

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD SET
						  USUARIOBORRAR = ''HREOS-5932-PUNTO3-A-VA''
						, FECHABORRAR = SYSDATE
						, BORRADO = 1
					WHERE GEE_ID IN (SELECT GEE.GEE_ID 
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
										INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
										INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GAC.GEE_ID = GEE.GEE_ID
										INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE on TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO in (''GCOM'','' SCOM'')
										WHERE ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-A-VA''
									)';

		EXECUTE IMMEDIATE V_MSQL;                
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 


		DBMS_OUTPUT.put_line('	[INFO] QUITAR GESTORES DE LA GEH_GESTOR_ENTIDAD_HIST');
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST SET
						  GEH_FECHA_HASTA = SYSDATE
						, USUARIOBORRAR = ''HREOS-5932-PUNTO3-A-VA''
						, FECHABORRAR = SYSDATE
						, BORRADO = 1
					WHERE GEH_ID in (SELECT GEH.GEH_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
										INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
										INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GAH.GEH_ID = GEH.GEH_ID AND GEH.GEH_FECHA_HASTA IS NULL
										INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE on TGE.DD_TGE_ID = GEH.DD_TGE_ID AND TGE.DD_TGE_CODIGO in (''GCOM'','' SCOM'')
										WHERE ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-A-VA''
									)';
									
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
  		
/** 3.3.5 C Todo lo relacionado con publicación de venta de estos activos (si lo tiene) deja de visualizarse en REM y si están publicados en venta se ocultan**/

		DBMS_OUTPUT.put_line('	[INFO] QUITAR LOS CHECKS DE VENTA');

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU USING
						(SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-A-VA'') T2
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
						, APU.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-A-VA''
						, APU.FECHAMODIFICAR = SYSDATE';
		
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
		
		

		DBMS_OUTPUT.PUT_LINE('	[INFO] SE ACTUALIZA EL HISTORICO DE PUBLICACIONES'); 
		
		OPEN ACTIVOS_HISTORICO_APU;
		
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
			FETCH ACTIVOS_HISTORICO_APU INTO FILA;
			EXIT WHEN ACTIVOS_HISTORICO_APU%NOTFOUND;
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
								AHP_FECHA_FIN_VENTA = SYSDATE
							,   USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-A-VA''
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
							,	SYSDATE
							,	APU_FECHA_INI_ALQUILER
							,	NULL
							,	VERSION
							,	''HREOS-5932-PUNTO3-A-VA''
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
				
				DBMS_OUTPUT.PUT_LINE('[INFO] Se comitean '||V_COUNT2||' registros ');
				V_COUNT2 := 0;
				
			END IF;
			
		END LOOP;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||V_COUNT||' registros.');  

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
6
