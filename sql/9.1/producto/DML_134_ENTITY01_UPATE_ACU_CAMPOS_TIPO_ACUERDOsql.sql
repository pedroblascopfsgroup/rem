--/*
--##########################################
--## AUTOR=Alberto b
--## FECHA_CREACION=20151113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-rcj-14
--## INCIDENCIA_LINK=HR-1359
--## PRODUCTO=SI
--##
--## Finalidad: Actualiza los campos de validacion de la tarea  PCO_DecTipoProcAutomatica
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_VIEW CODIGO_GENERACION_CAMPO');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET CODIGO_GENERACION_CAMPO = ''app.creaNumber(''''numExpediente'''', ''''<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numExpediente" text="**Nº expediente" />'''' , '''', {id:''''numExpediente''''});'' WHERE CMP_NOMBRE_CAMPO = ''pagoPrevioFormalizacion''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA ACU_CAMPOS_TIPO_ACUERDO ' );
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET CODIGO_GENERACION_CAMPO = ''app.creaNumber(''''plazosPagosPrevioFormalizacion'''', ''''<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.numeroPagos" text="**Plazos pago previo formalización" />'''' , '''', {id:''''plazosPagosPrevioFormalizacion''''});'' WHERE CMP_NOMBRE_CAMPO = ''plazosPagosPrevioFormalizacion''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA ACU_CAMPOS_TIPO_ACUERDO ' );
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET CODIGO_GENERACION_CAMPO = ''app.creaNumber(''''carencia'''', ''''<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.carencia" text="**Carencia" />'''' , '''', {id:''''carencia''''});'' WHERE CMP_NOMBRE_CAMPO = ''carencia''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA ACU_CAMPOS_TIPO_ACUERDO ' );
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET CODIGO_GENERACION_CAMPO = ''app.creaNumber(''''cuotaAsumible'''', ''''<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.cuaotaAsumible" text="**Cuota asumible cliente" />'''' , '''', {id:''''cuotaAsumible''''});'' WHERE CMP_NOMBRE_CAMPO = ''cuotaAsumible''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA ACU_CAMPOS_TIPO_ACUERDO ' );
    
    COMMIT;
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;