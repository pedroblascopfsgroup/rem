--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.14-hy-rc01
--## INCIDENCIA_LINK=HR-1327
--## PRODUCTO=NO
--## Finalidad: DML para actualizar el script de validación de la tarea H007_TasacionCostas
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
   
BEGIN
	
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(new BigDecimal(valores[''''H007_TasacionCostas''''][''''cuantiaLetrado''''])) > (damePrincipal() * 5 / 100) ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Las costas del letrado no pueden superar el 5% del principal</div>'''' : null''' ||
			  ' WHERE TAP_CODIGO = ''H007_TasacionCostas''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el script de validación de la tarea H007_TasacionCostas');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Script de validación de la tarea actualizado.');
     
   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]');
	
EXCEPTION
     
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT; 
