--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-9419
--## PRODUCTO=NO
--## 
--## Finalidad: Posicionamiento de ofertas. Post-Posicionado.
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de ID

    V_TABLA1 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL';  -- Tabla objetivo
    V_TABLA2 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_DETALLE';  -- Tabla objetivo
    V_TABLA3 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_OFR_TAP_EEC';  -- Tabla objetivo
    V_TABLA4 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_RESUMEN';  -- Tabla objetivo
    V_TABLA5 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_LOG';  -- Tabla objetivo
    V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
    V_SENTENCIA VARCHAR2(2000 CHAR);
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] COMIENZA EL PROCESO DE POST-POSICIONAMIENTO DE OFERTAS.');

    execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04003_REM01_MIGDIVARIAN_POST_POSICIONADO][INICIO] COMIENZA DML_04003_REM01_MIGDIVARIAN_POST_POSICIONADO.'' from dual';   
    commit;
/*COMENTAMOS ESTA PARTE PORQUE EN BBVA NO HAY ADVISORY NOTE
    DBMS_OUTPUT.PUT_LINE('[INFO] PASAMOS DE APROBADO(RESERVADO) PDTE PROPIEDAD A APROBADO(RESERVADO) CUANDO TIENE RELLENO EL ADVISORY NOTE.');
    V_MSQL := '
    MERGE INTO ECO_EXPEDIENTE_COMERCIAL TAB USING (
    SELECT DISTINCT 
    ECO.ECO_ID, 
    POS.ECO_FECHA_ENVIO_ADVISORY_NOTE, 
    ECO.DD_EEC_ID,
    DECODE(ECO.DD_EEC_ID,
        (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''36''),--Aprobado Pdte Propiedad
        (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''11''),--Aprobado
            (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''39''),--Reservado Pdte Propiedad
            (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''06'')--Reservado
    ,ECO.DD_EEC_ID) ESTADO_NUEVO
    FROM POSICIONAMIENTO_COMERCIAL POS
    INNER JOIN OFR_OFERTAS OFR
    ON OFR.OFR_COD_DIVARIAN = POS.OFR_COD_OFERTA
    INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
    ON ECO.OFR_ID = OFR.OFR_ID 
    WHERE ECO.DD_EEC_ID IN (
    (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''36''),--Aprobado Pdte Propiedad
    (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''11''),--Aprobado
    (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''39''),--Reservado Pdte Propiedad
    (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''06'')--Reservado
    )
    AND POS.ECO_FECHA_ENVIO_ADVISORY_NOTE IS NOT NULL
    ) TMP
    ON (TMP.ECO_ID = TAB.ECO_ID)
    WHEN MATCHED THEN UPDATE SET
    TAB.DD_EEC_ID = TMP.ESTADO_NUEVO
    WHERE TAB.DD_EEC_ID <> TMP.ESTADO_NUEVO
    ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS.');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] PASAMOS DE APROBADO(RESERVADO) A APROBADO(RESERVADO) PDTE PROPIEDAD CUANDO NO TIENE RELLENO EL ADVISORY NOTE.');
    V_MSQL := '
    MERGE INTO ECO_EXPEDIENTE_COMERCIAL TAB USING (
    SELECT DISTINCT 
    ECO.ECO_ID, 
    POS.ECO_FECHA_ENVIO_ADVISORY_NOTE, 
    ECO.DD_EEC_ID,
    DECODE(ECO.DD_EEC_ID,
        (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''11''),--Aprobado 
        (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''36''),--Aprobado Pdte Propiedad
            (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''06''),--Reservado 
            (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''39'')--Reservado Pdte Propiedad
    ,ECO.DD_EEC_ID) ESTADO_NUEVO
    FROM POSICIONAMIENTO_COMERCIAL POS
    INNER JOIN OFR_OFERTAS OFR
    ON OFR.OFR_COD_DIVARIAN = POS.OFR_COD_OFERTA
    INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
    ON ECO.OFR_ID = OFR.OFR_ID 
    WHERE ECO.DD_EEC_ID IN (
    (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''36''),--Aprobado Pdte Propiedad
    (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''11''),--Aprobado
    (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''39''),--Reservado Pdte Propiedad
    (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''06'')--Reservado
    )
    AND POS.ECO_FECHA_ENVIO_ADVISORY_NOTE IS NULL
    ) TMP
    ON (TMP.ECO_ID = TAB.ECO_ID)
    WHEN MATCHED THEN UPDATE SET
    TAB.DD_EEC_ID = TMP.ESTADO_NUEVO
    WHERE TAB.DD_EEC_ID <> TMP.ESTADO_NUEVO
    ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS.');
    COMMIT;
    --COMENTAMOS ESTA PARTE PORQUE EN BBVA NO HAY ADVISORY NOTE*/
    DBMS_OUTPUT.PUT_LINE('[INFO] PASAMOS DE RESERVADO PDTE PROPIEDAD A APROBADO PDTE PROPIEDAD SI NO HA PASADO OBTENCION CONTRATO RESERVA.');
    V_MSQL := '
    MERGE INTO ECO_EXPEDIENTE_COMERCIAL TAB USING (
    SELECT DISTINCT 
    ECO.ECO_ID, 
    DECODE(POS.RES_FECHA_FIRMA,''N/A'',NULL,POS.RES_FECHA_FIRMA) RES_FECHA_FIRMA, 
    ECO.DD_EEC_ID,
    CASE WHEN DECODE(POS.RES_FECHA_FIRMA,''N/A'',NULL,POS.RES_FECHA_FIRMA) IS NULL THEN (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''36'')
    ELSE (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''39'') END AS ESTADO_NUEVO
    FROM POSICIONAMIENTO_COMERCIAL POS
    INNER JOIN OFR_OFERTAS OFR
    ON OFR.OFR_COD_DIVARIAN = POS.OFR_COD_OFERTA
    INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
    ON ECO.OFR_ID = OFR.OFR_ID 
    WHERE ECO.DD_EEC_ID IN (
    (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''36''),--Aprobado Pdte Propiedad
    (SELECT DD_EEC_ID FROM dd_eec_est_exp_comercial WHERE DD_EEC_CODIGO = ''39'')--Reservado Pdte Propiedad
    )
    ) TMP
    ON (TMP.ECO_ID = TAB.ECO_ID)
    WHEN MATCHED THEN UPDATE SET
    TAB.DD_EEC_ID = TMP.ESTADO_NUEVO
    WHERE TAB.DD_EEC_ID <> TMP.ESTADO_NUEVO
    ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS.');
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[INFO] BORRAMOS (LOGICAMENTE) TAREAS QUE PUEDAN ESTAR DUPLICADAS.');

    execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04003_REM01_MIGDIVARIAN_POST_POSICIONADO][INFO] COMIENZA A BORRAR POSIBLES TAREAS DUPLICADAS.'' from dual';   
    commit;

    execute immediate 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_TAREAS_PARALELAS_DELETE_DUPL';

    v_msql := 'INSERT INTO '||V_ESQUEMA||'.AUX_TAREAS_PARALELAS_DELETE_DUPL (TAR_ID)
    SELECT DISTINCT TAR_ID FROM (
    SELECT
    TAR.TAR_ID, TAC.TRA_ID, TEX.TAP_ID, TAP.TAP_DESCRIPCION, TAR.BORRADO BORRADO_TAR, TAR.TAR_FECHA_FIN, TAR.TAR_TAREA_FINALIZADA, TEX.BORRADO BORRADO_TEX,
    ROW_NUMBER() OVER (PARTITION BY TAC.TRA_ID, TAP.TAP_ID ORDER BY TAR.TAR_ID DESC) ORDEN
    FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
    INNER JOIN '||V_ESQUEMA||'.tex_tarea_externa TEX
    ON TEX.TAR_ID = TAR.TAR_ID
    INNER JOIN '||V_ESQUEMA||'.tac_tareas_activos TAC
    ON TAC.TAR_ID = TAR.TAR_ID
    INNER JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento TAP
    ON TAP.TAP_ID = TEX.TAP_ID
    WHERE TAR.USUARIOCREAR = '''||V_USUARIO||''' AND (TAR.BORRADO = 0 or TEX.BORRADO = 0 or TAR_TAREA_FINALIZADA = 0 or TAR_FECHA_FIN IS NULL)
    ORDER BY TAC.TRA_ID ASC
    )
    WHERE ORDEN <> 1
    ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||SQL%ROWCOUNT||' REGISTROS EN AUX_TAREAS_PARALELAS_DELETE_DUPL.');
    COMMIT;

    v_msql := '
    DELETE FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAR WHERE EXISTS (
        SELECT 1 FROM '||V_ESQUEMA||'.AUX_TAREAS_PARALELAS_DELETE_DUPL PERIMETRO_BORRADO WHERE PERIMETRO_BORRADO.TAR_ID = TAR.TAR_ID
    )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS DE TAC_TAREAS_ACTIVOS DESDE AUX_TAREAS_PARALELAS_DELETE_DUPL.');
    COMMIT;

    v_msql := '
    DELETE FROM '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS TAR WHERE EXISTS (
        SELECT 1 FROM '||V_ESQUEMA||'.AUX_TAREAS_PARALELAS_DELETE_DUPL PERIMETRO_BORRADO WHERE PERIMETRO_BORRADO.TAR_ID = TAR.TAR_ID
    )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS DE DPR_DECISIONES_PROCEDIMIENTOS DESDE AUX_TAREAS_PARALELAS_DELETE_DUPL.');
    COMMIT;

    v_msql := '
    DELETE FROM '||V_ESQUEMA||'.ETN_EXTAREAS_NOTIFICACIONES TAR WHERE EXISTS (
        SELECT 1 FROM '||V_ESQUEMA||'.AUX_TAREAS_PARALELAS_DELETE_DUPL PERIMETRO_BORRADO WHERE PERIMETRO_BORRADO.TAR_ID = TAR.TAR_ID
    )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS DE ETN_EXTAREAS_NOTIFICACIONES DESDE AUX_TAREAS_PARALELAS_DELETE_DUPL.');
    COMMIT;

    v_msql := '
    DELETE FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TAR WHERE EXISTS (
        SELECT 1 FROM '||V_ESQUEMA||'.AUX_TAREAS_PARALELAS_DELETE_DUPL PERIMETRO_BORRADO WHERE PERIMETRO_BORRADO.TAR_ID = TAR.TAR_ID
    )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS DE TEX_TAREA_EXTERNA DESDE AUX_TAREAS_PARALELAS_DELETE_DUPL.');
    COMMIT;

    v_msql := '
    DELETE FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR WHERE EXISTS (
        SELECT 1 FROM '||V_ESQUEMA||'.AUX_TAREAS_PARALELAS_DELETE_DUPL PERIMETRO_BORRADO WHERE PERIMETRO_BORRADO.TAR_ID = TAR.TAR_ID
    )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS DE TAR_TAREAS_NOTIFICACIONES DESDE AUX_TAREAS_PARALELAS_DELETE_DUPL.');
    COMMIT;


    execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04003_REM01_MIGDIVARIAN_POST_POSICIONADO][FIN] FINALIZA DML_04003_REM01_MIGDIVARIAN_POST_POSICIONADO.'' from dual';   
    commit;

    REM01.SP_CALCULO_COMITE_MIG_BBVA('MIG_BBVA');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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
