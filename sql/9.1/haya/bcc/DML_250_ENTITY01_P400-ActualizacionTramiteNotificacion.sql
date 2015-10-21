--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150930
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-829
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite de posesión interina
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    
    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.

    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'P400'; -- Código de procedimiento para reemplazar
    
BEGIN		
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''!todosNotificados() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe notificar todos los demandados o excluirlos.</div>'''' : dameNumNotificadosNoEdictoNoExcluidos() != dameNumDocumentosTipo(''''ACUREC'''') ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Se deben adjuntar tantos documentos "Acuse de recibo" como demandados no excluidos y no notificados por edicto existan.</div>'''' : null'' WHERE TAP_CODIGO = ''P400_GestionarNotificaciones''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea P400_GestionarNotificaciones actualizada.');

	/*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
    /*
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
 
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