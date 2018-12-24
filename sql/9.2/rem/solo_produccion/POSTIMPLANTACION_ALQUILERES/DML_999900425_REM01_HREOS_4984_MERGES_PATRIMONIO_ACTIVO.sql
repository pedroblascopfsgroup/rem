--/*
--###########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181206
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4984
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso posterior al despliegue de ALQUILERES en PRODUCCION.
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
  
  V_MSQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 							-- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 					-- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); 											-- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); 												-- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  													-- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); 											-- Vble. auxiliar para registrar errores en el script.
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  
  
BEGIN		
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso posterior al despliegue de ALQUILERES en PRODUCCION...');

	V_MSQL :=  'MERGE INTO '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO T1
				USING (
					SELECT DISTINCT 
						   PTA.ACT_PTA_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO                                   ACT
					JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA                               CRA
					  ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
					JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION                 TCO
					  ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
					JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO                    PTA
					  ON PTA.ACT_ID = ACT.ACT_ID
					WHERE ACT.BORRADO = 0
					  AND TCO.DD_TCO_CODIGO IN (''02'',''03'')
					  AND (PTA.CHECK_HPM IS NULL OR PTA.CHECK_HPM = 0)
				) T2
				ON (T1.ACT_PTA_ID = T2.ACT_PTA_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.CHECK_HPM = 1,
					T1.USUARIOMODIFICAR = ''HREOS-4984'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza el check de perímetro alquilable de la pestaña patrimonio a 1 para '||SQL%ROWCOUNT||' activos de alquiler o alquiler/venta tienen que no lo tienen marcado.');  
	
	
	V_MSQL :=  'MERGE INTO '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO T1
				USING (
					SELECT DISTINCT 
						   PTA.ACT_PTA_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO                                   ACT
					JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA                               CRA
					  ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
					LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL              SCM 
					  ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
					JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO                    PTA
					  ON PTA.ACT_ID = ACT.ACT_ID
					WHERE ACT.BORRADO = 0
					  AND SCM.DD_SCM_CODIGO NOT IN (''10'')
					  AND PTA.CHECK_HPM = 1
					  AND PTA.DD_EAL_ID NOT IN (SELECT DD_EAL_ID FROM '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO = ''01'')
				) T2
				ON (T1.ACT_PTA_ID = T2.ACT_PTA_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.DD_EAL_ID = (SELECT DD_EAL_ID FROM '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO = ''01''),
					T1.USUARIOMODIFICAR = ''HREOS-4984'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza el estado de alquiler de la pestaña patrimonio a ''Libre'' para '||SQL%ROWCOUNT||' activos que NO están alquilados y están en el perímetro de alquiler.');  
	
	
	COMMIT;  
	DBMS_OUTPUT.PUT_LINE('[FIN] Fin del proceso.');
 

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
