--/*
--###########################################
--## AUTOR=Oscar Diestre Perez
--## FECHA_CREACION=20190902
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5063
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR TAR_TAREAS_NOTIFICACIONES
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
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-5161';
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACT_PAC_PROPIETARIO_ACTIVO ' );

            
                V_MSQL := ' 							
			MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO T1
       			 USING (

				SELECT ACT.ACT_ID, TGP.DD_TGP_ID, AUX.PAR_PORC_PROPIEDAD
				FROM '||V_ESQUEMA||'.AUX_REMVIP_5161 AUX,
				     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
				     '||V_ESQUEMA||'.DD_TGP_TIPO_GRADO_PROPIEDAD TGP
				WHERE 1 = 1
				AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
				AND TGP.DD_TGP_CODIGO  = AUX.DD_TGP_CODIGO

       				) T2 
		        ON (T1.ACT_ID = T2.ACT_ID)
			WHEN MATCHED THEN UPDATE SET
		 	T1.DD_TGP_ID = T2.DD_TGP_ID,
			T1.PAC_PORC_PROPIEDAD = T2.PAR_PORC_PROPIEDAD, 
			T1.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR|| ''', 
			T1.FECHAMODIFICAR = SYSDATE
		';

	EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS ' || SQL%ROWCOUNT || ' REGISTROS DE ACT_PAC_PROPIETARIO_ACTIVO ' );

--*******************************************************************************************************************************

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACT_PRO_PROPIETARIO ' );
            
                V_MSQL := ' 							
			MERGE INTO '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO T1
       			 USING (

				SELECT PAC.PRO_ID, AUX.PRO_NOMBRE
				FROM '||V_ESQUEMA||'.AUX_REMVIP_5161 AUX,
				     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
				     '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC
				WHERE 1 = 1
				AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
				AND PAC.ACT_ID  = ACT.ACT_ID

       				) T2 
		        ON (T1.PRO_ID = T2.PRO_ID)
			WHEN MATCHED THEN UPDATE SET
		 	T1.PRO_NOMBRE = T2.PRO_NOMBRE,
			T1.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR|| ''', 
			T1.FECHAMODIFICAR = SYSDATE
		';

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS ' || SQL%ROWCOUNT || ' REGISTROS DE ACT_PRO_PROPIETARIO ' );

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
