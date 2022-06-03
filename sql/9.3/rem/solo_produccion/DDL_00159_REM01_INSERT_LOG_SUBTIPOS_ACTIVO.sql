--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220513
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11670
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas LOG_SUBTIPOS_ACTIVO
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [REMVIP-11670]- Alejandra García
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


CREATE OR REPLACE TRIGGER #ESQUEMA#.CAMBIOS_ESTADO_SUBTIPO_ACTIVO
AFTER INSERT OR UPDATE OF DD_SAC_ID OR DELETE ON #ESQUEMA#.ACT_ACTIVO 
FOR EACH ROW

DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_TABLA VARCHAR2(40 CHAR) := 'LOG_SUBTIPOS_ACTIVO';
V_TRIGGER VARCHAR2(40 CHAR) := 'CAMBIOS_ESTADO_SUBTIPO_ACTIVO';
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN           
            INSERT INTO #ESQUEMA#.LOG_SUBTIPOS_ACTIVO (
                FECHA, 
                USUARIO_SO, 
                NOMBRE_PC, 
                ACT_ID_N , 
                ACT_ID_O,
                DD_CRA_ID_N ,
                DD_CRA_ID_O ,
                DD_TPA_ID_N ,
                DD_TPA_ID_O ,
                DD_SAC_ID_N ,
                DD_SAC_ID_O ,
                USUARIOCREAR_N ,
                USUARIOCREAR_O ,
                USUARIOMODIFICAR_N ,
                USUARIOMODIFICAR_O ,
                USUARIOBORRAR_N ,
                USUARIOBORRAR_O ,
                FECHACREAR_N ,
                FECHACREAR_O ,
                FECHAMODIFICAR_N ,
                FECHAMODIFICAR_O ,
                FECHABORRAR_N ,
                FECHABORRAR_O 
            )VALUES(
                SYSDATE, 
                SYS_CONTEXT('USERENV', 'OS_USER'), 
                SYS_CONTEXT('USERENV','TERMINAL'), 
                :NEW.ACT_ID, 
                :OLD.ACT_ID, 
                :NEW.DD_CRA_ID, 
                :OLD.DD_CRA_ID, 
                :NEW.DD_TPA_ID, 
                :OLD.DD_TPA_ID, 
                :NEW.DD_SAC_ID, 
                :OLD.DD_SAC_ID,
                :NEW.USUARIOCREAR, 
                :OLD.USUARIOCREAR, 
                :NEW.USUARIOMODIFICAR, 
                :OLD.USUARIOMODIFICAR, 
                :NEW.USUARIOBORRAR, 
                :OLD.USUARIOBORRAR,
                :NEW.FECHACREAR, 
                :OLD.FECHACREAR, 
                :NEW.FECHAMODIFICAR, 
                :OLD.FECHAMODIFICAR, 
                :NEW.FECHABORRAR, 
                :OLD.FECHABORRAR
            );
 
	
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
