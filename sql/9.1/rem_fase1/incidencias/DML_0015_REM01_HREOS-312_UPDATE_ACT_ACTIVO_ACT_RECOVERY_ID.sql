--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160504
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-312
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar el campo ACT_RECOVERY_ID en ACT_ACTIVO.
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

BEGIN	

   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ACTIVO');
          
   V_SQL := '
         MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
		 USING
		 (
			 SELECT BIE.BIE_ID AS BIE_ID, ACT.ACT_NUM_ACTIVO_UVEM AS NUM_UVEM FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			 INNER JOIN HAYA01.BIE_BIEN BIE 
			 ON ACT.ACT_NUM_ACTIVO_UVEM = BIE.BIE_NUMERO_ACTIVO
			 WHERE ACT.ACT_NUM_ACTIVO_UVEM !=0
			 AND ACT.DD_TTA_ID= 1
			 AND ACT.ACT_NUM_ACTIVO_UVEM != 15355198
		 ) TMP
		 ON (ACT.ACT_NUM_ACTIVO_UVEM = TMP.NUM_UVEM)
		 WHEN MATCHED THEN UPDATE 
		 SET 
		 ACT.ACT_RECOVERY_ID	 = TMP.BIE_ID,
		 ACT.USUARIOMODIFICAR = ''HREOS-312'',
		 ACT.FECHAMODIFICAR = SYSDATE
		 '
         ;
                            
    EXECUTE IMMEDIATE V_SQL;                  
                
    
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ACT_ACTIVO COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_ACTIVO ANALIZADA.');
      
    DBMS_OUTPUT.PUT_LINE('[FIN] LA TABLA ACT_ACTIVO SE HA ACTUALIZADO CORRECTAMENTE');
 
 
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
