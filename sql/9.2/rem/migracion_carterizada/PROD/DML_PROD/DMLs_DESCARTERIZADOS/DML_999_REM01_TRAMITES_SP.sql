--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170719
--## ARTEFACTO=migracion
--## VERSION_ARTEFACTO=2.0.7
--## INCIDENCIA_LINK=HREOS-2366
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración Fase 2, para la generacion de tramites, BPM.
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
 V_USUARIO VARCHAR2(200);
 PL_OUTPUT VARCHAR2(20000);

BEGIN
 V_USUARIO := '#USUARIO_MIGRACION#';
 PL_OUTPUT := NULL;

 REM01.ALTA_BPM_INSTANCES ( V_USUARIO, PL_OUTPUT );
 DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
 COMMIT;
      
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