--/*
--###########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20190904
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5176
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
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-5176';
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] Modifica el perímetro ');

     V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1
		USING
		(

			SELECT PAC.ACT_ID, AGR_INI_VIGENCIA
			FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC, '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA, 
			     '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR, '||V_ESQUEMA||'.ACT_ACTIVO ACT, '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM
			WHERE 1 = 1
			AND PAC.ACT_ID = AGA.ACT_ID
			AND AGA.ACT_ID = ACT.ACT_ID
			AND AGA.AGR_ID = AGR.AGR_ID
			AND AGR_NUM_AGRUP_REM = ''1000003510''
			AND SCM.DD_SCM_ID = ACT.DD_SCM_ID
			AND SCM.DD_SCM_CODIGO <> ''05''

		) T2
		ON ( T1.ACT_ID = T2.ACT_ID )
		WHEN MATCHED THEN UPDATE SET
		T1.PAC_CHECK_COMERCIALIZAR = 1,
		T1.PAC_CHECK_PUBLICAR = 1,
		T1.PAC_INCLUIDO = 1,
		T1.PAC_FECHA_COMERCIALIZAR = T2.AGR_INI_VIGENCIA,
		T1.PAC_FECHA_PUBLICAR      = T2.AGR_INI_VIGENCIA,
		T1.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR|| ''',
		T1.FECHAMODIFICAR = SYSDATE ';

	EXECUTE IMMEDIATE V_MSQL;

   DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en Perímetro ');  

    DBMS_OUTPUT.PUT_LINE('[INFO] Modifica la situación comercial ');

     V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
		USING
		(

			SELECT PAC.ACT_ID, AGR_INI_VIGENCIA
			FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC, '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA, 
			     '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR, '||V_ESQUEMA||'.ACT_ACTIVO ACT, '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM
			WHERE 1 = 1
			AND PAC.ACT_ID = AGA.ACT_ID
			AND AGA.ACT_ID = ACT.ACT_ID
			AND AGA.AGR_ID = AGR.AGR_ID
			AND AGR_NUM_AGRUP_REM = ''1000003510''
			AND SCM.DD_SCM_ID = ACT.DD_SCM_ID
			AND SCM.DD_SCM_CODIGO <> ''05''

		) T2
		ON ( T1.ACT_ID = T2.ACT_ID )
		WHEN MATCHED THEN UPDATE SET
		T1.DD_SCM_ID = ( SELECT DD_SCM_ID FROM DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''02'' ),
		T1.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR|| ''',
		T1.FECHAMODIFICAR = SYSDATE ';

	EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' activos '); 


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
