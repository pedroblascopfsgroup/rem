--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20151124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.18-bk
--## INCIDENCIA_LINK=BKREC-1409
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
    -- * Modificación de TAP_TAREA_PROCEDIMIENTO, donde insertamos la funcion groovy en la tarea: P413_RegistrarEntregaTitulo
    -- * validacionesAdjudicacionEntregaTituloPRE()
    -- */
    
    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap WHERE tap.TAP_CODIGO= ''P413_RegistrarEntregaTitulo''';
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 1 THEN  
    	--/**
    	--* Valor antiguo que es reemplazado con este update:
    	--* null
    	-- */
        execute immediate 'update '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap set tap.TAP_SCRIPT_VALIDACION=''validacionesAdjudicacionEntregaTituloPRE()'', tap.USUARIOMODIFICAR=''BKREC-1409'', tap.FECHAMODIFICAR=SYSDATE where tap.BORRADO=0 and tap.TAP_CODIGO= ''P413_RegistrarEntregaTitulo''';
        
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