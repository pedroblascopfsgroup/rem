--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190214
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.19
--## INCIDENCIA_LINK=REMVIP-3330
--## PRODUCTO=NO
--## Finalidad: Modificar el procedure para procesar lo necesario despues de que una agrupación de tipo asistida finalice.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/ 
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE REM01.AGR_ASISTIDA_PROCESO_FIN IS

    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    USUARIO VARCHAR2(50 CHAR) := 'AGR_ASISTIDA_PROCESO_FIN';
    V_MSQL VARCHAR2(20000 CHAR);


BEGIN


    --OFERTAS ACTIVAS
    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_OFERTAS_ACTIVAS';
    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.AUX_OFERTAS_ACTIVAS
        SELECT T3.OFR_ID, T1.ACT_ID
        FROM '||V_ESQUEMA||'.ACT_ACTIVO T1
        JOIN '||V_ESQUEMA||'.ACT_OFR T2 ON T1.ACT_ID = T2.ACT_ID
        JOIN '||V_ESQUEMA||'.OFR_OFERTAS T3 ON T3.OFR_ID = T2.OFR_ID AND T3.BORRADO = 0
        JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA T4 ON T4.DD_EOF_ID = T3.DD_EOF_ID AND T4.DD_EOF_CODIGO <> ''02''
        JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T5 ON T5.OFR_ID = T3.OFR_ID AND T5.BORRADO = 0
        JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL T6 ON T6.DD_EEC_ID = T5.DD_EEC_ID AND T6.DD_EEC_CODIGO NOT IN (''02'',''08'',''09'',''12'')
        WHERE T1.BORRADO = 0';

    --PDV CADUCADA (AGRUPACIONES ASISTIDAS) Estos activos se guardan en tabla temporal
    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA';
    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA
        SELECT T1.ACT_ID, T3.AGR_ID, T3.AGR_FECHA_BAJA
        FROM '||V_ESQUEMA||'.ACT_ACTIVO T1
        JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID AND T2.BORRADO = 0
        JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION T3 ON T3.AGR_ID = T2.AGR_ID AND T3.BORRADO = 0
        JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION T4 ON T4.DD_TAG_ID = T3.DD_TAG_ID AND T4.DD_TAG_CODIGO = ''13''
        WHERE T1.BORRADO = 0 AND TRUNC(T3.AGR_FIN_VIGENCIA) < TRUNC(SYSDATE)
        AND T3.AGR_FECHA_BAJA IS NULL
            AND NOT EXISTS(SELECT 1 FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION DD ON DD.DD_TAG_ID = AGR.DD_TAG_ID AND DD.DD_TAG_CODIGO = ''13''
                WHERE T1.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0 AND AGR.AGR_FECHA_BAJA is null AND TRUNC(AGR.AGR_FIN_VIGENCIA) >= TRUNC(SYSDATE))';


    --PDV Vigentes con fecha de vigencia anterior a la del día
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_AGR_AGRUPACION T1
        USING (SELECT T3.AGR_ID
            FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION T3
            JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION T4 ON T4.DD_TAG_ID = T3.DD_TAG_ID AND T4.DD_TAG_CODIGO = ''13''
            WHERE T3.BORRADO = 0 AND T3.AGR_FECHA_BAJA is null AND TRUNC(T3.AGR_FIN_VIGENCIA) < TRUNC(SYSDATE)) AUX
        ON (T1.AGR_ID = AUX.AGR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.AGR_FECHA_BAJA = SYSDATE, T1.FECHAMODIFICAR = SYSDATE, T1.USUARIOMODIFICAR = '''||USUARIO||''' ';

    --(Activos en PDV caducada y PAC_INCLUIDO = 1 sin ofertas en estado activo guardados en tabla temporal)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_ACT_PDVCADU_SINOFR_ACTIVAS';
    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.AUX_ACT_PDVCADU_SINOFR_ACTIVAS
        SELECT DISTINCT T1.ACT_ID
        FROM '||V_ESQUEMA||'.ACT_ACTIVO T1
        left JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID
        JOIN '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA T3 ON T3.ACT_ID = T1.ACT_ID
        LEFT JOIN '||V_ESQUEMA||'.AUX_OFERTAS_ACTIVAS T4 ON T4.ACT_ID = T1.ACT_ID
        WHERE T4.ACT_ID IS NULL and (t2.act_id is null or T2.PAC_INCLUIDO = 1)';

    --Modificar estado comercial
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
        USING (SELECT DISTINCT T1.ACT_ID
            FROM '||V_ESQUEMA||'.AUX_ACT_PDVCADU_SINOFR_ACTIVAS T1
            left JOIN '||V_ESQUEMA||'.ACT_OFR T2 ON T1.ACT_ID = T2.ACT_ID
            left JOIN '||V_ESQUEMA||'.OFR_OFERTAS T3 ON T3.OFR_ID = T2.OFR_ID AND T3.BORRADO = 0
            WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T4
                    JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL T5 ON T5.DD_EEC_ID = T4.DD_EEC_ID AND T5.DD_EEC_CODIGO = ''08''
                    WHERE T3.OFR_ID = T4.OFR_ID)) T2
        ON (ACT.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            ACT.DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''01'')
            , ACT.USUARIOMODIFICAR = '''||USUARIO||''', ACT.FECHAMODIFICAR = SYSDATE
        WHERE ACT.DD_SCM_ID <> (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''01'')';

    --Modificar perímetros de todos los activos pertenecientes a una PDV caducada con una PAC_INCLUIDO = 1 y sin ofertas activas
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
        USING '||V_ESQUEMA||'.AUX_ACT_PDVCADU_SINOFR_ACTIVAS T1
        ON (PAC.ACT_ID = T1.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            PAC.PAC_INCLUIDO = 0, PAC.PAC_CHECK_TRA_ADMISION = 0, PAC.PAC_CHECK_GESTIONAR = 0
            , PAC.PAC_CHECK_ASIGNAR_MEDIADOR = 0, PAC.PAC_CHECK_COMERCIALIZAR = 0, PAC.PAC_CHECK_FORMALIZAR = 0
            , PAC.PAC_FECHA_ASIGNAR_MEDIADOR = SYSDATE, PAC.PAC_FECHA_COMERCIALIZAR = SYSDATE
            , PAC.PAC_FECHA_FORMALIZAR = SYSDATE, PAC.PAC_FECHA_GESTIONAR= SYSDATE, PAC.PAC_FECHA_TRA_ADMISION= SYSDATE
            , PAC.PAC_MOT_EXCL_COMERCIALIZAR = ''Fin de vigencia de PDV'', PAC.PAC_MOTIVO_ASIGNAR_MEDIADOR = ''Fin de vigencia de PDV''
            , PAC.PAC_MOTIVO_FORMALIZAR = ''Fin de vigencia de PDV'', PAC.PAC_MOTIVO_GESTIONAR = ''Fin de vigencia de PDV''
            , PAC.PAC_MOTIVO_TRA_ADMISION = ''Fin de vigencia de PDV'', PAC.FECHAMODIFICAR = SYSDATE
            , PAC.USUARIOMODIFICAR = '''||USUARIO||'''';

    --Modificar el estado de publicación de activos en PDV caducada que no estén ya despublicados.
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
        USING (SELECT DISTINCT ACT_ID
            FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA) T2
        ON (ACT.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            ACT.DD_EPU_ID = (SELECT EPU.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION EPU WHERE EPU.DD_EPU_CODIGO = ''06'')
            , ACT.ACT_FECHA_IND_PUBLICABLE = SYSDATE, ACT.USUARIOMODIFICAR = '''||USUARIO||'''
            , ACT.FECHAMODIFICAR = SYSDATE
        WHERE ACT.DD_EPU_ID <> (SELECT EPU.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION EPU WHERE EPU.DD_EPU_CODIGO = ''06'')';

/*
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP
        USING (SELECT DISTINCT ACT_ID
            FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA) T2
        ON (HEP.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            HEP.HEP_FECHA_HASTA = SYSDATE
          , HEP.USUARIOMODIFICAR = '''||USUARIO||'''
          , HEP.FECHAMODIFICAR = SYSDATE
        WHERE HEP.HEP_FECHA_HASTA IS NULL
          AND HEP.DD_EPU_ID <> (SELECT EPU.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION EPU WHERE EPU.DD_EPU_CODIGO = ''06'')';
*/
    --Insertar una linea en el histórico de publicaciones como despublicado con la fecha del día a todos los que no estén actualmente despublicados

/*
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
        USING (SELECT DISTINCT ACT_ID
                 FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA) T2
        ON (APU.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            APU.DD_EPV_ID = (SELECT EPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV WHERE EPV.DD_EPV_CODIGO = ''04'')
          , APU.DD_EPA_ID = (SELECT EPA.DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA WHERE EPA.DD_EPA_CODIGO = ''04'')
          , APU.APU_MOT_OCULTACION_MANUAL_A = ''Fin vigencia asistida''
          , APU.APU_MOT_OCULTACION_MANUAL_V = ''Fin vigencia asistida''
          , APU.DD_MTO_V_ID = (select dd_mto_id from '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION where DD_MTO_CODIGO = ''12'' and borrado = 0)
		  , APU.DD_MTO_A_ID = (select dd_mto_id from '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION where DD_MTO_CODIGO = ''12'' and borrado = 0)
		  , APU.APU_CHECK_OCULTAR_V = 1
		  , APU.APU_CHECK_OCULTAR_A = 1
          , APU.USUARIOMODIFICAR = '''||USUARIO||'''
          , APU.FECHAMODIFICAR = SYSDATE
        WHERE (APU.DD_EPV_ID <> (SELECT EPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV WHERE EPV.DD_EPV_CODIGO = ''01'')
            OR APU.DD_EPA_ID <> (SELECT EPA.DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA WHERE EPA.DD_EPA_CODIGO = ''01'')
              )
        ';
*/

    /*  13/02/2019 ODP   */
    /*---- Venta -----  */

         /* ACT_PERIMETRO_ACTIVO */

    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
        USING (

                SELECT DISTINCT AUX.ACT_ID
                FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA AUX
                INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                 ON APU.ACT_ID = AUX.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO
                 ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                 ON ACT.ACT_ID = APU.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM
                 ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
                INNER JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV
                 ON APU.DD_EPV_ID = EPV.DD_EPV_ID
                WHERE 1 = 1
                AND TCO.DD_TCO_CODIGO IN ( ''01'', ''02'' )
                AND SCM.DD_SCM_CODIGO <> ''05''
                AND EPV.DD_EPV_CODIGO <> ''01''

               ) T2
        ON (PAC.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            PAC.PAC_CHECK_PUBLICAR      = 0
          , PAC.PAC_CHECK_COMERCIALIZAR = 0
          , PAC.PAC_CHECK_GESTIONAR     = 0
          , PAC.PAC_INCLUIDO            = 0
          , PAC.PAC_CHECK_FORMALIZAR    = 0
          , PAC.USUARIOMODIFICAR = '''||USUARIO||'''
          , PAC.FECHAMODIFICAR = SYSDATE
        WHERE 1 = 1
       ';


         /* ACT_APU_ACTIVO_PUBLICACION */

    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
        USING (

                SELECT DISTINCT AUX.ACT_ID
                FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA AUX
                INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                 ON APU.ACT_ID = AUX.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO
                 ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                 ON ACT.ACT_ID = APU.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM
                 ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
                INNER JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV
                 ON APU.DD_EPV_ID = EPV.DD_EPV_ID
                WHERE 1 = 1
                AND TCO.DD_TCO_CODIGO IN ( ''01'', ''02'' )
                AND SCM.DD_SCM_CODIGO <> ''05''
                AND EPV.DD_EPV_CODIGO <> ''01''

              ) T2
        ON (APU.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            APU.DD_EPV_ID = (SELECT EPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV WHERE EPV.DD_EPV_CODIGO = ''04'')
          , APU.APU_MOT_OCULTACION_MANUAL_V = ''Fin vigencia asistida''
          , APU.DD_MTO_V_ID = (select dd_mto_id from '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION where DD_MTO_CODIGO = ''08'' and borrado = 0)
		  , APU.APU_CHECK_OCULTAR_V = 1
          , APU.APU_FECHA_INI_VENTA = SYSDATE
          , APU.USUARIOMODIFICAR = '''||USUARIO||'''
          , APU.FECHAMODIFICAR = SYSDATE
        WHERE 1 = 1
       ';

         /* CERRAR EL ÚLTIMO REGISTRO HISTÓRICO */
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
        USING (

                SELECT DISTINCT( AHP.AHP_ID )
                FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                INNER JOIN
                ( SELECT MAX( AHP2.AHP_ID ) ID_MAX , ACT_ID
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP2
                    WHERE 1 = 1
                    AND AHP_FECHA_INI_VENTA IS NOT NULL
                    AND BORRADO = 0
                    GROUP BY ACT_ID ) AUX
                   ON (
                            AUX.ACT_ID = AHP.ACT_ID
                        AND AUX.ID_MAX = AHP.AHP_ID
                       )
                INNER JOIN '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA PDV
                 ON PDV.ACT_ID = AHP.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                 ON APU.ACT_ID = AUX.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO
                 ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                 ON ACT.ACT_ID = APU.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM
                 ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
                INNER JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV
                 ON APU.DD_EPV_ID = EPV.DD_EPV_ID
                WHERE 1 = 1
                AND TCO.DD_TCO_CODIGO IN ( ''01'', ''02'' )
                AND SCM.DD_SCM_CODIGO <> ''05''
                AND EPV.DD_EPV_CODIGO <> ''01''
                AND AHP.AHP_FECHA_FIN_VENTA IS NULL

              ) T2
        ON (AHP.AHP_ID = T2.AHP_ID)
        WHEN MATCHED THEN UPDATE SET
            AHP.AHP_FECHA_FIN_VENTA = SYSDATE
          , AHP.USUARIOMODIFICAR = '''||USUARIO||'''
          , AHP.FECHAMODIFICAR = SYSDATE
        WHERE 1 = 1
       ';

    /* AÑADIR REGISTRO AL HISTÓRICO DE VENTA */
    --Caducar el histórico de publicación de todos los activos relacionados con una PDV caducada que no estén actualmente despublicados:
          V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION
                                                (
                                                   AHP_ID,ACT_ID
                                                  ,DD_TPU_V_ID
                                                  ,DD_EPV_ID
                                                  ,DD_TCO_ID
                                                  ,DD_MTO_V_ID
                                                  ,AHP_MOT_OCULTACION_MANUAL_V
                                                  ,AHP_CHECK_PUBLICAR_V
                                                  ,AHP_CHECK_OCULTAR_V
                                                  ,AHP_CHECK_OCULTAR_PRECIO_V
                                                  ,AHP_CHECK_PUB_SIN_PRECIO_V
                                                  ,AHP_FECHA_INI_VENTA
                                                  ,VERSION
                                                  ,USUARIOCREAR
                                                  ,FECHACREAR
                                                  ,BORRADO
                                                  ,ES_CONDICONADO_ANTERIOR
                                                  )
            SELECT  '|| V_ESQUEMA ||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL,
                                                   ACT.ACT_ID
                                                  ,DD_TPU_V_ID
                                                  ,APU.DD_EPV_ID
                                                  ,APU.DD_TCO_ID
                                                  ,DD_MTO_V_ID
                                                  ,APU_MOT_OCULTACION_MANUAL_V
                                                  ,APU_CHECK_PUBLICAR_V
                                                  ,APU_CHECK_OCULTAR_V
                                                  ,APU_CHECK_OCULTAR_PRECIO_V
                                                  ,APU_CHECK_PUB_SIN_PRECIO_V
                                                  ,SYSDATE APU_FECHA_INI_VENTA
                                                  ,1
                                                  ,'''||USUARIO||''' USUARIOCREAR
                                                  , SYSDATE FECHACREAR
                                                  ,0
                                                  , ES_CONDICONADO_ANTERIOR
              FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA AUX
                INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                 ON APU.ACT_ID = AUX.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO
                 ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                 ON ACT.ACT_ID = APU.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM
                 ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
                INNER JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV
                 ON APU.DD_EPV_ID = EPV.DD_EPV_ID
                WHERE 1 = 1
                AND TCO.DD_TCO_CODIGO IN ( ''01'', ''02'' )
                AND SCM.DD_SCM_CODIGO <> ''05''
                AND EPV.DD_EPV_CODIGO <> ''01''
               ';

          EXECUTE IMMEDIATE V_MSQL;



  /*---- Alquiler -----  */

         /* ACT_PERIMETRO_ACTIVO */

    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
        USING (

                SELECT DISTINCT AUX.ACT_ID
                FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA AUX
                INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                 ON APU.ACT_ID = AUX.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO
                 ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                 ON ACT.ACT_ID = APU.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM
                 ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
                INNER JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA
                 ON APU.DD_EPA_ID = EPA.DD_EPA_ID
                WHERE 1 = 1
                AND TCO.DD_TCO_CODIGO IN ( ''02'', ''03'', ''04'' )
                AND SCM.DD_SCM_CODIGO <> ''05''
                AND EPA.DD_EPA_CODIGO <> ''01''

               ) T2
        ON (PAC.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            PAC.PAC_CHECK_PUBLICAR      = 0
          , PAC.PAC_CHECK_COMERCIALIZAR = 0
          , PAC.PAC_CHECK_GESTIONAR     = 0          
    	  , PAC.PAC_INCLUIDO            = 0
          , PAC.PAC_CHECK_FORMALIZAR    = 0

          , PAC.USUARIOMODIFICAR = '''||USUARIO||'''
          , PAC.FECHAMODIFICAR = SYSDATE

        WHERE 1 = 1
       ';

         /* ACT_APU_ACTIVO_PUBLICACION */

    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
        USING (

                SELECT DISTINCT AUX.ACT_ID
                FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA AUX
                INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                 ON APU.ACT_ID = AUX.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO
                 ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                 ON ACT.ACT_ID = APU.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM
                 ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
                INNER JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA
                 ON APU.DD_EPA_ID = EPA.DD_EPA_ID
                WHERE 1 = 1
                AND TCO.DD_TCO_CODIGO IN ( ''02'', ''03'', ''04'' )
                AND SCM.DD_SCM_CODIGO <> ''05''
                AND EPA.DD_EPA_CODIGO <> ''01''

               ) T2
        ON (APU.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            APU.DD_EPA_ID = (SELECT EPA.DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA WHERE EPA.DD_EPA_CODIGO = ''04'')
          , APU.APU_MOT_OCULTACION_MANUAL_A = ''Fin vigencia asistida''
		  , APU.DD_MTO_A_ID = (select dd_mto_id from '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION where DD_MTO_CODIGO = ''08'' and borrado = 0)
		  , APU.APU_CHECK_OCULTAR_A = 1
          , APU.APU_FECHA_INI_ALQUILER = SYSDATE
          , APU.USUARIOMODIFICAR = '''||USUARIO||'''
          , APU.FECHAMODIFICAR = SYSDATE

        WHERE 1 = 1
       ';

         /* CERRAR EL ÚLTIMO REGISTRO HISTÓRICO */

    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
        USING (

                SELECT DISTINCT( AHP.AHP_ID )
                FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                INNER JOIN
                ( SELECT MAX( AHP2.AHP_ID ) ID_MAX , ACT_ID
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP2
                    WHERE 1 = 1
                    AND AHP_FECHA_INI_ALQUILER IS NOT NULL
                    AND BORRADO = 0                    
                    GROUP BY ACT_ID ) AUX
                   ON (
                            AUX.ACT_ID = AHP.ACT_ID
                        AND AUX.ID_MAX = AHP.AHP_ID
                       )
                INNER JOIN '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA PDV
                 ON PDV.ACT_ID = AHP.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                 ON APU.ACT_ID = AUX.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO
                 ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                 ON ACT.ACT_ID = APU.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM
                 ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
                INNER JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA
                 ON APU.DD_EPA_ID = EPA.DD_EPA_ID
                WHERE 1 = 1
                AND TCO.DD_TCO_CODIGO IN ( ''02'', ''03'', ''04'' )
                AND SCM.DD_SCM_CODIGO <> ''05''
                AND EPA.DD_EPA_CODIGO <> ''01''

                AND AHP.AHP_FECHA_FIN_ALQUILER IS NULL

              ) T2
        ON (AHP.AHP_ID = T2.AHP_ID)
        WHEN MATCHED THEN UPDATE SET
            AHP.AHP_FECHA_FIN_ALQUILER = SYSDATE
          , AHP.USUARIOMODIFICAR = '''||USUARIO||'''
          , AHP.FECHAMODIFICAR = SYSDATE
        WHERE 1 = 1
       ';

         /* AÑADIR REGISTRO AL HISTÓRICO DE ALQUILER */
    --Caducar el histórico de publicación de todos los activos relacionados con una PDV caducada que no estén actualmente despublicados:
          V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION
                                                (
                                                   AHP_ID,ACT_ID
                                                  ,DD_TPU_A_ID
                                                  ,DD_EPA_ID
                                                  ,DD_TCO_ID
                                                  ,DD_MTO_A_ID
                                                  ,AHP_MOT_OCULTACION_MANUAL_A
                                                  ,AHP_CHECK_PUBLICAR_A
                                                  ,AHP_CHECK_OCULTAR_A
                                                  ,AHP_CHECK_OCULTAR_PRECIO_A
                                                  ,AHP_CHECK_PUB_SIN_PRECIO_A
                                                  ,AHP_FECHA_INI_ALQUILER
                                                  ,VERSION
                                                  ,USUARIOCREAR
                                                  ,FECHACREAR
                                                  ,BORRADO
                                                  ,ES_CONDICONADO_ANTERIOR
                                                  )
            SELECT  '|| V_ESQUEMA ||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL,
                                                   ACT.ACT_ID
                                                  ,DD_TPU_A_ID
                                                  ,APU.DD_EPA_ID
                                                  ,APU.DD_TCO_ID
                                                  ,DD_MTO_A_ID
                                                  ,APU_MOT_OCULTACION_MANUAL_A
                                                  ,APU_CHECK_PUBLICAR_A
                                                  ,APU_CHECK_OCULTAR_A
                                                  ,APU_CHECK_OCULTAR_PRECIO_A
                                                  ,APU_CHECK_PUB_SIN_PRECIO_A
                                                  ,SYSDATE APU_FECHA_INI_ALQUILER
                                                  ,1
                                                  ,'''||USUARIO||''' USUARIOCREAR
                                                  , SYSDATE FECHACREAR
                                                  ,0
                                                  , ES_CONDICONADO_ANTERIOR
              FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA AUX
                INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                 ON APU.ACT_ID = AUX.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO
                 ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                 ON ACT.ACT_ID = APU.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM
                 ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
                INNER JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA
                 ON APU.DD_EPA_ID = EPA.DD_EPA_ID
                WHERE 1 = 1
                AND TCO.DD_TCO_CODIGO IN ( ''02'', ''03'', ''04'' )
                AND SCM.DD_SCM_CODIGO <> ''05''
                AND EPA.DD_EPA_CODIGO <> ''01''
               ';
          EXECUTE IMMEDIATE V_MSQL;


    /*
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
                                                  ,SYSDATE APU_FECHA_FIN_VENTA
                                                  ,SYSDATE APU_FECHA_FIN_ALQUILER
                                                  ,VERSION
                                                  ,'''||USUARIO||''' USUARIOCREAR, SYSDATE FECHACREAR
                                                  ,USUARIOMODIFICAR,FECHAMODIFICAR
                                                  ,USUARIOBORRAR,FECHABORRAR,BORRADO
                                                  , ES_CONDICONADO_ANTERIOR
              FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
             WHERE APU.BORRADO = 0
               AND EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA AUX WHERE AUX.ACT_ID = APU.ACT_ID)
               AND (APU.DD_EPV_ID <> (SELECT EPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV WHERE EPV.DD_EPV_CODIGO = ''01'')
                 OR APU.DD_EPA_ID <> (SELECT EPA.DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA WHERE EPA.DD_EPA_CODIGO = ''01'')
                   )
                    ';
          EXECUTE IMMEDIATE V_MSQL;
          */

/*    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION
            (HEP_ID, ACT_ID, HEP_FECHA_DESDE, DD_POR_ID, DD_TPU_ID
            , DD_EPU_ID, HEP_MOTIVO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
        WITH ACTIVOS AS (
            SELECT DISTINCT ACT_ID
            FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA)
        SELECT '||V_ESQUEMA||'.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL, T1.ACT_ID, SYSDATE, NULL, NULL
            , T2.DD_EPU_ID, ''Fin vigencia asistida'', 0, '''||USUARIO||''', SYSDATE, 0
        FROM ACTIVOS T1
        JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION T2 ON T2.DD_EPU_ID = ''06''
        WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION AUX WHERE AUX.ACT_ID = T1.ACT_ID AND AUX.HEP_FECHA_HASTA IS NULL AND AUX.DD_EPU_ID = T2.DD_EPU_ID)';
*/
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

END AGR_ASISTIDA_PROCESO_FIN;
/
EXIT
