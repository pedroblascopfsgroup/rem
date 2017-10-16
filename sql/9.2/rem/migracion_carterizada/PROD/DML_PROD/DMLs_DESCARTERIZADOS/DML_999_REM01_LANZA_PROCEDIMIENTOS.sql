--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=2017075
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2318
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

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    DBMS_OUTPUT.PUT_LINE('  [INFO] EJECUTANDO SP_PERFILADO_FUNCIONES...');
    
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('  ############################  SP_PERFILADO_FUNCIONES  ###################################### ');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    REM01.SP_PERFILADO_FUNCIONES;
    
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('  ############################  FIN LOG  ###################################### ');
    DBMS_OUTPUT.PUT_LINE(' ');

    DBMS_OUTPUT.PUT_LINE('  [INFO] EJECUTANDO CALCULO_SINGULAR_RETAIL_AUTO...');
    
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('  ############################  CALCULO_SINGULAR_RETAIL_AUTO  ###################################### ');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    REM01.CALCULO_SINGULAR_RETAIL_AUTO(NULL, '#USUARIO_MIGRACION#', NULL, NULL);
    
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('  ############################  FIN LOG  ###################################### ');
    DBMS_OUTPUT.PUT_LINE(' ');

    DBMS_OUTPUT.PUT_LINE('[FIN]');

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