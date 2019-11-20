--/*
--###########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20190826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5052
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR BIE_LOCALIZACION
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
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_ACT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_COUNT1 NUMBER(16);
  V_COUNT2 NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-5052';
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR PROVINCIA, LOCALIDAD Y UNIDAD POBLACIONAL ' );

            
                V_MSQL := ' 							
			MERGE INTO '||V_ESQUEMA||'.BIE_LOCALIZACION T1
       			 USING (

				SELECT ACT.BIE_ID, PRV.DD_PRV_ID, LOC.DD_LOC_ID, UPO.DD_UPO_ID
				FROM '||V_ESQUEMA||'.AUX_REMVIP_5052 AUX
				INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
				LEFT  JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_CODIGO = AUX.DD_PRV_CODIGO
				LEFT  JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = AUX.DD_LOC_CODIGO
				LEFT  JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL UPO ON UPO.DD_UPO_CODIGO = AUX.DD_UPO_CODIGO

       				) T2 
		        ON (T1.BIE_ID = T2.BIE_ID)
			WHEN MATCHED THEN UPDATE SET
		 	T1.DD_PRV_ID = T2.DD_PRV_ID, 
			T1.DD_LOC_ID = T2.DD_LOC_ID,
			T1.DD_UPO_ID = T2.DD_UPO_ID, 
			T1.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR|| ''', 
			T1.FECHAMODIFICAR = SYSDATE
		';


	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en BIE_LOCALIZACION '); 

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
EXIT;
