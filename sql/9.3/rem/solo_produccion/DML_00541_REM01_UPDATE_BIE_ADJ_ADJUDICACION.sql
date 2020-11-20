--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8390
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar fecha decreto firme / no firme
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR( 100 CHAR ) := 'BIE_ADJ_ADJUDICACION';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8390'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAMOS VALORES EN TABLA BACKUP');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.BACKUP_REMVIP_8390 (ACT_ID,ACT_NUM_ACTIVO,BIE_ADJ_ID,FECHA_FIRME,FECHA_NO_FIRME)
                SELECT ACT.ACT_ID, AUX.ACT_NUM_ACTIVO, ADJ.BIE_ADJ_ID, ADJ.BIE_ADJ_F_DECRETO_FIRME,ADJ.BIE_ADJ_F_DECRETO_N_FIRME
                FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_8390_1 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
                INNER JOIN '||V_ESQUEMA||'.'||V_TABLA||' ADJ ON ACT.BIE_ID = ADJ.BIE_ID AND ADJ.BORRADO = 0
                WHERE ACT.BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||SQL%ROWCOUNT||' REGISTROS DE AUX_1'); 

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.BACKUP_REMVIP_8390 (ACT_ID,ACT_NUM_ACTIVO,BIE_ADJ_ID,FECHA_FIRME,FECHA_NO_FIRME)
                SELECT ACT.ACT_ID, AUX.ACT_NUM_ACTIVO, ADJ.BIE_ADJ_ID, ADJ.BIE_ADJ_F_DECRETO_FIRME,ADJ.BIE_ADJ_F_DECRETO_N_FIRME
                FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_8390_2 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
                INNER JOIN '||V_ESQUEMA||'.'||V_TABLA||' ADJ ON ACT.BIE_ID = ADJ.BIE_ID AND ADJ.BORRADO = 0
                WHERE ACT.BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||SQL%ROWCOUNT||' REGISTROS DE AUX_2'); 

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR FECHA DECRETO NO FIRME'); 

    V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING(
                    SELECT ADJ.BIE_ADJ_ID, AUX.FECHA_NO_FIRME
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' ADJ 
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.BIE_ID = ADJ.BIE_ID AND ACT.BORRADO = 0
                    INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_8390_2 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
                    WHERE ADJ.BORRADO = 0) T2
                ON (T1.BIE_ADJ_ID = T2.BIE_ADJ_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.BIE_ADJ_F_DECRETO_N_FIRME = TO_DATE(T2.FECHA_NO_FIRME,''DD/MM/YYYY''),		     
                T1.FECHAMODIFICAR = SYSDATE,
                T1.USUARIOMODIFICAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS');  

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR FECHA DECRETO FIRME'); 

    V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING(
                    SELECT ADJ.BIE_ADJ_ID, AUX.FECHA_FIRME
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' ADJ 
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.BIE_ID = ADJ.BIE_ID AND ACT.BORRADO = 0
                    INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_8390_1 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
                    WHERE ADJ.BORRADO = 0) T2
                ON (T1.BIE_ADJ_ID = T2.BIE_ADJ_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.BIE_ADJ_F_DECRETO_N_FIRME = TO_DATE(T2.FECHA_FIRME,''DD/MM/YYYY''),		     
                T1.FECHAMODIFICAR = SYSDATE,
                T1.USUARIOMODIFICAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS');  

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;

END;

/

EXIT
