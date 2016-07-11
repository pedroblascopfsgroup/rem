--/*
--#########################################
--## AUTOR=Pablo Meseguer 
--## FECHA_CREACION=20160506
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-238
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar el valor por defecto del campo BORRADO en ACT_AGA_AGRUPACION_ACTIVO.
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
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE LA TABLA ACT_AGA_AGRUPACION_ACTIVO');
          
   V_SQL := '
		  ALTER TABLE '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO MODIFY BORRADO NUMBER(1,0) DEFAULT 0
		 '
         ;
                            
    EXECUTE IMMEDIATE V_SQL;                  
                
    
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO ANALIZADA.');
      
    DBMS_OUTPUT.PUT_LINE('[FIN] LA TABLA ACT_AGA_AGRUPACION_ACTIVO SE HA ACTUALIZADO CORRECTAMENTE');
 
 
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
