--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20171213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3404
--## PRODUCTO=NO
--## 
--## Finalidad: HREOS-3404 - Usar EL PROCEDURE QUE ACTUALIZA LA SITUACIÓN COMERCIAL A LOS ACTIVOS SIN SITUACIÓN COMERCIAL
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

----PARAMETROS DEL SP
--ID_ACTIVO -> Podemos ejecutar el proceso sobre un Activo en concreto (ACT_ID),
--             o por contra, si no indicamos nada, o indicamos '0', el perímetro se extiende a todos los activos.
--ACTUALIZAR -> Si marcamos '1', ademas de informar la tabla TMP_ACT_SCM, se actualizara la tabla ACT_ACTIVO. Si marcamos '0' solo se informara.

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

declare
--v0.3
	V_SQL VARCHAR2(4000);
	V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
	p_input1 NUMBER := 0; -- ID_ACTIVO( 0: Todos los activos sin Sit. Comercial,
									 -- X: 'X' representa el ACT_ID del activo sin Sit. Comercial a informar/actualizar)
	p_input2 NUMBER := 1;-- ACTUALIZAR( 0: Solo informa, 
									 -- 1: Modifica)

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] SE VA A PROCEDER A LANZAR EL PROCESO QUE ACTUALIZA LA SITUACIÓN COMERCIAL A LOS ACTIVOS SIN SITUACIÓN COMERCIAL');
    
    V_SQL := 'BEGIN '||V_ESQUEMA||'.SP_ASC_ACT_SIT_COM_VACIOS(:p_input1, :p_input2); END;';
    
    EXECUTE IMMEDIATE V_SQL 
  	USING IN p_input1, IN p_input2;

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