--/*
--##########################################
--## AUTOR=ALBERTO RAMÍREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=BKNIVDOS-1586	
--## PRODUCTO=SI
--## Finalidad: Actualizar DD_PTP_PLAZO_SCRIPT de la tabla DD_PTP_PLAZOS_TAREAS_PLAZA que calcula 
--##            la fecha de vencimiento de la tarea P412_RevisarInsinuacionCreditos
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]: ');

DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar PTP de la tarea P412_RevisarInsinuacionCreditos');

-- Valor anterior --> damePlazo(valores['P412_RegistrarPublicacionBOE']['fecha']) + 22*24*60*60*1000L
execute immediate 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS PTP
SET PTP.DD_PTP_PLAZO_SCRIPT = ''((valores[''''P412_RegistrarPublicacionBOE'''']!=null) && (valores[''''P412_RegistrarPublicacionBOE''''][''''fecha'''']!=null)) ? damePlazo(valores[''''P412_RegistrarPublicacionBOE''''][''''fecha''''])+22*24*60*60*1000L : 22*24*60*60*1000L'',
PTP.USUARIOMODIFICAR = ''BKNIV-1586'',
PTP.FECHAMODIFICAR = SYSDATE
WHERE PTP.TAP_ID = ( SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''P412_RevisarInsinuacionCreditos'')';

DBMS_OUTPUT.PUT_LINE('[INFO]: Actualización realizada correctamente');
    
COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT