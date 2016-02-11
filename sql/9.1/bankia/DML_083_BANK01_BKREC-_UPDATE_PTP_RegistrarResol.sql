--/*
--##########################################
--## AUTOR=Óscar
--## FECHA_CREACION=20160105
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.19-bk
--## INCIDENCIA_LINK=BKREC-
--## PRODUCTO=NO
--## Finalidad: DML
--## 
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
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
    
    V_NUM1 NUMBER(20); -- Vble. auxiliar
    V_NUM2 NUMBER(20); -- Vble. auxiliar
    V_NUM3 NUMBER(20); -- Vble. auxiliar
    V_NUM4 NUMBER(20); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

     --/**
    -- * Modificación de DD_PTP_PLAZOS_TAREAS_PLAZAS, del campo DD_PTP_PLAZO_SCRIPT para la tarea P419_RegistrarResolucion
    -- */
    
    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS ptp WHERE  ptp.BORRADO=0 and ptp.TAP_ID = (select tap.TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap where tap.TAP_CODIGO = ''P419_RegistrarResolucion'')';
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 1 THEN  
    	--/**
    	--* Valor antiguo que es reemplazado con este update:
    	--* valores['P419_ConfirmarVista'] == null ? 20*24*60*60*1000L : (damePlazo(valores['P419_ConfirmarVista']['fechaVista'])+20*24*60*60*1000L) 
    	-- */
        execute immediate 'update '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS ptp set ptp.DD_PTP_PLAZO_SCRIPT=''valores[''''P419_ConfirmarVista''''] == null ? 20*24*60*60*1000L : (valores[''''P419_ConfirmarVista''''][''''fechaVista''''] == null ? 20*24*60*60*1000L : damePlazo(valores[''''P419_ConfirmarVista''''][''''fechaVista''''])+20*24*60*60*1000L)'' where ptp.TAP_ID = (select tap.TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap where tap.TAP_CODIGO = ''P419_RegistrarResolucion'')';
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('ACTUALIZACION CORRECTA....');
        DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe ese codigo en la base de datos ó Hay más de uno');
         DBMS_OUTPUT.PUT_LINE('[INFO] No se ha podido modificar el registro...');
    
    END IF;

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          
END;
/
EXIT;