--/*
--###########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181025
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2330
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizaciones de activos en agrupacion asistida.
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
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  
  
BEGIN		
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...');

	V_MSQL :=  'UPDATE REM01.ACT_ACTIVO T1
				SET 
					T1.DD_SCM_ID = (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''02''),
					T1.USUARIOMODIFICAR = ''REMVIP-2330'',
					T1.FECHAMODIFICAR = SYSDATE
				WHERE T1.ACT_ID IN (
					SELECT ACT.ACT_ID
					FROM REM01.ACT_ACTIVO                   ACT
					JOIN REM01.DD_SCM_SITUACION_COMERCIAL   SCM
					ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
					WHERE ACT.ACT_NUM_ACTIVO IN (
						7030516,
						7030517,
						7030518,
						7030519,
						7030520,
						7030521,
						7030522,
						7030523,
						7030524,
						7030525,
						7030526,
						7030527,
						7030528
					)
				)
	';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza la situacion comercial de '||SQL%ROWCOUNT||' activos a Disponible para la venta.');  
	
	
	COMMIT;  
	DBMS_OUTPUT.PUT_LINE('[FIN]: Fin del proceso.');
 

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
