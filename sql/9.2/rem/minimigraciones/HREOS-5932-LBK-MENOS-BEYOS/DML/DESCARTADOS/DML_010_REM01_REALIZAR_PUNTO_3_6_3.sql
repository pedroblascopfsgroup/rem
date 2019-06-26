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
    
    
    CURSOR ACTIVOS_HISTORICO_APU_AL IS  SELECT DISTINCT APU.ACT_ID FROM REM01.ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.USUARIOMODIFICAR = 'HREOS-5932-PUNTO3-6AL';

    CURSOR ACTIVOS_HISTORICO_APU_VE IS  SELECT DISTINCT APU.ACT_ID FROM REM01.ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.USUARIOMODIFICAR = 'HREOS-5932-PUNTO3-6VE';
    									
    CURSOR ACTIVOS_PUBLICACION_ALQUILER IS SELECT APU.ACT_ID FROM REM01.AUX_HREOS_5932 AUX 
																INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA AND ACT.USUARIOMODIFICAR = 'HREOS-5932-PUNTO3-6-4'
																INNER JOIN REM01.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
																INNER JOIN REM01.DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID
																INNER JOIN REM01.DD_MTO_MOTIVOS_OCULTACION MTO ON APU.DD_MTO_A_ID = MTO.DD_MTO_ID AND MTO.DD_MTO_CODIGO = '03'
																WHERE AUX.ESTADO_ADECUACION IN ('01','03');
																
	
    CURSOR ACTIVOS_PUBLICACION_REVISION_A IS SELECT APU.ACT_ID FROM REM01.AUX_HREOS_5932 AUX 
																			INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA AND ACT.USUARIOMODIFICAR = 'HREOS-5932-PUNTO3-6-4'
																			INNER JOIN REM01.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
																			INNER JOIN REM01.DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID
																			INNER JOIN REM01.DD_MTO_MOTIVOS_OCULTACION MTO ON APU.DD_MTO_A_ID = MTO.DD_MTO_ID AND MTO.DD_MTO_CODIGO = '03'
																			WHERE AUX.ESTADO_ADECUACION IN ('02');
																			
	CURSOR ACTIVOS_PUBLICACION_VENDER_ALQ IS SELECT APU.ACT_ID FROM REM01.AUX_HREOS_5932 AUX 
																		INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA AND ACT.USUARIOMODIFICAR = 'HREOS-5932-PUNTO3-6-4'
																		INNER JOIN REM01.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
																		INNER JOIN REM01.DD_MTO_MOTIVOS_OCULTACION MTO ON APU.DD_MTO_V_ID = MTO.DD_MTO_ID AND MTO.DD_MTO_CODIGO = '03';
    						
    FILA_A ACTIVOS_HISTORICO_APU_AL%ROWTYPE;
    
    FILA_V ACTIVOS_HISTORICO_APU_VE%ROWTYPE;
    
    FILA_364B ACTIVOS_PUBLICACION_ALQUILER%ROWTYPE;
    
    FILA_364C ACTIVOS_PUBLICACION_REVISION_A%ROWTYPE;

	FILA_364D ACTIVOS_PUBLICACION_VENDER_ALQ%ROWTYPE;
	
BEGIN
  
  DBMS_OUTPUT.put_line('[INICIO] Ejecutando [PUNTO 3]  ...........');

/**************************	PUNTO 3	*********************************/

/**	3.6.3. REM “Ocupado NO”, “Con título Vacío”, Excel “Alquilado”	**/
/** MARCAR PERIMETRO OCUPADO NO Y ALQUILADO **/

		DBMS_OUTPUT.PUT_LINE('	[INFO] MARCAR PERIMETRO OCUPADO NO Y ALQUILADO');  
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET
							USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6''
						,	USUARIOBORRAR = ''HREOS-5932-PUNTO3-6''	
						,   FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO IN (
									SELECT ACT.ACT_NUM_ACTIVO 
									FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
									INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
									INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO <> ''05''
									INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON ACT.ACT_ID = SPS.ACT_ID 
									LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_TITULO_ACT TPA ON TPA.DD_TPA_ID = SPS.DD_TPA_ID
									WHERE        AUX.ALQUILADO = ''02''
											AND ( SPS.SPS_CON_TITULO IS NULL OR SPS.SPS_CON_TITULO = 0 OR TPA.DD_TPA_CODIGO = ''02'')
											AND SPS.SPS_OCUPADO = 0
											)';
    
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
		
		DBMS_OUTPUT.put_line('	[INFO] SE INSERTA EL PERIMETRO EN LA TABLA AUX_HREOS_5932_PERIM ');
  		
  		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_HREOS_5932_PERIM  
						(SELECT 
							ACT_NUM_ACTIVO
							,''HREOS-5932-PUNTO3-6''
							,0  
							FROM '||V_ESQUEMA||'.ACT_ACTIVO 
							WHERE USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6'' AND BORRADO = 0
						)';
  		
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 


/**	3.6.3. A. Marcar “Ocupado SI”, “Con título SI” actualizando los discleimer correspondientes (cabecera del activo y publicación)	**/
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Marcar Ocupado SI, Con titulo SI '); 
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SET 
							SPS_OCUPADO = 1
						,   SPS_CON_TITULO = 1
						,   DD_TPA_ID = (SELECT TPA.DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_TITULO_ACT TPA WHERE TPA.DD_TPA_CODIGO = ''01'')
						,   USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6''
						,   FECHAMODIFICAR = SYSDATE
					WHERE ACT_ID IN (SELECT ACT.ACT_ID 
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
										INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON ACT.ACT_ID = SPS.ACT_ID 
										WHERE ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6''
									)';

		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');

/**	3.6.3. B. Si el activo está publicado en alquiler ocultarlo de alquiler con motivo “Alquilado” y actualizar su histórico de publicaciones de alquiler	**/

		DBMS_OUTPUT.put_line('	[INFO] QUITAR LOS CHECKS DE ALQUILER');

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU USING
						(SELECT ACT.ACT_ID 
                            FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                            INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
                            INNER JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID AND EPA.DD_EPA_CODIGO = ''03''
                            WHERE ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6'') T2
					ON (APU.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN
					UPDATE SET 
						  APU.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''01'')
						, APU.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6AL''
						, APU.FECHAMODIFICAR = SYSDATE';
		
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING (
							SELECT      ACT.ACT_ID
									,   AUX.ID_HAYA
									,	AUX.DESTINO_COMERCIAL
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
							INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON (AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO)
							WHERE ACT.USUARIOMODIFICAR  = ''HREOS-5932-PUNTO3-6AL'' 
							)T2
						ON (ACT.ACT_ID = T2.ACT_ID)        
					WHEN MATCHED THEN 
						UPDATE SET 
							ACT.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = T2.DESTINO_COMERCIAL)
						,   ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6AL''
						,   ACT.FECHAMODIFICAR = SYSDATE
					';

		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
		
		/*

		DBMS_OUTPUT.PUT_LINE('	[INFO] SE ACTUALIZA EL HISTORICO DE PUBLICACIONES'); 
		
		OPEN ACTIVOS_HISTORICO_APU_AL;
		
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
			FETCH ACTIVOS_HISTORICO_APU_AL INTO FILA_A;
			EXIT WHEN ACTIVOS_HISTORICO_APU_AL%NOTFOUND;
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
								AHP_FECHA_FIN_ALQUILER = SYSDATE
							,   USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6AL''
							,   FECHAMODIFICAR = SYSDATE
						WHERE   AHP_FECHA_INI_ALQUILER IS NOT NULL 
							AND AHP_FECHA_FIN_ALQUILER IS NULL
							AND ACT_ID = '||FILA_A.ACT_ID||'';
  		
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
							,	''HREOS-5932-PUNTO3-6AL''
							,	SYSDATE
							,   NULL
							,   NULL
							,   NULL
							,   NULL
							,   0
							,	ES_CONDICONADO_ANTERIOR
							,	DD_TPU_V_ID
							,	DD_TPU_A_ID
						FROM  '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION  WHERE ACT_ID = '||FILA_A.ACT_ID||')';
						
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

/**	3.6.3. C. Si el activo está publicado en venta y el tipo de alquiler NO es “Ordinario” ocultarlo de venta con motivo “Alquilado” y actualizar su histórico de publicaciones de venta	**/

		DBMS_OUTPUT.put_line('	[INFO] QUITAR LOS CHECKS DE VENTA');

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU USING
						(SELECT ACT.ACT_ID  ,AUX.DESTINO_COMERCIAL
                            FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
							INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON (AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO) 
                            INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID 
                            INNER JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID AND EPA.DD_EPA_CODIGO = ''03''
                            INNER JOIN '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION TPU ON TPU.DD_TPU_ID = APU.DD_TPU_ID AND TPU.DD_TPU_CODIGO <> ''01''
                            WHERE ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6'') T2
					ON (APU.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN
					UPDATE SET 
						  APU.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = T2.DESTINO_COMERCIAL)
						, APU.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6VE''
						, APU.FECHAMODIFICAR = SYSDATE';
		
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
  		
  		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING (
							SELECT      ACT.ACT_ID
									,   AUX.ID_HAYA
									,	AUX.DESTINO_COMERCIAL
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
							INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON (AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO)
							WHERE ACT.USUARIOMODIFICAR  = ''HREOS-5932-PUNTO3-6'' 
							)T2
						ON (ACT.ACT_ID = T2.ACT_ID)        
					WHEN MATCHED THEN 
						UPDATE SET 
							ACT.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = T2.DESTINO_COMERCIAL)
						,   ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6''
						,   ACT.FECHAMODIFICAR = SYSDATE
					';

		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
		
		/*

		DBMS_OUTPUT.PUT_LINE('	[INFO] SE ACTUALIZA EL HISTORICO DE PUBLICACIONES'); 
		
		OPEN ACTIVOS_HISTORICO_APU_VE;
		
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
			FETCH ACTIVOS_HISTORICO_APU_VE INTO FILA_V;
			EXIT WHEN ACTIVOS_HISTORICO_APU_VE%NOTFOUND;
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
								AHP_FECHA_FIN_VENTA = SYSDATE
							,   USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6VE''
							,   FECHAMODIFICAR = SYSDATE
						WHERE   AHP_FECHA_INI_VENTA IS NOT NULL 
							AND AHP_FECHA_FIN_VENTA IS NULL
							AND ACT_ID = '||FILA_V.ACT_ID||'';
  		
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
							,	''HREOS-5932-PUNTO3-6VE''
							,	SYSDATE
							,   NULL
							,   NULL
							,   NULL
							,   NULL
							,   0
							,	ES_CONDICONADO_ANTERIOR
							,	DD_TPU_V_ID
							,	DD_TPU_A_ID
						FROM  '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION  WHERE ACT_ID = '||FILA_V.ACT_ID||')';
						
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
		
/**	3.6.4. REM “Ocupado SI”, “Con título SI”, Excel “Libre”	**/
/** MARCAR PERIMETRO OCUPADO SI Y CON TITULO SI **/
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] MARCAR PERIMETRO OCUPADO SI Y CON TITULO SI '); 
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET
							USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
						,	USUARIOBORRAR = ''HREOS-5932-PUNTO3-6-4''
						,   FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO IN (
									SELECT ACT.ACT_NUM_ACTIVO 
									FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
									INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
									INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO <> ''05''
									INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON ACT.ACT_ID = SPS.ACT_ID 
									LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_TITULO_ACT TPA ON TPA.DD_TPA_ID = SPS.DD_TPA_ID
									WHERE        AUX.ALQUILADO = ''01''
											AND SPS.SPS_CON_TITULO = 1 
											AND TPA.DD_TPA_CODIGO = ''01''
											AND SPS.SPS_OCUPADO = 1
											)';
								
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
		
		DBMS_OUTPUT.put_line('	[INFO] SE INSERTA EL PERIMETRO EN LA TABLA AUX_HREOS_5932_PERIM ');
  		
  		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_HREOS_5932_PERIM  
						(SELECT 
							ACT_NUM_ACTIVO
							,''HREOS-5932-PUNTO3-6-4''
							,0    
							FROM '||V_ESQUEMA||'.ACT_ACTIVO 
							WHERE USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4'' AND BORRADO = 0
						)';
  		
  		DBMS_OUTPUT.PUT_LINE(V_MSQL);
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

/**	3.6.4. A. Marcar “Ocupado NO”, “Con título Vacío” actualizando los discleimer correspondientes (cabecera del activo y publicación)	**/

		DBMS_OUTPUT.PUT_LINE('	[INFO] MARCAR PERIMETRO OCUPADO SI Y CON TITULO SI '); 

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS 
						USING (SELECT ACT.ACT_ID 
								FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
								INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
								WHERE ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4'') T2
						ON (SPS.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN 
						UPDATE SET
							SPS.SPS_OCUPADO = 0
						,   SPS.SPS_CON_TITULO = 0
						,   SPS.DD_TPA_ID = NULL
						,   SPS.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
						,   SPS.FECHAMODIFICAR = SYSDATE ';
						
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

/**	3.6.4. B. Si el activo está oculto en alquiler por motivo “Alquiler” y el campo “Estado Adecuacion” del Excel es “Si” o “N/A” 
				publicar el activo en alquiler y actualizar su histórico de publicaciones de alquiler						**/
		
		DBMS_OUTPUT.put_line('	[INFO] 3.6.4. B QUITAR LOS CHECKS DE ALQUILER');

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU USING
						(SELECT APU.ACT_ID ,AUX.DESTINO_COMERCIAL
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX 
							INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA AND ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
							INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID ) T2
					ON (APU.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN
					UPDATE SET 
						  APU.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = T2.DESTINO_COMERCIAL)
						, APU.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
						, APU.FECHAMODIFICAR = SYSDATE';

		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
  				
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING (
							SELECT      ACT.ACT_ID
									,   AUX.ID_HAYA
									,	AUX.DESTINO_COMERCIAL
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
							INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON (AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO)
							WHERE ACT.USUARIOMODIFICAR  = ''HREOS-5932-PUNTO3-6-4'' 
							)T2
						ON (ACT.ACT_ID = T2.ACT_ID)        
					WHEN MATCHED THEN 
						UPDATE SET 
							ACT.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = T2.DESTINO_COMERCIAL)
						,   ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
						,   ACT.FECHAMODIFICAR = SYSDATE
					';

		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
		
		/*

		DBMS_OUTPUT.PUT_LINE('	[INFO] SE ACTUALIZA EL HISTORICO DE PUBLICACIONES'); 
		
		OPEN ACTIVOS_PUBLICACION_ALQUILER;
		
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
			FETCH ACTIVOS_PUBLICACION_ALQUILER INTO FILA_364B;
			EXIT WHEN ACTIVOS_PUBLICACION_ALQUILER%NOTFOUND;
			
			DBMS_OUTPUT.PUT_LINE(FILA_364B.ACT_ID);
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
								AHP_FECHA_FIN_ALQUILER = SYSDATE
							,   USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
							,   FECHAMODIFICAR = SYSDATE
						WHERE   AHP_FECHA_INI_ALQUILER IS NOT NULL 
							AND AHP_FECHA_FIN_ALQUILER IS NULL
							AND ACT_ID = '||FILA_364B.ACT_ID||'';
  		
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
							,	APU_FECHA_FIN_VENTA
							,	APU_FECHA_INI_ALQUILER
							,	NULL
							,	VERSION
							,	''HREOS-5932-PUNTO3-6-4''
							,	SYSDATE
							,   NULL
							,   NULL
							,   NULL
							,   NULL
							,   0
							,	ES_CONDICONADO_ANTERIOR
							,	DD_TPU_V_ID
							,	DD_TPU_A_ID
						FROM  '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION  WHERE ACT_ID = '||FILA_364B.ACT_ID||')';
							
			
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

/**	3.6.4. C. Si el activo está oculto en alquiler por motivo “Alquiler” y el campo “Adecuado” del Excel es “NO”” ocultar el activo 
				por motivo “Revisión adecuación” y actualizar su histórico de publicaciones de alquiler									**/
		
		
		DBMS_OUTPUT.put_line('	[INFO] 3.6.4. C QUITAR LOS CHECKS DE ALQUILER');

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU USING
						(SELECT  APU.ACT_ID 
								,AUX.DESTINO_COMERCIAL
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX 
							INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA AND ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
							INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
							INNER JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID
							INNER JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON APU.DD_MTO_A_ID = MTO.DD_MTO_ID AND MTO.DD_MTO_CODIGO = ''03''
							WHERE AUX.ESTADO_ADECUACION IN (''02'')) T2
					ON (APU.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN
					UPDATE SET 
						  APU.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = T2.DESTINO_COMERCIAL)
						, APU.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
						, APU.FECHAMODIFICAR = SYSDATE';
		
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
  		
  		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING (
							SELECT      ACT.ACT_ID
									,   AUX.ID_HAYA
									,	AUX.DESTINO_COMERCIAL
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
							INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON (AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO)
							WHERE ACT.USUARIOMODIFICAR  = ''HREOS-5932-PUNTO3-6-4'' 
							)T2
						ON (ACT.ACT_ID = T2.ACT_ID)        
					WHEN MATCHED THEN 
						UPDATE SET 
							ACT.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = T2.DESTINO_COMERCIAL)
						,   ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
						,   ACT.FECHAMODIFICAR = SYSDATE
					';

		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
		
		/*
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] SE ACTUALIZA EL HISTORICO DE PUBLICACIONES'); 
		
		OPEN ACTIVOS_PUBLICACION_REVISION_A;
		
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
			FETCH ACTIVOS_PUBLICACION_REVISION_A INTO FILA_364C;
			EXIT WHEN ACTIVOS_PUBLICACION_REVISION_A%NOTFOUND;
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
								AHP_FECHA_FIN_VENTA = SYSDATE
							,   USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
							,   FECHAMODIFICAR = SYSDATE
						WHERE   AHP_FECHA_INI_VENTA IS NOT NULL 
							AND AHP_FECHA_FIN_VENTA IS NULL
							AND ACT_ID = '||FILA_364C.ACT_ID||'';
  		
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
							,	''HREOS-5932-PUNTO3-6-4''
							,	SYSDATE
							,   NULL
							,   NULL
							,   NULL
							,   NULL
							,   0
							,	ES_CONDICONADO_ANTERIOR
							,	DD_TPU_V_ID
							,	DD_TPU_A_ID
						FROM  '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION  WHERE ACT_ID = '||FILA_364C.ACT_ID||')';
						
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
		
/**	3.6.4. D. Si el activo está oculto en venta por motivo “Alquiler” publicar el activo en venta y actualizar su histórico de 
				publicaciones de venta																							**/
		
		DBMS_OUTPUT.put_line('	[INFO] 3.6.4. D. QUITAR LOS CHECKS DE ALQUILER');

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU USING
						(SELECT APU.ACT_ID 
							,	AUX.DESTINO_COMERCIAL
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX 
							INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA AND ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
							INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
							INNER JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON APU.DD_MTO_V_ID = MTO.DD_MTO_ID AND MTO.DD_MTO_CODIGO = ''03'') T2
					ON (APU.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN
					UPDATE SET 
						  APU.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = T2.DESTINO_COMERCIAL)
						, APU.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
						, APU.FECHAMODIFICAR = SYSDATE';
		
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
		
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING (
							SELECT      ACT.ACT_ID
									,   AUX.ID_HAYA
									,	AUX.DESTINO_COMERCIAL
							FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
							INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON (AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO)
							WHERE ACT.USUARIOMODIFICAR  = ''HREOS-5932-PUNTO3-6-4'' 
							)T2
						ON (ACT.ACT_ID = T2.ACT_ID)        
					WHEN MATCHED THEN 
						UPDATE SET 
							ACT.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = T2.DESTINO_COMERCIAL)
						,   ACT.USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
						,   ACT.FECHAMODIFICAR = SYSDATE
					';

		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
		/*
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] SE ACTUALIZA EL HISTORICO DE PUBLICACIONES'); 
		
		OPEN ACTIVOS_PUBLICACION_VENDER_ALQ;
		
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
			FETCH ACTIVOS_PUBLICACION_VENDER_ALQ INTO FILA_364D;
			EXIT WHEN ACTIVOS_PUBLICACION_VENDER_ALQ%NOTFOUND;
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
								AHP_FECHA_FIN_VENTA = SYSDATE
							,   USUARIOMODIFICAR = ''HREOS-5932-PUNTO3-6-4''
							,   FECHAMODIFICAR = SYSDATE
						WHERE   AHP_FECHA_INI_VENTA IS NOT NULL 
							AND AHP_FECHA_FIN_VENTA IS NULL
							AND ACT_ID = '||FILA_364D.ACT_ID||'';
			
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
							,	NULL
							,	VERSION
							,	''HREOS-5932-PUNTO3-6-4''
							,	SYSDATE
							,   NULL
							,   NULL
							,   NULL
							,   NULL
							,   0
							,	ES_CONDICONADO_ANTERIOR
							,	DD_TPU_V_ID
							,	DD_TPU_A_ID
						FROM  '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION  WHERE ACT_ID = '||FILA_364D.ACT_ID||')';
						
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
