--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.3.0
--## INCIDENCIA_LINK=HREOS-5358
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial Carlos Lopez HREOS-4074
--##		0.2 Cambio SP_MOTIVO_OCULTACION por SP_MOTIVO_OCULTACION_AGR por fleco Ivan Rubio HREOS-4218
--##		0.3 Cambio SP_MOTIVO_OCULTACION para actualizacion de tipo publicacion.
--##		0.4 Llamada SP_CREAR_AVISO
--##		0.5 Modificado las condiciones alquiler Carles Molins HREOS-4683
--##		0.6 Sergio B HREOS-4931 - Optimización de tiempos
--##		0.7 Oscar Diestre HREOS-5358 - Tratamiento agrupaciones asisitidas vencidas
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 


create or replace PROCEDURE #ESQUEMA#.SP_CAMBIO_ESTADO_PUBLI_AGR (pAGR_ID IN NUMBER DEFAULT NULL
														, pCondAlquiler VARCHAR2 DEFAULT 1
                                                        , pUSUARIOMODIFICAR IN VARCHAR2 DEFAULT 'SP_CAMBIO_EST_PUB_AGR'
                                                        , pHISTORIFICAR IN VARCHAR2 DEFAULT 'N') IS

	  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(20000 CHAR); -- Sentencia a ejecutar 
    vWHERE VARCHAR2(4000 CHAR);

    nAGR_ID           #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.AGR_ID%TYPE;
    vDD_TCO_CODIGO    #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.DD_TCO_CODIGO%TYPE;
    vCODIGO_ESTADO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.CODIGO_ESTADO_A%TYPE;
    vDESC_ESTADO_A    #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.DESC_ESTADO_A%TYPE;
    vCHECK_PUBLICAR_A #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.CHECK_PUBLICAR_A%TYPE;
    vCHECK_OCULTAR_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.CHECK_OCULTAR_A%TYPE;
    vDD_MTO_CODIGO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.DD_MTO_CODIGO_A%TYPE;    
    vDD_MTO_MANUAL_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.DD_MTO_MANUAL_A%TYPE; 
    vCODIGO_ESTADO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.CODIGO_ESTADO_V%TYPE;
    vDESC_ESTADO_V    #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.DESC_ESTADO_V%TYPE;
    vCHECK_PUBLICAR_V #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.CHECK_PUBLICAR_V%TYPE;
    vCHECK_OCULTAR_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.CHECK_OCULTAR_V%TYPE;
    vDD_MTO_CODIGO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.DD_MTO_CODIGO_V%TYPE;
    vDD_MTO_MANUAL_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.DD_MTO_MANUAL_V%TYPE; 
    vDD_TPU_CODIGO_A  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.DD_TPU_CODIGO_A%TYPE;
    vDD_TPU_CODIGO_V  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.DD_TPU_CODIGO_V%TYPE;
    vDD_TAL_CODIGO	  #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.DD_TAL_CODIGO%TYPE;	
    nADMISION         #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.ADMISION%TYPE;
    nGESTION          #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.GESTION%TYPE;
    nINFORME_COMERCIAL #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.INFORME_COMERCIAL%TYPE;
    nPRECIO_A         #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.PRECIO_A%TYPE;
    nPRECIO_V         #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.PRECIO_V%TYPE;
    nCEE_VIGENTE      #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.CEE_VIGENTE%TYPE;
    nADECUADO         #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI_AGR.ADECUADO%TYPE;
    nES_CONDICONADO   #ESQUEMA#.V_CAMBIO_ESTADO_PUBLI.ES_CONDICONADO%TYPE;
    
    hDD_TCO_CODIGO    REM01.V_CAMBIO_ESTADO_PUBLI.DD_TCO_CODIGO%TYPE;  
    hCODIGO_ESTADO_A  REM01.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_A%TYPE;
    hCHECK_OCULTAR_A  REM01.V_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_A%TYPE;
    hDD_MTO_CODIGO_A  REM01.V_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_A%TYPE;
    hDD_TPU_CODIGO_A  REM01.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_A%TYPE;
    hCODIGO_ESTADO_V  REM01.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_V%TYPE;
    hCHECK_OCULTAR_V  REM01.V_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_V%TYPE;
    hDD_MTO_CODIGO_V  REM01.V_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_V%TYPE;
    hDD_TPU_CODIGO_V  REM01.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_V%TYPE;
    hES_CONDICONADO   REM01.V_CAMBIO_ESTADO_PUBLI.ES_CONDICONADO%TYPE;

    fDD_TCO_CODIGO    REM01.V_CAMBIO_ESTADO_PUBLI.DD_TCO_CODIGO%TYPE;  
    fCODIGO_ESTADO_A  REM01.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_A%TYPE;
    fCHECK_OCULTAR_A  REM01.V_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_A%TYPE;
    fDD_MTO_CODIGO_A  REM01.V_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_A%TYPE;
    fDD_TPU_CODIGO_A  REM01.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_A%TYPE;
    fCODIGO_ESTADO_V  REM01.V_CAMBIO_ESTADO_PUBLI.CODIGO_ESTADO_V%TYPE;
    fCHECK_OCULTAR_V  REM01.V_CAMBIO_ESTADO_PUBLI.CHECK_OCULTAR_V%TYPE;
    fDD_MTO_CODIGO_V  REM01.V_CAMBIO_ESTADO_PUBLI.DD_MTO_CODIGO_V%TYPE;
    fDD_TPU_CODIGO_V  REM01.V_CAMBIO_ESTADO_PUBLI.DD_TPU_CODIGO_V%TYPE;
    fES_CONDICONADO   REM01.V_CAMBIO_ESTADO_PUBLI.ES_CONDICONADO%TYPE;
    
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
    
    vQUERY            VARCHAR2(4000 CHAR);
    vQUERY_SINACT     VARCHAR2(4000 CHAR);
    vQUERY_ACTPRIN    VARCHAR2(4000 CHAR);
    V_TABLA_TMP_V VARCHAR2(35 CHAR):= 'TMP_PUBL_AGR';
    

  PROCEDURE PLP$LIMPIAR_ALQUILER(nAGR_ID NUMBER, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
	--V0.2
    V_MSQL := '
      MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
          USING '||vQUERY_SINACT||'
          ON (ACT.ACT_ID = AUX.ACT_ID)
        WHEN MATCHED THEN
          UPDATE
             SET APU_MOT_OCULTACION_MANUAL_A = NULL
               , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
               , FECHAMODIFICAR = SYSDATE
          WHERE BORRADO = 0
              ';

    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT > 0 THEN
      vACTUALIZADO := 'S';
    END IF;
  END;

  PROCEDURE PLP$LIMPIAR_VENTA(nAGR_ID NUMBER, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
    V_MSQL := '
      MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
          USING '||vQUERY_SINACT||'
          ON (ACT.ACT_ID = AUX.ACT_ID)
        WHEN MATCHED THEN
          UPDATE
             SET APU_MOT_OCULTACION_MANUAL_V = NULL
               , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
               , FECHAMODIFICAR = SYSDATE
          WHERE BORRADO = 0
              ';

    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT > 0 THEN
      vACTUALIZADO := 'S';
    END IF;
  END;

  PROCEDURE PLP$CAMBIO_ESTADO_ALQUILER(nAGR_ID NUMBER, pESTADO VARCHAR2, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
    V_MSQL := '
      MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
          USING '||vQUERY_SINACT||'
          ON (ACT.ACT_ID = AUX.ACT_ID)
        WHEN MATCHED THEN
          UPDATE
            SET DD_EPA_ID = (SELECT DD_EPA_ID
                               FROM '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER
                              WHERE BORRADO = 0
                                AND DD_EPA_CODIGO = '''||pESTADO||''')
              , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
              , FECHAMODIFICAR = SYSDATE
          WHERE BORRADO = 0
              ';

    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT > 0 THEN
      vACTUALIZADO := 'S';
    END IF;
  END;

  PROCEDURE PLP$CAMBIO_ESTADO_VENTA(nAGR_ID NUMBER, pESTADO VARCHAR2, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
    V_MSQL := '
      MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
          USING '||vQUERY_SINACT||'
          ON (ACT.ACT_ID = AUX.ACT_ID)
        WHEN MATCHED THEN
          UPDATE
            SET DD_EPV_ID = (SELECT DD_EPV_ID
                               FROM '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA
                              WHERE BORRADO = 0
                                AND DD_EPV_CODIGO = '''||pESTADO||''')
              , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
              , FECHAMODIFICAR = SYSDATE
          WHERE BORRADO = 0
              ';

    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT > 0 THEN
      vACTUALIZADO := 'S';
    END IF;

  END;

  PROCEDURE PLP$CAMBIO_OCULTO_MOTIVO(nAGR_ID NUMBER
									, pTIPO VARCHAR2 /*ALQUILER/VENTA*/
									, pDD_TCO_CODIGO VARCHAR2, pOCULTAR NUMBER, pDD_MTO_CODIGO VARCHAR2, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN
	IF pTIPO = 'A' THEN
		IF pDD_TCO_CODIGO IN ('02','03','04') THEN
    V_MSQL := '
      MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
          USING '||vQUERY_SINACT||'
          ON (ACT.ACT_ID = AUX.ACT_ID)
        WHEN MATCHED THEN
          UPDATE
						SET DD_MTO_A_ID = (SELECT DD_MTO_ID
											 FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
											WHERE BORRADO = 0
											  AND DD_MTO_CODIGO = '''||pDD_MTO_CODIGO||''')
						  , APU_CHECK_OCULTAR_A = '||pOCULTAR||'
						  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE
						  , APU_MOT_OCULTACION_MANUAL_A = NULL
          WHERE BORRADO = 0
						AND (APU_CHECK_OCULTAR_A <> '||pOCULTAR||'
						  OR NVL(DD_MTO_A_ID,-1) <> (SELECT DD_MTO_ID
											  FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
											 WHERE BORRADO = 0
											   AND DD_MTO_CODIGO = '''||pDD_MTO_CODIGO||'''))
              ';

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			vACTUALIZADO := 'S';
		  END IF;

		  IF pDD_MTO_CODIGO = '01' THEN /*No Publicable*/
        V_MSQL := '
          MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
              USING '||vQUERY_SINACT||'
              ON (ACT.ACT_ID = AUX.ACT_ID)
            WHEN MATCHED THEN
              UPDATE
                SET APU_MOT_OCULTACION_MANUAL_A = (SELECT substr(PAC.PAC_MOTIVO_PUBLICAR,1,250)
                                   FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                                  WHERE PAC.ACT_ID = ACT.ACT_ID
                                    AND PAC.BORRADO = 0)
                  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                  , FECHAMODIFICAR = SYSDATE
                  , APU_MOT_OCULTACION_MANUAL_V = NULL
              WHERE BORRADO = 0
                  ';

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
  			  vACTUALIZADO := 'S';
		    END IF;
		  END IF;

		  IF pDD_MTO_CODIGO = '02' THEN /*No Comercializable*/
        V_MSQL := '
          MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
              USING '||vQUERY_SINACT||'
              ON (ACT.ACT_ID = AUX.ACT_ID)
            WHEN MATCHED THEN
              UPDATE
                SET APU_MOT_OCULTACION_MANUAL_A = (SELECT SUBSTR(PAC.PAC_MOT_EXCL_COMERCIALIZAR,1,250)
                                   FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                                  WHERE PAC.ACT_ID = ACT.ACT_ID
                                    AND PAC.BORRADO = 0)
                  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                  , FECHAMODIFICAR = SYSDATE
              WHERE BORRADO = 0
                  ';

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			    vACTUALIZADO := 'S';
		    END IF;
		  END IF;

		  IF pDD_MTO_CODIGO = '04' THEN /*Revisión adecuación*/
        V_MSQL := '
          MERGE INTO '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO ACT
              USING '||vQUERY_SINACT||'
              ON (ACT.ACT_ID = AUX.ACT_ID)
            WHEN MATCHED THEN
              UPDATE
                SET ACT.DD_ADA_ID = (SELECT ADA.DD_ADA_ID
                                       FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER ADA
                                      WHERE ADA.DD_ADA_CODIGO = ''02''/*NO*/
                                        AND ADA.BORRADO = 0)
                  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                  , FECHAMODIFICAR = SYSDATE
              WHERE BORRADO = 0
                  ';

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			    vACTUALIZADO := 'S';
		    END IF;
		  END IF;

		  IF pDD_MTO_CODIGO = '06' THEN /*Revisión Publicación*/
		    vACTUALIZAR_COND := 'N';
		    REM01.SP_CREAR_AVISO (pAGR_ID, 'GPUBL', pUSUARIOMODIFICAR, 'Se ha situado en Oculto Alquiler con motivo Revisión Publicación la agrupación: ', 1);
		  END IF;

		END IF;
	END IF;
	IF pTIPO = 'V' THEN
		IF pDD_TCO_CODIGO IN ('01','02') THEN
        V_MSQL := '
          MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
              USING '||vQUERY_SINACT||'
              ON (ACT.ACT_ID = AUX.ACT_ID)
            WHEN MATCHED THEN
              UPDATE
                SET DD_MTO_V_ID = (SELECT DD_MTO_ID
                           FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
                          WHERE BORRADO = 0
                            AND DD_MTO_CODIGO = '''||pDD_MTO_CODIGO||''')
                  , APU_CHECK_OCULTAR_V = '||pOCULTAR||'
                  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                  , FECHAMODIFICAR = SYSDATE
              WHERE BORRADO = 0
						AND (APU_CHECK_OCULTAR_V <> '||pOCULTAR||'
						  OR NVL(DD_MTO_V_ID,-1) <> (SELECT DD_MTO_ID
											  FROM '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION
											 WHERE BORRADO = 0
											   AND DD_MTO_CODIGO = '''||pDD_MTO_CODIGO||'''))
                  ';

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
		  END IF;

		  IF pDD_MTO_CODIGO = '01' THEN /*No Publicable*/
        V_MSQL := '
          MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
              USING '||vQUERY_SINACT||'
              ON (ACT.ACT_ID = AUX.ACT_ID)
            WHEN MATCHED THEN
              UPDATE
                SET APU_MOT_OCULTACION_MANUAL_V = (SELECT substr(PAC.PAC_MOTIVO_PUBLICAR,1,250)
                                   FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                                  WHERE PAC.ACT_ID = ACT.ACT_ID
                                    AND PAC.BORRADO = 0)
                  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                  , FECHAMODIFICAR = SYSDATE
              WHERE BORRADO = 0
                  ';

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			    vACTUALIZADO := 'S';
		    END IF;
		  END IF;

		  IF pDD_MTO_CODIGO = '02' THEN /*No Comercializable*/
        V_MSQL := '
          MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
              USING '||vQUERY_SINACT||'
              ON (ACT.ACT_ID = AUX.ACT_ID)
            WHEN MATCHED THEN
              UPDATE
                SET APU_MOT_OCULTACION_MANUAL_V = (SELECT SUBSTR(PAC.PAC_MOT_EXCL_COMERCIALIZAR,1,250)
                                   FROM '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                                  WHERE PAC.ACT_ID = ACT.ACT_ID
                                    AND PAC.BORRADO = 0)
                  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                  , FECHAMODIFICAR = SYSDATE
              WHERE BORRADO = 0
                  ';

		    EXECUTE IMMEDIATE V_MSQL;
		    IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
		    END IF;
		  END IF;

		IF pDD_MTO_CODIGO IN ('04') THEN /*Revisión adecuación*/

			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
					SET DD_ADA_ID = (SELECT DDADA.DD_ADA_ID
										 FROM '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER DDADA
										WHERE DDADA.BORRADO = 0
										  AND DDADA.DD_ADA_CODIGO = ''02'')
					  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
					  , FECHAMODIFICAR = SYSDATE
				  WHERE BORRADO = 0
					  ';

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			vACTUALIZADO := 'S';
		  END IF;
		END IF;

		IF pDD_MTO_CODIGO IN ('13') THEN /*Vendido*/
			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
					SET ACT.PAC_CHECK_COMERCIALIZAR = 0
            , ACT.PAC_FECHA_COMERCIALIZAR = SYSDATE
					  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
					  , FECHAMODIFICAR = SYSDATE
				  WHERE ACT.PAC_CHECK_COMERCIALIZAR = 1
					  ';

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
		  END IF;

			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
					SET ACT.PAC_CHECK_FORMALIZAR = 0
            , ACT.PAC_FECHA_FORMALIZAR = SYSDATE
					  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
					  , FECHAMODIFICAR = SYSDATE
				  WHERE ACT.PAC_CHECK_FORMALIZAR = 1
					  ';

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
		  END IF;

			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
					SET ACT.PAC_CHECK_PUBLICAR = 0
            , ACT.PAC_FECHA_PUBLICAR = SYSDATE
					  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
					  , FECHAMODIFICAR = SYSDATE
				  WHERE ACT.PAC_CHECK_PUBLICAR = 1
					  ';

		  EXECUTE IMMEDIATE V_MSQL;
		  IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
		  END IF;
		END IF;

		IF pDD_MTO_CODIGO = '06' THEN /*Revisión Publicación*/
		  vACTUALIZAR_COND := 'N';
		  REM01.SP_CREAR_AVISO (pAGR_ID, 'GPUBL', pUSUARIOMODIFICAR, 'Se ha situado en Oculto Venta con motivo Revisión Publicación la agrupación: ', 1);
		END IF;

	  END IF;
	END IF;

  END;

  PROCEDURE PLP$CONDICIONANTE_VENTA(nAGR_ID NUMBER, pADMISION NUMBER, pGESTION NUMBER, pINFORME_COMERCIAL NUMBER, pPRECIO NUMBER, pUSUARIOMODIFICAR VARCHAR2) IS

  BEGIN

    IF pINFORME_COMERCIAL = 1 THEN
      IF pPRECIO = 1 THEN
        IF pADMISION = 1 AND pGESTION = 1 THEN
          /*PUBLICADO ORDINARIO*/
			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
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
				  WHERE BORRADO = 0
					  ';

          EXECUTE IMMEDIATE V_MSQL;
          IF SQL%ROWCOUNT > 0 THEN
            vACTUALIZADO := 'S';
          END IF;
        ELSE
          /*PUBLICADO FORZADO*/
			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
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
				  WHERE BORRADO = 0
					  ';
          EXECUTE IMMEDIATE V_MSQL;
          IF SQL%ROWCOUNT > 0 THEN
            vACTUALIZADO := 'S';
          END IF;
        END IF;
      ELSE
        /*PRE PUBLICADO ORDINARIO*/
			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
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
				  WHERE BORRADO = 0
					  ';
        EXECUTE IMMEDIATE V_MSQL;
        IF SQL%ROWCOUNT > 0 THEN
          vACTUALIZADO := 'S';
        END IF;
      END IF;
    ELSE
      IF pPRECIO = 1 THEN
        /*PUBLICADO FORZADO*/
			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
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
				  WHERE BORRADO = 0
					  ';
        EXECUTE IMMEDIATE V_MSQL;
        IF SQL%ROWCOUNT > 0 THEN
          vACTUALIZADO := 'S';
        END IF;
      END IF;
    END IF;

  END;

  PROCEDURE PLP$CONDICIONANTE_ALQUILER(nAGR_ID NUMBER, pADMISION NUMBER, pGESTION NUMBER
                                     , pINFORME_COMERCIAL NUMBER, pPRECIO NUMBER
                                     , pCEE_VIGENTE NUMBER, pADECUADO NUMBER
                                     , pUSUARIOMODIFICAR VARCHAR2
                                     , pCondAlquiler VARCHAR2) IS

  BEGIN

IF pINFORME_COMERCIAL = 1 THEN
   IF pPRECIO = 1 THEN
        IF pADMISION = 1 AND pGESTION = 1 THEN
			/*PUBLICADO ORDINARIO*/
			V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						USING '||vQUERY_SINACT||'
							ON (ACT.ACT_ID = AUX.ACT_ID)
							WHEN MATCHED THEN
							UPDATE
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
						WHERE  BORRADO = 0
						';

			EXECUTE IMMEDIATE V_MSQL;
				IF SQL%ROWCOUNT > 0 THEN
					vACTUALIZADO := 'S';
				END IF;
		ELSIF pCEE_VIGENTE = 1 AND pADECUADO = 1 THEN
			/*PUBLICADO FORZADO*/
			V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						USING '||vQUERY_SINACT||'
						ON (ACT.ACT_ID = AUX.ACT_ID)
						WHEN MATCHED THEN
							UPDATE
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
						WHERE  BORRADO = 0
						';

			EXECUTE IMMEDIATE V_MSQL;
				IF SQL%ROWCOUNT > 0 THEN
					vACTUALIZADO := 'S';
				END IF;

		ELSIF pCondAlquiler = 0 THEN
			/*PRE PUBLICADO ORDINARIO*/
			V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
							USING '||vQUERY_SINACT||'
					    	ON (ACT.ACT_ID = AUX.ACT_ID)
					    	WHEN MATCHED THEN
							UPDATE
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
						WHERE  BORRADO = 0
					  ';

			EXECUTE IMMEDIATE V_MSQL;
				IF SQL%ROWCOUNT > 0 THEN
				vACTUALIZADO := 'S';
				END IF;

		ELSIF pCondAlquiler = 1 THEN
				/*PUBLICADO FORZADO*/
				V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
								USING '||vQUERY_SINACT||'
								ON (ACT.ACT_ID = AUX.ACT_ID)
						WHEN MATCHED THEN
							UPDATE
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
							WHERE BORRADO = 0
						';

				EXECUTE IMMEDIATE V_MSQL;
					IF SQL%ROWCOUNT > 0 THEN
					vACTUALIZADO := 'S';
					END IF;
		END IF;

   ELSE
        /*PRE PUBLICADO ORDINARIO*/
        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
					USING '||vQUERY_SINACT||'
					ON (ACT.ACT_ID = AUX.ACT_ID)
					WHEN MATCHED THEN
				  UPDATE
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
                    WHERE BORRADO = 0
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
			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
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
				  WHERE BORRADO = 0
					  ';
			EXECUTE IMMEDIATE V_MSQL;
			IF SQL%ROWCOUNT > 0 THEN
			  vACTUALIZADO := 'S';
			END IF;

		ELSIF pCondAlquiler = 1 THEN
			/*PUBLICADO FORZADO*/
			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
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
				  WHERE BORRADO = 0
					  ';

			EXECUTE IMMEDIATE V_MSQL;
				IF SQL%ROWCOUNT > 0 THEN
				vACTUALIZADO := 'S';
				END IF;
        END IF;
      END IF;
 END IF;

  END;
  
  FUNCTION PLP$ES_ASISTIDA_VEN( nAGR_ID NUMBER ) RETURN NUMBER  IS
   v_cursor_aux    CurTyp;
   sDD_TAG_CODIGO VARCHAR2(50 CHAR);
   dAGR_FIN_VIGENCIA DATE;  
  BEGIN
  
      V_MSQL := ' SELECT TAG.DD_TAG_CODIGO, AGR.AGR_FIN_VIGENCIA
                FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR 
                JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG 
                    ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 
                WHERE 1 = 1
                AND AGR.AGR_ID = ' || nAGR_ID  || ' AND AGR.BORRADO = 0  ';       
  
    OPEN v_cursor_aux FOR V_MSQL;
    FETCH v_cursor_aux INTO sDD_TAG_CODIGO, dAGR_FIN_VIGENCIA;
    CLOSE v_cursor_aux;	
  
     IF sDD_TAG_CODIGO = '13' AND dAGR_FIN_VIGENCIA < SYSDATE THEN
     
      RETURN ( 1 );
      
    ELSE 
    
      RETURN ( 0 );
      
    END IF;
  
  END;


  PROCEDURE PLP$AGR_ASISTIDAS_ESC_ACT( nAGR_ID NUMBER, vDD_TCO_CODIGO VARCHAR2 ) IS
  
  BEGIN
    
    IF PLP$ES_ASISTIDA_VEN( nAGR_ID ) = 1 THEN --Se trata de una agrupación asistida ??
    
        IF vDD_TCO_CODIGO IN ('02','03','04') THEN -- Alquiler
    
            -- Activos en alquiler publicados:
            V_MSQL := '
            MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                USING '||vQUERY_SINACT||'
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
                vACTUALIZADO := 'S';
            END IF;

            -- Activos en alquiler no publicados:
            V_MSQL := '
            MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                USING '||vQUERY_SINACT||'
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
                vACTUALIZADO := 'S';
            END IF;
          
        END IF;

        IF vDD_TCO_CODIGO IN ('01','02') THEN -- Venta

            -- Activos en venta publicados:
            V_MSQL := '
            MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                USING '||vQUERY_SINACT||'
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
                vACTUALIZADO := 'S';
            END IF;

            -- Activos en venta no publicados:
            V_MSQL := '
            MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
                USING '||vQUERY_SINACT||'
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

      IF pAGR_ID IS NOT NULL THEN
        vWHERE := ' WHERE V.AGR_ID='||pAGR_ID;
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
        SELECT DISTINCT
               V.AGR_ID, V.DD_TCO_CODIGO
             , V.CODIGO_ESTADO_A, V.DESC_ESTADO_A, V.CHECK_PUBLICAR_A, V.CHECK_OCULTAR_A, V.DD_MTO_CODIGO_A, V.DD_MTO_MANUAL_A
             , V.CODIGO_ESTADO_V, V.DESC_ESTADO_V, V.CHECK_PUBLICAR_V, V.CHECK_OCULTAR_V, V.DD_MTO_CODIGO_V, V.DD_MTO_MANUAL_V
             , V.DD_TPU_CODIGO_A, V.DD_TPU_CODIGO_V, V.DD_TAL_CODIGO
             , V.ADMISION, V.GESTION
             , V.INFORME_COMERCIAL, V.PRECIO_A, V.PRECIO_V
             , V.CEE_VIGENTE, V.ADECUADO, V.ES_CONDICONADO
          FROM '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI_AGR V'
          ||vWHERE
       ;

     OPEN v_cursor FOR V_MSQL;
      LOOP
        FETCH v_cursor INTO nAGR_ID, vDD_TCO_CODIGO
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

        vQUERY := ' (SELECT AGA.ACT_ID
                       FROM  '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                       JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
                       JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 
                        AND (             
                              (        TAG.DD_TAG_CODIGO = ''02''	/*Restringida*/
                                AND (AGR.AGR_FIN_VIGENCIA IS NULL OR TRUNC(AGR.AGR_FIN_VIGENCIA) >= TRUNC(SYSDATE))
                              )     
                            OR(     TAG.DD_TAG_CODIGO = ''13''	/*Asistida*/
                                AND (TRUNC(AGR.AGR_FIN_VIGENCIA) < TRUNC(SYSDATE))
                                )
                            )                                                        
                      WHERE AGA.ACT_ID = ACT.ACT_ID
                        AND AGA.BORRADO = 0
                        AND AGR.AGR_ID = '||nAGR_ID||'
                   )AUX';
        vQUERY_SINACT :=
                  ' (SELECT AGA.ACT_ID
                       FROM  '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                       JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
                       JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0                        
                        AND (             
                              (        TAG.DD_TAG_CODIGO = ''02''	/*Restringida*/
                                AND (AGR.AGR_FIN_VIGENCIA IS NULL OR TRUNC(AGR.AGR_FIN_VIGENCIA) >= TRUNC(SYSDATE))
                              )     
                            OR(     TAG.DD_TAG_CODIGO = ''13''	/*Asistida*/
                                AND (TRUNC(AGR.AGR_FIN_VIGENCIA) < TRUNC(SYSDATE))
                                )
                            )                                                                                   
                      WHERE AGA.BORRADO = 0
                        AND AGR.AGR_ID = '||nAGR_ID||'
                   )AUX';

        vQUERY_ACTPRIN :=
                  ' (SELECT AGA.ACT_ID
                       FROM  '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                       JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
                       JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 
                        AND (             
                              (        TAG.DD_TAG_CODIGO = ''02''	/*Restringida*/
                                AND (AGR.AGR_FIN_VIGENCIA IS NULL OR TRUNC(AGR.AGR_FIN_VIGENCIA) >= TRUNC(SYSDATE))
                              )     
                            OR(     TAG.DD_TAG_CODIGO = ''13''	/*Asistida*/
                                AND (TRUNC(AGR.AGR_FIN_VIGENCIA) < TRUNC(SYSDATE))
                                )
                            )                                                        
                      WHERE AGA.BORRADO = 0
                        AND AGR.AGR_ID = '||nAGR_ID||'
                        AND AGR.AGR_ACT_PRINCIPAL = AGA.ACT_ID
                   )AUX';

        /**************/
        /*No Publicado*/
        /**************/

        IF vDD_TCO_CODIGO IN ('02','03','04') THEN

          IF vCODIGO_ESTADO_A = '01' THEN

            IF vCHECK_PUBLICAR_A = 1 THEN
              PLP$CONDICIONANTE_ALQUILER(nAGR_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_A, nCEE_VIGENTE, nADECUADO, vUSUARIOMODIFICAR, vCondAlquiler);
            END IF;

          END IF;
        END IF;

        IF vDD_TCO_CODIGO IN ('01','02') THEN

          IF vCODIGO_ESTADO_V = '01' THEN

            IF vCHECK_PUBLICAR_V = 1 THEN
              PLP$CONDICIONANTE_VENTA(nAGR_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_V, vUSUARIOMODIFICAR);
            END IF;

          END IF;
        END IF;


        /***************/
        /*Pre Publicado*/
        /***************/

        IF vDD_TCO_CODIGO IN ('02','03','04') THEN

          IF vCODIGO_ESTADO_A = '02' THEN

            IF vCHECK_PUBLICAR_A = 0 THEN
              PLP$CAMBIO_ESTADO_ALQUILER(nAGR_ID, '01', vUSUARIOMODIFICAR);
              PLP$LIMPIAR_ALQUILER(nAGR_ID, vUSUARIOMODIFICAR);
            END IF;

            IF vCHECK_PUBLICAR_A = 1 AND vCondAlquiler IS NOT NULL THEN
              PLP$CONDICIONANTE_ALQUILER(nAGR_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_A, nCEE_VIGENTE, nADECUADO, vUSUARIOMODIFICAR, vCondAlquiler);
            END IF;

          END IF;
        END IF;

        IF vDD_TCO_CODIGO IN ('01','02') THEN

          IF vCODIGO_ESTADO_V = '02' THEN

            IF vCHECK_PUBLICAR_V = 0 THEN
              PLP$CAMBIO_ESTADO_VENTA(nAGR_ID, '01', vUSUARIOMODIFICAR);
              PLP$LIMPIAR_VENTA(nAGR_ID, vUSUARIOMODIFICAR);
            END IF;

            IF vCHECK_PUBLICAR_V = 1 THEN
              PLP$CONDICIONANTE_VENTA(nAGR_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_V, vUSUARIOMODIFICAR);
            END IF;

          END IF;
        END IF;

        /***********/
        /*Publicado*/
        /***********/

        IF vDD_TCO_CODIGO IN ('02','03','04') THEN
          IF (vCODIGO_ESTADO_A = '03' AND vCHECK_PUBLICAR_A = 1) THEN
            REM01.SP_MOTIVO_OCULTACION_AGR (nAGR_ID, 'A', OutOCULTAR, OutMOTIVO);

            IF OutOCULTAR = 1 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nAGR_ID, 'A', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
              PLP$CAMBIO_ESTADO_ALQUILER(nAGR_ID, '04', vUSUARIOMODIFICAR);
            END IF;

            IF OutOCULTAR = 0 THEN
              IF vCHECK_OCULTAR_A = 1 THEN
                PLP$CAMBIO_ESTADO_ALQUILER(nAGR_ID, '04', vUSUARIOMODIFICAR);
                IF vDD_MTO_MANUAL_A = 0 THEN
                  PLP$CAMBIO_OCULTO_MOTIVO(nAGR_ID, 'A', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
                END IF;
              ELSE
                  PLP$CONDICIONANTE_ALQUILER(nAGR_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_A, nCEE_VIGENTE, nADECUADO, vUSUARIOMODIFICAR, vCondAlquiler);
              END IF;
            END IF;
          END IF;

        END IF;

        IF vDD_TCO_CODIGO IN ('01','02') THEN
          IF (vCODIGO_ESTADO_V = '03' AND vCHECK_PUBLICAR_V = 1) THEN
            REM01.SP_MOTIVO_OCULTACION_AGR (nAGR_ID, 'V', OutOCULTAR, OutMOTIVO);

            IF OutOCULTAR = 1 THEN
              IF OutMOTIVO = '03' AND vDD_TAL_CODIGO = '01' THEN /*SI MOTIVO ES ALQUILADO Y TIPO ALQUILER ORDINARIO, NO OCULTAR*/
                IF vDD_MTO_MANUAL_V = 0 THEN /*MOTIVO AUTOMÁTICO*/
					V_MSQL := '
					  MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
						  USING '||vQUERY_SINACT||'
						  ON (ACT.ACT_ID = AUX.ACT_ID)
						WHEN MATCHED THEN
						  UPDATE
                                SET APU_CHECK_OCULTAR_V = 0
                                  , DD_MTO_V_ID = NULL
                                  , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
                                  , FECHAMODIFICAR = SYSDATE
						  WHERE BORRADO = 0
							  ';
                  EXECUTE IMMEDIATE V_MSQL;

                ELSE
                  PLP$CAMBIO_ESTADO_VENTA(nAGR_ID, '04', vUSUARIOMODIFICAR);
                END IF;
              ELSE
                PLP$CAMBIO_OCULTO_MOTIVO(nAGR_ID, 'V', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
                PLP$CAMBIO_ESTADO_VENTA(nAGR_ID, '04', vUSUARIOMODIFICAR);
              END IF;
            END IF;

            IF OutOCULTAR = 0 THEN
              IF vCHECK_OCULTAR_V = 1 then
                PLP$CAMBIO_ESTADO_VENTA(nAGR_ID, '04', vUSUARIOMODIFICAR);

                IF vDD_MTO_MANUAL_V = 0 THEN
                  PLP$CAMBIO_OCULTO_MOTIVO(nAGR_ID, 'V', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
                END IF;
              ELSE
                 PLP$CONDICIONANTE_VENTA(nAGR_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_V, vUSUARIOMODIFICAR);
              END IF;
            END IF;
          END IF;
        END IF;

        /***********/
        /**OCULTAR**/
        /***********/

        IF vDD_TCO_CODIGO IN ('02','03','04') THEN
          IF vCODIGO_ESTADO_A = '04' THEN
            REM01.SP_MOTIVO_OCULTACION_AGR (nAGR_ID, 'A', OutOCULTAR, OutMOTIVO);

            IF OutOCULTAR = 0 AND vDD_MTO_MANUAL_A = 0 THEN
              --PLP$CAMBIO_ESTADO_ALQUILER(nAGR_ID, '03', vUSUARIOMODIFICAR);
              PLP$CONDICIONANTE_ALQUILER(nAGR_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_A, nCEE_VIGENTE, nADECUADO, vUSUARIOMODIFICAR, vCondAlquiler);
              PLP$LIMPIAR_ALQUILER(nAGR_ID, vUSUARIOMODIFICAR);
            END IF;

            IF OutOCULTAR = 1 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nAGR_ID, 'A', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
            END IF;

            /*Si el activo está oculto por un motivo automático y el proceso
            no encuentra ningún motivo automático hay que quitar la ocultación del activo.*/
            IF vDD_MTO_MANUAL_A = 0 AND OutOCULTAR = 0 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nAGR_ID, 'A', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
            END IF;
          END IF;

        END IF;

        IF vDD_TCO_CODIGO IN ('01','02') THEN
          IF vCODIGO_ESTADO_V = '04' THEN
            REM01.SP_MOTIVO_OCULTACION_AGR (nAGR_ID, 'V', OutOCULTAR, OutMOTIVO);

            IF OutOCULTAR = 0 AND vDD_MTO_MANUAL_V = 0 THEN
              --PLP$CAMBIO_ESTADO_VENTA(nAGR_ID, '03', vUSUARIOMODIFICAR);
              PLP$CONDICIONANTE_VENTA(nAGR_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_V, vUSUARIOMODIFICAR);
              PLP$LIMPIAR_VENTA(nAGR_ID, vUSUARIOMODIFICAR);
            END IF;

            IF OutOCULTAR = 1 THEN
              IF OutMOTIVO = '03' AND vDD_TAL_CODIGO = '01' THEN /*SI MOTIVO ES ALQUILADO Y TIPO ALQUILER ORDINARIO, NO OCULTAR*/
                IF vDD_MTO_MANUAL_V = 1 THEN /*MOTIVO MANUAL*/
                  NULL;
                ELSE
                  --PLP$CAMBIO_ESTADO_VENTA(nAGR_ID, '03', vUSUARIOMODIFICAR);
                  PLP$CONDICIONANTE_VENTA(nAGR_ID, nADMISION, nGESTION, nINFORME_COMERCIAL,nPRECIO_V, vUSUARIOMODIFICAR);
                END IF;
              ELSE
                PLP$CAMBIO_OCULTO_MOTIVO(nAGR_ID, 'V', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
              END IF;
            END IF;

            /*Si el activo está oculto por un motivo automático y el proceso
            no encuentra ningún motivo automático hay que quitar la ocultación del activo.*/
            IF vDD_MTO_MANUAL_V = 0 AND OutOCULTAR = 0 THEN
              PLP$CAMBIO_OCULTO_MOTIVO(nAGR_ID, 'V', vDD_TCO_CODIGO, OutOCULTAR, OutMOTIVO, vUSUARIOMODIFICAR);
            END IF;
          END IF;
        END IF;

        IF vACTUALIZAR_COND = 'S' THEN

			V_MSQL := '
			  MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
				  USING '||vQUERY_SINACT||'
				  ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				  UPDATE
					 SET ACT.ES_CONDICONADO_ANTERIOR = '||nES_CONDICONADO||'
					   , USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
					   , FECHAMODIFICAR = SYSDATE
				  WHERE BORRADO = 0
					  ';
		    EXECUTE IMMEDIATE V_MSQL;

        END IF;
        

        /*******************************************************************************************/
        /*Actualiza los activos de agrupaciones asistidas con fecha vigencia anterior al día actual para esconderlas:*/
        /**************/
        PLP$AGR_ASISTIDAS_ESC_ACT( nAGR_ID, vDD_TCO_CODIGO );        
     
        
        -- Solamente historifica cuando NO sea una agrupación restringida:        
        IF PLP$ES_ASISTIDA_VEN( nAGR_ID ) = 0 THEN -- No es una agrupación asistida ??

        /**************/
        /*HISTORIFICAR*/
        /**************/
        V_MSQL := '
            SELECT SS.DD_TCO_CODIGO, SS.TPU_V_COD, SS.TPU_A_COD, SS.DD_EPV_CODIGO, SS.DD_EPA_CODIGO, SS.MTO_V_COD, SS.MTO_A_COD
                , SS.AHP_CHECK_OCULTAR_V, SS.AHP_CHECK_OCULTAR_A, SS.ES_CONDICONADO_ANTERIOR
            FROM (
                SELECT AHP_ID, ACT_ID, TCO.DD_TCO_CODIGO, TPU_V.DD_TPU_CODIGO AS TPU_V_COD, TPU_A.DD_TPU_CODIGO AS TPU_A_COD, EPV.DD_EPV_CODIGO, EPA.DD_EPA_CODIGO, MTO_V.DD_MTO_CODIGO AS MTO_V_COD, MTO_A.DD_MTO_CODIGO AS MTO_A_COD
                    , ACT.AHP_CHECK_OCULTAR_V, ACT.AHP_CHECK_OCULTAR_A, ACT.ES_CONDICONADO_ANTERIOR
                    , ROW_NUMBER() OVER(
                        PARTITION BY ACT.ACT_ID
                        ORDER BY (CASE
                            WHEN TCO.DD_TCO_CODIGO IN (''01'',''02'')
                            THEN ACT.AHP_FECHA_FIN_VENTA
                            ELSE ACT.AHP_FECHA_FIN_ALQUILER
                            END)
                            DESC NULLS FIRST) RN
                FROM '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION ACT
                JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
                JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = ACT.DD_EPV_ID
                JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = ACT.DD_EPA_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO_V ON MTO_V.DD_MTO_ID = ACT.DD_MTO_V_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO_A ON MTO_A.DD_MTO_ID = ACT.DD_MTO_A_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION TPU_V ON TPU_V.DD_TPU_ID = ACT.DD_TPU_V_ID
                LEFT JOIN '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION TPU_A ON TPU_A.DD_TPU_ID = ACT.DD_TPU_A_ID
                WHERE ACT.ACT_ID = '|| replace(vQUERY_ACTPRIN,'AUX','')||'
                    AND ACT.BORRADO = 0) SS
            WHERE RN = 1';
            
        DBMS_OUTPUT.PUT_LINE( V_MSQL );              
          
        EXECUTE IMMEDIATE V_MSQL INTO hDD_TCO_CODIGO, hDD_TPU_CODIGO_V, hDD_TPU_CODIGO_A, hCODIGO_ESTADO_V, hCODIGO_ESTADO_A
            , hDD_MTO_CODIGO_V, hDD_MTO_CODIGO_A, hCHECK_OCULTAR_V, hCHECK_OCULTAR_A, hES_CONDICONADO;                  

        V_MSQL := 'SELECT TCO.DD_TCO_CODIGO, TPU_V.DD_TPU_CODIGO AS TPU_V_COD, TPU_A.DD_TPU_CODIGO AS TPU_A_COD, EPV.DD_EPV_CODIGO, EPA.DD_EPA_CODIGO, MTO_V.DD_MTO_CODIGO AS MTO_V_COD, MTO_A.DD_MTO_CODIGO AS MTO_A_COD
                , ACT.APU_CHECK_OCULTAR_V, ACT.APU_CHECK_OCULTAR_A, ACT.ES_CONDICONADO_ANTERIOR
            FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
            JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
            JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = ACT.DD_EPV_ID
            JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = ACT.DD_EPA_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO_V ON MTO_V.DD_MTO_ID = ACT.DD_MTO_V_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO_A ON MTO_A.DD_MTO_ID = ACT.DD_MTO_A_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION TPU_V ON TPU_V.DD_TPU_ID = ACT.DD_TPU_V_ID
            LEFT JOIN '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION TPU_A ON TPU_A.DD_TPU_ID = ACT.DD_TPU_A_ID
            WHERE ACT.ACT_ID = '|| replace(vQUERY_ACTPRIN,'AUX','')||'
                AND ACT.BORRADO = 0';
                                
        EXECUTE IMMEDIATE V_MSQL INTO fDD_TCO_CODIGO, fDD_TPU_CODIGO_V, fDD_TPU_CODIGO_A, fCODIGO_ESTADO_V, fCODIGO_ESTADO_A
            , fDD_MTO_CODIGO_V, fDD_MTO_CODIGO_A, fCHECK_OCULTAR_V, fCHECK_OCULTAR_A, fES_CONDICONADO;                            

            DBMS_OUTPUT.PUT_LINE('fDD_TCO_CODIGO: '||fDD_TCO_CODIGO);
            DBMS_OUTPUT.PUT_LINE('hDD_TCO_CODIGO: '||hDD_TCO_CODIGO);
            DBMS_OUTPUT.PUT_LINE('fCODIGO_ESTADO_A: '||fCODIGO_ESTADO_A);
            DBMS_OUTPUT.PUT_LINE('hCODIGO_ESTADO_A: '||hCODIGO_ESTADO_A);
            DBMS_OUTPUT.PUT_LINE('fCHECK_OCULTAR_A: '||fCHECK_OCULTAR_A);
            DBMS_OUTPUT.PUT_LINE('hCHECK_OCULTAR_A: '||hCHECK_OCULTAR_A);
            DBMS_OUTPUT.PUT_LINE('NVL(fDD_MTO_CODIGO_A, ''00''): '||NVL(fDD_MTO_CODIGO_A, '00'));
            DBMS_OUTPUT.PUT_LINE('NVL(hDD_MTO_CODIGO_A, ''00''): '||NVL(hDD_MTO_CODIGO_A, '00'));
            DBMS_OUTPUT.PUT_LINE('NVL(fDD_TPU_CODIGO_A, ''00''): '||NVL(fDD_TPU_CODIGO_A, '00'));
            DBMS_OUTPUT.PUT_LINE('NVL(hDD_TPU_CODIGO_A, ''00''): '||NVL(hDD_TPU_CODIGO_A, '00'));
            DBMS_OUTPUT.PUT_LINE('fCODIGO_ESTADO_V: '||fCODIGO_ESTADO_V);
            DBMS_OUTPUT.PUT_LINE('hCODIGO_ESTADO_V: '||hCODIGO_ESTADO_V);
            DBMS_OUTPUT.PUT_LINE('fCHECK_OCULTAR_V: '||fCHECK_OCULTAR_V);
            DBMS_OUTPUT.PUT_LINE('hCHECK_OCULTAR_V: '||hCHECK_OCULTAR_V);
            DBMS_OUTPUT.PUT_LINE('NVL(fDD_MTO_CODIGO_V, ''00''): '||NVL(fDD_MTO_CODIGO_V, '00'));
            DBMS_OUTPUT.PUT_LINE('NVL(hDD_MTO_CODIGO_V, ''00''): '||NVL(hDD_MTO_CODIGO_V, '00'));
            DBMS_OUTPUT.PUT_LINE('NVL(fDD_TPU_CODIGO_V, ''00''): '||NVL(fDD_TPU_CODIGO_V, '00'));
            DBMS_OUTPUT.PUT_LINE('NVL(hDD_TPU_CODIGO_V, ''00''): '||NVL(hDD_TPU_CODIGO_V, '00'));
            DBMS_OUTPUT.PUT_LINE('fES_CONDICONADO: '||fES_CONDICONADO);
            DBMS_OUTPUT.PUT_LINE('hES_CONDICONADO: '||hES_CONDICONADO);

        IF fDD_TCO_CODIGO <> hDD_TCO_CODIGO OR
           fCODIGO_ESTADO_A <> hCODIGO_ESTADO_A OR
           fCHECK_OCULTAR_A <> hCHECK_OCULTAR_A OR
           NVL(fDD_MTO_CODIGO_A, '00') <> NVL(hDD_MTO_CODIGO_A, '00') OR
           NVL(fDD_TPU_CODIGO_A, '00') <> NVL(hDD_TPU_CODIGO_A, '00') OR
           fCODIGO_ESTADO_V <> hCODIGO_ESTADO_V OR
           fCHECK_OCULTAR_V <> hCHECK_OCULTAR_V OR
           NVL(fDD_MTO_CODIGO_V, '00') <> NVL(hDD_MTO_CODIGO_V, '00') OR
           NVL(fDD_TPU_CODIGO_V, '00') <> NVL(hDD_TPU_CODIGO_V, '00') OR
           fES_CONDICONADO <> hES_CONDICONADO THEN

           DBMS_OUTPUT.PUT_LINE('HA ENTRADO');
           
        IF vACTUALIZADO = 'S' THEN
			IF pHISTORIFICAR = 'S' THEN
	          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION ACT
	                        SET AHP_FECHA_FIN_VENTA = SYSDATE
	                            ,AHP_FECHA_FIN_ALQUILER = SYSDATE
	                            ,USUARIOMODIFICAR = '''||pUSUARIOMODIFICAR||'''
	                            ,FECHAMODIFICAR = SYSDATE
	                        WHERE (AHP_FECHA_FIN_VENTA IS NULL AND AHP_FECHA_FIN_ALQUILER IS NULL)
	                            AND BORRADO = 0
	                            AND EXISTS '|| replace(vQUERY,'AUX','');
	          EXECUTE IMMEDIATE V_MSQL;
			END IF;
			
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
                                                  ,VERSION
                                                  ,USUARIOCREAR,FECHACREAR
                                                  ,USUARIOMODIFICAR,FECHAMODIFICAR
                                                  ,USUARIOBORRAR,FECHABORRAR,BORRADO
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
                                                  ,FECHAMODIFICAR,FECHAMODIFICAR
                                                  ,VERSION
                                                  ,'''||pUSUARIOMODIFICAR||''' USUARIOCREAR, SYSDATE FECHACREAR
                                                  ,USUARIOMODIFICAR,FECHAMODIFICAR
                                                  ,USUARIOBORRAR,FECHABORRAR,BORRADO
                                                  ,ES_CONDICONADO_ANTERIOR
              	FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT
             	WHERE ACT.BORRADO = 0
               	AND EXISTS '|| replace(vQUERY,'AUX','')
                    ;
          	EXECUTE IMMEDIATE V_MSQL;
        END IF;

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

	/*BEGIN
	  REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','ACT_APU_ACTIVO_PUBLICACION');
	  REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','ACT_AHP_HIST_PUBLICACION');
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

	END SP_CAMBIO_ESTADO_PUBLI_AGR;

/
EXIT;
