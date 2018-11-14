--/*
--##########################################
--## AUTOR=JIN LI, HU
--## FECHA_CREACION=20181026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4525
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


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'AUX_MOT_OCULT_A';  -- Tabla a modificar  
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4525'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	
	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (OCULTO, DD_MTO_CODIGO, ACT_ID) (
	SELECT OCULTO, DD_MTO_CODIGO, ACT_ID
              FROM (
                  SELECT OCULTO, DD_MTO_CODIGO, ACT_ID, ROW_NUMBER () OVER (PARTITION BY ACT_ID ORDER BY ORDEN ASC) ROWNUMBER
                    FROM(
                          SELECT ACT.ACT_ID
                               /*, DECODE(SCM.DD_SCM_CODIGO,''05'',1,0)OCULTO*/ /*Vendido*/
                               , 1 OCULTO /*Vendido*/
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                                    JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''05'' AND SCM.BORRADO = 0
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''13'' AND MTO.BORRADO = 0 /*Vendido*/
                                   WHERE ACT.BORRADO = 0
                       
                          UNION
                          SELECT PAC.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''08'' AND MTO.BORRADO = 0 /*Salida Perímetro*/
                                   WHERE PAC.BORRADO = 0
                                     AND PAC.PAC_INCLUIDO = 0
                                
                          UNION
                          SELECT PTA.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''05'' AND MTO.BORRADO = 0 
                                   WHERE (PTA.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
                                                             FROM '||V_ESQUEMA||'.DD_ADA_ADECUACION_ALQUILER DDADA
                                                            WHERE DDADA.BORRADO = 0
                                                              AND DDADA.DD_ADA_CODIGO = ''02''
                                                           )
                                          OR PTA.DD_ADA_ID IS NULL)
                                     AND PTA.BORRADO = 0
                                     AND PTA.CHECK_HPM = 1
                              
                          UNION
                          SELECT PAC.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''01'' AND MTO.BORRADO = 0 /*No Publicable*/
                                   WHERE PAC.BORRADO = 0
                                     AND PAC.PAC_CHECK_PUBLICAR = 0
                                    
                          UNION
                          SELECT ACT.ACT_ID
                               /*, DECODE(SCM.DD_SCM_CODIGO,''01'',1,0)OCULTO*/ /*No comercializable*/
                               , 1 OCULTO /*No comercializable*/
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                                    JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''01'' AND SCM.BORRADO = 0
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''02'' AND MTO.BORRADO = 0 /*No Comercializable*/
                                   WHERE ACT.BORRADO = 0
                                    
                          UNION
                          SELECT ACT.ACT_ID
                               /*, DECODE(SCM.DD_SCM_CODIGO,''04'',1,0)OCULTO*/ /*Reservado*/
                               , 1 OCULTO /*Reservado*/
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                                    JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''04'' AND SCM.BORRADO = 0
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''07'' AND MTO.BORRADO = 0 /*Reservado*/
                                   WHERE ACT.BORRADO = 0
                                  
                          UNION
                          SELECT APU.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                                    JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = APU.ACT_ID AND SPS.BORRADO = 0
                                    JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = APU.DD_TCO_ID
                                          AND DDTCO.DD_TCO_CODIGO IN (''02'',''03'',''04'')
                                          AND DDTCO.BORRADO = 0
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''03'' AND MTO.BORRADO = 0 /*Alquilado*/
                                   WHERE APU.BORRADO = 0.
                                     AND SPS.SPS_OCUPADO = 1
                                     AND SPS.SPS_CON_TITULO = 1
                                     AND ((TRUNC(SPS.SPS_FECHA_TITULO) <= TRUNC(SYSDATE) AND TRUNC(SPS.SPS_FECHA_VENC_TITULO) >= TRUNC(sysdate)) OR (TRUNC(SPS.SPS_FECHA_TITULO) <= TRUNC(SYSDATE) AND SPS.SPS_FECHA_VENC_TITULO IS NULL))
                          UNION
                          SELECT APU.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                                    JOIN '||V_ESQUEMA||'.V_COND_DISPONIBILIDAD V ON V.ACT_ID = APU.ACT_ID AND V.ES_CONDICIONADO = 0
                                    JOIN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI EST ON EST.ACT_ID = APU.ACT_ID AND EST.INFORME_COMERCIAL = 0
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''06'' AND MTO.BORRADO = 0 /*Revisión Publicación*/
                                   WHERE APU.BORRADO = 0.
                                     AND APU.ES_CONDICONADO_ANTERIOR = 1
                           
                          UNION
                          SELECT APU.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                                    JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = APU.DD_TCO_ID
                                          AND DDTCO.DD_TCO_CODIGO IN (''02'',''03'',''04'')
                                          AND DDTCO.BORRADO = 0
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''14'' AND MTO.BORRADO = 0 
                                   WHERE APU.BORRADO = 0
                                     AND APU.APU_CHECK_PUB_SIN_PRECIO_A = 0
                                     AND NOT EXISTS (SELECT 1
                                                      FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
                                                      JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.BORRADO = 0 AND TPC.DD_TPC_CODIGO = ''03''
                                                     WHERE VAL.BORRADO = 0
                                                       AND VAL.ACT_ID = APU.ACT_ID)
                                                       
                          UNION
                          SELECT SPS.ACT_ID
                               , 1 OCULTO
                               , MTO.DD_MTO_CODIGO
                               , MTO.DD_MTO_ORDEN ORDEN
                                    FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                                    JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = APU.ACT_ID
                                         AND SPS.BORRADO = 0
                                         AND APU.DD_EPA_ID = (SELECT DDEPA.DD_EPA_ID
                                                                FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER DDEPA
                                                               WHERE DDEPA.BORRADO = 0
                                                                 AND DDEPA.DD_EPA_CODIGO = ''04'')
                                    LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''04'' AND MTO.BORRADO = 0 
                                   WHERE APU.BORRADO = 0
									
                                     AND ((EXISTS (SELECT 1
                                                     FROM '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO2
                                                    WHERE MTO2.DD_MTO_CODIGO = ''03'' 
                                                      AND MTO2.BORRADO = 0
                                                      AND MTO2.DD_MTO_ID = APU.DD_MTO_A_ID)
                                         AND (SPS.SPS_OCUPADO = 0
                                           OR SPS.SPS_CON_TITULO = 0
                                           OR SPS.SPS_FECHA_VENC_TITULO <= sysdate)
                                          )
                                     OR (EXISTS (SELECT 1
                                                   FROM '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO2
                                                  WHERE MTO2.DD_MTO_CODIGO = ''04'' 
                                                    AND MTO2.BORRADO = 0
                                                    AND MTO2.DD_MTO_ID = APU.DD_MTO_A_ID)
                                         AND EXISTS (SELECT 1
                                                       FROM '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA
                                                      WHERE (PTA.DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
                                                                               FROM '||V_ESQUEMA||'.DD_ADA_ADECUACION_ALQUILER DDADA
                                                                              WHERE DDADA.BORRADO = 0
                                                                                AND DDADA.DD_ADA_CODIGO = ''02''
                                                                             )
                                                          OR PTA.DD_ADA_ID IS NULL)
                                                        AND PTA.BORRADO = 0
                                                        AND PTA.CHECK_HPM = 1
                                                        AND PTA.ACT_ID = APU.ACT_ID)
                                          ))
                                
                       )
                    )AUX WHERE AUX.ROWNUMBER = 1
                 )';
	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS CORRECTAMENTE');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA AUX_MOT_OCULT_A ACTUALIZADA CORRECTAMENTE ');
   

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
