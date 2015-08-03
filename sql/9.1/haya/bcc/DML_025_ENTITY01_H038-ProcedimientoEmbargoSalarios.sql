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

BEGIN
	
	/* 
	 * UPDATES
	 * -------
	 */
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' tpo SET tpo.DD_TPO_DESCRIPCION = ''T. de Embargo de Salarios - HCJ'', tpo.DD_TPO_XML_JBPM = ''hcj_tramiteEmbargoSalarios'' WHERE tpo.DD_TPO_CODIGO = ''H038''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboRequerido''''] == DDSiNo.SI) && ((valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboResultado''''] == '''''''')||(valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboResultado''''] == null)||(valores[''''H038_ConfirmarRequerimientoResultado''''][''''importeNom''''] == '''''''')||(valores[''''H038_ConfirmarRequerimientoResultado''''][''''importeRet''''] == '''''''')) )?''''tareaExterna.error.H038_ConfirmarRequerimientoResultado.importesYresultado'''':null''  WHERE TAP_CODIGO = ''H038_ConfirmarRequerimientoResultado''';
    
    	
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
