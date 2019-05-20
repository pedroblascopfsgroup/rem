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
SET DEFINE OFF;

DECLARE
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'HREOS-5932-PUNTO2';
    V_MSQL VARCHAR2(4000 CHAR);
    V_MAX_PTO_ID NUMBER(16,0);
    V_EJE_ID NUMBER(16,0);
    V_COUNT NUMBER(16):= 0;
    V_COUNT2 NUMBER(16):= 0;
    
    
    CURSOR ACTIVOS_HISTORICO_APU IS  SELECT DISTINCT APU.ACT_ID FROM REM01.ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.USUARIOMODIFICAR = 'HREOS-5932-PUNTO2';
    									
    						
    FILA ACTIVOS_HISTORICO_APU%ROWTYPE;

BEGIN

  DBMS_OUTPUT.put_line('[INICIO] Ejecutando [PUNTO 2]  ...........');

/**************************	PUNTO 2	*********************************/

/**
2.1. Modificar su destino comercial a “Venta”
**/

		DBMS_OUTPUT.PUT_LINE('	[INFO] CAMBIA EL PERIMETRO DE ALQUILER A VENTA');
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						  DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''01'')
						, USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
						, USUARIOBORRAR = '''||V_USUARIOMODIFICAR||'''
						, FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO in (
							SELECT ACT.ACT_NUM_ACTIVO 
								FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
								INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO on ACT.DD_TCO_ID = TCO.DD_TCO_ID
								INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO <> ''05''
								INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS on ACT.ACT_ID = SPS.ACT_ID
								INNER JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON ACT.ACT_ID = PTA.ACT_ID AND PTA.CHECK_HPM = 0
							WHERE   TCO.DD_TCO_CODIGO <> ''03'' 
								AND SPS.SPS_OCUPADO = 1
								AND SPS.DD_TPA_ID = (SELECT TPA.DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_TITULO_ACT TPA WHERE TPA.DD_TPA_CODIGO = ''01'')
								AND ACT.ACT_NUM_ACTIVO NOT IN (SELECT ID_HAYA FROM '||V_ESQUEMA||'.AUX_HREOS_5932)
						)';
											
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
  		
  		DBMS_OUTPUT.put_line('	[INFO] SE INSERTA EL PERIMETRO EN LA TABLA AUX_HREOS_5932_PERIM ');
  		
  		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_HREOS_5932_PERIM  
						(SELECT 
							ACT_NUM_ACTIVO 
							FROM '||V_ESQUEMA||'.ACT_ACTIVO 
							WHERE USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''' AND BORRADO = 0
						)';
  		
  		EXECUTE IMMEDIATE V_MSQL;
  		
  		DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
  		 		  		
  		
/**
2.2. Marcarlos como “Ocupado NO”, “Con título Vacío” actualizando los discleimer correspondientes (cabecera del activo y publicación)
**/
		DBMS_OUTPUT.PUT_LINE('	[INFO] CAMBIA SITUACION POSESORIA');
		
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
2.3. Todo lo relacionado con publicación de alquiler de estos activos (si lo tiene) deja de visualizarse en REM y si están publicados se ocultan
**/

		DBMS_OUTPUT.PUT_LINE('	[INFO] CAMBIA SITUACION POSESORIA');
		
		V_MSQL := 'MERGE INTO ACT_APU_ACTIVO_PUBLICACION APU USING
						(SELECT ACT.ACT_ID FROM ACT_ACTIVO ACT WHERE ACT.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''') T2
					ON (APU.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN
					UPDATE SET 
						  APU.DD_EPA_ID = (SELECT EPA.DD_EPA_ID FROM DD_EPA_ESTADO_PUB_ALQUILER EPA WHERE EPA.DD_EPA_CODIGO = ''04'')
						, APU.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''01'')
						, APU.DD_MTO_A_ID = (SELECT MTO.DD_MTO_ID FROM DD_MTO_MOTIVOS_OCULTACION MTO WHERE MTO.DD_MTO_CODIGO = ''08'')
						, APU.APU_CHECK_PUBLICAR_A = 0
						, APU.APU_CHECK_OCULTAR_PRECIO_A = 1
						, APU.APU_CHECK_PUB_SIN_PRECIO_A = 0
						, APU.DD_TPU_A_ID = NULL
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
		
DBMS_OUTPUT.PUT_LINE('[FIN] Fin PUNTO 2');

COMMIT;
  

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
