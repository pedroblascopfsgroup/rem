--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15634
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

create or replace PROCEDURE       SP_CAMBIO_ESTADO_PUBLICACION_CONV_CAIXA (pACT_ID IN NUMBER DEFAULT NULL
														, pCondAlquiler VARCHAR2 DEFAULT 1
                                                        , pUSUARIOMODIFICAR IN VARCHAR2 DEFAULT 'SP_CAMBIO_EST_PUB') IS

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
    vDD_TPU_CODIGO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_A%TYPE;
    vDD_TPU_CODIGO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_V%TYPE;
    vDD_TAL_CODIGO	  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TAL_CODIGO%TYPE;
    nADMISION         #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.ADMISION%TYPE;
    nGESTION          #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.GESTION%TYPE;
    nINFORME_COMERCIAL #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.INFORME_COMERCIAL%TYPE;
    nPRECIO_A         #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.PRECIO_A%TYPE;
    nPRECIO_V         #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.PRECIO_V%TYPE;
    nCEE_VIGENTE      #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CEE_VIGENTE%TYPE;
    nADECUADO         #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.ADECUADO%TYPE;
    nES_CONDICIONADO  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.ES_CONDICIONADO_PUBLI%TYPE;

    hDD_TCO_CODIGO    #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TCO_CODIGO%TYPE;
    hCODIGO_ESTADO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_A%TYPE;
    hCHECK_OCULTAR_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_A%TYPE;
    hDD_MTO_CODIGO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_A%TYPE;
    hCODIGO_ESTADO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_V%TYPE;
    hCHECK_OCULTAR_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_V%TYPE;
    hDD_MTO_CODIGO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_V%TYPE;
    hDD_TPU_CODIGO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_A%TYPE;
    hDD_TPU_CODIGO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_V%TYPE;

    fDD_TCO_CODIGO    #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TCO_CODIGO%TYPE;
    fCODIGO_ESTADO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_A%TYPE;
    fCHECK_OCULTAR_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_A%TYPE;
    fDD_MTO_CODIGO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_A%TYPE;
    fCODIGO_ESTADO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_V%TYPE;
    fCHECK_OCULTAR_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_V%TYPE;
    fDD_MTO_CODIGO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_V%TYPE;
    fDD_TPU_CODIGO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_A%TYPE;
    fDD_TPU_CODIGO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_V%TYPE;

    OutOCULTAR        #ESQUEMA#.ACT_APU_ACTIVO_PUBLICACION.APU_CHECK_OCULTAR_A%TYPE;
    OutMOTIVO         #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION.DD_MTO_CODIGO%TYPE;

    cCODIGO_ESTADO_V #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_V%TYPE;
    cDD_POR_CODIGO	 #ESQUEMA#.DD_POR_PORTAL.DD_POR_CODIGO%TYPE;
	hDD_POR_CODIGO	 #ESQUEMA#.DD_POR_PORTAL.DD_POR_CODIGO%TYPE;
    fDD_POR_CODIGO   #ESQUEMA#.DD_POR_PORTAL.DD_POR_CODIGO%TYPE;



    vACTUALIZADO_V    VARCHAR2(1 CHAR);
    vACTUALIZADO_A    VARCHAR2(1 CHAR);
    vACTUALIZAR_COND  VARCHAR2(1 CHAR);
    vUSUARIOMODIFICAR VARCHAR2(50 CHAR);
    vCondAlquiler     VARCHAR2(1 CHAR);
    V_AUX             VARCHAR2(50 CHAR);
    OutCANAL		  VARCHAR2(4000 CHAR);
    vRESTRINGIDA	  NUMBER := 0;


    TYPE CurTyp IS REF CURSOR;
    v_cursor    CurTyp;

    nCONTADOR         NUMBER := 0;
    nCONTADORMax      NUMBER := 10000;
    V_TABLA_TMP_V VARCHAR2(30 CHAR):='TMP_PUBL_ACT';

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
      vACTUALIZADO_A := 'S';
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
      vACTUALIZADO_V := 'S';
    END IF;
  END;

  PROCEDURE PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID NUMBER, pESTADO VARCHAR2, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                  SET DD_EPA_ID = (SELECT DD_EPA_ID
                                     FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                                    WHERE BORRADO = 0
                                      AND DD_EPA_CODIGO = '''||pESTADO||''')
					, APU_FECHA_INI_ALQUILER = SYSDATE
                    , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                    , FECHAMODIFICAR = SYSDATE
                WHERE ACT_ID = '||nACT_ID||'
                  AND BORRADO = 0
              ';

    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT > 0 THEN
      vACTUALIZADO_A := 'S';
    END IF;





  END;

  PROCEDURE PLP$CAMBIO_ESTADO_VENTA(nACT_ID NUMBER, pESTADO VARCHAR2, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                  SET DD_EPV_ID = (SELECT DD_EPV_ID
                                     FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                                    WHERE BORRADO = 0
                                      AND DD_EPV_CODIGO = '''||pESTADO||''')
					, APU_FECHA_INI_VENTA = SYSDATE
                    , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                    , FECHAMODIFICAR = SYSDATE
                WHERE ACT_ID = '||nACT_ID||'
                  AND BORRADO = 0
              ';

    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT > 0 THEN
      vACTUALIZADO_V := 'S';
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
						  , APU_FECHA_INI_ALQUILER = SYSDATE
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
			vACTUALIZADO_A := 'S';
		  END IF;

		  IF pDD_MTO_CODIGO = '01' THEN /*No Publicable*/
		    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						SET APU_MOT_OCULTACION_MANUAL_A = (SELECT substr(PAC.PAC_MOTIVO_PUBLICAR,1,250)
															 FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
															WHERE PAC.ACT_ID = ACT.ACT_ID
															  AND PAC.BORRADO = 0)
						  , APU_FECHA_INI_ALQUILER = SYSDATE
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
						  , APU_MOT_OCULTACION_MANUAL_V = NULL
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
					'
					;

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO_A := 'S';
		    END IF;
		  END IF;

		  IF pDD_MTO_CODIGO = '02' THEN /*No Comercializable*/
		    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						SET APU_MOT_OCULTACION_MANUAL_A = (SELECT SUBSTR(PAC.PAC_MOT_EXCL_COMERCIALIZAR,1,250)
															 FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
															WHERE PAC.ACT_ID = ACT.ACT_ID
															  AND PAC.BORRADO = 0)
						  , APU_FECHA_INI_ALQUILER = SYSDATE
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
					'
					;

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO_A := 'S';
		    END IF;
		  END IF;

		  IF pDD_MTO_CODIGO = '06' THEN /*Revisión Publicación*/
		    vACTUALIZAR_COND := 'N';
		    #ESQUEMA#.SP_CREAR_AVISO (pACT_ID, 'GPUBL', pUSUARIOMODIFICAR, 'Se ha situado en Oculto Alquiler con motivo Revisión Publicación el activo: ', 0);
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
						  , APU_FECHA_INI_VENTA = SYSDATE
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
			vACTUALIZADO_V := 'S';
		  END IF;

		  IF pDD_MTO_CODIGO = '01' THEN /*No Publicable*/
		    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						SET APU_MOT_OCULTACION_MANUAL_V = (SELECT substr(PAC.PAC_MOTIVO_PUBLICAR,1,250)
															 FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
															WHERE PAC.ACT_ID = ACT.ACT_ID
															  AND PAC.BORRADO = 0)
						  , APU_FECHA_INI_VENTA = SYSDATE
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
					'
					;

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO_V := 'S';
		    END IF;
		  END IF;

		  IF pDD_MTO_CODIGO = '02' THEN /*No Comercializable*/
		    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						SET APU_MOT_OCULTACION_MANUAL_V = (SELECT SUBSTR(PAC.PAC_MOT_EXCL_COMERCIALIZAR,1,250)
															 FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
															WHERE PAC.ACT_ID = ACT.ACT_ID
															  AND PAC.BORRADO = 0)
						  , APU_FECHA_INI_VENTA = SYSDATE
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
					  WHERE ACT_ID = '||nACT_ID||'
						AND BORRADO = 0
					'
					;

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO_V := 'S';
		    END IF;
		  END IF;

		IF pDD_MTO_CODIGO IN ('13') THEN /*Vendido*/
      V_MSQL:='UPDATE '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT '||
          '       SET ACT.PAC_CHECK_COMERCIALIZAR = 0
                     ,ACT.PAC_FECHA_COMERCIALIZAR = SYSDATE
                     ,ACT.USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
					 ,ACT.FECHAMODIFICAR = SYSDATE
                WHERE ACT.ACT_ID = '||nACT_ID||'
                  AND ACT.PAC_CHECK_COMERCIALIZAR = 1
          ';

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO_V := 'S';
		  END IF;

      V_MSQL:='UPDATE '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT '||
          '       SET ACT.PAC_CHECK_FORMALIZAR = 0
                     ,ACT.PAC_FECHA_FORMALIZAR = SYSDATE
                     ,ACT.USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
					 ,ACT.FECHAMODIFICAR = SYSDATE
                WHERE ACT.ACT_ID = '||nACT_ID||'
                  AND ACT.PAC_CHECK_FORMALIZAR = 1
          ';

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO_V := 'S';
		  END IF;

      V_MSQL:='UPDATE '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT '||
          '       SET ACT.PAC_CHECK_PUBLICAR = 0
                     ,ACT.PAC_FECHA_PUBLICAR = SYSDATE
                     ,ACT.USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
					 ,ACT.FECHAMODIFICAR = SYSDATE
                WHERE ACT.ACT_ID = '||nACT_ID||'
                  AND ACT.PAC_CHECK_PUBLICAR = 1
          ';

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO_V := 'S';
		  END IF;
		END IF;

		IF pDD_MTO_CODIGO = '06' THEN /*Revisión Publicación*/
		  vACTUALIZAR_COND := 'N';
		  #ESQUEMA#.SP_CREAR_AVISO (pACT_ID, 'GPUBL', pUSUARIOMODIFICAR, 'Se ha situado en Oculto Venta con motivo Revisión Publicación el activo: ', 0);
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
            vACTUALIZADO_V := 'S';
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
            vACTUALIZADO_V := 'S';
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
          vACTUALIZADO_V := 'S';
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
          vACTUALIZADO_V := 'S';
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
					vACTUALIZADO_A := 'S';
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
					vACTUALIZADO_A := 'S';
				END IF;

		ELSIF pCondAlquiler = 0 THEN
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
					vACTUALIZADO_A := 'S';
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
						vACTUALIZADO_A := 'S';
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
				vACTUALIZADO_A := 'S';
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
			  vACTUALIZADO_A := 'S';
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
					vACTUALIZADO_A := 'S';
				END IF;
        END IF;
   END IF;
END IF;
  END;


  FUNCTION PLP$ESTA_EN_ASISTIDA_VEN( nACT_ID NUMBER ) RETURN NUMBER  IS
   v_cursor_aux    CurTyp;
   sRES NUMBER;
  BEGIN

      V_MSQL := ' SELECT COUNT( 1 ) AS RES
                FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR
                JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG
                    ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0
                WHERE 1 = 1
                AND EXISTS ( SELECT 1
                             FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                             WHERE AGA.AGR_ID = AGR.AGR_ID
                             AND AGA.ACT_ID = ' || nACT_ID  || ' AND AGA.BORRADO = 0
                            )
                AND TAG.DD_TAG_CODIGO = ''13''
                AND AGR.AGR_FIN_VIGENCIA < SYSDATE
				AND AGR.AGR_FECHA_BAJA IS NULL';

    OPEN v_cursor_aux FOR V_MSQL;
    FETCH v_cursor_aux INTO sRES;
    CLOSE v_cursor_aux;

     IF sRES > 0 THEN

      RETURN ( 1 );

    ELSE

      RETURN ( 0 );

    END IF;

  END;

  PROCEDURE PLP$AGR_ASISTIDAS_ESC_ACT( nACT_ID NUMBER, vDD_TCO_CODIGO VARCHAR2 ) IS

  BEGIN

    IF PLP$ESTA_EN_ASISTIDA_VEN( nACT_ID ) = 1 THEN --Se trata de una agrupación asistida ??

        IF vDD_TCO_CODIGO IN ('02','03','04') THEN -- Alquiler

            -- Activos en alquiler publicados:
            V_MSQL := '
            MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                USING ( SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ID = ' || nACT_ID || ' ) AUX
                ON ( ACT.ACT_ID = AUX.ACT_ID )
                WHEN MATCHED THEN
                UPDATE
                    SET APU_CHECK_OCULTAR_A = 1
                    , APU_CHECK_OCULTAR_V = 1
                    , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                    , FECHAMODIFICAR = SYSDATE
                    , DD_MTO_A_ID = ( SELECT DD_MTO_ID
                                      FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
                                      WHERE DD_MTO_CODIGO = ''01'' )
                    , DD_EPV_ID = ( SELECT DD_EPV_ID
                                    FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                                    WHERE DD_EPV_CODIGO = ''04'' )
                    , DD_EPA_ID = ( SELECT DD_EPA_ID
                                    FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                                    WHERE DD_EPA_CODIGO = ''04'' )
                WHERE BORRADO = 0
                AND DD_EPA_ID IN ( SELECT DD_EPA_ID
                                    FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                                    WHERE DD_EPA_CODIGO IN ( ''02'', ''03'' ) )
            ';

            EXECUTE IMMEDIATE V_MSQL;

            IF SQL%ROWCOUNT > 0 THEN
                vACTUALIZADO_A := 'S';
            END IF;

            -- Activos en alquiler no publicados:
            V_MSQL := '
            MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                USING ( SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ID = ' || nACT_ID || ' ) AUX
                ON ( ACT.ACT_ID = AUX.ACT_ID )
                WHEN MATCHED THEN
                UPDATE
                    SET APU_CHECK_OCULTAR_A = 1
                    , APU_CHECK_OCULTAR_V = 1
                    , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                    , FECHAMODIFICAR = SYSDATE
                    , DD_MTO_A_ID = ( SELECT DD_MTO_ID
                                      FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
                                      WHERE DD_MTO_CODIGO = ''01'' )
                WHERE BORRADO = 0
                AND DD_EPA_ID IN ( SELECT DD_EPA_ID
                                    FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                                    WHERE DD_EPA_CODIGO = ''01'' )
            ';

            EXECUTE IMMEDIATE V_MSQL;

            IF SQL%ROWCOUNT > 0 THEN
                vACTUALIZADO_A := 'S';
            END IF;

        END IF;

        IF vDD_TCO_CODIGO IN ('01','02') THEN -- Venta

            -- Activos en venta publicados:
            V_MSQL := '
            MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                USING ( SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ID = ' || nACT_ID || ' ) AUX
                ON ( ACT.ACT_ID = AUX.ACT_ID )
                WHEN MATCHED THEN
                UPDATE
                    SET APU_CHECK_OCULTAR_A = 1
                    , APU_CHECK_OCULTAR_V = 1
                    , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                    , FECHAMODIFICAR = SYSDATE
                    , DD_MTO_V_ID = ( SELECT DD_MTO_ID
                                      FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
                                      WHERE DD_MTO_CODIGO = ''01'' )
                    , DD_EPV_ID = ( SELECT DD_EPV_ID
                                    FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                                    WHERE DD_EPV_CODIGO = ''04'' )
                    , DD_EPA_ID = ( SELECT DD_EPA_ID
                                    FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                                    WHERE DD_EPA_CODIGO = ''04'' )
                WHERE BORRADO = 0
                AND DD_EPV_ID IN ( SELECT DD_EPV_ID
                                    FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                                    WHERE DD_EPV_CODIGO IN ( ''02'', ''03'' ) )
            ';

            EXECUTE IMMEDIATE V_MSQL;

            IF SQL%ROWCOUNT > 0 THEN
                vACTUALIZADO_V := 'S';
            END IF;

            -- Activos en venta no publicados:
            V_MSQL := '
            MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                USING ( SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_ID = ' || nACT_ID || ' ) AUX
                ON ( ACT.ACT_ID = AUX.ACT_ID )
                WHEN MATCHED THEN
                UPDATE
                    SET APU_CHECK_OCULTAR_A = 1
                    , APU_CHECK_OCULTAR_V = 1
                    , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                    , FECHAMODIFICAR = SYSDATE
                    , DD_MTO_V_ID = ( SELECT DD_MTO_ID
                                      FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
                                      WHERE DD_MTO_CODIGO = ''01'' )
                WHERE BORRADO = 0
                AND DD_EPV_ID IN ( SELECT DD_EPV_ID
                                    FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                                    WHERE DD_EPV_CODIGO =  ''01'' )
            ';

            EXECUTE IMMEDIATE V_MSQL;

            IF SQL%ROWCOUNT > 0 THEN
                vACTUALIZADO_V := 'S';
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
             , V.CEE_VIGENTE, V.ADECUADO, V.ES_CONDICIONADO_PUBLI
          FROM '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI V'
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
                              , nES_CONDICIONADO;
        EXIT WHEN v_cursor%NOTFOUND;

        vACTUALIZADO_V := 'N';
        vACTUALIZADO_A := 'N';
        vACTUALIZAR_COND := 'S';

        -- Esconde el activo si está en una agrupación asistida vencida:
        IF PLP$ESTA_EN_ASISTIDA_VEN( nACT_ID ) = 1 THEN

         PLP$AGR_ASISTIDAS_ESC_ACT( nACT_ID, vDD_TCO_CODIGO );

        END IF;

        /***********/
        /*Publicado*/
        /***********/

         IF vDD_TCO_CODIGO IN ('02','03') THEN
          IF (vCODIGO_ESTADO_A = '03' AND vCHECK_PUBLICAR_A = 1) THEN
            #ESQUEMA#.SP_MOTIVO_OCULTACION_CONV_CAIXA (nACT_ID, 'A', OutOCULTAR, OutMOTIVO);

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
              ELSE
                PLP$CONDICIONANTE_ALQUILER(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_A, nCEE_VIGENTE, nADECUADO, vUSUARIOMODIFICAR, vCondAlquiler);
              END IF;

            END IF;
          END IF;

        END IF;

        IF vDD_TCO_CODIGO IN ('01','02') THEN
          IF (vCODIGO_ESTADO_V = '03' AND vCHECK_PUBLICAR_V = 1) THEN
            #ESQUEMA#.SP_MOTIVO_OCULTACION_CONV_CAIXA (nACT_ID, 'V', OutOCULTAR, OutMOTIVO);

            IF OutOCULTAR = 1 THEN
           		PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, 'V', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
            	PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '04', vUSUARIOMODIFICAR);
            END IF;

            IF OutOCULTAR = 0 THEN
              IF vCHECK_OCULTAR_V = 1 then
                PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '04', vUSUARIOMODIFICAR);

                IF vDD_MTO_MANUAL_V = 0 THEN
                  PLP$CAMBIO_OCULTO_MOTIVO(nACT_ID, 'V', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
                END IF;
              ELSE
                PLP$CONDICIONANTE_VENTA(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_V, vUSUARIOMODIFICAR);
              END IF;
            END IF;
          END IF;
        END IF;

        /***********/
        /**OCULTAR**/
        /***********/

         IF vDD_TCO_CODIGO IN ('02','03') THEN
          IF vCODIGO_ESTADO_A = '04' THEN
            #ESQUEMA#.SP_MOTIVO_OCULTACION_CONV_CAIXA (nACT_ID, 'A', OutOCULTAR, OutMOTIVO);

            IF OutOCULTAR = 0 AND vDD_MTO_MANUAL_A = 0 THEN
              --PLP$CAMBIO_ESTADO_ALQUILER(nACT_ID, '03', vUSUARIOMODIFICAR);
                PLP$CONDICIONANTE_ALQUILER(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_A, nCEE_VIGENTE, nADECUADO, vUSUARIOMODIFICAR, vCondAlquiler);

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
            #ESQUEMA#.SP_MOTIVO_OCULTACION_CONV_CAIXA (nACT_ID, 'V', OutOCULTAR, OutMOTIVO);

            IF OutOCULTAR = 0 AND vDD_MTO_MANUAL_V = 0 THEN
              --PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '03', vUSUARIOMODIFICAR);
                PLP$CONDICIONANTE_VENTA(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_V, vUSUARIOMODIFICAR);

              PLP$LIMPIAR_VENTA(nACT_ID, vUSUARIOMODIFICAR);
            END IF;

            IF OutOCULTAR = 1 THEN
              IF OutMOTIVO = '03' AND vDD_TAL_CODIGO = '01' THEN /*SI MOTIVO ES ALQUILADO Y TIPO ALQUILER ORDINARIO, NO OCULTAR*/
                IF vDD_MTO_MANUAL_V = 1 THEN /*MOTIVO MANUAL*/
                  NULL;
                ELSE
                  --PLP$CAMBIO_ESTADO_VENTA(nACT_ID, '03', vUSUARIOMODIFICAR);
                    PLP$CONDICIONANTE_VENTA(nACT_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_V, vUSUARIOMODIFICAR);
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
						SET ACT.ES_CONDICONADO_ANTERIOR = '||nES_CONDICIONADO||'
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
		V_MSQL := '
            SELECT SS.DD_TCO_CODIGO, SS.DD_EPV_CODIGO, SS.DD_EPA_CODIGO, SS.MTO_V_COD, SS.MTO_A_COD
                , SS.AHP_CHECK_OCULTAR_V, SS.AHP_CHECK_OCULTAR_A, SS.DD_POR_CODIGO, SS.DD_TPU_CODIGO_V, SS.DD_TPU_CODIGO_A
            FROM (
                SELECT AHP_ID, ACT_ID, TCO.DD_TCO_CODIGO, EPV.DD_EPV_CODIGO, EPA.DD_EPA_CODIGO, MTO_V.DD_MTO_CODIGO AS MTO_V_COD, MTO_A.DD_MTO_CODIGO AS MTO_A_COD
                    , AHP.AHP_CHECK_OCULTAR_V, AHP.AHP_CHECK_OCULTAR_A, POR.DD_POR_CODIGO, TPU_V.DD_TPU_CODIGO AS DD_TPU_CODIGO_V, TPU_A.DD_TPU_CODIGO AS DD_TPU_CODIGO_A
                    , ROW_NUMBER() OVER(
                        PARTITION BY AHP.ACT_ID
                        ORDER BY AHP.AHP_ID
                            DESC) RN
                FROM '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION AHP
                LEFT JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = AHP.DD_TCO_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = AHP.DD_EPV_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = AHP.DD_EPA_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO_V ON MTO_V.DD_MTO_ID = AHP.DD_MTO_V_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO_A ON MTO_A.DD_MTO_ID = AHP.DD_MTO_A_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION TPU_V ON TPU_V.DD_TPU_ID = AHP.DD_TPU_V_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION TPU_A ON TPU_A.DD_TPU_ID = AHP.DD_TPU_A_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_POR_PORTAL POR ON POR.DD_POR_ID = AHP.DD_POR_ID
                WHERE AHP.ACT_ID = '||nACT_ID||'
                    AND AHP.BORRADO = 0) SS
            WHERE RN = 1';
        EXECUTE IMMEDIATE V_MSQL INTO hDD_TCO_CODIGO, hCODIGO_ESTADO_V, hCODIGO_ESTADO_A
            , hDD_MTO_CODIGO_V, hDD_MTO_CODIGO_A, hCHECK_OCULTAR_V, hCHECK_OCULTAR_A, hDD_POR_CODIGO, hDD_TPU_CODIGO_V, hDD_TPU_CODIGO_A;

        V_MSQL := 'SELECT TCO.DD_TCO_CODIGO, EPV.DD_EPV_CODIGO, EPA.DD_EPA_CODIGO, MTO_V.DD_MTO_CODIGO AS MTO_V_COD, MTO_A.DD_MTO_CODIGO AS MTO_A_COD
                , APU.APU_CHECK_OCULTAR_V, APU.APU_CHECK_OCULTAR_A, POR.DD_POR_CODIGO, TPU_V.DD_TPU_CODIGO AS DD_TPU_CODIGO_V, TPU_A.DD_TPU_CODIGO AS DD_TPU_CODIGO_A
            FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
            LEFT JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO_V ON MTO_V.DD_MTO_ID = APU.DD_MTO_V_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO_A ON MTO_A.DD_MTO_ID = APU.DD_MTO_A_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION TPU_V ON TPU_V.DD_TPU_ID = APU.DD_TPU_V_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION TPU_A ON TPU_A.DD_TPU_ID = APU.DD_TPU_A_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_POR_PORTAL POR ON POR.DD_POR_ID = APU.DD_POR_ID
            WHERE APU.ACT_ID = '||nACT_ID||'
                AND APU.BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO fDD_TCO_CODIGO, fCODIGO_ESTADO_V, fCODIGO_ESTADO_A
            , fDD_MTO_CODIGO_V, fDD_MTO_CODIGO_A, fCHECK_OCULTAR_V, fCHECK_OCULTAR_A, fDD_POR_CODIGO, fDD_TPU_CODIGO_V, fDD_TPU_CODIGO_A;

        IF fDD_TCO_CODIGO <> hDD_TCO_CODIGO OR
           fCODIGO_ESTADO_A <> hCODIGO_ESTADO_A OR
           fCHECK_OCULTAR_A <> hCHECK_OCULTAR_A OR
           NVL(fDD_MTO_CODIGO_A, '00') <> NVL(hDD_MTO_CODIGO_A, '00') OR
           fCODIGO_ESTADO_V <> hCODIGO_ESTADO_V OR
           fCHECK_OCULTAR_V <> hCHECK_OCULTAR_V OR
           NVL(fDD_MTO_CODIGO_V, '00') <> NVL(hDD_MTO_CODIGO_V, '00') OR
           NVL(fdd_POR_CODIGO, '00') <> NVL(hDD_POR_CODIGO, '00') OR
		   NVL(fDD_TPU_CODIGO_V, '00') <> NVL(hDD_TPU_CODIGO_V, '00') OR
		   NVL(fDD_TPU_CODIGO_A, '00') <> NVL(hDD_TPU_CODIGO_A, '00')
           THEN

		IF vACTUALIZADO_V = 'S' THEN
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                        SET APU_FECHA_CAMB_PUBL_VENTA = SYSDATE
                            ,USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                            ,FECHAMODIFICAR = SYSDATE
                        WHERE ACT_ID = '||nACT_ID||'
							AND BORRADO = 0
                    ';
          	EXECUTE IMMEDIATE V_MSQL;

        	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION
                        SET AHP_FECHA_FIN_VENTA = SYSDATE
                            ,USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                            ,FECHAMODIFICAR = SYSDATE
                        WHERE (AHP_FECHA_INI_VENTA IS NOT NULL AND AHP_FECHA_FIN_VENTA IS NULL)
                            AND BORRADO = 0
                            AND ACT_ID = '||nACT_ID||'
                    ';
          	EXECUTE IMMEDIATE V_MSQL;

		  	V_MSQL := '
		    	INSERT INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION(AHP_ID,ACT_ID
		                                          ,DD_TPU_A_ID,DD_TPU_V_ID,DD_EPV_ID,DD_EPA_ID,DD_TCO_ID,DD_MTO_V_ID
		                                          ,AHP_MOT_OCULTACION_MANUAL_V,AHP_CHECK_PUBLICAR_V,AHP_CHECK_OCULTAR_V
		                                          ,AHP_CHECK_OCULTAR_PRECIO_V,AHP_CHECK_PUB_SIN_PRECIO_V
		                                          ,DD_MTO_A_ID
		                                          ,AHP_MOT_OCULTACION_MANUAL_A,AHP_CHECK_PUBLICAR_A
		                                          ,AHP_CHECK_OCULTAR_A,AHP_CHECK_OCULTAR_PRECIO_A
		                                          ,AHP_CHECK_PUB_SIN_PRECIO_A
		                                          ,AHP_FECHA_INI_VENTA
                                              	  ,DD_POR_ID
		                                          ,VERSION
		                                          ,USUARIOCREAR,FECHACREAR
		                                          ,BORRADO
		                                          ,ES_CONDICONADO_ANTERIOR)
		    	SELECT  '|| V_ESQUEMA ||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL, ACT_ID
		                                          ,DD_TPU_A_ID
		                                          ,DD_TPU_V_ID
		                                          ,DD_EPV_ID
		                                          ,DD_EPA_ID
		                                          ,DD_TCO_ID
		                                          ,DD_MTO_V_ID
		                                          ,APU_MOT_OCULTACION_MANUAL_V,APU_CHECK_PUBLICAR_V,APU_CHECK_OCULTAR_V
		                                          ,APU_CHECK_OCULTAR_PRECIO_V,APU_CHECK_PUB_SIN_PRECIO_V
		                                          ,DD_MTO_A_ID
		                                          ,APU_MOT_OCULTACION_MANUAL_A,APU_CHECK_PUBLICAR_A
		                                          ,APU_CHECK_OCULTAR_A,APU_CHECK_OCULTAR_PRECIO_A
		                                          ,APU_CHECK_PUB_SIN_PRECIO_A
		                                          ,SYSDATE
                                                  ,DD_POR_ID
		                                          ,VERSION
		                                          ,'''||pUSUARIOMODIFICAR||''' USUARIOCREAR, SYSDATE FECHACREAR
												  ,0 BORRADO
		                                          ,ES_CONDICONADO_ANTERIOR
		      	FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
		       	WHERE BORRADO = 0
		       	AND ACT_ID = '||nACT_ID||'
		            ';
		  	EXECUTE IMMEDIATE V_MSQL;
		END IF;

		IF vACTUALIZADO_A = 'S' THEN
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
                        SET APU_FECHA_CAMB_PUBL_ALQ = SYSDATE
                            ,USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                            ,FECHAMODIFICAR = SYSDATE
                        WHERE ACT_ID = '||nACT_ID||'
							AND BORRADO = 0
                    ';
          	EXECUTE IMMEDIATE V_MSQL;

          	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION
                        SET AHP_FECHA_FIN_ALQUILER = SYSDATE
                            ,USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                            ,FECHAMODIFICAR = SYSDATE
                        WHERE (AHP_FECHA_INI_ALQUILER IS NOT NULL AND AHP_FECHA_FIN_ALQUILER IS NULL)
                            AND BORRADO = 0
                            AND ACT_ID = '||nACT_ID||'
                    ';
          	EXECUTE IMMEDIATE V_MSQL;

			V_MSQL := '
		    	INSERT INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION(AHP_ID,ACT_ID
		                                          ,DD_TPU_A_ID,DD_TPU_V_ID,DD_EPV_ID,DD_EPA_ID,DD_TCO_ID,DD_MTO_V_ID
		                                          ,AHP_MOT_OCULTACION_MANUAL_V,AHP_CHECK_PUBLICAR_V,AHP_CHECK_OCULTAR_V
		                                          ,AHP_CHECK_OCULTAR_PRECIO_V,AHP_CHECK_PUB_SIN_PRECIO_V
		                                          ,DD_MTO_A_ID
		                                          ,AHP_MOT_OCULTACION_MANUAL_A,AHP_CHECK_PUBLICAR_A
		                                          ,AHP_CHECK_OCULTAR_A,AHP_CHECK_OCULTAR_PRECIO_A
		                                          ,AHP_CHECK_PUB_SIN_PRECIO_A
		                                          ,AHP_FECHA_INI_ALQUILER
		                                          ,VERSION
		                                          ,USUARIOCREAR,FECHACREAR
		                                          ,BORRADO
		                                          ,ES_CONDICONADO_ANTERIOR)
		    	SELECT  '|| V_ESQUEMA ||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL, ACT_ID
		                                          ,DD_TPU_A_ID
		                                          ,DD_TPU_V_ID
		                                          ,DD_EPV_ID
		                                          ,DD_EPA_ID
		                                          ,DD_TCO_ID
		                                          ,DD_MTO_V_ID
		                                          ,APU_MOT_OCULTACION_MANUAL_V,APU_CHECK_PUBLICAR_V,APU_CHECK_OCULTAR_V
		                                          ,APU_CHECK_OCULTAR_PRECIO_V,APU_CHECK_PUB_SIN_PRECIO_V
		                                          ,DD_MTO_A_ID
		                                          ,APU_MOT_OCULTACION_MANUAL_A,APU_CHECK_PUBLICAR_A
		                                          ,APU_CHECK_OCULTAR_A,APU_CHECK_OCULTAR_PRECIO_A
		                                          ,APU_CHECK_PUB_SIN_PRECIO_A
		                                          ,SYSDATE
		                                          ,VERSION
		                                          ,'''||pUSUARIOMODIFICAR||''' USUARIOCREAR, SYSDATE FECHACREAR
												  ,0 BORRADO
		                                          ,ES_CONDICONADO_ANTERIOR
		      	FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
		       	WHERE BORRADO = 0
		       	AND ACT_ID = '||nACT_ID||'
		            ';
		  	EXECUTE IMMEDIATE V_MSQL;
		END IF;
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

	END SP_CAMBIO_ESTADO_PUBLICACION_CONV_CAIXA;

/

EXIT;
