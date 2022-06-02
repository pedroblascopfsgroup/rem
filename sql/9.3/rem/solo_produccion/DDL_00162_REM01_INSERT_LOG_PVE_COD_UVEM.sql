--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20220516
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-XXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas LOG_PVE_COD_UVEM
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [REMVIP-XXXXX]- DAP
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


CREATE OR REPLACE TRIGGER #ESQUEMA#.CAMBIOS_PVE_COD_UVEM
AFTER INSERT OR UPDATE OF PVE_COD_UVEM OR DELETE ON #ESQUEMA#.ACT_PVE_PROVEEDOR 
FOR EACH ROW

DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_TABLA VARCHAR2(40 CHAR) := 'LOG_PVE_COD_UVEM';
V_TRIGGER VARCHAR2(40 CHAR) := 'CAMBIOS_PVE_COD_UVEM';
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN           
            INSERT INTO #ESQUEMA#.LOG_PVE_COD_UVEM (
                FECHA, 
                USUARIO_SO, 
                NOMBRE_PC, 
                PVE_ID_N , 
                PVE_ID_O,
                PVE_COD_UVEM_N ,
                PVE_COD_UVEM_O ,
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
                FECHABORRAR_O ,
				BORRADO_N,
				BORRADO_O
            )VALUES(
                SYSDATE, 
                SYS_CONTEXT('USERENV', 'OS_USER'), 
                SYS_CONTEXT('USERENV', 'TERMINAL'), 
                :NEW.PVE_ID, 
                :OLD.PVE_ID, 
                :NEW.PVE_COD_UVEM, 
                :OLD.PVE_COD_UVEM,
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
                :OLD.FECHABORRAR,
				:NEW.BORRADO,
				:OLD.BORRADO
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
