--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20151109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.17-bk
--## INCIDENCIA_LINK=BKREC-1428
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

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

     --/** 
    -- * Modificación de TAP_TAREA_PROCEDIMIENTO, pondremos 'null' en TAP_ALERTA_VUELTA_ATRAS  para el trámite 
    -- * P401 Subasta Bankia, en las tareas (contabilizar activa/cierre), (solicitar mandamiento de pago), (registrar acta subasta)
    -- */
    
    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap WHERE tap.BORRADO=0 and (tap.TAP_CODIGO=''P401_ContabilizarCierreDeuda'' or tap.TAP_CODIGO=''P401_SolicitarMtoPago'' or tap.TAP_CODIGO=''P401_RegistrarActaSubasta'') ';
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 3 THEN  
    	--/**
    	--* Valor antiguo que es reemplazado con este update: tareaExterna.cancelarTarea
    	-- */
        execute immediate 'update '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO set TAP_ALERT_VUELTA_ATRAS=null, USUARIOMODIFICAR=''BKREC-1428'', FECHAMODIFICAR=SYSDATE WHERE BORRADO=0 and (TAP_CODIGO=''P401_ContabilizarCierreDeuda'' or TAP_CODIGO=''P401_SolicitarMtoPago'' or TAP_CODIGO=''P401_RegistrarActaSubasta'')';
        
        DBMS_OUTPUT.PUT_LINE('ACTUALIZACION CORRECTA....');
        DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe ese codigo en la base de datos ó Hay más de uno');
         DBMS_OUTPUT.PUT_LINE('[INFO] No se ha podido modificar el registro...');
    
    END IF;
    COMMIT;
    
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