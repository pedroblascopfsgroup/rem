--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20211802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8996
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla temporal para cambiar los gestores de GCOM y SCOM
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial SOG
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
V_TABLA VARCHAR2(40 CHAR) := 'AUX_REMVIP_8946_GEE';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
(
		GEE_ID 							NUMBER, 
		USUARIO							VARCHAR2(20 CHAR)
)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  


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
