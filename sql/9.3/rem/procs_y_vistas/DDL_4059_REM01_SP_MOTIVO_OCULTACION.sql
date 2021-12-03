--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211202
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-10864
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Versión con ofertas express
--##		0.3 Modificaciones motivo "No adecuado" y "Revisión publicación"
--##		0.4 Optimización de tiempos
--##		0.5 HREOS-5562, Ocultación Automática, motivo "Revisión publicación", eliminar el join con la tabla TMP_PUBL_ACT
--##		0.6 REMVIP-4301 - Cambios ocultación Revisión publicación
--##		0.7 REMVIP-4622 - Ocultación alquilado
--##		0.8 HREOS-9509 - Ocultacion Adecuacion DD_ADA 05
--##		0.9 REMVIP-6642 - Ocultacion Adecuacion DD_ADA 06
--##    0.10 REMVIP-10864 - Nuevo motivo ocultacion "Oferta aprobada" caixa, si ha pasado las tareas ''T017_ResolucionCES'',''T015_ElevarASancion''
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

create or replace PROCEDURE SP_MOTIVO_OCULTACION (pACT_ID IN NUMBER
												, pTIPO IN VARCHAR2 /*ALQUILER/VENTA*/
                                                , pOCULTAR OUT NUMBER
                                                , pMOTIVO OUT VARCHAR2) IS

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
    vWHERE VARCHAR2(4000 CHAR);
    nORDEN NUMBER;
    
    
  BEGIN
	    /*DBMS_OUTPUT.PUT_LINE('[INICIO]');*/
      
      pOCULTAR := 0;  
      pMOTIVO  := 0;


      V_MSQL := '
            SELECT OCULTO, DD_MTO_CODIGO
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
                                     AND ACT.ACT_ID= '||pACT_ID||                               
                         ' UNION
                          SELECT PAC.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''08'' AND MTO.BORRADO = 0 /*Salida Perímetro*/
                                   WHERE PAC.BORRADO = 0
                                     AND PAC.PAC_INCLUIDO = 0
                                     AND PAC.ACT_ID= '||pACT_ID||
                         ' UNION
                          SELECT PTA.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO PTA
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''05'' AND MTO.BORRADO = 0 /*No adecuado*/
                                   WHERE (PTA.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
								                             FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA
								                            WHERE DDADA.BORRADO = 0
								                              AND DDADA.DD_ADA_CODIGO = ''02''
								                           )
								          OR PTA.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
								                             FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA
								                            WHERE DDADA.BORRADO = 0
								                              AND DDADA.DD_ADA_CODIGO = ''04''
								                           )
								          OR PTA.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
								                             FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA
								                            WHERE DDADA.BORRADO = 0
								                              AND DDADA.DD_ADA_CODIGO = ''05''
								                           )
								          OR PTA.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
								                             FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA
								                            WHERE DDADA.BORRADO = 0
								                              AND DDADA.DD_ADA_CODIGO = ''06''
								                           )
								          OR PTA.DD_ADA_ID IS NULL)
								          AND (PTA.DD_ADA_ID_ANTERIOR = (SELECT DDADA.DD_ADA_ID
								                             FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA
								                            WHERE DDADA.BORRADO = 0
								                              AND DDADA.DD_ADA_CODIGO = ''01''
								                           )
								          OR PTA.DD_ADA_ID_ANTERIOR = (SELECT DDADA.DD_ADA_ID
								                             FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA
								                            WHERE DDADA.BORRADO = 0
								                              AND DDADA.DD_ADA_CODIGO = ''03''
								                           )
								         )
                                     AND PTA.BORRADO = 0
                                     AND PTA.CHECK_HPM = 1
                                     AND ''A'' = '''||pTIPO||'''
                                     AND PTA.ACT_ID= '||pACT_ID||                                                                  
                         ' UNION
                          SELECT ACT.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT
                                    LEFT JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
                                    LEFT JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''01'' AND MTO.BORRADO = 0 /*NO publicable*/
                                    WHERE ACT.BORRADO = 0 
										AND (ACT.PAC_CHECK_PUBLICAR = 0
                                        	OR (TAG.DD_TAG_CODIGO = ''13'' AND AGR.AGR_FIN_VIGENCIA < SYSDATE AND AGR.AGR_FECHA_BAJA IS NULL))
                                        AND ACT.ACT_ID = '||pACT_ID||
                         ' UNION
                          SELECT ACT.ACT_ID
                               /*, DECODE(SCM.DD_SCM_CODIGO,''01'',1,0)OCULTO*/ /*No comercializable*/
                               , 1 OCULTO /*No comercializable*/
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                                    JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''02'' AND MTO.BORRADO = 0 /*No Comercializable*/
                                   WHERE ACT.BORRADO = 0
									 AND PAC.PAC_CHECK_COMERCIALIZAR = 0
                                     AND ACT.ACT_ID= '||pACT_ID||    
                         ' UNION
                          SELECT ACT.ACT_ID
                               /*, DECODE(SCM.DD_SCM_CODIGO,''04'',1,0)OCULTO*/ /*Reservado*/
                               , 1 OCULTO /*Reservado*/
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                                    JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
									JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID
									JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
									JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID AND RES.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''07'' AND MTO.BORRADO = 0 /*Reservado*/
                                   WHERE ACT.BORRADO = 0
									 AND RES.DD_ERE_ID = (SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = ''02'')
									 AND ECO.DD_EEC_ID <> (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''02'')
									 AND OFR.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''01'')
                                     AND ACT.ACT_ID= '||pACT_ID||
                         ' UNION
                          SELECT DISTINCT ACT.ACT_ID
                               , 1 OCULTO /*Aprobado*/
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                                    JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
									                  JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID
                                    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''18'' AND MTO.BORRADO = 0 /*Aprobado*/
                                    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
                                    JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID=ECO.TBJ_ID AND TBJ.BORRADO = 0
                                    JOIN '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID=TBJ.DD_TTR_ID AND TTR.BORRADO=0
                                    JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID=ECO.TBJ_ID AND TRA.BORRADO = 0
                                    JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID=TRA.TRA_ID
                                    JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID=TAC.TAR_ID
                                    JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID=TAR.TAR_ID
                                    JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID=TEX.TAP_ID AND TAP.BORRADO = 0
                                    JOIN '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR TEV ON TEV.TEX_ID=TEX.TEX_ID AND TEV.BORRADO = 0
                                    WHERE ACT.BORRADO = 0 AND OFR.BORRADO = 0 AND CRA.DD_CRA_CODIGO=''03'' AND TTR.DD_TTR_CODIGO=''06'' AND TAP.TAP_CODIGO IN (''T017_ResolucionCES'',''T015_ElevarASancion'')
                                    AND (TAR.TAR_TAREA_FINALIZADA=1 OR (TAR.BORRADO = 1 AND TAC.BORRADO = 1))
                                    AND (TEV.TEV_NOMBRE = ''comboResolucion'' AND TEV.TEV_VALOR=''01'' OR (TEV.TEV_NOMBRE=''resolucionOferta'' AND TEV.TEV_VALOR=''01''))
                                    AND ACT.ACT_ID ='||pACT_ID||'
                            UNION
                          SELECT APU.ACT_ID
                              , 1 OCULTO
                              , MTO.DD_MTO_CODIGO
                              , MTO.DD_MTO_ORDEN ORDEN
                                   FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                                   JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = APU.ACT_ID AND SPS.BORRADO = 0
                                   JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID
                                   LEFT JOIN '|| V_ESQUEMA ||'.DD_TAL_TIPO_ALQUILER TAL ON TAL.DD_TAL_ID = ACT.DD_TAL_ID
                                   JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = APU.DD_TCO_ID
                                         AND DDTCO.DD_TCO_CODIGO IN (''02'',''03'',''04'')
                                         AND DDTCO.BORRADO = 0
                                   LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''03'' AND MTO.BORRADO = 0 /*Alquilado*/
                                  WHERE APU.BORRADO = 0.
                                    AND SPS.SPS_OCUPADO = 1
                                    AND SPS.DD_TPA_ID = (SELECT DD_TPA_ID FROM DD_TPA_TIPO_TITULO_ACT WHERE DD_TPA_CODIGO = ''01'')                                 
                                    AND (''A'' = '''||pTIPO||''' OR (''V'' = '''||pTIPO||''' AND TAL.DD_TAL_CODIGO <> ''01''))
                                    AND SPS.ACT_ID= '||pACT_ID||         
                         ' UNION
                          SELECT APU.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
									JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID
                                    JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND DD_CRA_CODIGO <> ''02'' AND DD_CRA_CODIGO <> ''08''
                                    JOIN '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI EST ON EST.ACT_ID = APU.ACT_ID AND EST.INFORME_COMERCIAL = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''06'' AND MTO.BORRADO = 0 /*Revisión Publicación*/
                                   WHERE APU.BORRADO = 0.
                                     AND ((APU.ES_CONDICONADO_ANTERIOR = 1 AND EST.ES_CONDICIONADO_PUBLI = 0)
                                        OR (APU.ES_CONDICONADO_ANTERIOR = 1 AND EST.ES_CONDICIONADO_PUBLI = 1
                                            AND (MTO.DD_MTO_ID = APU.DD_MTO_V_ID OR MTO.DD_MTO_ID = APU.DD_MTO_A_ID)))
                                     AND APU.ACT_ID= '||pACT_ID||
                         ' UNION                                     
                          SELECT APU.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                                    JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = APU.DD_TCO_ID 
                                          AND DDTCO.DD_TCO_CODIGO IN (''02'',''03'',''04'') 
                                          AND DDTCO.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''14'' AND MTO.BORRADO = 0 /*Precio*/
                                   WHERE APU.BORRADO = 0
                                     AND APU.APU_CHECK_PUB_SIN_PRECIO_A = 0
                                     AND NOT EXISTS (SELECT 1 
                                                      FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL
                                                      JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 AND TPC.DD_TPC_CODIGO = ''03''/*Aprobado de renta (web)*/
                                                     WHERE VAL.BORRADO = 0
													   AND VAL.VAL_IMPORTE IS NOT NULL
                                                       AND VAL.ACT_ID = APU.ACT_ID)                                     
                                     AND ''A'' = '''||pTIPO||'''
                                     AND APU.ACT_ID= '||pACT_ID||                                         
                         ' UNION                                     
                          SELECT APU.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                                    JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = APU.DD_TCO_ID 
                                          AND DDTCO.DD_TCO_CODIGO IN (''01'',''02'') 
                                          AND DDTCO.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''14'' AND MTO.BORRADO = 0 /*Precio*/
                                   WHERE APU.BORRADO = 0
                                     AND APU.APU_CHECK_PUB_SIN_PRECIO_V = 0
                                     AND NOT EXISTS (SELECT 1 
                                                      FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL
                                                      JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 AND TPC.DD_TPC_CODIGO = ''02''/*Aprobado de venta (web)*/
                                                     WHERE VAL.BORRADO = 0
													   AND VAL.VAL_IMPORTE IS NOT NULL
                                                       AND VAL.ACT_ID = APU.ACT_ID)                                       
                                     AND ''V'' = '''||pTIPO||'''
                                     AND APU.ACT_ID= '||pACT_ID||                                           
                         ' UNION                                     
                          SELECT SPS.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                                    JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = APU.ACT_ID 
                                         AND SPS.BORRADO = 0
                                         AND APU.DD_EPA_ID = (SELECT DDEPA.DD_EPA_ID 
                                                                FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER DDEPA 
                                                               WHERE DDEPA.BORRADO = 0
                                                                 AND DDEPA.DD_EPA_CODIGO = ''04'')/*Oculto Alquiler*/
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''04'' AND MTO.BORRADO = 0 /*Revisión adecuación*/
                                   WHERE APU.BORRADO = 0
									 AND ''A'' = '''||pTIPO||'''
                                     AND ((EXISTS (SELECT 1 
                                                     FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO2 
                                                    WHERE MTO2.DD_MTO_CODIGO = ''03'' /*Alquilado*/
                                                      AND MTO2.BORRADO = 0
                                                      AND MTO2.DD_MTO_ID = APU.DD_MTO_A_ID) 
                                         AND (SPS.SPS_OCUPADO = 0
                                         OR SPS.DD_TPA_ID IN (SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_TITULO_ACT WHERE DD_TPA_CODIGO IN (''02'', ''03'')))
                                          ) 
                                     OR (EXISTS (SELECT 1
                                                   FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO2
                                                  WHERE MTO2.DD_MTO_CODIGO = ''04'' /*Revisión adecuación*/
                                                    AND MTO2.BORRADO = 0
                                                    AND MTO2.DD_MTO_ID = APU.DD_MTO_A_ID)
                                         AND EXISTS (SELECT 1
                                                       FROM '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO PTA
                                                      WHERE (PTA.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
                                                                               FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA 
                                                                              WHERE DDADA.BORRADO = 0
                                                                                AND DDADA.DD_ADA_CODIGO = ''02''
                                                                             )
                                                          OR PTA.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
                                                                               FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA 
                                                                              WHERE DDADA.BORRADO = 0
                                                                                AND DDADA.DD_ADA_CODIGO = ''05''
                                                                             )
                                                          OR PTA.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
                                                                               FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA 
                                                                              WHERE DDADA.BORRADO = 0
                                                                                AND DDADA.DD_ADA_CODIGO = ''06''
                                                                             )
                                                          OR PTA.DD_ADA_ID IS NULL)
                                                        AND PTA.BORRADO = 0
                                                        AND PTA.CHECK_HPM = 1
                                                        AND PTA.ACT_ID = APU.ACT_ID)
                                          ))   
                                     AND SPS.ACT_ID= '||pACT_ID||
                         ' UNION
                         SELECT ACT.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                                    JOIN '|| V_ESQUEMA ||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
                                    JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID AND OFR.OFR_OFERTA_EXPRESS = 1 AND OFR.BORRADO = 0
                                    JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.DD_EOF_CODIGO = ''01'' AND EOF.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''15'' AND MTO.BORRADO = 0 /*Oferta Express*/
                                   WHERE ACT.BORRADO = 0
                                     AND ACT.ACT_ID= '||pACT_ID||
                         'UNION
                         SELECT  ACT.ACT_ID
							, 1 OCULTO
							, MTO.DD_MTO_CODIGO
							, MTO.DD_MTO_ORDEN ORDEN
									FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT 
									JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.BORRADO = 0 AND AGA.AGA_PRINCIPAL = 1
									JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.AGR_FECHA_BAJA IS NULL AND AGR.BORRADO = 0 
									JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON  TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.DD_TAG_CODIGO = ''16''
									LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''17'' AND MTO.BORRADO = 0  /*Division en UAs*/
								   WHERE ACT.BORRADO = 0
									AND ''A'' = '''||pTIPO||'''
									AND ACT.ACT_ID= '||pACT_ID||
						' UNION
						SELECT ACT3.ACT_ID	
							,1 OCULTO
							, MTO.DD_MTO_CODIGO
							, MTO.DD_MTO_ORDEN ORDEN		
								FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT1
								JOIN  '|| V_ESQUEMA ||'.ACT_ACTIVO ACT3 on ACT3.ACT_ID = '||pACT_ID||'
								JOIN  '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA1 on ACT1.ACT_ID = AGA1.ACT_ID
								JOIN  '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO ACTPTA ON ACTPTA.ACT_ID = ACT1.ACT_ID
								JOIN  '|| V_ESQUEMA ||'.DD_EAL_ESTADO_ALQUILER EAL ON EAL.DD_EAL_ID = ACTPTA.DD_EAL_ID
								JOIN  '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL SCM ON ACT1.DD_SCM_ID = SCM.DD_SCM_ID
								LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''16'' AND MTO.BORRADO = 0  /*ActivoMatrizAlquilado*/
								WHERE AGA1.AGR_ID IN (
								    SELECT AGA2.AGR_ID FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA2 
								    	JOIN  '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA2.AGR_ID  AND AGR.BORRADO = 0
								    	JOIN  '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON  TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.DD_TAG_CODIGO = 16
								    	WHERE AGA2.ACT_ID = '||pACT_ID||'  AND AGA2.AGA_PRINCIPAL = 0
								    )
								AND AGA1.AGA_PRINCIPAL = 1
								AND ( EAL.DD_EAL_CODIGO <> ''01'' OR SCM.DD_SCM_CODIGO = ''10'')
								AND ''A'' = '''||pTIPO||'''
                       )
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

	EXCEPTION
	  WHEN OTHERS THEN
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
	    DBMS_OUTPUT.put_line(ERR_MSG);
	    ROLLBACK;
	    RAISE;

	END SP_MOTIVO_OCULTACION;
/

EXIT;
