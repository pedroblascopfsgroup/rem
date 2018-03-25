--/*
--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20180315
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3936
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

create or replace PROCEDURE SP_CAMBIO_ESTADO_PUBLICACION (pACT_ID IN NUMBER DEFAULT NULL
                                                        , pUSUARIOMODIFICAR IN VARCHAR2 DEFAULT 'SP_CAMBIO_EST_PUB'
                                                        , pHISTORIFICAR IN VARCHAR2 DEFAULT 'N') IS

	  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(20000 CHAR); -- Sentencia a ejecutar 
    vWHERE VARCHAR2(4000 CHAR);

    nACT_ID           #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.ACT_ID%TYPE;
    vDD_TCO_CODIGO    #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TCO_CODIGO%TYPE;
    vCODIGO_ESTADO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_A%TYPE;
    vDESC_ESTADO_A    #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DESC_ESTADO_A%TYPE;
    vCHECK_PUBLICAR_A #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CHECK_PUBLICAR_A%TYPE;
    vCHECK_OCULTAR_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_A%TYPE;
    vDD_MTO_CODIGO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_A%TYPE;    
    vDD_MTO_MANUAL_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_MTO_MANUAL_A%TYPE; 
    vCODIGO_ESTADO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_V%TYPE;
    vDESC_ESTADO_V    #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DESC_ESTADO_V%TYPE;
    vCHECK_PUBLICAR_V #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CHECK_PUBLICAR_V%TYPE;
    vCHECK_OCULTAR_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_V%TYPE;
    vDD_MTO_CODIGO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_V%TYPE;
    vDD_MTO_MANUAL_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_MTO_MANUAL_V%TYPE; 
    vDD_TPU_CODIGO    #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO%TYPE;
    nADMISION         #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.ADMISION%TYPE;
    nGESTION          #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.GESTION%TYPE;
    nINFORME_COMERCIAL #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.INFORME_COMERCIAL%TYPE;
    nPRECIO           #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.PRECIO%TYPE;
    nCEE_VIGENTE      #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CEE_VIGENTE%TYPE;
    nADECUADO         #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.ADECUADO%TYPE;
    
    OutOCULTAR        #ESQUEMA#.ACT_APU_ACTIVO_PUBLICACION.APU_CHECK_OCULTAR_A%TYPE;
    OutMOTIVO         #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION.DD_MTO_CODIGO%TYPE;
    
    vACTUALIZADO      VARCHAR2(1 CHAR);

    TYPE CurTyp IS REF CURSOR;
    v_cursor    CurTyp;
    
    nCONTADOR         NUMBER := 0;
    nCONTADORMax      NUMBER := 10000;
    
  PROCEDURE PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID NUMBER, pESTADO VARCHAR2) IS

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

  PROCEDURE PLP$CAMBIO_ESTADO_VENTA(nACT_ID NUMBER, pESTADO VARCHAR2) IS

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

  PROCEDURE PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID NUMBER, pDD_TCO_CODIGO VARCHAR2, pOCULTAR NUMBER, pDD_MTO_CODIGO VARCHAR2) IS

  BEGIN

    IF pDD_TCO_CODIGO IN ('02','03','04') THEN
      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                    SET DD_MTO_A_ID = (SELECT DD_MTO_ID
                                         FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
                                        WHERE BORRADO = 0
                                          AND DD_MTO_CODIGO = '''||pDD_MTO_CODIGO||''')
                      , APU_CHECK_OCULTAR_A = '||OutOCULTAR||'
                      , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                      , FECHAMODIFICAR = SYSDATE
                  WHERE ACT_ID = '||nACT_ID||'
                    AND BORRADO = 0
                    AND APU_CHECK_OCULTAR_A <> '||pOCULTAR
                ;
      
      EXECUTE IMMEDIATE V_MSQL;
      IF SQL%ROWCOUNT > 0 THEN
        vACTUALIZADO := 'S';
      END IF;
    END IF;

    IF pDD_TCO_CODIGO IN ('01','02') THEN
      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                    SET DD_MTO_V_ID = (SELECT DD_MTO_ID
                                         FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
                                        WHERE BORRADO = 0
                                          AND DD_MTO_CODIGO = '''||pDD_MTO_CODIGO||''')
                      , APU_CHECK_OCULTAR_V = '||OutOCULTAR||'
                      , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                      , FECHAMODIFICAR = SYSDATE
                  WHERE ACT_ID = '||nACT_ID||'
                    AND BORRADO = 0
                    AND APU_CHECK_OCULTAR_V <> '||pOCULTAR
                ;

      EXECUTE IMMEDIATE V_MSQL;
      IF SQL%ROWCOUNT > 0 THEN
        vACTUALIZADO := 'S';
      END IF;
    END IF;

    IF pDD_MTO_CODIGO IN ('04') THEN /*04	Revisión adecuación*/
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
    
    END IF;
  END;

  PROCEDURE PLP$CONDICIONANTE_VENTA(nACT_ID NUMBER, pADMISION NUMBER, pGESTION NUMBER, pINFORME_COMERCIAL NUMBER, pPRECIO NUMBER) IS

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
                          , DD_TPU_ID = (SELECT DD_TPU_ID
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
                          , DD_TPU_ID = (SELECT DD_TPU_ID
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
                        , DD_TPU_ID = (SELECT DD_TPU_ID
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
                        , DD_TPU_ID = (SELECT DD_TPU_ID
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
                                     , pCEE_VIGENTE NUMBER, pADECUADO NUMBER) IS

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
                          , DD_TPU_ID = (SELECT DD_TPU_ID
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
                          , DD_TPU_ID = (SELECT DD_TPU_ID
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
                        , DD_TPU_ID = (SELECT DD_TPU_ID
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
                      SET DD_EPA_ID = (SELECT DD_EPA_ID
                                         FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                                        WHERE BORRADO = 0
                                          AND DD_EPA_CODIGO = ''03'')
                        , DD_TPU_ID = (SELECT DD_TPU_ID
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

  BEGIN
	    DBMS_OUTPUT.PUT_LINE('[INICIO]');

      /**************************************/
      /********** FUNCION PRINCIPAL *********/
      /**************************************/
      nCONTADOR    := 0;
        
      IF pACT_ID IS NOT NULL THEN
        vWHERE := ' WHERE V.ACT_ID='||pACT_ID;
      END IF;

      V_MSQL := '
        SELECT DISTINCT
               V.ACT_ID, V.DD_TCO_CODIGO
             , V.CODIGO_ESTADO_A, V.DESC_ESTADO_A, V.CHECK_PUBLICAR_A, V.CHECK_OCULTAR_A, V.DD_MTO_CODIGO_A, V.DD_MTO_MANUAL_A
             , V.CODIGO_ESTADO_V, V.DESC_ESTADO_V, V.CHECK_PUBLICAR_V, V.CHECK_OCULTAR_V, V.DD_MTO_CODIGO_V, V.DD_MTO_MANUAL_V
             , V.DD_TPU_CODIGO
             , V.ADMISION, V.GESTION
             , V.INFORME_COMERCIAL, V.PRECIO
             , V.CEE_VIGENTE, V.ADECUADO
          FROM '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI V'
          ||vWHERE
       ;

     OPEN v_cursor FOR V_MSQL;
      LOOP
        FETCH v_cursor INTO nACT_ID, vDD_TCO_CODIGO
                              , vCODIGO_ESTADO_A, vDESC_ESTADO_A, vCHECK_PUBLICAR_A, vCHECK_OCULTAR_A, vDD_MTO_CODIGO_A, vDD_MTO_MANUAL_A
                              , vCODIGO_ESTADO_V, vDESC_ESTADO_V, vCHECK_PUBLICAR_V, vCHECK_OCULTAR_V, vDD_MTO_CODIGO_V, vDD_MTO_MANUAL_V
                              , vDD_TPU_CODIGO
                              , nADMISION, nGESTION
                              , nINFORME_COMERCIAL, nPRECIO
                              , nCEE_VIGENTE, nADECUADO;
        EXIT WHEN v_cursor%NOTFOUND;
        
        vACTUALIZADO := 'N';
           
        /**************/
        /*No Publicado*/
        /**************/
  
        IF vDD_TCO_CODIGO IN ('02','03','04') THEN
  
          IF vCODIGO_ESTADO_A = '01' THEN
  
            IF vCHECK_PUBLICAR_A = 1 THEN
              PLP$CONDICIONANTE_ALQUILER(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO, nCEE_VIGENTE, nADECUADO);
            END IF;
  
          END IF;
        END IF;
  
        IF vDD_TCO_CODIGO IN ('01','02') THEN
  
          IF vCODIGO_ESTADO_V = '01' THEN
  
            IF vCHECK_PUBLICAR_A = 1 THEN
              PLP$CONDICIONANTE_VENTA(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO);
            END IF;
  
          END IF;
        END IF;
  
  
        /***************/
        /*Pre Publicado*/
        /***************/
  
        IF vDD_TCO_CODIGO IN ('02','03','04') THEN
  
          IF vCODIGO_ESTADO_A = '02' THEN
  
            IF vCHECK_PUBLICAR_A = 0 THEN
              PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID, '01');
            END IF;
  
            IF vCHECK_PUBLICAR_A = 1 THEN
              PLP$CONDICIONANTE_ALQUILER(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO, nCEE_VIGENTE, nADECUADO);
            END IF;
  
          END IF;
        END IF;
  
        IF vDD_TCO_CODIGO IN ('01','02') THEN
  
          IF vCODIGO_ESTADO_V = '02' THEN
  
            IF vCHECK_PUBLICAR_V = 0 THEN
              PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '01');
            END IF;
  
            IF vCHECK_PUBLICAR_V = 1 THEN
              PLP$CONDICIONANTE_VENTA(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO);
            END IF;
  
          END IF;
        END IF;
  
        /***********/
        /*Publicado*/
        /***********/
        
        IF vDD_TCO_CODIGO IN ('02','03','04') THEN
          IF (vCODIGO_ESTADO_A = '03' AND vCHECK_PUBLICAR_A = 1) THEN
            REM01.SP_MOTIVO_OCULTACION (nACT_ID, OutOCULTAR, OutMOTIVO);
    
            IF OutOCULTAR = 1 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO);
              PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID, '04');
            END IF;
    
            IF OutOCULTAR = 0 THEN
              IF vCHECK_OCULTAR_A = 1 AND vDD_MTO_MANUAL_A = 0 THEN
                PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO);
              END IF; 
            END IF;  
          END IF;
  
        END IF;
        
        IF vDD_TCO_CODIGO IN ('01','02') THEN
          IF (vCODIGO_ESTADO_V = '03' AND vCHECK_PUBLICAR_V = 1) THEN
            REM01.SP_MOTIVO_OCULTACION (nACT_ID, OutOCULTAR, OutMOTIVO);
    
            IF OutOCULTAR = 1 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO);
              PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '04');
            END IF;
    
            IF OutOCULTAR = 0 THEN
              IF vCHECK_OCULTAR_V = 1 AND vDD_MTO_MANUAL_V = 0 THEN
                PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO);
              END IF;  
            END IF;  
          END IF;      
        END IF;
  
        /***********/
        /**OCULTAR**/
        /***********/
        
        IF vDD_TCO_CODIGO IN ('02','03','04') THEN
          IF vCODIGO_ESTADO_A = '04' THEN
            REM01.SP_MOTIVO_OCULTACION (nACT_ID, OutOCULTAR, OutMOTIVO);
    
            IF OutOCULTAR = 0 AND vDD_MTO_MANUAL_A = 0 THEN
              PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID, '03');
            END IF;
    
            IF OutOCULTAR = 1 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO);
            END IF; 
            
            /*Si el activo está oculto por un motivo automático y el proceso 
            no encuentra ningún motivo automático hay que quitar la ocultación del activo.*/
            IF vDD_MTO_MANUAL_A = 0 AND OutOCULTAR = 0 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO);
            END IF;
          END IF;
  
        END IF;
        
        IF vDD_TCO_CODIGO IN ('01','02') THEN
          IF vCODIGO_ESTADO_V = '04' THEN
            REM01.SP_MOTIVO_OCULTACION (nACT_ID, OutOCULTAR, OutMOTIVO);
    
            IF OutOCULTAR = 0 AND vDD_MTO_MANUAL_V = 0 THEN
              PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '03');
            END IF;
    
            IF OutOCULTAR = 1 THEN
                PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO);
            END IF;
            
            /*Si el activo está oculto por un motivo automático y el proceso 
            no encuentra ningún motivo automático hay que quitar la ocultación del activo.*/
            IF vDD_MTO_MANUAL_V = 0 AND OutOCULTAR = 0 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO);
            END IF;            
          END IF;      
        END IF;
  
  
        /**************/
        /*HISTORIFICAR*/
        /**************/
        IF vACTUALIZADO = 'S' AND pHISTORIFICAR = 'S' THEN
          V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION(AHP_ID,ACT_ID
                                                  ,DD_TPU_ID,DD_EPV_ID,DD_EPA_ID,DD_TCO_ID,DD_MTO_V_ID
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
                                                  ,USUARIOBORRAR,FECHABORRAR,BORRADO)
            SELECT  '|| V_ESQUEMA ||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL, ACT_ID
                                                  ,(SELECT DD_TPU_ID FROM '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION WHERE BORRADO = 0 AND DD_TPU_CODIGO = '''||vDD_TPU_CODIGO||''')DD_TPU_ID
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
                                                  ,APU_FECHA_INI_VENTA,APU_FECHA_INI_ALQUILER
                                                  ,SYSDATE APU_FECHA_FIN_VENTA
                                                  ,SYSDATE APU_FECHA_FIN_ALQUILER
                                                  ,VERSION
                                                  ,NVL('''||pUSUARIOMODIFICAR||''',''SP_CAMBIO_EST_PUB'') USUARIOCREAR, SYSDATE FECHACREAR
                                                  ,USUARIOMODIFICAR,FECHAMODIFICAR
                                                  ,USUARIOBORRAR,FECHABORRAR,BORRADO
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

	END SP_CAMBIO_ESTADO_PUBLICACION;
/

EXIT;
