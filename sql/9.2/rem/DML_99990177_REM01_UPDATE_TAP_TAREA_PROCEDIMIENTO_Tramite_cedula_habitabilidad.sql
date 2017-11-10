--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20171109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3108
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar Trámite de cedula de habitabilidad
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
        
BEGIN
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T008_ObtencionDocumento'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET TAP_SCRIPT_VALIDACION = ''existeAdjuntoUGValidacion("27","T")'', TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T008_ObtencionDocumento''''][''''comboObtencion''''] == DDSiNo.SI ? ((existeAdjuntoUG("13","T") || existeAdjuntoUG("27","T")) ? null : "Es necesario adjuntar sobre el trabajo el documento Cédula de habitabilidad o bien el Certificado sustitutivo de Cédula de Habitabilidad") : (existeAdjuntoUGValidacion("27","T") ? (valores[''''T008_ObtencionDocumento''''][''''motivoNoObtencion''''] == DDMotivoNoObtencion.NO_CUMPLE_REQUISITOS ? null : null) : "Es necesario adjuntar sobre el trabajo el Certificado sustitutivo de Cédula de Habitabilidad")'', USUARIOMODIFICAR=''HREOS-3108'', FECHAMODIFICAR=SYSDATE WHERE TAP_CODIGO = ''T008_ObtencionDocumento'' ';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tarea T008_ObtencionDocumento.......');
		    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		  
		END IF;
		
		
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