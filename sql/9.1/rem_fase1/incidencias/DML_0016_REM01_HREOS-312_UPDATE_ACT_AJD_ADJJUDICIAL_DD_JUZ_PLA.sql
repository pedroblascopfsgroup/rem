--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160504
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-312
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar el campo DD_JUZ_ID  y  DD_PLA_ID en ACT_AJD_ADJJUDICIAL.
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

   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_AJD_ADJJUDICIAL');
          
   V_SQL := '
         MERGE INTO '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD
		 USING
		 (
		 	 SELECT DD_JUZ_ID, DD_PLA_ID, ACT_ID FROM (
			  SELECT ROW_NUMBER () OVER (PARTITION BY PRB.BIE_ID
									   ORDER BY PRC.FECHACREAR DESC) AS ORDEN, ACT.ACT_ID, JUZ.DD_JUZ_ID, JUZ.DD_PLA_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			  INNER JOIN HAYA01.BIE_BIEN BIE
			  ON ACT.ACT_NUM_ACTIVO_UVEM = BIE.BIE_NUMERO_ACTIVO
			  INNER JOIN HAYA01.PRB_PRC_BIE PRB
			  ON BIE.BIE_ID = PRB.BIE_ID
			  INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC
			  ON PRB.PRC_ID = PRC.PRC_ID AND PRC.DD_JUZ_ID IS NOT NULL
			  INNER JOIN HAYA01.DD_JUZ_JUZGADOS_PLAZA JUZ
			  ON JUZ.DD_JUZ_ID = PRC.DD_JUZ_ID
			  WHERE ACT.ACT_NUM_ACTIVO_UVEM !=0
			  AND ACT.DD_TTA_ID= 1
              AND ACT.ACT_NUM_ACTIVO_UVEM != 15355198)
			WHERE ORDEN =1
		 ) TMP
		 ON (AJD.ACT_ID = TMP.ACT_ID)
		 WHEN MATCHED THEN UPDATE 
		 SET 
		 AJD.DD_JUZ_ID = TMP.DD_JUZ_ID,
		 AJD.DD_PLA_ID = TMP.DD_PLA_ID,
		 AJD.USUARIOMODIFICAR = ''HREOS-312'',
		 AJD.FECHAMODIFICAR = SYSDATE
		 '
         ;
                            
    EXECUTE IMMEDIATE V_SQL;                  
                
    
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL ANALIZADA.');
      
    DBMS_OUTPUT.PUT_LINE('[FIN] LA TABLA ACT_AJD_ADJJUDICIAL SE HA ACTUALIZADO CORRECTAMENTE');
 
 
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
