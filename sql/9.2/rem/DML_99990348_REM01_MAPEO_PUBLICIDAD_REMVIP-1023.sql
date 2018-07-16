--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180716
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=REMVIP-1023
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de mapeo en ETG_EQV
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'DD_ETG_EQV_TIPO_GASTO_RU'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1023'; -- Vble. para indicar el trabajo que solicita la acción.
    
    TYPE T_ACCION IS TABLE OF VARCHAR2(250 CHAR);
                                  --SUBTIPO_GASTO --TIPO_PROVEEDOR --DESC_TIPO_GASTO                 --COGRUG_POS --COTACA_POS --COSBAC_POS --DESC_TIPO_GASTO_NEG --COGRUG_NEG --COTACA_NEG --COSBAC_NEG
    V_ACCION T_ACCION := T_ACCION('88'            ,'IS NULL'       ,'PUBLICIDAD ACTIVOS ADJUDICADOS' ,'3'         ,'48'        ,'7'         ,NULL               ,'NULL'      ,'NULL'      ,'NULL');

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
        USING (
            SELECT DD_ETG_ID
            FROM '||V_ESQUEMA||'.'||V_TABLA||' ETG
            JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = ETG.DD_STG_ID AND STG.DD_TGA_ID = ETG.DD_TGA_ID
                AND STG.DD_STG_CODIGO = '''||V_ACCION(1)||'''
            WHERE ETG.DD_TPR_ID '||V_ACCION(2)||'
            ) T2
        ON (T1.DD_ETG_ID = T2.DD_ETG_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
            , T1.DD_ETG_DESCRIPCION_POS = '''||V_ACCION(3)||''', T1.DD_ETG_DESCRIPCION_LARGA_POS = '''||V_ACCION(3)||'''
            , T1.COGRUG_POS = '||V_ACCION(4)||', T1.COTACA_POS = '||V_ACCION(5)||', T1.COSBAC_POS = '||V_ACCION(6)||'
            , T1.DD_ETG_DESCRIPCION_NEG = '''||V_ACCION(7)||''', T1.DD_ETG_DESCRIPCION_LARGA_NEG = '''||V_ACCION(7)||'''
            , T1.COGRUG_NEG = '||V_ACCION(8)||', T1.COTACA_NEG = '||V_ACCION(9)||', T1.COSBAC_NEG = '||V_ACCION(10)||'';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] Actualizada/s '||NVL(SQL%ROWCOUNT,0)||' fila en tabla de mapeo '||V_TABLA||'.');
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    COMMIT;

 
EXCEPTION
    WHEN OTHERS THEN
        ERR_NUM := SQLCODE;
        ERR_MSG := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
        DBMS_OUTPUT.PUT_LINE(ERR_MSG);
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        ROLLBACK;
        RAISE;   
END;
/
EXIT;