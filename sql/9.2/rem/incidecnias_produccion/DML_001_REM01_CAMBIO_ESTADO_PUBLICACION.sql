--/*
--##########################################
--## AUTOR=JINLI, HU
--## FECHA_CREACION=20181005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4525
--## PRODUCTO=NO
--## Finalidad: 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial 
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    pACT_ID NUMBER(16):= NULL;
    pCondAlquiler VARCHAR2(50 CHAR):= 1;
    pUSUARIOMODIFICAR VARCHAR2(50 CHAR):= 'SP_CAMBIO_EST_PUB_AGR'; 
    pHISTORIFICAR VARCHAR2(50 CHAR):= 'N';

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(20000 CHAR); -- Sentencia a ejecutar 
    vWHERE VARCHAR2(4000 CHAR);

    nACT_ID           #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.ACT_ID%TYPE;
    vDD_TCO_CODIGO    #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.DD_TCO_CODIGO%TYPE;
    vCODIGO_ESTADO_A  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_A%TYPE;
    vDESC_ESTADO_A    #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.DESC_ESTADO_A%TYPE;
    vCHECK_PUBLICAR_A #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.CHECK_PUBLICAR_A%TYPE;
    vCHECK_OCULTAR_A  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_A%TYPE;
    vDD_MTO_CODIGO_A  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_A%TYPE;    
    vDD_MTO_MANUAL_A  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.DD_MTO_MANUAL_A%TYPE; 
    vCODIGO_ESTADO_V  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_V%TYPE;
    vDESC_ESTADO_V    #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.DESC_ESTADO_V%TYPE;
    vCHECK_PUBLICAR_V #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.CHECK_PUBLICAR_V%TYPE;
    vCHECK_OCULTAR_V  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_V%TYPE;
    vDD_MTO_CODIGO_V  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_V%TYPE;
    vDD_MTO_MANUAL_V  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.DD_MTO_MANUAL_V%TYPE; 
    vDD_TPU_CODIGO_A  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_A%TYPE;
    vDD_TPU_CODIGO_V  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_V%TYPE;
    vDD_TAL_CODIGO	  #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.DD_TAL_CODIGO%TYPE;	
    nADMISION         #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.ADMISION%TYPE;
    nGESTION          #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.GESTION%TYPE;
    nINFORME_COMERCIAL #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.INFORME_COMERCIAL%TYPE;
    nPRECIO_A         #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.PRECIO_A%TYPE;
    nPRECIO_V         #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.PRECIO_V%TYPE;
    nCEE_VIGENTE      #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.CEE_VIGENTE%TYPE;
    nADECUADO         #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.ADECUADO%TYPE;
    nES_CONDICONADO   #ESQUEMA#.AUX_CAMBIO_ESTADO_PUBLI.ES_CONDICONADO%TYPE;
    
    OutOCULTAR        #ESQUEMA#.ACT_APU_ACTIVO_PUBLICACION.APU_CHECK_OCULTAR_A%TYPE;
    OutMOTIVO         #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION.DD_MTO_CODIGO%TYPE;
    
    vACTUALIZADO      VARCHAR2(1 CHAR);
    vACTUALIZAR_COND  VARCHAR2(1 CHAR);
    vUSUARIOMODIFICAR VARCHAR2(50 CHAR);
    vCondAlquiler     VARCHAR2(1 CHAR);

    TYPE CurTyp IS REF CURSOR;
    v_cursor    CurTyp;
    
    nCONTADOR         NUMBER := 0;
    nCONTADORMax      NUMBER := 10000;
  PROCEDURE PLP$LIMPIAR_ALQUILER(nACT_ID NUMBER, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                  SET APU_MOT_OCULTACION_MANUAL_A = NULL
                    , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                    , FECHAMODIFICAR = SYSDATE
                WHERE ACT_ID = '||nACT_ID||'
                  AND BORRADO = 0
              ';

    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT > 0 THEN
      vACTUALIZADO := 'S';
    END IF;
  END;

  PROCEDURE PLP$LIMPIAR_VENTA(nACT_ID NUMBER, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                  SET APU_MOT_OCULTACION_MANUAL_V = NULL
                    , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                    , FECHAMODIFICAR = SYSDATE
                WHERE ACT_ID = '||nACT_ID||'
                  AND BORRADO = 0
              ';

    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT > 0 THEN
      vACTUALIZADO := 'S';
    END IF;
  END;
      
  PROCEDURE PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID NUMBER, pESTADO VARCHAR2, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                  SET DD_EPA_ID = (SELECT DD_EPA_ID
                                     FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                                    WHERE BORRADO = 0
                                      AND DD_EPA_CODIGO = '''||pESTADO||''')
                    , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                    , FECHAMODIFICAR = SYSDATE
                WHERE ACT_ID = '||nACT_ID||'
                  AND BORRADO = 0
              ';

    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT > 0 THEN
      vACTUALIZADO := 'S';
    END IF;
  END;

  PROCEDURE PLP$CAMBIO_ESTADO_VENTA(nACT_ID NUMBER, pESTADO VARCHAR2, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                  SET DD_EPV_ID = (SELECT DD_EPV_ID
                                     FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                                    WHERE BORRADO = 0
                                      AND DD_EPV_CODIGO = '''||pESTADO||''')
                    , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                    , FECHAMODIFICAR = SYSDATE
                WHERE ACT_ID = '||nACT_ID||'
                  AND BORRADO = 0
              ';

    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT > 0 THEN
      vACTUALIZADO := 'S';
    END IF;

  END;

  PROCEDURE PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID NUMBER
									, pTIPO VARCHAR2 /*ALQUILER/VENTA*/
									, pDD_TCO_CODIGO VARCHAR2, pOCULTAR NUMBER, pDD_MTO_CODIGO VARCHAR2, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
	IF pTIPO = 'A' THEN
		IF pDD_TCO_CODIGO IN ('02','03','04') THEN
		  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
						SET DD_MTO_A_ID = (SELECT DD_MTO_ID
											 FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
											WHERE BORRADO = 0
											  AND DD_MTO_CODIGO = '''||pDD_MTO_CODIGO||''')
						  , APU_CHECK_OCULTAR_A = '||pOCULTAR||'
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
						  , APU_MOT_OCULTACION_MANUAL_A = NULL
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
						AND (APU_CHECK_OCULTAR_A <> '||pOCULTAR||'
						  OR NVL(DD_MTO_A_ID,-1) <> (SELECT DD_MTO_ID
											  FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
											 WHERE BORRADO = 0
											   AND DD_MTO_CODIGO = '''||pDD_MTO_CODIGO||'''))
					'  
					;
		  
		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			vACTUALIZADO := 'S';
		  END IF;
		  
		  IF pDD_MTO_CODIGO = '01' THEN /*No Publicable*/
		    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						SET APU_MOT_OCULTACION_MANUAL_A = (SELECT PAC.PAC_MOTIVO_PUBLICAR
															 FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
															WHERE PAC.ACT_ID = ACT.ACT_ID
															  AND PAC.BORRADO = 0)
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
						  , APU_MOT_OCULTACION_MANUAL_V = NULL
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
					'  
					;

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
		    END IF;		  
		  END IF;
		  
		  IF pDD_MTO_CODIGO = '02' THEN /*No Comercializable*/
		    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						SET APU_MOT_OCULTACION_MANUAL_A = (SELECT PAC.PAC_MOT_EXCL_COMERCIALIZAR
															 FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
															WHERE PAC.ACT_ID = ACT.ACT_ID
															  AND PAC.BORRADO = 0)
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
					'  
					;

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
		    END IF;		  
		  END IF;
		  
		  IF pDD_MTO_CODIGO = '04' THEN /*Revisión adecuación*/
		    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO ACT
						SET ACT.DD_ADA_ID = (SELECT ADA.DD_ADA_ID
										    					 FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER ADA
												    			WHERE ADA.DD_ADA_CODIGO = ''02''/*NO*/
														    	  AND ADA.BORRADO = 0)
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
					'
					;

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
		    END IF;
		  END IF; 	
		  	  
		  IF pDD_MTO_CODIGO = '06' THEN /*Revisión Publicación*/
		    vACTUALIZAR_COND := 'N';
		  END IF; 
		  	  
		END IF;
	END IF;
	IF pTIPO = 'V' THEN
		IF pDD_TCO_CODIGO IN ('01','02') THEN
		  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
						SET DD_MTO_V_ID = (SELECT DD_MTO_ID
											 FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
											WHERE BORRADO = 0
											  AND DD_MTO_CODIGO = '''||pDD_MTO_CODIGO||''')
						  , APU_CHECK_OCULTAR_V = '||pOCULTAR||'
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
						AND (APU_CHECK_OCULTAR_V <> '||pOCULTAR||'
						  OR NVL(DD_MTO_V_ID,-1) <> (SELECT DD_MTO_ID
											  FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
											 WHERE BORRADO = 0
											   AND DD_MTO_CODIGO = '''||pDD_MTO_CODIGO||'''))
					'  
					;

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			vACTUALIZADO := 'S';
		  END IF;
		  
		  IF pDD_MTO_CODIGO = '01' THEN /*No Publicable*/
		    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						SET APU_MOT_OCULTACION_MANUAL_V = (SELECT PAC.PAC_MOTIVO_PUBLICAR
															 FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
															WHERE PAC.ACT_ID = ACT.ACT_ID
															  AND PAC.BORRADO = 0)
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
					'  
					;

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
		    END IF;		  
		  END IF;
		  
		  IF pDD_MTO_CODIGO = '02' THEN /*No Comercializable*/
		    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						SET APU_MOT_OCULTACION_MANUAL_V = (SELECT PAC.PAC_MOT_EXCL_COMERCIALIZAR
															 FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
															WHERE PAC.ACT_ID = ACT.ACT_ID
															  AND PAC.BORRADO = 0)
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
					'  
					;

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
		    END IF;		  
		  END IF;

		IF pDD_MTO_CODIGO IN ('04') THEN /*Revisión adecuación*/
		  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO PTA
						SET DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
											 FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA
											WHERE DDADA.BORRADO = 0
											  AND DDADA.DD_ADA_CODIGO = ''02'')
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
					  WHERE PTA.ACT_ID = '||nACT_ID||'
						AND PTA.BORRADO = 0 '
					;

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			vACTUALIZADO := 'S';
		  END IF;   
		   
		END IF;
		
		IF pDD_MTO_CODIGO = '06' THEN /*Revisión Publicación*/
		  vACTUALIZAR_COND := 'N';
		END IF; 		
		
	  END IF;	  		  
	END IF;
	
  END;

  PROCEDURE PLP$CONDICIONANTE_VENTA(nACT_ID NUMBER, pADMISION NUMBER, pGESTION NUMBER, pINFORME_COMERCIAL NUMBER, pPRECIO NUMBER, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN

    IF pINFORME_COMERCIAL = 1 THEN
      IF pPRECIO = 1 THEN
        IF pADMISION = 1 AND pGESTION = 1 THEN
          /*PUBLICADO ORDINARIO*/
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                        SET DD_EPV_ID = (SELECT DD_EPV_ID
                                           FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                                          WHERE BORRADO = 0
                                            AND DD_EPV_CODIGO = ''03'')
                          , DD_TPU_V_ID = (SELECT DD_TPU_ID
                                           FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION
                                          WHERE BORRADO = 0
                                            AND DD_TPU_CODIGO = ''01'')
                          , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                          , FECHAMODIFICAR = SYSDATE
                      WHERE ACT_ID = '||nACT_ID||'
                        AND BORRADO = 0
                    ';

          EXECUTE IMMEDIATE V_MSQL;
          IF SQL%ROWCOUNT > 0 THEN
            vACTUALIZADO := 'S';
          END IF;
        ELSE
          /*PUBLICADO FORZADO*/
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                        SET DD_EPV_ID = (SELECT DD_EPV_ID
                                           FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                                          WHERE BORRADO = 0
                                            AND DD_EPV_CODIGO = ''03'')
                          , DD_TPU_V_ID = (SELECT DD_TPU_ID
                                           FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION
                                          WHERE BORRADO = 0
                                            AND DD_TPU_CODIGO = ''02'')
                          , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                          , FECHAMODIFICAR = SYSDATE
                      WHERE ACT_ID = '||nACT_ID||'
                        AND BORRADO = 0
                    ';

          EXECUTE IMMEDIATE V_MSQL;
          IF SQL%ROWCOUNT > 0 THEN
            vACTUALIZADO := 'S';
          END IF;
        END IF;
      ELSE
        /*PRE PUBLICADO ORDINARIO*/
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                      SET DD_EPV_ID = (SELECT DD_EPV_ID
                                         FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                                        WHERE BORRADO = 0
                                          AND DD_EPV_CODIGO = ''02'')
                        , DD_TPU_V_ID = (SELECT DD_TPU_ID
                                         FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION
                                        WHERE BORRADO = 0
                                          AND DD_TPU_CODIGO = ''01'')
                        , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                        , FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = '||nACT_ID||'
                      AND BORRADO = 0
                  ';

        EXECUTE IMMEDIATE V_MSQL;
        IF SQL%ROWCOUNT > 0 THEN
          vACTUALIZADO := 'S';
        END IF;
      END IF;
    ELSE
      IF pPRECIO = 1 THEN
        /*PUBLICADO FORZADO*/
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                      SET DD_EPV_ID = (SELECT DD_EPV_ID
                                         FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                                        WHERE BORRADO = 0
                                          AND DD_EPV_CODIGO = ''03'')
                        , DD_TPU_V_ID = (SELECT DD_TPU_ID
                                         FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION
                                        WHERE BORRADO = 0
                                          AND DD_TPU_CODIGO = ''02'')
                        , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                        , FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = '||nACT_ID||'
                      AND BORRADO = 0
                  ';

        EXECUTE IMMEDIATE V_MSQL;
        IF SQL%ROWCOUNT > 0 THEN
          vACTUALIZADO := 'S';
        END IF;
      END IF;
    END IF;

  END;

  PROCEDURE PLP$CONDICIONANTE_ALQUILER(nACT_ID NUMBER, pADMISION NUMBER, pGESTION NUMBER
                                     , pINFORME_COMERCIAL NUMBER, pPRECIO NUMBER
                                     , pCEE_VIGENTE NUMBER, pADECUADO NUMBER
                                     , pUSUARIOMODIFICAR VARCHAR2
                                     , pCondAlquiler VARCHAR2) IS

  BEGIN

    IF pINFORME_COMERCIAL = 1 THEN
      IF pPRECIO = 1 THEN
        IF pADMISION = 1 AND pGESTION = 1 THEN
          /*PUBLICADO ORDINARIO*/
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                        SET DD_EPA_ID = (SELECT DD_EPA_ID
                                           FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                                          WHERE BORRADO = 0
                                            AND DD_EPA_CODIGO = ''03'')
                          , DD_TPU_A_ID = (SELECT DD_TPU_ID
                                           FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION
                                          WHERE BORRADO = 0
                                            AND DD_TPU_CODIGO = ''01'')
                          , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                          , FECHAMODIFICAR = SYSDATE
                      WHERE ACT_ID = '||nACT_ID||'
                        AND BORRADO = 0
                    ';

          EXECUTE IMMEDIATE V_MSQL;
          IF SQL%ROWCOUNT > 0 THEN
            vACTUALIZADO := 'S';
          END IF;
        ELSIF pCEE_VIGENTE = 1 AND pADECUADO = 1 THEN
          /*PUBLICADO FORZADO*/
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                        SET DD_EPA_ID = (SELECT DD_EPA_ID
                                           FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                                          WHERE BORRADO = 0
                                            AND DD_EPA_CODIGO = ''03'')
                          , DD_TPU_A_ID = (SELECT DD_TPU_ID
                                           FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION
                                          WHERE BORRADO = 0
                                            AND DD_TPU_CODIGO = ''02'')
                          , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                          , FECHAMODIFICAR = SYSDATE
                      WHERE ACT_ID = '||nACT_ID||'
                        AND BORRADO = 0
                    ';

          EXECUTE IMMEDIATE V_MSQL;
          IF SQL%ROWCOUNT > 0 THEN
            vACTUALIZADO := 'S';
          END IF;
        END IF;
      ELSE
        /*PRE PUBLICADO ORDINARIO*/
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                      SET DD_EPA_ID = (SELECT DD_EPA_ID
                                         FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                                        WHERE BORRADO = 0
                                          AND DD_EPA_CODIGO = ''02'')
                        , DD_TPU_A_ID = (SELECT DD_TPU_ID
                                         FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION
                                        WHERE BORRADO = 0
                                          AND DD_TPU_CODIGO = ''01'')
                        , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                        , FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = '||nACT_ID||'
                      AND BORRADO = 0
                  ';

        EXECUTE IMMEDIATE V_MSQL;
        IF SQL%ROWCOUNT > 0 THEN
          vACTUALIZADO := 'S';
        END IF;
      END IF;
    ELSE
      IF pPRECIO = 1 THEN
		IF pCondAlquiler = 0 THEN
			/*PRE PUBLICADO ORDINARIO*/
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
						  SET DD_EPA_ID = (SELECT DD_EPA_ID
											 FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
											WHERE BORRADO = 0
											  AND DD_EPA_CODIGO = ''02'')
							, DD_TPU_A_ID = (SELECT DD_TPU_ID
											 FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION
											WHERE BORRADO = 0
											  AND DD_TPU_CODIGO = ''01'')
							, USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
							, FECHAMODIFICAR = SYSDATE
						WHERE ACT_ID = '||nACT_ID||'
						  AND BORRADO = 0
					  ';

			EXECUTE IMMEDIATE V_MSQL;
			IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
			END IF;  		

		ELSIF pCondAlquiler = 1 THEN
			/*PUBLICADO FORZADO*/
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
						  SET DD_EPA_ID = (SELECT DD_EPA_ID
											 FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
											WHERE BORRADO = 0
											  AND DD_EPA_CODIGO = ''03'')
							, DD_TPU_A_ID = (SELECT DD_TPU_ID
											 FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION
											WHERE BORRADO = 0
											  AND DD_TPU_CODIGO = ''02'')
							, USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
							, FECHAMODIFICAR = SYSDATE
						WHERE ACT_ID = '||nACT_ID||'
						  AND BORRADO = 0
					  ';

			EXECUTE IMMEDIATE V_MSQL;
			IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
			END IF;   
        END IF;
      END IF;
    END IF;

  END;

  BEGIN
	    DBMS_OUTPUT.PUT_LINE('[INICIO]');

      /**************************************/
      /********** FUNCION PRINCIPAL *********/
      /**************************************/
      nCONTADOR    := 0;
        
      IF pACT_ID IS NOT NULL THEN
        vWHERE := ' WHERE V.ACT_ID='||pACT_ID;
      END IF;

	  IF pUSUARIOMODIFICAR IS NULL THEN
	    vUSUARIOMODIFICAR := 'SP_CAMBIO_EST_PUB';
	  ELSE
	    vUSUARIOMODIFICAR := pUSUARIOMODIFICAR;
	  END IF;

	  IF pCondAlquiler IS NULL THEN
	    vCondAlquiler:= 1;
	  ELSE
	    vCondAlquiler := pCondAlquiler;
	  END IF;
    
      V_MSQL := '
        SELECT 
               V.ACT_ID, V.DD_TCO_CODIGO
             , V.CODIGO_ESTADO_A, V.DESC_ESTADO_A, V.CHECK_PUBLICAR_A, V.CHECK_OCULTAR_A, V.DD_MTO_CODIGO_A, V.DD_MTO_MANUAL_A
             , V.CODIGO_ESTADO_V, V.DESC_ESTADO_V, V.CHECK_PUBLICAR_V, V.CHECK_OCULTAR_V, V.DD_MTO_CODIGO_V, V.DD_MTO_MANUAL_V
             , V.DD_TPU_CODIGO_A, V.DD_TPU_CODIGO_V, V.DD_TAL_CODIGO
             , V.ADMISION, V.GESTION
             , V.INFORME_COMERCIAL, V.PRECIO_A, V.PRECIO_V
             , V.CEE_VIGENTE, V.ADECUADO, V.ES_CONDICONADO
          FROM '|| V_ESQUEMA ||'.AUX_CAMBIO_ESTADO_PUBLI V'
          ||vWHERE
       ;

     OPEN v_cursor FOR V_MSQL;
      LOOP
        FETCH v_cursor INTO nACT_ID, vDD_TCO_CODIGO
                              , vCODIGO_ESTADO_A, vDESC_ESTADO_A, vCHECK_PUBLICAR_A, vCHECK_OCULTAR_A, vDD_MTO_CODIGO_A, vDD_MTO_MANUAL_A
                              , vCODIGO_ESTADO_V, vDESC_ESTADO_V, vCHECK_PUBLICAR_V, vCHECK_OCULTAR_V, vDD_MTO_CODIGO_V, vDD_MTO_MANUAL_V
                              , vDD_TPU_CODIGO_A, vDD_TPU_CODIGO_V, vDD_TAL_CODIGO
                              , nADMISION, nGESTION
                              , nINFORME_COMERCIAL, nPRECIO_A, nPRECIO_V
                              , nCEE_VIGENTE, nADECUADO
                              , nES_CONDICONADO;
        EXIT WHEN v_cursor%NOTFOUND;
        
        vACTUALIZADO := 'N';
        vACTUALIZAR_COND := 'S';
           
        /**************/
        /*No Publicado*/
        /**************/
  
        IF vDD_TCO_CODIGO IN ('02','03','04') THEN
  
          IF vCODIGO_ESTADO_A = '01' THEN
  
            IF vCHECK_PUBLICAR_A = 1 THEN
              PLP$CONDICIONANTE_ALQUILER(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_A, nCEE_VIGENTE, nADECUADO, vUSUARIOMODIFICAR, vCondAlquiler);
            END IF;
  
          END IF;
        END IF;
  
        IF vDD_TCO_CODIGO IN ('01','02') THEN
  
          IF vCODIGO_ESTADO_V = '01' THEN
  
            IF vCHECK_PUBLICAR_V = 1 THEN
              PLP$CONDICIONANTE_VENTA(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_V, vUSUARIOMODIFICAR);
            END IF;
  
          END IF;
        END IF;
  
  
        /***************/
        /*Pre Publicado*/
        /***************/
  
        IF vDD_TCO_CODIGO IN ('02','03','04') THEN
  
          IF vCODIGO_ESTADO_A = '02' THEN
  
            IF vCHECK_PUBLICAR_A = 0 THEN
              PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID, '01', vUSUARIOMODIFICAR);
              PLP$LIMPIAR_ALQUILER(nACT_ID, vUSUARIOMODIFICAR);
            END IF;
  
            IF vCHECK_PUBLICAR_A = 1 AND pCondAlquiler IS NOT NULL THEN
              PLP$CONDICIONANTE_ALQUILER(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_A, nCEE_VIGENTE, nADECUADO, vUSUARIOMODIFICAR, vCondAlquiler);
            END IF;
  
          END IF;
        END IF;
  
        IF vDD_TCO_CODIGO IN ('01','02') THEN
  
          IF vCODIGO_ESTADO_V = '02' THEN
  
            IF vCHECK_PUBLICAR_V = 0 THEN
              PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '01', vUSUARIOMODIFICAR);
              PLP$LIMPIAR_VENTA(nACT_ID, vUSUARIOMODIFICAR);
            END IF;
  
            IF vCHECK_PUBLICAR_V = 1 THEN
              PLP$CONDICIONANTE_VENTA(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_V, vUSUARIOMODIFICAR);
            END IF;
  
          END IF;
        END IF;
  
        /***********/
        /*Publicado*/
        /***********/
        
        IF vDD_TCO_CODIGO IN ('02','03','04') THEN
          IF (vCODIGO_ESTADO_A = '03' AND vCHECK_PUBLICAR_A = 1) THEN
            #ESQUEMA#.SP_MOTIVO_OCULTACION_A (nACT_ID, 'A', OutOCULTAR, OutMOTIVO);
    
            IF OutOCULTAR = 1 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, 'A', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
              PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID, '04', vUSUARIOMODIFICAR);
            END IF;
    
            IF OutOCULTAR = 0 THEN
              IF vCHECK_OCULTAR_A = 1 THEN
                PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID, '04', vUSUARIOMODIFICAR);
                IF vDD_MTO_MANUAL_A = 0 THEN
                  PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, 'A', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
                END IF;  
              END IF;
            END IF;
          END IF;
  
        END IF;
        
        IF vDD_TCO_CODIGO IN ('01','02') THEN
          IF (vCODIGO_ESTADO_V = '03' AND vCHECK_PUBLICAR_V = 1) THEN
            #ESQUEMA#.SP_MOTIVO_OCULTACION_V (nACT_ID, 'V', OutOCULTAR, OutMOTIVO);
    
            IF OutOCULTAR = 1 THEN
              IF OutMOTIVO = '03' AND vDD_TAL_CODIGO = '01' THEN /*SI MOTIVO ES ALQUILADO Y TIPO ALQUILER ORDINARIO, NO OCULTAR*/
                IF vDD_MTO_MANUAL_V = 0 THEN /*MOTIVO AUTOMÁTICO*/
                  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                                SET APU_CHECK_OCULTAR_V = 0
                                  , DD_MTO_V_ID = NULL
                                  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                                  , FECHAMODIFICAR = SYSDATE
                                WHERE ACT_ID = '||nACT_ID||'
                                AND BORRADO = 0
                              ';
            
                  EXECUTE IMMEDIATE V_MSQL; 
                ELSE
                  PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '04', vUSUARIOMODIFICAR);               
                END IF;
              ELSE
                PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, 'V', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
                PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '04', vUSUARIOMODIFICAR);
              END IF;
            END IF;
    
            IF OutOCULTAR = 0 THEN
              IF vCHECK_OCULTAR_V = 1 then
                PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '04', vUSUARIOMODIFICAR);
                
                IF vDD_MTO_MANUAL_V = 0 THEN
                  PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, 'V', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
                END IF;
              END IF;
            END IF;
          END IF;     
        END IF;
  
        /***********/
        /**OCULTAR**/
        /***********/
        
        IF vDD_TCO_CODIGO IN ('02','03','04') THEN
          IF vCODIGO_ESTADO_A = '04' THEN
            #ESQUEMA#.SP_MOTIVO_OCULTACION_A (nACT_ID, 'A', OutOCULTAR, OutMOTIVO);
    
            IF OutOCULTAR = 0 AND vDD_MTO_MANUAL_A = 0 THEN
              PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID, '03', vUSUARIOMODIFICAR);
              PLP$LIMPIAR_ALQUILER(nACT_ID, vUSUARIOMODIFICAR);
            END IF;
    
            IF OutOCULTAR = 1 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, 'A', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
            END IF; 
            
            /*Si el activo está oculto por un motivo automático y el proceso 
            no encuentra ningún motivo automático hay que quitar la ocultación del activo.*/
            IF vDD_MTO_MANUAL_A = 0 AND OutOCULTAR = 0 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, 'A', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
            END IF;
          END IF;
  
        END IF;
        
        IF vDD_TCO_CODIGO IN ('01','02') THEN
          IF vCODIGO_ESTADO_V = '04' THEN
            #ESQUEMA#.SP_MOTIVO_OCULTACION_V (nACT_ID, 'V', OutOCULTAR, OutMOTIVO);
    
            IF OutOCULTAR = 0 AND vDD_MTO_MANUAL_V = 0 THEN
              PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '03', vUSUARIOMODIFICAR);
              PLP$LIMPIAR_VENTA(nACT_ID, vUSUARIOMODIFICAR);
            END IF;
    
            IF OutOCULTAR = 1 THEN
              IF OutMOTIVO = '03' AND vDD_TAL_CODIGO = '01' THEN /*SI MOTIVO ES ALQUILADO Y TIPO ALQUILER ORDINARIO, NO OCULTAR*/
                IF vDD_MTO_MANUAL_V = 1 THEN /*MOTIVO MANUAL*/
                  NULL;
                ELSE
                  PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '03', vUSUARIOMODIFICAR);
                END IF;
              ELSE
                PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, 'V', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
              END IF;
            END IF;
            
            /*Si el activo está oculto por un motivo automático y el proceso 
            no encuentra ningún motivo automático hay que quitar la ocultación del activo.*/
            IF vDD_MTO_MANUAL_V = 0 AND OutOCULTAR = 0 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, 'V', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
            END IF;            
          END IF;      
        END IF;
  
        IF vACTUALIZAR_COND = 'S' THEN
		    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						SET ACT.ES_CONDICONADO_ANTERIOR = '||nES_CONDICONADO||'
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
					'
					;

		    EXECUTE IMMEDIATE V_MSQL;        
        END IF;
  
        /**************/
        /*HISTORIFICAR*/
        /**************/
        IF vACTUALIZADO = 'S' AND pHISTORIFICAR = 'S' THEN
          V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION(AHP_ID,ACT_ID
                                                  ,DD_TPU_A_ID,DD_TPU_V_ID,DD_EPV_ID,DD_EPA_ID,DD_TCO_ID,DD_MTO_V_ID
                                                  ,AHP_MOT_OCULTACION_MANUAL_V,AHP_CHECK_PUBLICAR_V,AHP_CHECK_OCULTAR_V
                                                  ,AHP_CHECK_OCULTAR_PRECIO_V,AHP_CHECK_PUB_SIN_PRECIO_V
                                                  ,DD_MTO_A_ID
                                                  ,AHP_MOT_OCULTACION_MANUAL_A,AHP_CHECK_PUBLICAR_A
                                                  ,AHP_CHECK_OCULTAR_A,AHP_CHECK_OCULTAR_PRECIO_A
                                                  ,AHP_CHECK_PUB_SIN_PRECIO_A
                                                  ,AHP_FECHA_INI_VENTA,AHP_FECHA_INI_ALQUILER
                                                  ,AHP_FECHA_FIN_VENTA,AHP_FECHA_FIN_ALQUILER
                                                  ,VERSION
                                                  ,USUARIOCREAR,FECHACREAR
                                                  ,USUARIOMODIFICAR,FECHAMODIFICAR
                                                  ,USUARIOBORRAR,FECHABORRAR,BORRADO
                                                  ,ES_CONDICONADO_ANTERIOR)
            SELECT  '|| V_ESQUEMA ||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL, ACT_ID
                                                  ,(SELECT DD_TPU_ID FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION WHERE BORRADO = 0 AND DD_TPU_CODIGO = '''||vDD_TPU_CODIGO_A||''')DD_TPU_A_ID
                                                  ,(SELECT DD_TPU_ID FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION WHERE BORRADO = 0 AND DD_TPU_CODIGO = '''||vDD_TPU_CODIGO_V||''')DD_TPU_V_ID
                                                  ,(SELECT DD_EPV_ID FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA WHERE BORRADO = 0 AND DD_EPV_CODIGO = '''||vCODIGO_ESTADO_V||''')DD_EPV_ID
                                                  ,(SELECT DD_EPA_ID FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE BORRADO = 0 AND DD_EPA_CODIGO = '''||vCODIGO_ESTADO_A||''')DD_EPA_ID
                                                  ,DD_TCO_ID
                                                  ,(SELECT DD_MTO_ID FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '''||vDD_MTO_CODIGO_V||''')DD_MTO_V_ID
                                                  ,APU_MOT_OCULTACION_MANUAL_V,APU_CHECK_PUBLICAR_V,'''||vCHECK_OCULTAR_V||''' APU_CHECK_OCULTAR_V
                                                  ,APU_CHECK_OCULTAR_PRECIO_V,APU_CHECK_PUB_SIN_PRECIO_V
                                                  ,(SELECT DD_MTO_ID FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '''||vDD_MTO_CODIGO_A||''')DD_MTO_A_ID
                                                  ,APU_MOT_OCULTACION_MANUAL_A,APU_CHECK_PUBLICAR_A
                                                  ,'''||vCHECK_OCULTAR_A||''' APU_CHECK_OCULTAR_A,APU_CHECK_OCULTAR_PRECIO_A
                                                  ,APU_CHECK_PUB_SIN_PRECIO_A
                                                  ,FECHAMODIFICAR,FECHAMODIFICAR
                                                  ,SYSDATE APU_FECHA_FIN_VENTA
                                                  ,SYSDATE APU_FECHA_FIN_ALQUILER
                                                  ,VERSION
                                                  ,'''||pUSUARIOMODIFICAR||''' USUARIOCREAR, SYSDATE FECHACREAR
                                                  ,USUARIOMODIFICAR,FECHAMODIFICAR
                                                  ,USUARIOBORRAR,FECHABORRAR,BORRADO
                                                  ,'''||nES_CONDICONADO||''' ES_CONDICONADO_ANTERIOR
              FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
             WHERE BORRADO = 0
               AND ACT_ID = '||nACT_ID||'
                    ';
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
        
        nCONTADOR := nCONTADOR + 1;
        
        IF nCONTADOR > nCONTADORMax THEN
          nCONTADOR := 0;
          COMMIT;
        END IF;
        
      END LOOP;
    CLOSE v_cursor;
    DBMS_OUTPUT.PUT_LINE('[FIN]');

	/*BEGIN
	  #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','ACT_APU_ACTIVO_PUBLICACION');
	  #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','ACT_AHP_HIST_PUBLICACION');
	END;*/
    
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
