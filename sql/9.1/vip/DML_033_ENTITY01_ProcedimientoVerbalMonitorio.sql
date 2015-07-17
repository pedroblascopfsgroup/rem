--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc02
--## INCIDENCIA_LINK=CMREC-391
--## PRODUCTO=NO
--##
--## Finalidad: Adaptar BPM's Haya-Cajamar
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

	/*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    
    /*
    * CONFIGURACION: TABLAS
    *---------------------------------------------------------------------
    */    
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
	PAR_TABLENAME_TARPR VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';     -- [PARAMETRO] TABLA para tareas del procedimiento. Por defecto TAP_TAREA_PROCEDIMIENTO
    
BEGIN
	
	/* 
	 * UPDATES
	 * -------
	 */
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' tpo SET tpo.DD_TPO_DESCRIPCION = ''P. Verbal desde Monitorio - HCJ'', tpo.DD_TPO_XML_JBPM = ''hcj_procedimientoVerbalDesdeMonitorio'' WHERE tpo.DD_TPO_CODIGO = ''H028''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||PAR_TABLENAME_TARPR||' tap SET tap.TAP_SCRIPT_VALIDACION = ''!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : (comprobarExisteDocumentoEDO() ? null : ''''Es necesario adjuntar el documento Escrito de demanda completo + copia sellada de la demanda'''')'' WHERE tap.TAP_CODIGO = ''H024_InterposicionDemanda''';
    	
   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
	
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
