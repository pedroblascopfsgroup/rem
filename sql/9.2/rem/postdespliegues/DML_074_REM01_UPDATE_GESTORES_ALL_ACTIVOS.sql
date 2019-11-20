--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20190709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7039
--## PRODUCTO=NO
--## Finalidad: Ejecucon del procedimiento almacenado que asigna Gestores de todos los tipos.
--##           
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial 
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(4000 CHAR);
    V_NUM NUMBER(16);
    V_COUNT_1 NUMBER(16) := 0;
    V_COUNT_GES NUMBER(16) := 0;

    V_USUARIO VARCHAR2(200);
    PL_OUTPUT VARCHAR2(2000);
    P_ACT_ID NUMBER;
    P_ALL_ACTIVOS NUMBER;
    P_CLASE_ACTIVO VARCHAR2(200);

BEGIN
    V_USUARIO := 'HREOS-7039';
    P_ACT_ID := NULL;
    P_ALL_ACTIVOS := NULL;
    P_CLASE_ACTIVO := '02';

    #ESQUEMA#.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3(V_USUARIO => V_USUARIO, PL_OUTPUT => PL_OUTPUT, P_ACT_ID => P_ACT_ID, P_ALL_ACTIVOS => P_ALL_ACTIVOS, P_CLASE_ACTIVO => P_CLASE_ACTIVO);

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado los gestores de '||SQL%ROWCOUNT||' activos');

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecucion: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL || CHR(10);
        ROLLBACK;
        RAISE;
END SP_AGA_ASIGNA_GESTOR_ACTIVO_V3;
/
EXIT;
