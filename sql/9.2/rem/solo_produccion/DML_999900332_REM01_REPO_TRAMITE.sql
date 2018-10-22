--/*
--#########################################
--## AUTOR=Ivan Castelló 
--## FECHA_CREACION=20180927
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=REMVIP-2059
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

    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_ESQUEMA VARCHAR2(50 CHAR) := '#ESQUEMA#';
    V_MSQL VARCHAR2(4000 CHAR);
    
BEGIN

   
    REM01.REPOSICIONAMIENTO_TRAMITE('REMVIP-2059','121511','T013_ResultadoPBC',NULL,NULL,PL_OUTPUT);
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE);
      PL_OUTPUT := PL_OUTPUT ||chr(10) || '-----------------------------------------------------------';
      PL_OUTPUT := PL_OUTPUT ||chr(10) || SQLERRM;
      PL_OUTPUT := PL_OUTPUT ||chr(10) || V_MSQL;
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;