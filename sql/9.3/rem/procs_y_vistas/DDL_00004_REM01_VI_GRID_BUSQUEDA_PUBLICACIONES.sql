--/*
--##########################################
--## AUTOR=Juan Beltran
--## FECHA_CREACION=20210318
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10301
--## PRODUCTO=NO
--## 
--## Finalidad: Crear vista para rellenar el grid de la busqueda de publicaciones
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 [HREOS-10301] Versión inicial (Creación de la vista)
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE    
    ERR_NUM NUMBER; -- Numero de error
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR); 
    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_GRID_BUSQUEDA_PUBLICACIONES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_PUBLICACIONES...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_PUBLICACIONES';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_PUBLICACIONES... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_GRID_BUSQUEDA_PUBLICACIONES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_PUBLICACIONES...');
    EXECUTE IMMEDIATE 'DROP VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_PUBLICACIONES';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_PUBLICACIONES... borrada OK');
  END IF;

    
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_PUBLICACIONES...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_PUBLICACIONES 
	AS          
         SELECT
    		ACT.ACT_ID,
    		ACT.ACT_NUM_ACTIVO 												AS ACT_NUM_ACTIVO,
    		TPA.DD_TPA_CODIGO 													AS TIPO_ACTIVO_CODIGO,
    		TPA.DD_TPA_DESCRIPCION 											AS TIPO_ACTIVO_DESCRIPCION,
    		SAC.DD_SAC_CODIGO 													AS SUBTIPO_ACTIVO_CODIGO,
    		SAC.DD_SAC_DESCRIPCION 											AS SUBTIPO_ACTIVO_DESCRIPCION,
    		TVI.DD_TVI_DESCRIPCION || '' '' || LOC.BIE_LOC_NOMBRE_VIA || '' '' || LOC.BIE_LOC_NUMERO_DOMICILIO || '' '' || LOC.BIE_LOC_PUERTA	AS DIRECCION,
    		CRA.DD_CRA_CODIGO 													AS CARTERA_CODIGO,			
			SCR.DD_SCR_CODIGO 													AS SUBCARTERA_CODIGO,
			EPV.DD_EPV_CODIGO 													AS ESTADO_PUBLICACION_VENTA_CODIGO,
    		EPV.DD_EPV_DESCRIPCION											AS ESTADO_PUBLICACION_VENTA_DESCRIPCION,
			EPA.DD_EPA_CODIGO													AS ESTADO_PUBLICACION_ALQUILER_CODIGO, 
    		EPA.DD_EPA_DESCRIPCION											AS ESTADO_PUBLICACION_ALQUILER_DESCRIPCION,    
    		DECODE(TCO.DD_TCO_CODIGO,''01'',EPV.DD_EPV_DESCRIPCION,''03'',EPA.DD_EPA_DESCRIPCION,''02'',EPA.DD_EPA_DESCRIPCION||''/''||EPV.DD_EPV_DESCRIPCION)	AS ESTADO_PUBLICACION_DESCRIPCION,
			TCO.DD_TCO_CODIGO 													AS TIPO_COMERCIALIZACION_CODIGO,     		
			TCO.DD_TCO_DESCRIPCION 										AS TIPO_COMERCIALIZACION_DESCRIPCION,
    		ACT.ACT_ADMISION 														AS ADMISION,
    		ACT.ACT_GESTION 															AS GESTION,  
    		NVL2(ACT.ACT_FECHA_IND_PUBLICABLE, 1, 0)		AS PUBLICACION,
    		DECODE(TCO.DD_TCO_CODIGO,''01'',VAL_02.VAL_IMPORTE,''02'',VAL_02.VAL_IMPORTE,''03'',VAL_03.VAL_IMPORTE)		AS TAS_IMPORTE_TAS_FIN,
    		NVL2(VAL_02.VAL_IMPORTE,1,NVL2(VAL_03.VAL_IMPORTE,1,0))	AS PRECIO,    
			GPUBL.USU_USERNAME 												AS GPUBL_USU_USERNAME,
			FSP.DD_FSP_CODIGO 													AS FASE_PUBLICACION_CODIGO,
			FSP.DD_FSP_DESCRIPCION 											AS FASE_PUBLICACION_DESCRIPCION,
			SFP.DD_SFP_CODIGO 													AS SUBFASE_PUBLICACION_CODIGO,
			SFP.DD_SFP_DESCRIPCION 											AS SUBFASE_PUBLICACION_DESCRIPCION,	
			TAL.DD_TAL_DESCRIPCION 											AS TAL_DESCRIPCION,
			ACT_APU.APU_FECHA_INI_VENTA 								AS FECHA_VENTA,
			ACT_APU.APU_FECHA_INI_ALQUILER						AS FECHA_ALQUILER, 			
			ACT_APU.APU_CHECK_PUB_SIN_PRECIO_V				AS PUBLICAR_SIN_PRECIO_VENTA,
			ACT_APU.APU_CHECK_PUB_SIN_PRECIO_A				AS PUBLICAR_SIN_PRECIO_ALQUILER,
			MTOV.DD_MTO_CODIGO 												AS MOTIVO_OCULTACION_VENTA_CODIGO,
			MTOA.DD_MTO_CODIGO 												AS MOTIVO_OCULTACION_ALQUILER_CODIGO,
 			INFCOM.INFORME_COMERCIAL									AS INFORME_COMERCIAL,
            ADA.ADJUNTO_ACTIVO  												AS ADJUNTO_ACTIVO,
			ADEC.DD_ADA_CODIGO												AS ADECUACION_ALQUILER_CODIGO,
 			NVL2(VAL_03.VAL_IMPORTE,1,0)               					AS CON_PRECIO_ALQUILER            
    
  		FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
  			JOIN '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL SCM 						ON ACT.DD_SCM_ID = SCM.DD_SCM_ID AND SCM.DD_SCM_CODIGO IN (''02'',''03'',''04'',''06'',''07'',''08'',''09'')

    		LEFT JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC 					ON ACT.ACT_ID = PAC.ACT_ID 
    		LEFT JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT_APU 	ON ACT_APU.ACT_ID = ACT.ACT_ID 
    		LEFT JOIN '|| V_ESQUEMA ||'.ACT_HFP_HIST_FASES_PUB HFP 						ON HFP.ACT_ID = ACT.ACT_ID 
		    LEFT JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION LOC 										ON ACT.BIE_ID = LOC.BIE_ID 
		    LEFT JOIN '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO PTA 				ON PTA.ACT_ID= ACT.ACT_ID			   			
		  
		    LEFT JOIN '|| V_ESQUEMA_M ||'.DD_TVI_TIPO_VIA TVI 										ON LOC.DD_TVI_ID = TVI.DD_TVI_ID		    
			 
 			LEFT JOIN '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER ADEC 			ON ADEC.DD_ADA_ID=PTA.DD_ADA_ID
		    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER EPA				ON ACT_APU.DD_EPA_ID = EPA.DD_EPA_ID 
		    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV 					ON ACT_APU.DD_EPV_ID = EPV.DD_EPV_ID   
		    LEFT JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION TCO 			ON TCO.DD_TCO_ID = ACT_APU.DD_TCO_ID
		    LEFT JOIN '|| V_ESQUEMA ||'.DD_FSP_FASE_PUBLICACION FSP 						ON FSP.DD_FSP_ID = HFP.DD_FSP_ID
		    LEFT JOIN '|| V_ESQUEMA ||'.DD_SFP_SUBFASE_PUBLICACION SFP 				ON SFP.DD_SFP_ID = HFP.DD_SFP_ID
		    LEFT JOIN '|| V_ESQUEMA ||'.DD_TAL_TIPO_ALQUILER TAL 								ON TAL.DD_TAL_ID = ACT.DD_TAL_ID  
		    JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA 										ON CRA.DD_CRA_ID = ACT.DD_CRA_ID 
			JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR 									ON SCR.DD_SCR_ID = ACT.DD_SCR_ID 
		    JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO TPA 									ON TPA.DD_TPA_ID = ACT.DD_TPA_ID 
			JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO SAC 							ON SAC.DD_SAC_ID = ACT.DD_SAC_ID 
  			LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTOV 			ON MTOV.DD_MTO_ID = ACT_APU.DD_MTO_V_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTOA 			ON MTOA.DD_MTO_ID = ACT_APU.DD_MTO_A_ID

			LEFT JOIN (SELECT 1 INFORME_COMERCIAL, MIN(HIC.ACT_ID) ACT_ID 
									FROM '|| V_ESQUEMA ||'.ACT_HIC_EST_INF_COMER_HIST HIC
						          	  JOIN '|| V_ESQUEMA ||'.DD_AIC_ACCION_INF_COMERCIAL AIC ON HIC.DD_AIC_ID = AIC.DD_AIC_ID AND AIC.DD_AIC_CODIGO = ''02''                
						            GROUP BY HIC.ACT_ID, 1) INFCOM													ON INFCOM.ACT_ID = ACT.ACT_ID
       
            LEFT JOIN (SELECT 1 ADJUNTO_ACTIVO, MIN(ADA.ACT_ID) ACT_ID 
									FROM '|| V_ESQUEMA ||'.ACT_ADA_ADJUNTO_ACTIVO ADA
			                			JOIN '|| V_ESQUEMA ||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = ADA.DD_TPD_ID AND TPD.DD_TPD_CODIGO = ''11''        
			                		GROUP BY ADA.ACT_ID, 1) ADA 														ON ADA.ACT_ID=ACT.ACT_ID 
    
		    LEFT JOIN (SELECT GAC.ACT_ID, USU.USU_USERNAME
									FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU
										JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE ON GEE.USU_ID = USU.USU_ID AND GEE.BORRADO = 0
										JOIN '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GPUBL''
										JOIN '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
					                 WHERE USU.BORRADO = 0) GPUBL 												ON GPUBL.ACT_ID = ACT.ACT_ID    
		    
		    LEFT JOIN (SELECT VAL.ACT_ID, VAL.VAL_IMPORTE
								  	FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL
										JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''02''
					                WHERE VAL.BORRADO = 0) VAL_02 												ON VAL_02.ACT_ID = ACT.ACT_ID
		    
		    LEFT JOIN (SELECT VAL.ACT_ID, VAL.VAL_IMPORTE
								  	FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL
										JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''03''
									WHERE VAL.BORRADO = 0) VAL_03 												ON VAL_03.ACT_ID = ACT.ACT_ID         
		  
		  WHERE ACT.BORRADO = 0 
		  AND PAC.PAC_CHECK_COMERCIALIZAR = 1
		  AND PAC.BORRADO = 0 
		  AND HFP.HFP_FECHA_FIN IS NULL 
		  AND HFP.BORRADO = 0';
        
DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_PUBLICACIONES...Creada OK');
  
EXCEPTION
    WHEN OTHERS THEN
         ERR_NUM := SQLCODE;
         ERR_MSG := SQLERRM;

         DBMS_OUTPUT.PUT_LINE('KO no modificada');
         DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
         DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
         DBMS_OUTPUT.PUT_LINE(ERR_MSG);

         ROLLBACK;
         RAISE;   
		 
END;
/

EXIT;