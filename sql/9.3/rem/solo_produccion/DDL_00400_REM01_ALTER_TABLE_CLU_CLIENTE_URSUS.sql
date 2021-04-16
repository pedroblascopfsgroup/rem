--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20210416
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9312
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla temporal para cambiar los gestores de GCOM y SCOM
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

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLA VARCHAR2(40 CHAR) := 'CLU_CLIENTE_URSUS';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY(CLU_ESTADO_CIVIL_ACTUAL VARCHAR2(50 CHAR))'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' MODIFICADA');  


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
