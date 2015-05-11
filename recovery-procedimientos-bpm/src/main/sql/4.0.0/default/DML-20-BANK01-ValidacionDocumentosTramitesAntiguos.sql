 --/*
 --##########################################
 --## Author: Sergio Hernández
 --## Finalidad: DML de inserción de TAP_TAREA_PROCEDIMIENTO
 --## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
 --## VERSIONES:
 --##        0.1 Versión inicial
 --##########################################
 --*/
 WHENEVER SQLERROR EXIT SQL.SQLCODE;
 SET SERVEROUTPUT ON; 
 SET DEFINE OFF; 
 DECLARE
     V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
     V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
     V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
     V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
     ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
     ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
         
     --Insertando valores en TAP_TAREA_PROCEDIMIENTO
     TYPE T_TAREA IS TABLE OF VARCHAR2(500);
     TYPE T_ARRAY_TAREA IS TABLE OF T_TAREA;
     V_TAREA T_ARRAY_TAREA := T_ARRAY_TAREA(
       T_TAREA('P01_DemandaCertificacionCargas','!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : (comprobarExisteDocumentoDSCC() ? null : ''''Es necesario adjuntar el documento demanda sellada + certificación de cargas (cuando se obtenga)'''')' ), 
       T_TAREA('P03_InterposicionDemanda','!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : (comprobarExisteDocumentoDSO() ? null : ''''Es necesario adjuntar el documento demanda sellada'''')' ), 
       T_TAREA('P04_InterposicionDemanda','!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : (comprobarExisteDocumentoDSV() ? null : ''''Es necesario adjuntar el documento demanda sellada'''')' ), 
       T_TAREA('P412_regInsinuacionCreditosSup','comprobarExisteDocumentoESI() ? null : ''Es necesario adjuntar el documento escrito de insinuación''' ));
     V_TMP_TAREA T_TAREA;
 
 
 BEGIN   
     -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
     DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.TAP_TAREA_PROCEDIMIENTO... Empezando a insertar datos en el diccionario');
     
         FOR I IN V_TAREA.FIRST .. V_TAREA.LAST
       LOOP
       V_TMP_TAREA := V_TAREA(I);
                   
                   V_SQL := 'SELECT COUNT(1) FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TAREA(1))||'''';
                   EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                   -- Si existe la TAREA
                   IF V_NUM_TABLAS = 0 THEN                                
                           DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.TAP_TAREA_PROCEDIMIENTO... No existe la tarea'''|| TRIM(V_TMP_TAREA(1))||'''');
                   ELSE            
                           V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.TAP_TAREA_PROCEDIMIENTO SET tap_script_validacion = '''||TRIM(V_TMP_TAREA(2))||''' WHERE ' ||
                           'TAP_CODIGO = '''||TRIM(V_TMP_TAREA(1))||'''';         
                           DBMS_OUTPUT.PUT_LINE('UPDATEANDO: '||V_TMP_TAREA(1));
                           EXECUTE IMMEDIATE V_MSQL;
                   END IF;
       END LOOP;
     COMMIT;
     DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.TAP_TAREA_PROCEDIMIENTO... Datos del diccionario modificado');
         
 
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