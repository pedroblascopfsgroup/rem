--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=20150918
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.5-hcj
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Litigios
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-603');
	V_TAREA:='H015_RegistrarSolicitudPosesion';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deber&aacute; de haber un bien vinculado al procedimiento, esto podr&aacute; comprobarlo a trav&eacute;s de la pestaña Bienes del procedimiento, en caso de no haberlo, a trav&eacute;s de esa misma pestaña dispone de la opci&oacute;n de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; de informar si hay una posible posesi&oacute;n o no. En caso de que no sea posible la posesión deber&aacute; anotar si existe un contrato de arrendamiento v&aacute;lido vinculado al bien. En caso de que proceda, la fecha de solicitud de la posesi&oacute;n, si el bien se encuentra ocupado o no, si se ha producido una petici&oacute;n de moratoria y en cualquier caso se deber&aacute; informar la condici&oacute;n del bien respecto a si es vivienda habitual o no.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y dependiendo de la informaci&oacute;n registrada se lanzar&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber solicitud de moratoria de posesi&oacute;n se iniciar&aacute; el tr&aacute;mite para tal efecto.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien con ocupantes, se lanzar&aacute; el tr&aacute;mite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien sin ocupantes, se lanzar&aacute; la tarea "Registrar señalamiento de la posesi&oacute;n".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que haya indicado que existe un contrato v&aacute;lido, se lanzar&aacute; la tarea Confirmar notificaci&oacute;n deudor.</li><li style="margin-bottom: 10px; margin-left: 35px;">En el caso de que el bien no est&eacute; en ninguna de las situaciones expuestas y no haya una posible posesi&oacute;n, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li></ul></div>'' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-603');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-603');
	V_TAREA:='H002_SolicitarSuspenderSubasta';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''valores[''''H002_ObtenerValidacionComite''''] != null ? valores[''''H002_ObtenerValidacionComite''''][''''comboMotivo''''] : null'' WHERE TFI_NOMBRE = ''comboMotivo'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TAREA ||''')';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-603');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-786');
	V_TAREA:='H036_CelebracionSubasta';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''H036_CelebracionSubasta''''][''''celebrada''''] == DDSiNo.NO ? ''''SUSPENDIDA'''' : (dameEntidadAdjudicatariaBien() != '''''''' ? (bienConCesionRemate() ? ''''ADJUDICACICONCESION'''' : ''''ADJUDICACIONSINCESION'''') : ''''TERCEROS'''')'' WHERE TAP_CODIGO='''|| V_TAREA ||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-786');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-638');
	V_TAREA:='H058_EstConformidadOAlegacion';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''valores[''''H058_ObtencionAvaluo''''] != null && valores[''''H058_ObtencionAvaluo''''][''''fecha''''] != null ? comprobarExisteDocumentoTVAPJ() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para continuar debe adjuntar al procedimiento el documento de "Tasaci&oacute;n de verificaci&oacute;n del aval&uacute;o realizado por perito judicial (Valoraci&oacute;n de Bienes Inmuebles)"</div>'''' : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe completar la tarea Obtenci&oacute;n aval&uacute;o antes de continuar</div>'''''' WHERE TAP_CODIGO = '''|| V_TAREA ||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-638');
	
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