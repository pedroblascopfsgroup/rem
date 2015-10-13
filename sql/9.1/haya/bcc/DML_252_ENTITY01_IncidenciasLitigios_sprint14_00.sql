--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20150802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.7-hy
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Concursos
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
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-900');
	V_TAREA:='H002_CelebracionSubasta';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente información:</p><p style="margin-bottom: 10px">-En el campo Celebrada deberá indicar si la subasta ha sido celebrada o no. </p><p style="margin-bottom: 10px">-En caso de haberse celebrado deberá indicar a través de la pestaña Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados.</p><p style="margin-bottom: 10px">-En la ficha del bien se debe recoger el resultado de la  adjudicación y el valor de la adjudicación.</p><p style="margin-bottom: 10px">-En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá adjuntar el acta de subasta al procedimiento a través de la pestaña "Adjuntos" y anotar la situación final de cada bien en la ficha del bien.</p><p style="margin-bottom: 10px">La siguiente tarea será:</p><p style="margin-bottom: 10px">-En caso de haber uno o más bienes adjudicados a un tercero se lanzará la tarea “Solicitar mandamiento de pago”.</p><p style="margin-bottom: 10px">-En caso de haber uno o más bienes con cesión de remate se lanzará la tarea "Trámite de Cesión de Remate" por cada uno de ellos.</p><p style="margin-bottom: 10px">-En caso de haber uno o más bienes adjudicados a la entidad, se lanzará el "Trámite de Adjudicación" por cada uno de ellos.</p><p style="margin-bottom: 10px">-En caso de suspensión de la subasta deberá indicar dicha circunstancia en el campo “Celebrada”, en el campo “Decisión suspensión” deberá informar quien ha provocado dicha suspensión y en el campo “Motivo suspensión” deberá indicar el motivo por el cual se ha suspendido. Si la suspensión ha sido por parte de la entidad, se lanzará un nuevo trámite de subasta paralizado por 60 días. En caso de no ser necesario realizar una nueva subasta, deberá finalizar el nuevo trámite. Si la suspensión ha sido por motivos de un tercero, se lanzará un nuevo trámite de subasta.</p><p style="margin-bottom: 10px">-En caso de que algún bien haya sido adjudicado a la entidad o con cesión de remate, se lanzará el "Trámite de solvencia patrimonial" para averiguar la solvencia del deudor.</p></div>'' ' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-900');
	
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