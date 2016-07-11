--/*
--###########################################
--## AUTOR=Pablo Meseguer 
--## FECHA_CREACION=20160525
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-505
--## PRODUCTO=NO
--## 
--## Finalidad: Crear los registros correspondientes en ACT_ADM_INF_ADMINISTRATIVA tras su alta en ACT_ACTIVO
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
  V_NUM_INSERTS NUMBER(16); -- Vble. para almacenar los inserts realizados.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE INSERCION DE ACT_ADM_INF_ADMINISTRATIVA');
          
    
    -- INSERTAMOS EN ACT_ADM_INF_ADMINISTRATIVA LOS REGISTROS CORRESPONDIENTES A LOS NUEVOS ACTIVOS DE ACT_ACTIVO
    
    V_SQL := '
		 MERGE INTO '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA ADM
		 USING (
				SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				WHERE ACT.USUARIOCREAR = ''APR''
				AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CARTERA.DD_CRA_CODIGO = ''02'')
		 ) TMP
		 ON (ADM.ACT_ID = TMP.ACT_ID)
		 WHEN NOT MATCHED THEN INSERT (
		 ADM_ID, 
		 ACT_ID, 
		 ADM_SUELO_VPO, 
		 ADM_PROMOCION_VPO,
		 ADM_OBLIGATORIO_SOL_DEV_AYUDA,
		 ADM_OBLIG_AUT_ADM_VENTA,
		 ADM_DESCALIFICADO,
		 ADM_MAX_PRECIO_VENTA,
		 VERSION,
		 USUARIOCREAR, 
		 FECHACREAR)
		 VALUES (
		 S_ACT_ADM_INF_ADMINISTRATIVA.NEXTVAL,
		 TMP.ACT_ID,
		 NULL,
		 NULL,
		 NULL,
		 NULL,
		 NULL,
		 NULL,
		 0,
		 ''HREOS-505'',
		 SYSDATE)
		 '
         ;
         
    EXECUTE IMMEDIATE V_SQL;
    
    V_NUM_INSERTS := sql%rowcount;
    
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA ANALIZADA.');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INSERTADO '||V_NUM_INSERTS||' REGISTROS EN ACT_ADM_INF_ADMINISTRATIVA.');
      
    DBMS_OUTPUT.PUT_LINE('[FIN] LA TABLA ACT_ADM_INF_ADMINISTRATIVA SE HA ACTUALIZADO CORRECTAMENTE');
 
 
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
