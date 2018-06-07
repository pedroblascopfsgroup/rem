--/*
--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20180605
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-4074
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

create or replace PROCEDURE SP_MOTIVO_OCULTACION_AGR (nAGR_ID IN NUMBER
												    , pTIPO IN VARCHAR2 /*ALQUILER/VENTA*/
                                                    , pOCULTAR OUT NUMBER
                                                    , pMOTIVO OUT VARCHAR2) IS

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.

    V_MSQL VARCHAR2(20000 CHAR); -- Sentencia a ejecutar 
    vWHERE VARCHAR2(4000 CHAR);
    nORDEN NUMBER;
    vQUERY            VARCHAR2(4000 CHAR);
  BEGIN
	    /*DBMS_OUTPUT.PUT_LINE('[INICIO]');*/
      
      pOCULTAR := 0; 
      pMOTIVO  := 0;

	  vQUERY := ' (SELECT 1
				   FROM  '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
				   JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
				   JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 AND TAG.DD_TAG_CODIGO = ''02''	/*Restringida*/ 
					   AND (AGR.AGR_FIN_VIGENCIA IS NULL OR TRUNC(AGR.AGR_FIN_VIGENCIA) >= TRUNC(SYSDATE))
				  WHERE AGA.ACT_ID = ACT.ACT_ID 
					AND AGA.BORRADO = 0
					AND AGR.AGR_ID = '||nAGR_ID||'
			      )';

      V_MSQL := '
            SELECT DISTINCT OCULTO, DD_MTO_CODIGO
              FROM (
                  SELECT OCULTO, DD_MTO_CODIGO, ROW_NUMBER () OVER (PARTITION BY ACT_ID ORDER BY ORDEN ASC) ROWNUMBER
                    FROM(
                          SELECT ACT.ACT_ID
                               /*, DECODE(SCM.DD_SCM_CODIGO,''05'',1,0)OCULTO*/ /*Vendido*/
                               , 1 OCULTO /*Vendido*/
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                                    JOIN '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''05'' AND SCM.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''13'' AND MTO.BORRADO = 0 /*Vendido*/
                                   WHERE ACT.BORRADO = 0   
                                     AND EXISTS '||vQUERY||                      
                         ' UNION
                          SELECT ACT.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''08'' AND MTO.BORRADO = 0 /*Salida Perímetro*/
                                   WHERE ACT.BORRADO = 0
                                     AND ACT.PAC_INCLUIDO = 0
                                     AND EXISTS '||vQUERY||
                         ' UNION
                          SELECT ACT.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO ACT
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''05'' AND MTO.BORRADO = 0 /*No adecuado*/
                                   WHERE (ACT.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
                                                             FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA 
                                                            WHERE DDADA.BORRADO = 0
                                                              AND DDADA.DD_ADA_CODIGO = ''02''
                                                           )
                                          OR ACT.DD_ADA_ID IS NULL)
                                     AND ACT.BORRADO = 0
                                     AND ACT.CHECK_HPM = 1
                                     AND ''A'' = '''||pTIPO||''' 
                                     AND EXISTS '||vQUERY||                                                                
                         ' UNION
                          SELECT ACT.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''01'' AND MTO.BORRADO = 0 /*No Publicable*/
                                   WHERE ACT.BORRADO = 0
                                     AND ACT.PAC_CHECK_PUBLICAR = 0
                                     AND EXISTS '||vQUERY||                                    
                         ' UNION
                          SELECT ACT.ACT_ID
                               /*, DECODE(SCM.DD_SCM_CODIGO,''01'',1,0)OCULTO*/ /*No comercializable*/
                               , 1 OCULTO /*No comercializable*/
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                                    JOIN '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''01'' AND SCM.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''02'' AND MTO.BORRADO = 0 /*No Comercializable*/
                                   WHERE ACT.BORRADO = 0
                                     AND EXISTS '||vQUERY|| 
                         ' UNION
                          SELECT ACT.ACT_ID
                               /*, DECODE(SCM.DD_SCM_CODIGO,''04'',1,0)OCULTO*/ /*Reservado*/
                               , 1 OCULTO /*Reservado*/
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                                    JOIN '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''04'' AND SCM.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''07'' AND MTO.BORRADO = 0 /*Reservado*/
                                   WHERE ACT.BORRADO = 0
                                     AND EXISTS '||vQUERY||
                         ' UNION
                          SELECT ACT.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                                    JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID AND SPS.BORRADO = 0
                                    JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = ACT.DD_TCO_ID 
                                          AND DDTCO.DD_TCO_CODIGO IN (''02'',''03'',''04'') 
                                          AND DDTCO.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''03'' AND MTO.BORRADO = 0 /*Alquilado*/
                                   WHERE ACT.BORRADO = 0.
                                     AND SPS.SPS_OCUPADO = 1 
                                     AND SPS.SPS_CON_TITULO = 1 
                                     AND ((TRUNC(SPS.SPS_FECHA_TITULO) <= TRUNC(SYSDATE) AND TRUNC(SPS.SPS_FECHA_VENC_TITULO) >= TRUNC(sysdate)) OR (TRUNC(SPS.SPS_FECHA_TITULO) <= TRUNC(SYSDATE) AND SPS.SPS_FECHA_VENC_TITULO IS NULL))
                                     AND EXISTS '||vQUERY||                                                  
                         ' UNION
                          SELECT ACT.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                                    JOIN '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD V ON V.ACT_ID = ACT.ACT_ID AND V.ES_CONDICIONADO = 0
                                    JOIN '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI_AGR EST ON EST.AGR_ID = '||nAGR_ID||' AND EST.INFORME_COMERCIAL = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''06'' AND MTO.BORRADO = 0 /*Revisión Publicación*/
                                   WHERE ACT.BORRADO = 0.
                                     AND ACT.ES_CONDICONADO_ANTERIOR = 1 
                                     AND EXISTS '||vQUERY||                                        
                         ' UNION                                     
                          SELECT ACT.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                                    JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = ACT.DD_TCO_ID 
                                          AND DDTCO.DD_TCO_CODIGO IN (''02'',''03'',''04'') 
                                          AND DDTCO.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''14'' AND MTO.BORRADO = 0 /*Precio*/
                                   WHERE ACT.BORRADO = 0
                                     AND ACT.APU_CHECK_PUB_SIN_PRECIO_A = 0
                                     AND NOT EXISTS (SELECT 1 
                                                      FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL
                                                      JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 AND TPC.DD_TPC_CODIGO = ''03''/*Aprobado de renta (web)*/
                                                     WHERE VAL.BORRADO = 0
                                                       AND VAL.ACT_ID = ACT.ACT_ID)                                     
                                     AND ''A'' = '''||pTIPO||'''
                                     AND EXISTS '||vQUERY||                                      
                         ' UNION                                     
                          SELECT ACT.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                                    JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = ACT.DD_TCO_ID 
                                          AND DDTCO.DD_TCO_CODIGO IN (''01'',''02'') 
                                          AND DDTCO.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''14'' AND MTO.BORRADO = 0 /*Precio*/
                                   WHERE ACT.BORRADO = 0
                                     AND ACT.APU_CHECK_PUB_SIN_PRECIO_V = 0
                                     AND NOT EXISTS (SELECT 1 
                                                      FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL
                                                      JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 AND TPC.DD_TPC_CODIGO = ''02''/*Aprobado de venta (web)*/
                                                     WHERE VAL.BORRADO = 0
                                                       AND VAL.ACT_ID = ACT.ACT_ID)                                       
                                     AND ''V'' = '''||pTIPO||'''
                                     AND EXISTS '||vQUERY||                                   
                         ' UNION                                     
                          SELECT SPS.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                                    JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID 
                                         AND SPS.BORRADO = 0
                                         AND ACT.DD_EPA_ID = (SELECT DDEPA.DD_EPA_ID 
                                                                FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER DDEPA 
                                                               WHERE DDEPA.BORRADO = 0
                                                                 AND DDEPA.DD_EPA_CODIGO = ''04'')/*Oculto Alquiler*/
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''04'' AND MTO.BORRADO = 0 /*Revisión adecuación*/
                                   WHERE ACT.BORRADO = 0
									 AND ''A'' = '''||pTIPO||'''
                                     AND ((EXISTS (SELECT 1 
                                                     FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO2 
                                                    WHERE MTO2.DD_MTO_CODIGO = ''03'' /*Alquilado*/
                                                      AND MTO2.BORRADO = 0
                                                      AND MTO2.DD_MTO_ID = ACT.DD_MTO_A_ID) 
                                         AND (SPS.SPS_OCUPADO = 0
                                           OR SPS.SPS_CON_TITULO = 0
                                           OR SPS.SPS_FECHA_VENC_TITULO <= sysdate)
                                          ) 
                                     OR (EXISTS (SELECT 1
                                                   FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO2
                                                  WHERE MTO2.DD_MTO_CODIGO = ''04'' /*Revisión adecuación*/
                                                    AND MTO2.BORRADO = 0
                                                    AND MTO2.DD_MTO_ID = ACT.DD_MTO_A_ID)
                                         AND EXISTS (SELECT 1
                                                       FROM '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO PTA
                                                      WHERE (PTA.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
                                                                               FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA 
                                                                              WHERE DDADA.BORRADO = 0
                                                                                AND DDADA.DD_ADA_CODIGO = ''02''
                                                                             )
                                                          OR PTA.DD_ADA_ID IS NULL)
                                                        AND PTA.BORRADO = 0
                                                        AND PTA.CHECK_HPM = 1
                                                        AND PTA.ACT_ID = ACT.ACT_ID)
                                          ))   
                                     AND EXISTS '||vQUERY||                                       
                       ')
                    )AUX WHERE AUX.ROWNUMBER = 1
                 '
       ;
      
      BEGIN
        EXECUTE IMMEDIATE V_MSQL INTO pOCULTAR, pMOTIVO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          pOCULTAR := 0; 
          pMOTIVO  := 0;          
      END;

	  /*DBMS_OUTPUT.PUT_LINE('[FIN]');*/

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

	END SP_MOTIVO_OCULTACION_AGR;
/

EXIT;
