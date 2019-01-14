--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180717
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-4320
--## PRODUCTO=NO
--## 
--## Finalidad: MODIFICACIÓN DE COLUMNAS DE TASACIONES
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


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
  V_ID NUMBER(16);
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
   DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACIÓN DE COLUMNAS DE TASACIONES');
        
   V_MSQL := '
   ALTER TABLE '||V_ESQUEMA||'.ACT_TAS_TASACION 
   MODIFY (
   TAS_TASACION_MODIFICADA NUMBER(13,2)
   )
   ';
   EXECUTE IMMEDIATE V_MSQL;
    
   DBMS_OUTPUT.PUT_LINE('[INFO] Columna ''TAS_TASACION_MODIFICADA'' modificada correctamente');
   
   
   V_MSQL := '
   ALTER TABLE '||V_ESQUEMA||'.ACT_TAS_TASACION 
   MODIFY (
   TAS_CONDICIONANTE_OBS VARCHAR2(250 CHAR)
   )
   ';
   EXECUTE IMMEDIATE V_MSQL;
    
   DBMS_OUTPUT.PUT_LINE('[INFO] Columna ''TAS_CONDICIONANTE_OBS'' modificada correctamente');
   
   
   V_MSQL := '
   ALTER TABLE '||V_ESQUEMA||'.ACT_TAS_TASACION 
   MODIFY (
   TAS_ORDEN_ECO_OBS VARCHAR2(250 CHAR)
   )
   ';
   EXECUTE IMMEDIATE V_MSQL;
    
   DBMS_OUTPUT.PUT_LINE('[INFO] Columna ''TAS_ORDEN_ECO_OBS'' modificada correctamente');
   
   
   V_MSQL := '
   ALTER TABLE '||V_ESQUEMA||'.ACT_TAS_TASACION 
   MODIFY (
   TAS_ADVERTENCIAS_OBS VARCHAR2(250 CHAR)
   )
   ';
   EXECUTE IMMEDIATE V_MSQL;
    
   DBMS_OUTPUT.PUT_LINE('[INFO] Columna ''TAS_ADVERTENCIAS_OBS'' modificada correctamente');
   
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]');
 

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
