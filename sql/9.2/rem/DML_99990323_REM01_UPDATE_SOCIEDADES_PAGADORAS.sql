--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180227
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.14
--## INCIDENCIA_LINK=REMVIP-86
--## PRODUCTO=NO
--## 
--## Finalidad: 
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

    V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';             --REM01
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';   --REMMASTER
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-86';
    V_TABLA VARCHAR2(40 CHAR) := 'ACT_PRO_PROPIETARIOS';
    V_SENTENCIA VARCHAR2(2000 CHAR);
    V_COUNT NUMBER(10) := 0;
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    --(PRO_CODIGO_UVEM, PRO_SOCIEDAD_PAGADORA)
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA(1,900),
        T_TIPO_DATA(11,900),
        T_TIPO_DATA(15,900),
        T_TIPO_DATA(16,900),
        T_TIPO_DATA(18,900),
        T_TIPO_DATA(21,21),
        T_TIPO_DATA(38,900),
        T_TIPO_DATA(45,900),
        T_TIPO_DATA(48,900),
        T_TIPO_DATA(49,900),
        T_TIPO_DATA(56,900),
        T_TIPO_DATA(57,900),
        T_TIPO_DATA(59,900),
        T_TIPO_DATA(67,900),
        T_TIPO_DATA(69,900),
        T_TIPO_DATA(77,900),
        T_TIPO_DATA(80,900),
        T_TIPO_DATA(81,900),
        T_TIPO_DATA(82,900),
        T_TIPO_DATA(83,900),
        T_TIPO_DATA(85,900),
        T_TIPO_DATA(86,900),
        T_TIPO_DATA(99,990),
        T_TIPO_DATA(9991,9991),
        T_TIPO_DATA(9999,5074)); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
                EXECUTE IMMEDIATE 'UPDATE REM01.ACT_PRO_PROPIETARIO 
                    SET PRO_SOCIEDAD_PAGADORA = '||V_TMP_TIPO_DATA(2)||', USUARIOMODIFICAR = ''REMVIP-86'', FECHAMODIFICAR = SYSDATE
                    WHERE PRO_CODIGO_UVEM = '||V_TMP_TIPO_DATA(1)||' AND NVL(PRO_SOCIEDAD_PAGADORA,''0'') <> '||V_TMP_TIPO_DATA(2);
            V_COUNT := V_COUNT + SQL%ROWCOUNT;
        END LOOP;

    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_COUNT||' sociedades pagadoras actualizadas.');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT;
