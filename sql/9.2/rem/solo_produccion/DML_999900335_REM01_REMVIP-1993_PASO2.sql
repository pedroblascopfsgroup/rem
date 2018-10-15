--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180926
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1993
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
SET DEFINE OFF;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); 										-- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; 						-- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); 											-- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); 											-- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  												-- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); 										-- Vble. auxiliar para registrar errores en el script.
    n_times NUMBER := 10;
    val NUMBER;
    V_USUARIO VARCHAR2(40 CHAR) := 'REMVIP-1993';

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);							--Array con las tablas que mergearemos para pasarles estadísticas al final del script.
	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

		--TABLAS ICO, EDI, VIV y LOC
		T_TIPO_DATA('ACT_ICO_INFO_COMERCIAL'),
		T_TIPO_DATA('ACT_EDI_EDIFICIO'),
		T_TIPO_DATA('ACT_VIV_VIVIENDA'),
		T_TIPO_DATA('ACT_LOC_LOCALIZACION'),
		--TABLAS DE CALIDADES
		T_TIPO_DATA('ACT_CRI_CARPINTERIA_INT'),
		T_TIPO_DATA('ACT_CRE_CARPINTERIA_EXT'),
		T_TIPO_DATA('ACT_ZCO_ZONA_COMUN'),
		T_TIPO_DATA('ACT_COC_COCINA'),
		T_TIPO_DATA('ACT_INS_INSTALACION'),
		T_TIPO_DATA('ACT_PRV_PARAMENTO_VERTICAL'),
		T_TIPO_DATA('ACT_SOL_SOLADO'),
		T_TIPO_DATA('ACT_BNY_BANYO'),
		T_TIPO_DATA('ACT_INF_INFRAESTRUCTURA'),
		--TABLA DE DISTRIBUCIONES
		T_TIPO_DATA('ACT_DIS_DISTRIBUCION')
	
	);
	V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN	        

	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el script de mergeo a tablas finales...');


	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_ACTIVO
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--Calificacion (rating) del activo (DD_RTG_ID)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_ACTIVO ACT
				USING 
				(
				SELECT 
					  ACT.ACT_NUM_ACTIVO AS ACT_NUMERO_ACTIVO,
					  CASE WHEN AUX.IV_VALORACIONGLOBAL = ''Muy bueno'' THEN (SELECT DD_RTG_ID FROM REM01.DD_RTG_RATING_ACTIVO DD WHERE DD.DD_RTG_CODIGO = ''01'') 
						   WHEN AUX.IV_VALORACIONGLOBAL = ''Bueno'' THEN (SELECT DD_RTG_ID FROM REM01.DD_RTG_RATING_ACTIVO DD WHERE DD.DD_RTG_CODIGO = ''02'') 
						   WHEN AUX.IV_VALORACIONGLOBAL = ''Medio'' THEN (SELECT DD_RTG_ID FROM REM01.DD_RTG_RATING_ACTIVO DD WHERE DD.DD_RTG_CODIGO = ''05'') 
						   WHEN AUX.IV_VALORACIONGLOBAL = ''Malo'' THEN (SELECT DD_RTG_ID FROM REM01.DD_RTG_RATING_ACTIVO DD WHERE DD.DD_RTG_CODIGO = ''08'') 
						   WHEN AUX.IV_VALORACIONGLOBAL = ''Infravivienda'' THEN (SELECT DD_RTG_ID FROM REM01.DD_RTG_RATING_ACTIVO DD WHERE DD.DD_RTG_CODIGO = ''10'') 
						   WHEN AUX.IV_VALORACIONGLOBAL IS NULL THEN NULL 
					  END AS RATING
				FROM  REM01.MIG_AUX_DATOS_INMUEBLES  AUX
				JOIN  REM01.ACT_ACTIVO               ACT
				  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
				 AND  REF_CLIENTE_AK IS NOT NULL 
				 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'',048721373500000387)
				 AND  ACT.ACT_ACTIVO_COOPER = 2
				) AUXILIAR
				ON (AUXILIAR.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO)
				WHEN MATCHED THEN
				UPDATE SET   ACT.DD_RTG_ID = AUXILIAR.RATING
						   , ACT.USUARIOMODIFICAR = '''||V_USUARIO||'''
						   , ACT.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_ACTIVO '||SQL%ROWCOUNT||' Filas actualizadas.');


	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_ICO_INFO_COMERCIAL
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--Tipo de activo (DD_TPA_ID)
	--Subtipo de activo (DD_SAC_ID)
	--Ubicación del activo (DD_UAC_ID)
	--Año de construccion del activo (ICO_ANO_CONSTRUCCION)
	--Estado de conservacion del activo (DD_ECV_ID)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_ICO_INFO_COMERCIAL ICO
				USING
				(
						SELECT	ICO.ICO_ID,
								ACT.ACT_ID,
								ACT.DD_TPA_ID,
								ACT.DD_SAC_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						LEFT JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
				) AUXILIAR
				ON (AUXILIAR.ICO_ID = ICO.ICO_ID)
				WHEN MATCHED THEN
				UPDATE SET
						ICO.DD_TPA_ID = AUXILIAR.DD_TPA_ID
					  , ICO.DD_SAC_ID = AUXILIAR.DD_SAC_ID	
					  ,	ICO.DD_UAC_ID = (SELECT DD_UAC_ID FROM REM01.DD_UAC_UBICACION_ACTIVO UAC 
										 WHERE UAC.DD_UAC_CODIGO = CASE WHEN AUXILIAR.XTR_TIPORESIDENCIA = ''Costa'' THEN ''01'' WHEN AUXILIAR.XTR_TIPORESIDENCIA = ''Rural'' THEN ''03'' WHEN AUXILIAR.XTR_TIPORESIDENCIA LIKE ''Urbana'' THEN ''04'' END)             			
					  , ICO.ICO_ANO_CONSTRUCCION = CASE WHEN AUXILIAR.INMU_ANIOCONST IN (''0'',''00'',''000'',''0000'',''0001'',''1'',''1000'') OR AUXILIAR.INMU_ANIOCONST IS NULL THEN NULL ELSE AUXILIAR.INMU_ANIOCONST END
					  , ICO.DD_ECV_ID = (SELECT DD_ECV_ID FROM REM01.DD_ECV_ESTADO_CONSERVACION ECV 
										 WHERE ECV.DD_ECV_CODIGO = CASE WHEN LOWER(AUXILIAR.INMU_ESTADO) IN (''nuevo a estrenar'') THEN ''01'' WHEN LOWER(AUXILIAR.INMU_ESTADO) IN (''buen estado'') THEN ''02'' WHEN LOWER(AUXILIAR.INMU_ESTADO) IN (''habitable'') THEN ''03'' WHEN LOWER(AUXILIAR.INMU_ESTADO) IN (''a reformar'') THEN ''04'' WHEN LOWER(AUXILIAR.INMU_ESTADO) IN (''inaccesible'') THEN ''05'' END)            
					  , ICO.USUARIOMODIFICAR = '''||V_USUARIO||'''
					  , ICO.FECHAMODIFICAR = SYSDATE                   
				WHEN NOT MATCHED THEN
				INSERT 
				(
						ICO_ID,
						ACT_ID,
						DD_TPA_ID,
						DD_SAC_ID,
						DD_UAC_ID,
						DD_ECV_ID,
						ICO_ANO_CONSTRUCCION,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_ICO_INFO_COMERCIAL.NEXTVAL                                            
						, AUXILIAR.ACT_ID 
						, AUXILIAR.DD_TPA_ID
						, AUXILIAR.DD_SAC_ID	                                                          		  
						, (SELECT DD_UAC_ID FROM REM01.DD_UAC_UBICACION_ACTIVO UAC 
								  WHERE UAC.DD_UAC_CODIGO = CASE WHEN XTR_TIPORESIDENCIA = ''Costa'' THEN ''01'' WHEN XTR_TIPORESIDENCIA = ''Rural'' THEN ''03'' WHEN XTR_TIPORESIDENCIA LIKE ''Urbana'' THEN ''04'' END)
						, (SELECT DD_ECV_ID FROM REM01.DD_ECV_ESTADO_CONSERVACION ECV 
								  WHERE ECV.DD_ECV_CODIGO = CASE WHEN LOWER(INMU_ESTADO) IN (''nuevo a estrenar'') THEN ''01'' WHEN LOWER(INMU_ESTADO) IN (''buen estado'') THEN ''02'' WHEN LOWER(INMU_ESTADO) IN (''habitable'') THEN ''03'' WHEN LOWER(INMU_ESTADO) IN (''a reformar'') THEN ''04'' WHEN LOWER(INMU_ESTADO) IN (''inaccesible'') THEN ''05'' END)     
						, CASE WHEN INMU_ANIOCONST IN (''0'',''00'',''000'',''0000'',''0001'',''1'',''1000'') OR INMU_ANIOCONST IS NULL THEN NULL ELSE INMU_ANIOCONST END
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';      
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_ICO_INFO_COMERCIAL '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');



	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_EDI_EDIFICIO
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--Entorno de infraestructuras del activo (EDI_ENTORNO_INFRAESTRUCTURA)
	--Número de plantas del activo(EDI_NUM_PLANTAS)
	--Estado de conservación del edificio (DD_ECV_ID)
	--Si el activo posee ascensor (EDI_ASCENSOR)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_EDI_EDIFICIO EDI
				USING
				(
						SELECT	EDI.ICO_ID AS EDI_ICO_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_EDI_EDIFICIO                EDI
						  ON  EDI.ICO_ID = ICO.ICO_ID
				) AUXILIAR
				ON (AUXILIAR.EDI_ICO_ID = EDI.ICO_ID)
				WHEN MATCHED THEN
				UPDATE SET
						EDI.EDI_ENTORNO_INFRAESTRUCTURA = CASE WHEN IDI_VISTAS IS NOT NULL THEN ''Vistas desde el activo: ''||IDI_VISTAS||''. '' END||
														  CASE WHEN XTR_SUPERMERCADO IS NOT NULL AND XTR_SUPERMERCADO NOT IN (''No cercano'') THEN ''Supermercado a m''||SUBSTR(XTR_SUPERMERCADO,2)||''. '' END ||
														  CASE WHEN XTR_NIVELSERVICIOS IN (''Buenos'',''Muy buenos'',''Normales'') THEN ''Niveles ''||LOWER(SUBSTR(XTR_NIVELSERVICIOS,1,1))||SUBSTR(XTR_NIVELSERVICIOS,2)||'' respecto a los servicios cercanos al activo.'' END         
					  , EDI.EDI_NUM_PLANTAS = XTR_NUMPLANTAS
					  , EDI.DD_ECV_ID = (SELECT DD_ECV_ID FROM REM01.DD_ECV_ESTADO_CONSERVACION ECV 
												WHERE ECV.DD_ECV_CODIGO = CASE WHEN XTR_ESTADOCONSEXT IN (''Bueno'') THEN ''02'' WHEN XTR_ESTADOCONSEXT IN (''Malo'') THEN ''04'' WHEN XTR_ESTADOCONSEXT IN (''Medio'') THEN ''03'' WHEN XTR_ESTADOCONSEXT IN (''Muy malo'') THEN ''05'' END)
					  , EDI.EDI_ASCENSOR = CASE WHEN INMU_ASCENSOR = 1 THEN 1 ELSE 0 END
					  , EDI.USUARIOMODIFICAR = '''||V_USUARIO||'''
					  , EDI.FECHAMODIFICAR = SYSDATE 
				WHEN NOT MATCHED THEN
				INSERT 
				(
						EDI_ID,
						ICO_ID,
						EDI_ENTORNO_INFRAESTRUCTURA,
						EDI_NUM_PLANTAS,
						DD_ECV_ID,
						EDI_ASCENSOR,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_EDI_EDIFICIO.NEXTVAL     
						, AUXILIAR.ICO_ID                                            
						, CASE WHEN IDI_VISTAS IS NOT NULL THEN ''Vistas desde el activo: ''||IDI_VISTAS END||''. '' ||
						   CASE WHEN XTR_SUPERMERCADO IS NOT NULL AND XTR_SUPERMERCADO NOT IN (''No cercano'') THEN ''Supermercado a m''||SUBSTR(XTR_SUPERMERCADO,2)||''. '' END ||
							CASE WHEN XTR_NIVELSERVICIOS IN (''Buenos'',''Muy buenos'',''Normales'') THEN ''Niveles ''||LOWER(SUBSTR(XTR_NIVELSERVICIOS,1,1))||SUBSTR(XTR_NIVELSERVICIOS,2)||'' respecto a los servicios cercanos al activo.'' END 
						, XTR_NUMPLANTAS
						, (SELECT DD_ECV_ID FROM REM01.DD_ECV_ESTADO_CONSERVACION ECV 
								  WHERE ECV.DD_ECV_CODIGO = CASE WHEN XTR_ESTADOCONSEXT IN (''Bueno'') THEN ''02'' WHEN XTR_ESTADOCONSEXT IN (''Malo'') THEN ''04'' WHEN XTR_ESTADOCONSEXT IN (''Medio'') THEN ''03'' WHEN XTR_ESTADOCONSEXT IN (''Muy malo'') THEN ''05'' END)
						, CASE WHEN INMU_ASCENSOR = 1 THEN 1 ELSE 0 END 
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_EDI_EDIFICIO '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');



	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_VIV_VIVIENDA
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--Tipo de vivienda (DD_TPV_ID)
	--Orientación de la vivienda (DD_TPO_ID)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_VIV_VIVIENDA VIV
				USING
				(
						SELECT	ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_VIV_VIVIENDA                VIV
						  ON  VIV.ICO_ID = ICO.ICO_ID
				) AUXILIAR
				ON (AUXILIAR.ICO_ID = VIV.ICO_ID)
				WHEN MATCHED THEN
				UPDATE SET
						VIV.DD_TPV_ID = (SELECT DD_TPV_ID FROM REM01.DD_TPV_TIPO_VIVIENDA TPV 
												WHERE TPV.DD_TPV_CODIGO = CASE WHEN XTR_EXTINT = ''Exterior'' THEN ''01'' WHEN XTR_EXTINT = ''Interior'' THEN ''02'' END) 
					  , VIV.DD_TPO_ID = (SELECT DD_TPO_ID FROM REM01.DD_TPO_TIPO_ORIENTACION TPO 
												WHERE TPO.DD_TPO_CODIGO = CASE WHEN INMU_ORIENTACION IS NULL OR INMU_ORIENTACION IN (''97'',''95'') THEN NULL WHEN INMU_ORIENTACION IN (''49'') THEN ''01'' WHEN INMU_ORIENTACION IN (''51'',''60'',''62'') THEN ''02'' WHEN INMU_ORIENTACION IN (''52'',''56'') THEN ''03'' WHEN INMU_ORIENTACION IN (''54'',''58'') THEN ''04'' END )
				WHEN NOT MATCHED THEN
				INSERT 
				(
						ICO_ID,
						DD_TPV_ID,
						DD_TPO_ID
				)
				VALUES
				(
						AUXILIAR.ICO_ID,
						(SELECT DD_TPV_ID FROM REM01.DD_TPV_TIPO_VIVIENDA TPV 
												WHERE TPV.DD_TPV_CODIGO = CASE WHEN XTR_EXTINT = ''Exterior'' THEN ''01'' WHEN XTR_EXTINT = ''Interior'' THEN ''02'' END),
						(SELECT DD_TPO_ID FROM REM01.DD_TPO_TIPO_ORIENTACION TPO 
												WHERE TPO.DD_TPO_CODIGO = CASE WHEN INMU_ORIENTACION IS NULL OR INMU_ORIENTACION IN (''97'',''95'') THEN NULL WHEN INMU_ORIENTACION IN (''49'') THEN ''01'' WHEN INMU_ORIENTACION IN (''51'',''60'',''62'') THEN ''02'' WHEN INMU_ORIENTACION IN (''52'',''56'') THEN ''03'' WHEN INMU_ORIENTACION IN (''54'',''58'') THEN ''04'' END )
				)   
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_VIV_VIVIENDA '||SQL%ROWCOUNT||' Filas actualizadas.');



	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_LOC_LOCALIZACION
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--Tipo de ubicación del activo (DD_TUB_ID)
	--Distancia a la playa (LOC_DIST_PLAYA)
	--Latitud del activo (LOC_LATITUD)
	--Longitud del activo (LOC_LONGITUD)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_LOC_LOCALIZACION LOC
				USING
				(
						SELECT	LOC.LOC_ID,
								ACT.BIE_ID,
								BIE_LOC.BIE_LOC_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.BIE_LOCALIZACION            BIE_LOC
						  ON  BIE_LOC.BIE_ID = ACT.BIE_ID
						LEFT JOIN  REM01.ACT_LOC_LOCALIZACION            LOC
						  ON  LOC.ACT_ID = ACT.ACT_ID
				) AUXILIAR
				ON (AUXILIAR.LOC_ID = LOC.LOC_ID)
				WHEN MATCHED THEN
				UPDATE SET
						LOC.DD_TUB_ID = (SELECT DD_TUB_ID FROM REM01.DD_TUB_TIPO_UBICACION TUB 
												  WHERE TUB.DD_TUB_CODIGO = CASE WHEN XTR_TIPORESIDENCIA = ''Costa'' THEN ''01'' WHEN XTR_TIPORESIDENCIA = ''Rural'' THEN ''04'' WHEN XTR_TIPORESIDENCIA LIKE ''Urbana'' THEN ''07'' END)
					  , LOC.LOC_DIST_PLAYA = CASE WHEN XTR_DISTPLAYA IN (''Hasta 1 km'') THEN 1000 WHEN XTR_DISTPLAYA IN (''Menos de 20 km'') THEN 20000 WHEN XTR_DISTPLAYA IN (''Menos de 5 km'') THEN 5000 WHEN XTR_DISTPLAYA IN (''1ª linea'') THEN 50 WHEN XTR_DISTPLAYA IN (''2ª linea'') THEN 200 END
					  , LOC.LOC_LATITUD = TO_NUMBER(LATITUD)
					  , LOC.LOC_LONGITUD = TO_NUMBER(LONGITUD) 
					  , LOC.USUARIOMODIFICAR = '''||V_USUARIO||'''
					  , LOC.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT 
				(
						LOC_ID,
						BIE_LOC_ID,
						ACT_ID,
						DD_TUB_ID,
						LOC_DIST_PLAYA,
						LOC_LATITUD,
						LOC_LONGITUD,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_LOC_LOCALIZACION.NEXTVAL  
						, AUXILIAR.BIE_LOC_ID
						, AUXILIAR.ACT_ID
						, (SELECT DD_TUB_ID FROM REM01.DD_TUB_TIPO_UBICACION TUB 
												  WHERE TUB.DD_TUB_CODIGO = CASE WHEN XTR_TIPORESIDENCIA = ''Costa'' THEN ''01'' WHEN XTR_TIPORESIDENCIA = ''Rural'' THEN ''04'' WHEN XTR_TIPORESIDENCIA LIKE ''Urbana'' THEN ''07'' END)
						, CASE WHEN XTR_DISTPLAYA IN (''Hasta 1 km'') THEN 1000 WHEN XTR_DISTPLAYA IN (''Menos de 20 km'') THEN 20000 WHEN XTR_DISTPLAYA IN (''Menos de 5 km'') THEN 5000 WHEN XTR_DISTPLAYA IN (''1ª linea'') THEN 50 WHEN XTR_DISTPLAYA IN (''2ª linea'') THEN 200 END
						, TO_NUMBER(LATITUD)
						, TO_NUMBER(LONGITUD)  
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_LOC_LOCALIZACION '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');


	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--CALIDADES DE LOS ACTIVOS
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_CRI_CARPINTERIA_INT
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_CRI_CARPINTERIA_INT CRI
				USING
				(
						SELECT	CRI.CRI_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_CRI_CARPINTERIA_INT                CRI
						  ON  CRI.ICO_ID = ICO.ICO_ID

				) AUXILIAR
				ON (AUXILIAR.CRI_ID = CRI.CRI_ID)
				WHEN NOT MATCHED THEN
				INSERT 
				(
						CRI_ID,
						ICO_ID,
						DD_ACR_ID,
						CRI_PTA_ENT_NORMAL,
						CRI_PTA_ENT_BLINDADA,
						CRI_PTA_ENT_ACORAZADA,
						CRI_PTA_PASO_MACIZAS,
						CRI_PTA_PASO_HUECAS,
						CRI_PTA_PASO_LACADAS,
						CRI_ARMARIOS_EMPOTRADOS,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_CRI_CARPINTERIA_INT.NEXTVAL  
						, AUXILIAR.ICO_ID
						, (SELECT DD_ACR_ID FROM REM01.DD_ACR_ACABADO_CARPINTERIA WHERE DD_ACR_CODIGO = CASE WHEN INMU_EMPOTRADOS IN (''Equipados'') THEN ''02'' WHEN INMU_EMPOTRADOS IN (''No equipados'') THEN ''03'' ELSE NULL END)
						, CASE XTR_PUERTAPRIN WHEN ''Normal''    THEN 1 END
						, CASE XTR_PUERTAPRIN WHEN ''Blindada''  THEN 1 END
						, CASE XTR_PUERTAPRIN WHEN ''Acorazada'' THEN 1 END
						, CASE XTR_PUERTASINT WHEN ''Macizas''   THEN 1 END 
						, CASE XTR_PUERTASINT WHEN ''Chapadas''  THEN 1 END
						, CASE XTR_PUERTASINT WHEN ''Lacadas''   THEN 1 END
						, CASE WHEN INMU_EMPOTRADOS IN (''Equipados'') THEN 1 WHEN INMU_EMPOTRADOS IN (''No dispone'',''No equipados'') THEN 0 END
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_CRI_CARPINTERIA_INT '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');



	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_CRE_CARPINTERIA_EXT
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_CRE_CARPINTERIA_EXT CRE
				USING
				(
						SELECT	CRE.CRE_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_CRE_CARPINTERIA_EXT                CRE
						  ON  CRE.ICO_ID = ICO.ICO_ID

				) AUXILIAR
				ON (AUXILIAR.CRE_ID = CRE.CRE_ID)
				WHEN NOT MATCHED THEN
				INSERT 
				(
						  CRE_ID,
						  ICO_ID,
						  CRE_VTNAS_HIERRO,
						  CRE_VTNAS_ALU_ANODIZADO,
						  CRE_VTNAS_ALU_LACADO,
						  CRE_VTNAS_PVC,
						  CRE_VTNAS_MADERA,
						  CRE_CRP_EXT_OTROS,
						  VERSION,
						  USUARIOCREAR,
						  FECHACREAR,
						  BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_CRE_CARPINTERIA_EXT.NEXTVAL  
						, AUXILIAR.ICO_ID
						, CASE WHEN INMU_VENTANAS IN (''Hierro'') THEN 1 END
						, CASE WHEN INMU_VENTANAS IN (''Aluminio'') THEN 1 END
						, CASE WHEN INMU_VENTANAS IN (''Aluminio'') THEN 1 END 
						, CASE WHEN INMU_VENTANAS IN (''PVC'') THEN 1 END
						, CASE WHEN INMU_VENTANAS IN (''Madera'') THEN 1 END
						, CASE WHEN INMU_PERSIANAS = ''1'' THEN ''El activo dispone de persianas.'' END 
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_CRE_CARPINTERIA_EXT '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_ZCO_ZONA_COMUN
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_ZCO_ZONA_COMUN ZCO
				USING
				(
						SELECT	ZCO.ZCO_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_ZCO_ZONA_COMUN                ZCO
						  ON  ZCO.ICO_ID = ICO.ICO_ID

				) AUXILIAR
				ON (AUXILIAR.ZCO_ID = ZCO.ZCO_ID)
				WHEN NOT MATCHED THEN
				INSERT 
				(
						  ZCO_ID,
						  ICO_ID,
						  ZCO_JARDINES,
						  ZCO_PISCINA,
						  ZCO_INST_DEP,
						  ZCO_OTROS,
						  ZCO_ZONA_INFANTIL,
						  ZCO_ZONA_COMUN_OTROS,
						  VERSION,
						  USUARIOCREAR,
						  FECHACREAR,
						  BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_ZCO_ZONA_COMUN.NEXTVAL  
						, AUXILIAR.ICO_ID
						, XTR_ZONASVERDES
						, CASE WHEN XTR_PISCINA IN (''Común'',''Privada'') THEN 1 WHEN XTR_PISCINA IN (''No dispone'') THEN 0 END
						, CASE WHEN INMU_ZDEPORTIVAS IN (''si'') THEN 1 WHEN INMU_ZDEPORTIVAS IN (''no'') THEN 0 END			  
						, NVL2(INMU_ZDEPORTIVASOBS,''Zonas deportivas: ''||lower(INMU_ZDEPORTIVASOBS)||''. '',INMU_ZDEPORTIVASOBS)||   
						  CASE WHEN XTR_PISCINA = ''Privada'' THEN ''El activo dispone de piscina privada.'' END
						, CASE WHEN XTR_PARQUE IS NULL OR XTR_PARQUE IN (''No dispone'') THEN NULL ELSE 1 END
						, CASE WHEN XTR_PISCINA = ''Común'' THEN ''El activo dispone de piscina comunitaria. '' END||
						  CASE WHEN XTR_PORTEROFISICO IN (''Automático'',''Físico'') THEN ''El activo dispone de portero ''||LOWER(XTR_PORTEROFISICO)||''.'' WHEN XTR_PORTEROFISICO IN (''Videoportero'') THEN ''El activo dispone de ''||LOWER(XTR_PORTEROFISICO)||''.'' END
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_ZCO_ZONA_COMUN '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_COC_COCINA
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_COC_COCINA COC
				USING
				(
						SELECT	COC.COC_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_COC_COCINA                COC
						  ON  COC.ICO_ID = ICO.ICO_ID

				) AUXILIAR
				ON (AUXILIAR.COC_ID = COC.COC_ID)
				WHEN NOT MATCHED THEN
				INSERT 
				(
						  COC_ID,
						  ICO_ID,
						  COC_AMUEBLADA,
						  COC_AMUEBLADA_EST,
						  COC_LAVADORA,
						  COC_FRIGORIFICO,
						  COC_LAVAVAJILLAS,
						  COC_MICROONDAS,
						  COC_HORNO,
						  COC_COCINA_OTROS, 
						  VERSION,
						  USUARIOCREAR,
						  FECHACREAR,
						  BORRADO   
				)
				VALUES
				(
						  REM01.S_ACT_COC_COCINA.NEXTVAL  
						, AUXILIAR.ICO_ID
						, CASE WHEN IDI_ESTADOCOCINA IN (''No aplica'',''Nueva a amueblar'') OR IDI_ESTADOCOCINA IS NULL THEN 0 ELSE 1 END
						, CASE WHEN IDI_ESTADOCOCINA IN (''Normal'',''Nueva a estrenar'',''Nueva a amueblar'',''Reformada'') THEN 1 ELSE 0 END
						, XTR_LAVADORA 
						, XTR_FRIGORIFICO 
						, XTR_LAVAVAJILLAS 
						, XTR_MICROONDAS 
						, XTR_HORNO
						, CASE WHEN INMU_BARBACOA IN (''1'') THEN ''Barbacoa en buen estado. '' END ||
						  CASE WHEN INMU_BODEGA = ''1'' THEN ''El activo dispone de una bodega. '' END ||
						  CASE WHEN INMU_TIPOCOCINA IN (''Americana'',''Independiente'') THEN ''El activo posee una cocina ''||LOWER(SUBSTR(INMU_TIPOCOCINA,1,1))||SUBSTR(INMU_TIPOCOCINA,2) END
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_COC_COCINA '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_INS_INSTALACION
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_INS_INSTALACION INS
				USING
				(
						SELECT	INS.INS_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_INS_INSTALACION                INS
						  ON  INS.ICO_ID = ICO.ICO_ID

				) AUXILIAR
				ON (AUXILIAR.INS_ID = INS.INS_ID)
				WHEN NOT MATCHED THEN
				INSERT 
				(
						  INS_ID,
						  ICO_ID,
						  INS_CALEF,
						  INS_CALEF_CENTRAL,
						  INS_CALEF_GAS_NATURAL,
						  INS_CALEF_RADIADORES_ALU,
						  INS_CALEF_PREINSTALACION,
						  INS_AIRE,
						  INS_AIRE_PREINSTALACION,
						  INS_AIRE_INSTALACION,
						  INS_AIRE_FRIO_CALOR,
						  VERSION,
						  USUARIOCREAR,
						  FECHACREAR,
						  BORRADO   
				)
				VALUES
				(
						  REM01.S_ACT_INS_INSTALACION.NEXTVAL  
						, AUXILIAR.ICO_ID
						, CASE WHEN INMU_TIPOCALEF NOT IN (''No dispone'') AND INMU_TIPOCALEF IS NOT NULL THEN 1 ELSE 0 END
						, CASE WHEN INMU_TIPOCALEF IN (''Central'') THEN 1 ELSE 0 END
						, CASE WHEN INMU_TIPOCALEF IN (''Individual'') THEN 1 ELSE 0 END
						, CASE WHEN INMU_TIPOCALEF IN (''Acumuladores eléctricos'',''Central'',''Individual'') THEN 1 ELSE 0 END
						, CASE WHEN INMU_TIPOCALEF IN (''No dispone'') THEN 1 ELSE 0 END 
						, CASE WHEN INMU_AIREA IN (''Si central'',''Si individual'') THEN 1 ELSE 0 END
						, CASE WHEN INMU_AIREA IN (''Si central'',''Si individual'') THEN 1 ELSE 0 END
						, CASE WHEN INMU_AIREA IN (''Si central'',''Si individual'') THEN 1 ELSE 0 END 
						, CASE WHEN INMU_AIREA IN (''Si central'',''Si individual'') AND INMU_TIPOCALEF IN (''Bomba de calor'') THEN 1 END 
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_INS_INSTALACION '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_PRV_PARAMENTO_VERTICAL
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_PRV_PARAMENTO_VERTICAL PRV
				USING
				(
						SELECT	PRV.PRV_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_PRV_PARAMENTO_VERTICAL                PRV
						  ON  PRV.ICO_ID = ICO.ICO_ID

				) AUXILIAR
				ON (AUXILIAR.PRV_ID = PRV.PRV_ID)
				WHEN NOT MATCHED THEN
				INSERT 
				(
						  PRV_ID,
						  ICO_ID,
						  PRV_GOTELE,
						  PRV_PLASTICA_LISA,
						  PRV_PINTURA_LISA_TECHO,
						  PRV_PAPEL_PINTADO,
						  PRV_MOLDURA_ESCAYOLA,
						  VERSION,
						  USUARIOCREAR,
						  FECHACREAR,
						  BORRADO   
				)
				VALUES
				(
						  REM01.S_ACT_PRV_PARAMENTO_VERTICAL.NEXTVAL  
						, AUXILIAR.ICO_ID
						, CASE WHEN XTR_PAREDES IN (''Gotelé'') THEN 1 END
						, CASE WHEN XTR_PAREDES IN (''Lisas'') THEN 1 END
						, CASE WHEN XTR_PAREDES IN (''Lisas'') THEN 1 END
						, CASE WHEN XTR_PAREDES IN (''Papel'') THEN 1 END 
						, CASE WHEN XTR_PAREDES IN (''Estuco'') THEN 1 END 
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_PRV_PARAMENTO_VERTICAL '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_SOL_SOLADO
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_SOL_SOLADO SOL
				USING
				(
						SELECT	SOL.SOL_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_SOL_SOLADO                SOL
						  ON  SOL.ICO_ID = ICO.ICO_ID

				) AUXILIAR
				ON (AUXILIAR.SOL_ID = SOL.SOL_ID)
				WHEN NOT MATCHED THEN
				INSERT 
				(
						  SOL_ID,
						  ICO_ID,
						  SOL_TARIMA_FLOTANTE,
						  SOL_PARQUE,
						  SOL_MARMOL,
						  SOL_SOLADO_OTROS, 
						  VERSION,
						  USUARIOCREAR,
						  FECHACREAR,
						  BORRADO   
				)
				VALUES
				(
						  REM01.S_ACT_SOL_SOLADO.NEXTVAL  
						, AUXILIAR.ICO_ID
						, CASE WHEN INMU_SUELOS IN (''Tarima'') THEN 1 END
						, CASE WHEN INMU_SUELOS IN (''Parquet'') THEN 1 END
						, CASE WHEN INMU_SUELOS IN (''Mármol'') THEN 1 END
						, CASE WHEN INMU_SUELOS NOT IN (''Mármol'',''Parquet'',''Tarima'') AND INMU_SUELOS IS NOT NULL THEN ''El material del suelo del activo es de tipo: ''||INMU_SUELOS  END
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_SOL_SOLADO '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_BNY_BANYO
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_BNY_BANYO BNY
				USING
				(
						SELECT	BNY.BNY_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_BNY_BANYO                BNY
						  ON  BNY.ICO_ID = ICO.ICO_ID

				) AUXILIAR
				ON (AUXILIAR.BNY_ID = BNY.BNY_ID)
				WHEN NOT MATCHED THEN
				INSERT 
				(
						  BNY_ID,
						  ICO_ID,
						  BNY_DUCHA_BANYERA,
						  BNY_BANYERA_HIDROMASAJE, 
						  BNY_COLUMNA_HIDROMASAJE,
						  BNY_SUELOS,
						  VERSION,
						  USUARIOCREAR,
						  FECHACREAR,
						  BORRADO   
				)
				VALUES
				(
						  REM01.S_ACT_BNY_BANYO.NEXTVAL  
						, AUXILIAR.ICO_ID 
						, CASE WHEN XTR_BANIERAS IS NULL AND XTR_DUCHAS IS NULL THEN NULL WHEN XTR_BANIERAS IN (''0'') OR XTR_BANIERAS IS NULL AND XTR_DUCHAS IN (''0'') OR XTR_DUCHAS IS NULL THEN 0 ELSE 1 END
						, INMU_BANIERAHIDRO
						, INMU_DUCHAHIDRO 
						, CASE WHEN INMU_SUELOSBANIOS IN (''Buen Estado'') THEN 1 WHEN INMU_SUELOSBANIOS IN (''Mal Estado'') THEN 0 END
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_BNY_BANYO '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');



	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_INF_INFRAESTRUCTURA
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_INF_INFRAESTRUCTURA INF
				USING
				(
						SELECT	INF.INF_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES     AUX
						JOIN  REM01.ACT_ACTIVO                  ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL            ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						LEFT JOIN  REM01.ACT_INF_INFRAESTRUCTURA                INF
						  ON  INF.ICO_ID = ICO.ICO_ID

				) AUXILIAR
				ON (AUXILIAR.INF_ID = INF.INF_ID)
				WHEN NOT MATCHED THEN
				INSERT 
				(
						  INF_ID,
						  ICO_ID,
						  INF_CENTROS_COMERC,
						  INF_CENTROS_COMERC_DESC,
						  INF_CENTROS_EDU,
						  INF_ESCUELAS_INF,
						  INF_ESCUELAS_INF_DESC,
						  INF_COLEGIOS,
						  INF_COLEGIOS_DESC,
						  INF_CENTROS_SANIT,
						  INF_CENTROS_SALUD,
						  INF_CENTROS_SALUD_DESC,
						  INF_CLINICAS,
						  INF_CLINICAS_DESC,
						  INF_HOSPITALES,
						  INF_HOSPITALES_DESC,
						  INF_CENTROS_SANIT_OTROS,
						  INF_COMUNICACIONES,
						  INF_FACIL_ACCESO,
						  INF_FACIL_ACCESO_DESC,
						  INF_LINEAS_BUS,
						  INF_LINEAS_BUS_DESC,
						  INF_METRO,
						  INF_METRO_DESC,
						  INF_EST_TREN,
						  INF_EST_TREN_DESC,
						  INF_COMUNICACIONES_OTRO,
						  VERSION,
						  USUARIOCREAR,
						  FECHACREAR,
						  BORRADO   
				)
				VALUES
				(
						  REM01.S_ACT_INF_INFRAESTRUCTURA.NEXTVAL  
						, AUXILIAR.ICO_ID       
						, CASE WHEN XTR_CENTROCOMERCIAL IN (''No cercano'',''Menos de 10 km'',''Menos de 20 km'') THEN 0 WHEN XTR_CENTROCOMERCIAL NOT IN (''No cercano'',''Menos de 10 km'',''Menos de 20 km'') AND XTR_CENTROCOMERCIAL IS NOT NULL THEN 1 END
						, CASE WHEN XTR_CENTROCOMERCIAL NOT IN (''No cercano'') AND XTR_CENTROCOMERCIAL IS NOT NULL THEN ''Centro comercial a m''||SUBSTR(XTR_CENTROCOMERCIAL,2)||''.'' END
						, CASE WHEN XTR_COLEGIO IN (''No cercano'',''No dispone'') THEN 0 WHEN XTR_COLEGIO NOT IN (''No cercano'',''No dispone'') AND XTR_COLEGIO IS NOT NULL THEN 1 END
						, CASE WHEN XTR_GUARDERIA IN (''No cercano'',''No dispone'') THEN 0 WHEN XTR_GUARDERIA NOT IN (''No cercano'',''No dispone'') AND XTR_GUARDERIA IS NOT NULL THEN 1 END
						, CASE WHEN XTR_GUARDERIA IN (''No cercano'',''No dispone'') THEN ''No hay guarderías cercanos.'' WHEN XTR_GUARDERIA NOT IN (''No cercano'',''No dispone'') AND XTR_GUARDERIA IS NOT NULL THEN ''Guardería a m''||SUBSTR(XTR_GUARDERIA,2)||''.'' END
						, CASE WHEN XTR_COLEGIO IN (''No cercano'',''No dispone'') THEN 0 WHEN XTR_COLEGIO NOT IN (''No cercano'',''No dispone'') AND XTR_COLEGIO IS NOT NULL THEN 1 END
						, CASE WHEN XTR_COLEGIO IN (''No cercano'',''No dispone'') THEN ''No hay colegios cercanos.'' WHEN XTR_COLEGIO NOT IN (''No cercano'',''No dispone'') AND XTR_COLEGIO IS NOT NULL THEN ''Colegio a m''||SUBSTR(XTR_COLEGIO,2)||''.'' END
						, CASE WHEN XTR_HOSPITALCLINICA IN (''No cercano'') THEN 0 WHEN XTR_HOSPITALCLINICA NOT IN (''No cercano'') AND XTR_HOSPITALCLINICA IS NOT NULL THEN 1 END
						, CASE WHEN XTR_HOSPITALCLINICA IN (''No cercano'') THEN 0 WHEN XTR_HOSPITALCLINICA NOT IN (''No cercano'') AND XTR_HOSPITALCLINICA IS NOT NULL THEN 1 END
						, CASE WHEN XTR_HOSPITALCLINICA IN (''No cercano'') THEN ''No hay centros médicos cercanos.'' WHEN XTR_HOSPITALCLINICA NOT IN (''No cercano'') AND XTR_HOSPITALCLINICA IS NOT NULL THEN ''Centro médico a m''||SUBSTR(XTR_HOSPITALCLINICA,2)||''.'' END
						, CASE WHEN XTR_HOSPITALCLINICA IN (''No cercano'') THEN 0 WHEN XTR_HOSPITALCLINICA NOT IN (''No cercano'') AND XTR_HOSPITALCLINICA IS NOT NULL THEN 1 END
						, CASE WHEN XTR_HOSPITALCLINICA IN (''No cercano'') THEN ''No hay centros médicos cercanos.'' WHEN XTR_HOSPITALCLINICA NOT IN (''No cercano'') AND XTR_HOSPITALCLINICA IS NOT NULL THEN ''Centro médico a m''||SUBSTR(XTR_HOSPITALCLINICA,2)||''.'' END
						, CASE WHEN XTR_HOSPITALCLINICA IN (''No cercano'') THEN 0 WHEN XTR_HOSPITALCLINICA NOT IN (''No cercano'') AND XTR_HOSPITALCLINICA IS NOT NULL THEN 1 END
						, CASE WHEN XTR_HOSPITALCLINICA IN (''No cercano'') THEN ''No hay centros médicos cercanos.'' WHEN XTR_HOSPITALCLINICA NOT IN (''No cercano'') AND XTR_HOSPITALCLINICA IS NOT NULL THEN ''Centro médico a m''||SUBSTR(XTR_HOSPITALCLINICA,2)||''.'' END
						, CASE WHEN XTR_FARMACIA IN (''No cercano'') THEN ''No hay farmacias cercanas.'' WHEN XTR_FARMACIA NOT IN (''No cercano'') AND XTR_FARMACIA IS NOT NULL THEN ''Farmacia a m''||SUBSTR(XTR_FARMACIA,2)||''.'' END
						, CASE WHEN XTR_ACCCARRETERA IN (''Malos'') THEN 0 WHEN XTR_ACCCARRETERA NOT IN (''Malos'') AND XTR_ACCCARRETERA IS NOT NULL THEN 1 END
						, CASE WHEN XTR_ACCCARRETERA IN (''Malos'') THEN 0 WHEN XTR_ACCCARRETERA NOT IN (''Malos'') AND XTR_ACCCARRETERA IS NOT NULL THEN 1 END
						, CASE WHEN XTR_ACCCARRETERA IN (''Malos'') THEN ''Accesos malos por carretera.'' WHEN XTR_ACCCARRETERA NOT IN (''Malos'') AND XTR_ACCCARRETERA IS NOT NULL THEN ''Accesos ''||LOWER(SUBSTR(XTR_ACCCARRETERA,1,1))||SUBSTR(XTR_ACCCARRETERA,2)||'' por carretera.'' END
						, CASE WHEN XTR_AUTOBUS IN (''No cercano'') THEN 0 WHEN XTR_AUTOBUS NOT IN (''No cercano'') AND XTR_AUTOBUS IS NOT NULL THEN 1 END
						, CASE WHEN XTR_AUTOBUS IN (''No cercano'') THEN ''No hay líneas de autobuses cercanas.'' WHEN XTR_AUTOBUS NOT IN (''No cercano'') AND XTR_AUTOBUS IS NOT NULL THEN ''Línea de autobús a m''||SUBSTR(XTR_AUTOBUS,2)||''.'' END
						, CASE WHEN XTR_METRO IN (''No cercano'',''No dispone'') THEN 0 WHEN XTR_METRO NOT IN (''No cercano'',''No dispone'') AND XTR_METRO IS NOT NULL THEN 1 END
						, CASE WHEN XTR_METRO IN (''No cercano'',''No dispone'') THEN ''No hay líneas de metro cercanas.'' WHEN XTR_METRO NOT IN (''No cercano'',''No dispone'') AND XTR_METRO IS NOT NULL THEN ''Línea de metro a m''||SUBSTR(XTR_METRO,2)||''.'' END
						, CASE WHEN XTR_RENFE IN (''No cercano'',''No dispone'') THEN 0 WHEN XTR_RENFE NOT IN (''No cercano'',''No dispone'') AND XTR_RENFE IS NOT NULL THEN 1 END
						, CASE WHEN XTR_RENFE IN (''No cercano'',''No dispone'') THEN ''No hay estaciones de tren cercanas.'' WHEN XTR_RENFE NOT IN (''No cercano'',''No dispone'') AND XTR_RENFE IS NOT NULL THEN ''Estación de tren a m''||SUBSTR(XTR_RENFE,2)||''.'' END
						, CASE WHEN XTR_AEROPUERTO IN (''No dispone'') THEN ''No dispone de aeropuertos cercanos.'' WHEN XTR_AEROPUERTO NOT IN (''No dispone'') AND XTR_AEROPUERTO IS NOT NULL THEN ''Aeropuerto a m''||SUBSTR(XTR_FARMACIA,2)||''.'' END
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_INF_INFRAESTRUCTURA '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--DISTRIBUCIONES DE LOS ACTIVOS
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_DIS_DISTRIBUCION --> (DORMITORIOS '01')
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_DIS_DISTRIBUCION DIS
				USING
				(
						SELECT	DIS.DIS_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES                                         AUX
						JOIN  REM01.ACT_ACTIVO                                                      ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						 AND  INMU_DORMITORIOS + (CASE WHEN (NVL(XTR_CUARTOESTAR, 0) > 0) AND (XTR_SALONCOMEDOR > 0) THEN TO_NUMBER(XTR_CUARTOESTAR) ELSE 0 END) > 0
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL                                          ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						JOIN  REM01.DD_TPH_TIPO_HABITACULO                                          TPH
						  ON  TPH.DD_TPH_CODIGO = ''01''
						LEFT JOIN  REM01.ACT_DIS_DISTRIBUCION                                       DIS
						  ON  DIS.ICO_ID = ICO.ICO_ID
				) AUXILIAR
				ON (AUXILIAR.DIS_ID = DIS.DIS_ID)
				WHEN MATCHED THEN
				UPDATE SET
						DIS.DIS_NUM_PLANTA = 0
					  , DIS.DD_TPH_ID = (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''01'')
					  , DIS.DIS_CANTIDAD = INMU_DORMITORIOS + (CASE WHEN (NVL(XTR_CUARTOESTAR, 0) > 0) AND (XTR_SALONCOMEDOR > 0) THEN TO_NUMBER(XTR_CUARTOESTAR) ELSE 0 END)
					  , DIS.DIS_SUPERFICIE = NVL(IDI_DORMPRINM2,0) + NVL(IDI_DORM2M2,0) + NVL(IDI_DORM3M2,0) + NVL(IDI_DORM4M2,0) + NVL(IDI_DORM5M2,0)  
					  , DIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
					  , DIS.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT 
				(
						DIS_ID,
						ICO_ID,
						DIS_NUM_PLANTA,
						DD_TPH_ID,
						DIS_CANTIDAD,
						DIS_SUPERFICIE,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_DIS_DISTRIBUCION.NEXTVAL  
						, AUXILIAR.ICO_ID
						, 0 
						, (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''01'')
						, INMU_DORMITORIOS + (CASE WHEN (NVL(XTR_CUARTOESTAR, 0) > 0) AND (XTR_SALONCOMEDOR > 0) THEN TO_NUMBER(XTR_CUARTOESTAR) ELSE 0 END)
						, NVL(IDI_DORMPRINM2,0) + NVL(IDI_DORM2M2,0) + NVL(IDI_DORM3M2,0) + NVL(IDI_DORM4M2,0) + NVL(IDI_DORM5M2,0)  
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_DIS_DISTRIBUCION --> (DORMITORIOS) '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_DIS_DISTRIBUCION --> (GARAGE '12')
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_DIS_DISTRIBUCION DIS
				USING
				(
						SELECT	DIS.DIS_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES                                         AUX
						JOIN  REM01.ACT_ACTIVO                                                      ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						 AND  INMU_GARAJE IS NOT NULL AND INMU_GARAJE NOT IN (''No dispone'')
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL                                          ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						JOIN  REM01.DD_TPH_TIPO_HABITACULO                                          TPH
						  ON  TPH.DD_TPH_CODIGO = ''12''
						LEFT JOIN  REM01.ACT_DIS_DISTRIBUCION                                       DIS
						  ON  DIS.ICO_ID = ICO.ICO_ID
				) AUXILIAR
				ON (AUXILIAR.DIS_ID = DIS.DIS_ID)
				WHEN MATCHED THEN
				UPDATE SET
						DIS.DIS_NUM_PLANTA = 0
					  , DIS.DD_TPH_ID = (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''12'')
					  , DIS.DIS_CANTIDAD = 1
					  , DIS.DIS_SUPERFICIE = 0
					  , DIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
					  , DIS.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT 
				(
						DIS_ID,
						ICO_ID,
						DIS_NUM_PLANTA,
						DD_TPH_ID,
						DIS_CANTIDAD,
						DIS_SUPERFICIE,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_DIS_DISTRIBUCION.NEXTVAL  
						, AUXILIAR.ICO_ID
						, 0 
						, (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''12'')
						, 1
						, 0  
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_DIS_DISTRIBUCION --> (GARAGES) '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_DIS_DISTRIBUCION --> (TERRAZA '15')
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_DIS_DISTRIBUCION DIS
				USING
				(
						SELECT	DIS.DIS_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES                                         AUX
						JOIN  REM01.ACT_ACTIVO                                                      ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						 AND  (INMU_TERRAZA + NVL(XTR_TIENETERRAZA, 0)) > 0
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL                                          ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						JOIN  REM01.DD_TPH_TIPO_HABITACULO                                          TPH
						  ON  TPH.DD_TPH_CODIGO = ''15''
						LEFT JOIN  REM01.ACT_DIS_DISTRIBUCION                                       DIS
						  ON  DIS.ICO_ID = ICO.ICO_ID
				) AUXILIAR
				ON (AUXILIAR.DIS_ID = DIS.DIS_ID)
				WHEN MATCHED THEN
				UPDATE SET
						DIS.DIS_NUM_PLANTA = 0
					  , DIS.DD_TPH_ID = (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''15'')
					  , DIS.DIS_CANTIDAD = CASE WHEN INMU_TERRAZA = 0 THEN ''1'' ELSE INMU_TERRAZA END
					  , DIS.DIS_SUPERFICIE = IDI_TERRAZA2M2
					  , DIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
					  , DIS.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT 
				(
						DIS_ID,
						ICO_ID,
						DIS_NUM_PLANTA,
						DD_TPH_ID,
						DIS_CANTIDAD,
						DIS_SUPERFICIE,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_DIS_DISTRIBUCION.NEXTVAL  
						, AUXILIAR.ICO_ID
						, 0 
						, (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''15'')
						, CASE WHEN INMU_TERRAZA = 0 THEN ''1'' ELSE INMU_TERRAZA END
						, IDI_TERRAZA2M2  
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_DIS_DISTRIBUCION --> (TERRAZAS) '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_DIS_DISTRIBUCION --> (BAÑOS '02')
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_DIS_DISTRIBUCION DIS
				USING
				(
						SELECT	DIS.DIS_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES                                         AUX
						JOIN  REM01.ACT_ACTIVO                                                      ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						 AND  INMU_BANIOS > 0
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL                                          ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						JOIN  REM01.DD_TPH_TIPO_HABITACULO                                          TPH
						  ON  TPH.DD_TPH_CODIGO = ''02''
						LEFT JOIN  REM01.ACT_DIS_DISTRIBUCION                                       DIS
						  ON  DIS.ICO_ID = ICO.ICO_ID
				) AUXILIAR
				ON (AUXILIAR.DIS_ID = DIS.DIS_ID)
				WHEN MATCHED THEN
				UPDATE SET
						DIS.DIS_NUM_PLANTA = 0
					  , DIS.DD_TPH_ID = (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''02'')
					  , DIS.DIS_CANTIDAD = INMU_BANIOS
					  , DIS.DIS_SUPERFICIE = 0
					  , DIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
					  , DIS.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT 
				(
						DIS_ID,
						ICO_ID,
						DIS_NUM_PLANTA,
						DD_TPH_ID,
						DIS_CANTIDAD,
						DIS_SUPERFICIE,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_DIS_DISTRIBUCION.NEXTVAL  
						, AUXILIAR.ICO_ID
						, 0 
						, (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''02'')
						, INMU_BANIOS
						, 0  
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_DIS_DISTRIBUCION --> (BAÑOS) '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	

	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_DIS_DISTRIBUCION --> (ASEOS '04')
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_DIS_DISTRIBUCION DIS
				USING
				(
						SELECT	DIS.DIS_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES                                         AUX
						JOIN  REM01.ACT_ACTIVO                                                      ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						 AND  INMU_ASEOS > 0
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL                                          ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						JOIN  REM01.DD_TPH_TIPO_HABITACULO                                          TPH
						  ON  TPH.DD_TPH_CODIGO = ''04''
						LEFT JOIN  REM01.ACT_DIS_DISTRIBUCION                                       DIS
						  ON  DIS.ICO_ID = ICO.ICO_ID
				) AUXILIAR
				ON (AUXILIAR.DIS_ID = DIS.DIS_ID)
				WHEN MATCHED THEN
				UPDATE SET
						DIS.DIS_NUM_PLANTA = 0
					  , DIS.DD_TPH_ID = (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''04'')
					  , DIS.DIS_CANTIDAD = INMU_ASEOS
					  , DIS.DIS_SUPERFICIE = 0
					  , DIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
					  , DIS.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT 
				(
						DIS_ID,
						ICO_ID,
						DIS_NUM_PLANTA,
						DD_TPH_ID,
						DIS_CANTIDAD,
						DIS_SUPERFICIE,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_DIS_DISTRIBUCION.NEXTVAL  
						, AUXILIAR.ICO_ID
						, 0 
						, (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''04'')
						, INMU_ASEOS
						, 0  
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_DIS_DISTRIBUCION --> (ASEOS) '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_DIS_DISTRIBUCION --> (ASEOS '04')
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_DIS_DISTRIBUCION DIS
				USING
				(
						SELECT	DIS.DIS_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES                                         AUX
						JOIN  REM01.ACT_ACTIVO                                                      ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						 AND  XTR_SALONCOMEDOR + (CASE WHEN (NVL(XTR_CUARTOESTAR, 0) > 0) AND (XTR_SALONCOMEDOR = 0 OR XTR_SALONCOMEDOR IS NULL) THEN TO_NUMBER(XTR_CUARTOESTAR) ELSE 0 END) > 0
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL                                          ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						JOIN  REM01.DD_TPH_TIPO_HABITACULO                                          TPH
						  ON  TPH.DD_TPH_CODIGO = ''03''
						LEFT JOIN  REM01.ACT_DIS_DISTRIBUCION                                       DIS
						  ON  DIS.ICO_ID = ICO.ICO_ID
				) AUXILIAR
				ON (AUXILIAR.DIS_ID = DIS.DIS_ID)
				WHEN MATCHED THEN
				UPDATE SET
						DIS.DIS_NUM_PLANTA = 0
					  , DIS.DD_TPH_ID = (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''03'')
					  , DIS.DIS_CANTIDAD = XTR_SALONCOMEDOR + (CASE WHEN (NVL(XTR_CUARTOESTAR, 0) > 0) AND (XTR_SALONCOMEDOR = 0 OR XTR_SALONCOMEDOR IS NULL) THEN TO_NUMBER(XTR_CUARTOESTAR) ELSE 0 END)
					  , DIS.DIS_SUPERFICIE = 0
					  , DIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
					  , DIS.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT 
				(
						DIS_ID,
						ICO_ID,
						DIS_NUM_PLANTA,
						DD_TPH_ID,
						DIS_CANTIDAD,
						DIS_SUPERFICIE,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_DIS_DISTRIBUCION.NEXTVAL  
						, AUXILIAR.ICO_ID
						, 0 
						, (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''03'')
						, XTR_SALONCOMEDOR + (CASE WHEN (NVL(XTR_CUARTOESTAR, 0) > 0) AND (XTR_SALONCOMEDOR = 0 OR XTR_SALONCOMEDOR IS NULL) THEN TO_NUMBER(XTR_CUARTOESTAR) ELSE 0 END)
						, 0  
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_DIS_DISTRIBUCION --> (SALONES) '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MERGE ACT_DIS_DISTRIBUCION --> (TRASTEROS '11')
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	V_MSQL :=  'MERGE INTO REM01.ACT_DIS_DISTRIBUCION DIS
				USING
				(
						SELECT	DIS.DIS_ID,
								ICO.ICO_ID,
								ACT.ACT_ID,
								AUX.*		
						FROM  REM01.MIG_AUX_DATOS_INMUEBLES                                         AUX
						JOIN  REM01.ACT_ACTIVO                                                      ACT
						  ON  ACT.ACT_NUM_ACTIVO_UVEM = LTRIM(AUX.REF_CLIENTE_AK,''0'') 
						 AND  REF_CLIENTE_AK IS NOT NULL 
						 AND  REF_CLIENTE_AK NOT IN (''NO TENEMOS'', 048721373500000387)
						 AND  ACT.ACT_ACTIVO_COOPER = 2
						 AND  IDI_TRASTEROM2 > 0
						JOIN  REM01.ACT_ICO_INFO_COMERCIAL                                          ICO
						  ON  ICO.ACT_ID = ACT.ACT_ID
						JOIN  REM01.DD_TPH_TIPO_HABITACULO                                          TPH
						  ON  TPH.DD_TPH_CODIGO = ''11''
						LEFT JOIN  REM01.ACT_DIS_DISTRIBUCION                                       DIS
						  ON  DIS.ICO_ID = ICO.ICO_ID
				) AUXILIAR
				ON (AUXILIAR.DIS_ID = DIS.DIS_ID)
				WHEN MATCHED THEN
				UPDATE SET
						DIS.DIS_NUM_PLANTA = 0
					  , DIS.DD_TPH_ID = (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''11'')
					  , DIS.DIS_CANTIDAD = 1
					  , DIS.DIS_SUPERFICIE = IDI_TRASTEROM2
					  , DIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
					  , DIS.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT 
				(
						DIS_ID,
						ICO_ID,
						DIS_NUM_PLANTA,
						DD_TPH_ID,
						DIS_CANTIDAD,
						DIS_SUPERFICIE,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO
				)
				VALUES
				(
						  REM01.S_ACT_DIS_DISTRIBUCION.NEXTVAL  
						, AUXILIAR.ICO_ID
						, 0 
						, (SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''11'')
						, 1
						, IDI_TRASTEROM2  
						, 0                                                                                                   
						, '''||V_USUARIO||'''                                                                   
						, SYSDATE                                                                                     
						, 0
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Merge ACT_DIS_DISTRIBUCION --> (TRASTEROS) '||SQL%ROWCOUNT||' Filas actualizadas/insertadas.');
	

	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--ESTADÍSTICAS - Pasamos estadísticas a todas las tablas que hemos mergeado
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL := ' BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TMP_TIPO_DATA(1)||'''); END;';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Pasamos estadísticas a la tabla '||V_TMP_TIPO_DATA(1)||' correctamente.'); 
		
	END LOOP;



	COMMIT;
	--ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;          
END;
/
EXIT
