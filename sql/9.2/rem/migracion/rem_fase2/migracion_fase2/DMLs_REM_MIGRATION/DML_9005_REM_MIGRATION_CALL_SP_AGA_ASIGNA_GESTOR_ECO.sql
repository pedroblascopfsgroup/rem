--/*
--#########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20170517
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-1977
--## PRODUCTO=NO
--## 
--## Finalidad: HREOS-1976 - Usar procedure de asignación de gestores para rellenar los huecos faltantes en la asignación de gestores a los expedientes.
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

declare
--v0.3
	V_SQL VARCHAR2(4000);
	V_ESQUEMA VARCHAR2(15 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	p_input1 VARCHAR2(100 char) := 'MIG2_SP';
	p_input2 NUMBER := NULL;
	p_input3 NUMBER := 1;
	v_output1 VARCHAR2(2000);   

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] SE VA A PROCEDER A CREAR LA RELACION DE EXPEDIENTES CON SU GESTOR.');
    
    V_SQL := 'BEGIN '||V_ESQUEMA||'.SP_AGA_ASIGNA_GESTOR_ECO(:p_input1, :v_output, :p_input2, :p_input3); END;';
    
    EXECUTE IMMEDIATE V_SQL 
  	USING IN p_input1, out v_output1, IN p_input2, IN p_input3;

  	DBMS_OUTPUT.PUT_LINE('[OK] - PROCESO FINALIZADO.');


EXCEPTION

    WHEN OTHERS THEN

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);

    ROLLBACK;
    RAISE;

END;

/

EXIT;
 
 
