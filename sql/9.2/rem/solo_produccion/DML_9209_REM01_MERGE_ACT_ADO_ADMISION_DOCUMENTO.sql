--/*
--###########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=2019081
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5026
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-5026';
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
     V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO 
		USING (
		     SELECT AUX.ACT_ID FROM REM01.AUX_REMVIP_5062 AUX
		)AUX ON (ADO.ACT_ID = AUX.ACT_ID AND ADO.CFD_ID = 33)
		WHEN MATCHED THEN 
		UPDATE SET  ADO.DD_EDC_ID = 1,
			    ADO.ADO_FECHA_VERIFICADO = TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
			    ADO.ADO_FECHA_SOLICITUD  = TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
			    ADO.ADO_FECHA_EMISION  = TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
			    ADO.ADO_FECHA_OBTENCION  = TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
			    ADO.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR|| ''',
			    ADO.FECHAMODIFICAR = SYSDATE
		WHEN NOT MATCHED THEN
		INSERT (ADO.ADO_ID, ADO.ACT_ID, ADO.CFD_ID, ADO.DD_EDC_ID, ADO.ADO_APLICA, ADO.ADO_FECHA_VERIFICADO, ADO.ADO_FECHA_SOLICITUD, ADO.ADO_FECHA_EMISION, ADO.ADO_FECHA_OBTENCION, ADO.VERSION, ADO.USUARIOCREAR, ADO.FECHACREAR, ADO.BORRADO) 
		VALUES (REM01.S_ACT_ADO_ADMISION_DOCUMENTO.NEXTVAL, AUX.ACT_ID, 33, 1, 1, TO_DATE(''01/01/1900'',''DD/MM/YYYY''), TO_DATE(''01/01/1900'',''DD/MM/YYYY''), TO_DATE(''01/01/1900'',''DD/MM/YYYY''), TO_DATE(''01/01/1900'',''DD/MM/YYYY''), 0, '''||V_USUARIOMODIFICAR|| ''', SYSDATE, 0)
		';

	EXECUTE IMMEDIATE V_MSQL;

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
