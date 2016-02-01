--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20151217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc34
--## INCIDENCIA_LINK=CMREC-1237
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de incidencias de concursos
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

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-1237');
	V_TAREA:='H009_RevisarInsinuacionCreditos';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
	' TAP_SCRIPT_VALIDACION_JBPM=''valores[''''H009_RevisarInsinuacionCreditos''''][''''comboRectificacion'''']==DDSiNo.SI && valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos'''']==null ? ''''Debe indicar el n&uacute;mero de cr&eacute;ditos rectificados.'''' : valores[''''H009_RevisarInsinuacionCreditos''''][''''comboRectificacion'''']==DDSiNo.SI && valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos'''']!=null && noExistenTantosCreditosInsinuados(valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos'''']) ? ''''El n&uacute;mero de cr&eacute;ditos rectificados no puede ser mayor al n&uacute;mero de cr&eacute;ditos insinuados.'''' : null'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-1237');
	
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