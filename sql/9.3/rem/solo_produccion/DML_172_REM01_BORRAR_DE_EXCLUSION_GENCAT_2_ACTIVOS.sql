--/*
--##########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20210324
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9266
--## PRODUCTO=NO
--## 
--## Finalidad: CREAR TRAMITE GENCAT
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-9266'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_ACTIVO NUMBER(16) := 7257159;

BEGIN

	--Creación comunicación
    V_MSQL := 'delete from '||V_ESQUEMA||'.act_exg_exclusion_gencat where act_id in (select distinct act_id from '||V_ESQUEMA||'.act_activo where act_num_activo in (7312432,7257159))';
    EXECUTE IMMEDIATE V_MSQL;

    dbms_output.put_line('[INFO] Borrados '||SQL%ROWCOUNT||' registros de act_exg_exclusion_gencat.');
    

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
