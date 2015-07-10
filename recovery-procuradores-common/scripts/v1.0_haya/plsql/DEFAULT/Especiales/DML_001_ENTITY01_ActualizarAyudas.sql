--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar los campos de ayuda de todas las resoluciones (Hay que ejecutar previamente todos los DML de resoluciones).
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(5000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_ENTIDAD#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count2 number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** DD_TR_TIPOS_RESOLUCION ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION... Comprobaciones previas');
	
	V_MSQL := 'UPDATE ' ||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION TIPO SET TIPO.DD_TR_AYUDA = ( 
	    SELECT TFI.TFI_LABEL FROM DD_TR_TIPOS_RESOLUCION TIPOS
	    JOIN BPM_DD_TIN_TIPO_INPUT TIN ON SUBSTR(TIPOS.DD_TR_CODIGO,2) = SUBSTR(TIN.BPM_DD_TIN_CODIGO,2)
	    JOIN BPM_TPI_TIPO_PROC_INPUT TPI ON TIN.BPM_DD_TIN_ID = TPI.BPM_DD_TIN_ID
	    JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TPI.BPM_TPI_NODE_INC = TAP.TAP_CODIGO
	    JOIN TFI_TAREAS_FORM_ITEMS TFI ON TAP.TAP_ID = TFI.TAP_ID AND TFI_NOMBRE LIKE ''titulo''
	    WHERE TIPOS.DD_TR_ID = TIPO.DD_TR_ID AND ROWNUM <= 1
	    )
	WHERE (SELECT TFI.TFI_LABEL FROM DD_TR_TIPOS_RESOLUCION TIPOS
	    JOIN BPM_DD_TIN_TIPO_INPUT TIN ON SUBSTR(TIPOS.DD_TR_CODIGO,2) = SUBSTR(TIN.BPM_DD_TIN_CODIGO,2)
	    JOIN BPM_TPI_TIPO_PROC_INPUT TPI ON TIN.BPM_DD_TIN_ID = TPI.BPM_DD_TIN_ID
	    JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TPI.BPM_TPI_NODE_INC = TAP.TAP_CODIGO
	    JOIN TFI_TAREAS_FORM_ITEMS TFI ON TAP.TAP_ID = TFI.TAP_ID AND TFI_NOMBRE LIKE ''titulo''
	    WHERE TIPOS.DD_TR_ID = TIPO.DD_TR_ID AND ROWNUM <= 1) IS NOT NULL';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION... Actualizando ayudas');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION... OK');

	COMMIT;
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/

EXIT;