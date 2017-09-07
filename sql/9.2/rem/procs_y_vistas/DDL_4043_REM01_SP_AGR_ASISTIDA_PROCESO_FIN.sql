--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170907
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.7
--## INCIDENCIA_LINK=HREOS-2766
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

create or replace PROCEDURE AGR_ASISTIDA_PROCESO_FIN IS
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    USUARIO VARCHAR2(50 CHAR) := 'AGR_ASISTIDA_PROCESO_FIN';

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
        WHERE T1.BORRADO = 0 AND TRUNC(T3.AGR_FECHA_BAJA) <= TRUNC(SYSDATE) 
            AND NOT EXISTS(SELECT 1 FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION DD ON DD.DD_TAG_ID = AGR.DD_TAG_ID AND DD.DD_TAG_CODIGO = ''13''
                WHERE T1.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0 AND TRUNC(AGR.AGR_FECHA_BAJA) > TRUNC(SYSDATE))';
    
    --PDV Vigentes con fecha de vigencia anterior a la del día
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_AGR_AGRUPACION T1
        USING (SELECT T3.AGR_ID
            FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION T3
            JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION T4 ON T4.DD_TAG_ID = T3.DD_TAG_ID AND T4.DD_TAG_CODIGO = ''13''
            WHERE T3.BORRADO = 0 AND TRUNC(T3.AGR_FIN_VIGENCIA) < TRUNC(SYSDATE)) AUX
        ON (T1.AGR_ID = AUX.AGR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.AGR_FECHA_BAJA = SYSDATE, T1.FECHAMODIFICAR = SYSDATE, T1.USUARIOMODIFICAR = '''||USUARIO||''' ';
        
    --(Activos en PDV caducada y PAC_INCLUIDO = 1 sin ofertas en estado activo guardados en tabla temporal)
    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.AUX_ACT_PDVCADU_SINOFR_ACTIVAS
        SELECT DISTINCT T1.ACT_ID
        FROM '||V_ESQUEMA||'.ACT_ACTIVO T1
        JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T2 ON T1.ACT_ID = T2.ACT_ID AND T2.PAC_INCLUIDO = 1
        JOIN '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA T3 ON T3.ACT_ID = T1.ACT_ID
        LEFT JOIN '||V_ESQUEMA||'.AUX_OFERTAS_ACTIVAS T4 ON T4.ACT_ID = T1.ACT_ID
        WHERE T4.ACT_ID IS NULL';
    
    --Modificar estado comercial 
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
        USING (SELECT DISTINCT T1.ACT_ID
            FROM '||V_ESQUEMA||'.AUX_ACT_PDVCADU_SINOFR_ACTIVAS T1
            JOIN '||V_ESQUEMA||'.ACT_OFR T2 ON T1.ACT_ID = T2.ACT_ID
            JOIN '||V_ESQUEMA||'.OFR_OFERTAS T3 ON T3.OFR_ID = T2.OFR_ID AND T3.BORRADO = 0
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
    
    --Caducar el histórico de publicación de todos los activos relacionados con una PDV caducada que no estén actualmente despublicados:
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP
        USING (SELECT DISTINCT ACT_ID
            FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA) T2
        ON (HEP.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            HEP.HEP_FECHA_HASTA = SYSDATE, HEP.USUARIOMODIFICAR = '''||USUARIO||'''
            , HEP.FECHAMODIFICAR = SYSDATE
        WHERE HEP.HEP_FECHA_HASTA IS NULL 
            AND HEP.DD_EPU_ID <> (SELECT EPU.DD_EPU_ID FROM DD_EPU_ESTADO_PUBLICACION EPU WHERE EPU.DD_EPU_CODIGO = ''06'')';
    
    --Insertar una linea en el histórico de publicaciones como despublicado con la fecha del día a todos los que no estén actualmente despublicados
    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION 
            (HEP_ID, ACT_ID, HEP_FECHA_DESDE, DD_POR_ID, DD_TPU_ID
            , DD_EPU_ID, HEP_MOTIVO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
        WITH ACTIVOS AS (
            SELECT DISTINCT ACT_ID
            FROM '||V_ESQUEMA||'.AUX_ACTIVOS_PDV_CADUCADA)
        SELECT '||V_ESQUEMA||'.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL, T1.ACT_ID, SYSDATE, NULL, NULL
            , T2.DD_EPU_ID, ''Fin vigencia asistida'', 0, '''||USUARIO||''', SYSDATE, 0
        FROM ACTIVOS T1
        JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION T2 ON T2.DD_EPU_ID = ''06''';

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