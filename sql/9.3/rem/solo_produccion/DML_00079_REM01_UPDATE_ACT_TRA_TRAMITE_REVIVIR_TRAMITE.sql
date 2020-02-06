--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6250
--## PRODUCTO=NO
--## 
--## Finalidad: revivir tramite
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(50 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_M VARCHAR2(50 CHAR) := '#ESQUEMA_MASTER#';
    V_EXISTS NUMBER(1);
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6250'; -- USUARIOCREAR/USUARIOMODIFICAR
 
BEGIN

    #ESQUEMA#.ALTA_BPM_INSTANCES(V_USR,PL_OUTPUT);

    COMMIT;


EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(SQLERRM);
        DBMS_OUTPUT.put_line(V_MSQL);
        ROLLBACK;
        RAISE;   
END;
/
EXIT;
