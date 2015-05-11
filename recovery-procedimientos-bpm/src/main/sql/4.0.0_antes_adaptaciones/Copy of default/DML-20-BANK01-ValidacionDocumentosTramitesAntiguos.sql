

	SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	BEGIN
	
	UPDATE tap_tarea_procedimiento
   SET tap_script_validacion =
          '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (comprobarExisteDocumentoDSCC() ? null : ''Es necesario adjuntar el documento demanda sellada + certificación de cargas (cuando se obtenga)'')'
 WHERE tap_codigo = 'P01_DemandaCertificacionCargas';
 
update tap_tarea_procedimiento
    set tap_script_validacion = 
        '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (comprobarExisteDocumentoDSO() ? null : ''Es necesario adjuntar el documento demanda sellada'')'
 WHERE TAP_CODIGO = 'P03_InterposicionDemanda';
 
 
update tap_tarea_procedimiento
    set tap_script_validacion = 
        '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (comprobarExisteDocumentoDSV() ? null : ''Es necesario adjuntar el documento demansa sellada'')'
 WHERE TAP_CODIGO = 'P04_InterposicionDemanda';
 
 update tap_tarea_procedimiento
    set tap_script_validacion = 
        'comprobarExisteDocumentoESI() ? null : ''Es necesario adjuntar el documento escrito de insinuación'''
 WHERE TAP_CODIGO = 'P412_regInsinuacionCreditosSup';
 

--Pendiente saber si F común abreviado se implementa en BANKIA
--  update tap_tarea_procedimiento
--    set tap_script_validacion = 
--        'comprobarExisteDocumentoESI() ? null : ''Es necesario adjuntar el documento escrito de insinuación'''
-- WHERE TAP_CODIGO = 'P24_regInsinuacionCreditosSup';
 
 
 
  
  
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