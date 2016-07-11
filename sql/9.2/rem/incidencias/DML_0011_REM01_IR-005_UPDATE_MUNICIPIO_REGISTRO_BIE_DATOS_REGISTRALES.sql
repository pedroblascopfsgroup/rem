--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160429
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar el campo MUNICIPIO_REGISTRO en BIE_DATOS_REGISTRALES.
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

   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE BIE_DATOS_REGISTRALES');
          
   V_SQL := '
         MERGE INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BDR 
         USING 
         (
				SELECT ADA.BIE_DREG_ID AS BIE_DREG, LOC.DD_LOC_ID AS MUNICIPIO 
                FROM '||V_ESQUEMA||'.MIG_ADA_DATOS_ADI ADA
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                ON ACT.ACT_NUM_ACTIVO = ADA.ACT_NUMERO_ACTIVO
                INNER JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG
                ON REG.ACT_ID = ACT.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES DATOS
                ON DATOS.BIE_DREG_ID = REG.BIE_DREG_ID
                LEFT OUTER JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC
                ON ADA.MUNICIPIO_REGISTRO = LOC.DD_LOC_CODIGO
                WHERE ADA.MUNICIPIO != ADA.MUNICIPIO_REGISTRO
         ) TMP
		 ON (TMP.BIE_DREG = BDR.BIE_DREG_ID)
         WHEN MATCHED THEN UPDATE 
         SET 
         BDR.DD_LOC_ID = TMP.MUNICIPIO,
         BDR.USUARIOMODIFICAR = ''IR-005'',
		 BDR.FECHAMODIFICAR = SYSDATE
		 '
         ;
                            
    EXECUTE IMMEDIATE V_SQL;                  
                
    
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES ANALIZADA.');
      
    DBMS_OUTPUT.PUT_LINE('[FIN] LA TABLA BIE_DATOS_REGISTRALES SE HA ACTUALIZADO CORRECTAMENTE');
 
 
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
