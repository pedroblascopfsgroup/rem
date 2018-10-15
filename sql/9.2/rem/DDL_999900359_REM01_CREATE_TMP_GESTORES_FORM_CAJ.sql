--/*
--######################################### 
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181005
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-2105
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla temporal para cambiar los gestores de SFORM, GFORM y GIAFORM
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
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
V_TABLA VARCHAR2(40 CHAR) := 'TMP_GESTORES_FORM_CAJ';

BEGIN


	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.TMP_GESTORES_FORM_CAJ AS (SELECT TIPO_GESTOR, COD_CARTERA, COD_PROVINCIA, USERNAME FROM REM01.ACT_GES_DIST_GESTORES WHERE COD_CARTERA = 1 AND TIPO_GESTOR IN (''GFORM'',''SFORM'',''GIAFORM''))';

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
