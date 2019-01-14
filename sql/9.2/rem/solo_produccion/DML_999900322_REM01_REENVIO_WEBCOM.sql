--/*
--###########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20180914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1875
--## PRODUCTO=NO
--## 
--## Finalidad: Marcar para reenviar entidades del detector de cambios
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
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
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');

       
       -------------------------------------------------
       --Comprobamos que el proveedor existe--
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: MARCADO PARA REENVIAR PROVEEDOR: 973');


       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PWH_PROVEEDOR_WEBCOM_HIST WHERE ID_PROVEEDOR_REM = 973';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe, se borra
       IF V_NUM_TABLAS > 0 THEN				         
		
            DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS EL REGISTRO 973 EN PWH_PROVEEDOR_WEBCOM_HIST');
            V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.PWH_PROVEEDOR_WEBCOM_HIST WHERE ID_PROVEEDOR_REM = 973';

          	EXECUTE IMMEDIATE V_MSQL;
        
          	DBMS_OUTPUT.PUT_LINE('[INFO]: PROVEEDOR 973 MARCADO PARA REENVIAR');
			
       --Si no existe, se informa
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: EL PROVEEDOR 973 NO EXISTE, NO SE MARCARÁ PARA REENVIAR');   
        
       END IF;
		
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO FINALIZADO CORRECTAMENTE ');
 

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
