--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160423
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## 
--## Finalidad: Asignar USU_ID a proveedores en ACT_PVC_PROVEEDOR_CONTACTO
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
  V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
 EXECUTE IMMEDIATE '
 MERGE INTO '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC USING (
  select
  UPPER(PVC.PVC_NOMBRE),
  USU.USU_NOMBRE||' '||USU.USU_APELLIDO1 USU_NOMBRECOMPLETO,
  USU.USU_ID
  from '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO pvc
  LEFT join '||V_ESQUEMA_MASTER||'.usu_usuarios usu
    on UPPER(usu.usu_nombre)||' '||UPPER(usu.usu_APELLIDO1) = UPPER(pvc.PVC_NOMBRE)
    OR UPPER(usu.usu_nombre)= UPPER(pvc.PVC_NOMBRE)
  WHERE PVC.USUARIOCREAR = ''DML''
  AND USU.USU_USERNAME != ''TINSA''
  AND USU.USU_NOMBRE IS NOT NULL
) TMP
ON (TRIM(UPPER(pvc.PVC_NOMBRE)) = TRIM(TMP.USU_NOMBRECOMPLETO))
WHEN MATCHED THEN UPDATE
SET
PVC.USU_ID = TMP.USU_ID
 '
 ;


   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN] ');
 

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
