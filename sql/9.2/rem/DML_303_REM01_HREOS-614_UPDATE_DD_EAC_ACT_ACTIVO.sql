--/*
--#########################################
--## AUTOR=Pablo Meseguer 
--## FECHA_CREACION=20160615
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-614
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar el campo DD_EAC_ID en ACT_ACTIVO para los activos dados de alta con el usuariocrear ALT_SAREB, ACT_SAREB Y APR.
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
  V_NUM_UPDATES NUMBER(16); -- Vble. para almacenar los updates realizados.     
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ACTIVO');
        
   --ACTUALIZAMOS EL CAMPO DD_EAC_ID DE LOS ACTIVOS QUE TENGAN INFORMADO UN 1 EN EL CAMPO BIE_OBRA_EN_CURSO DE LA TABLA BIE_BIEN
   --ESTE PROCESO ACTUALIZA UNICAMENTE LOS ACTIVOS CREADOS ATRAVES DE EL PROCESO DE ETL
          
   V_SQL := '
		 MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
		 USING
		 (
			SELECT BIE.BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN BIE
			INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT1
			ON BIE.BIE_ID  = ACT1.BIE_ID
			WHERE (BIE.USUARIOCREAR = ''ALT_SAREB'' OR BIE.USUARIOCREAR = ''ACT_SAREB'' OR BIE.USUARIOCREAR = ''APR'')
			AND BIE_OBRA_EN_CURSO = 1
			AND ACT1.DD_CRA_ID = 2
		 ) TMP
		 ON (ACT.BIE_ID = TMP.BIE_ID)      
		 WHEN MATCHED THEN UPDATE 
		 SET 
		 ACT.DD_EAC_ID = (SELECT DD_EAC_ID FROM DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = ''02''),
		 ACT.USUARIOMODIFICAR = ''HREOS-614'',
		 ACT.FECHAMODIFICAR = SYSDATE
		 '
         ;
                            
    EXECUTE IMMEDIATE V_SQL;      
    
    V_NUM_UPDATES := sql%rowcount;
        
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ACT_ACTIVO COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_ACTIVO ANALIZADA.');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN ACTUALIZADO '||V_NUM_UPDATES||' REGISTROS EN ACT_ACTIVO.');
      
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
