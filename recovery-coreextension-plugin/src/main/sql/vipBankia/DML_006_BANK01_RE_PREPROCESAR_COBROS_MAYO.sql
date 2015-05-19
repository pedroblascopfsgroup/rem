--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20150519
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.0.2
--## INCIDENCIA_LINK=BCFI-627
--## PRODUCTO=NO
--##
--## Finalidad: Borrar el preprocesado de los cobros del mes de mayo, y de las fechas de control
--##			para que el batch vuelva a preprocesarlos
--## INSTRUCCIONES: Relanzable.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

whenever sqlerror exit sql.sqlcode;


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
v_seq_count number(3);
v_table_count number(3);
v_schema   VARCHAR(25) := '#ESQUEMA#';
v_schema_MASTER VARCHAR(25) := '#ESQUEMA_MASTER#';
v_constraint_count number(3);
v_sql varchar2(4000);

BEGIN


-- ###############################################################################
DBMS_OUTPUT.PUT_LINE('[START] Borrar cobros preprocesados de MAYO 2015 en adelante');
EXECUTE IMMEDIATE '
	DELETE FROM '||v_schema||'.CPR_COBROS_PAGOS_RECOBRO WHERE CPR_ID IN (
	    SELECT CPR.CPR_ID 
	    FROM '||v_schema||'.CPR_COBROS_PAGOS_RECOBRO CPR
	        JOIN CPA_COBROS_PAGOS CPA ON CPR.CPA_ID = CPA.CPA_ID
	    WHERE CPA.CPA_FECHA_EXTRACCION >= TRUNC(TO_DATE(''01/05/2015'',''DD/MM/YYYY''))
	)
';
DBMS_OUTPUT.PUT_LINE('Borrado cobros preprocesados ... OK');
-- ###############################################################################

-- ###############################################################################
DBMS_OUTPUT.PUT_LINE('[START] Borrar fechas control cobros preprocesados de MAYO 2015 en adelante');
EXECUTE IMMEDIATE '
	DELETE FROM '||v_schema||'.CCR_CONTROL_COBROS_RECOBRO
	WHERE TRUNC(CCR_FECHA) >= TRUNC(TO_DATE(''01/05/2015'',''DD/MM/YYYY''))
';
DBMS_OUTPUT.PUT_LINE('Borrado fechas control cobros preprocesados ... OK');
-- ###############################################################################



EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
          


END;
/

EXIT