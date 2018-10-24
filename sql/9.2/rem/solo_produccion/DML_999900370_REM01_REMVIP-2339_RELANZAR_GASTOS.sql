--/*
--###########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181022
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2339
--## PRODUCTO=NO
--## 
--## Finalidad: Relanzar gastos.
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
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL :=  'UPDATE GGE_GASTOS_GESTION GGE SET
					GGE.DD_EAP_ID = NULL,
					GGE.USUARIOMODIFICAR = ''REMVIP-2339'',
					GGE.FECHAMODIFICAR = SYSDATE
				WHERE GGE.GGE_ID IN (
					SELECT GGE.GGE_ID 
					FROM REM01.GPV_GASTOS_PROVEEDOR GPV
					JOIN REM01.GGE_GASTOS_GESTION 	GGE 
					  ON GGE.GPV_ID = GPV.GPV_ID
					WHERE GPV.GPV_NUM_GASTO_HAYA IN 
					(
						''9560966'',
						''9560976'',
						''9560975'',
						''9490565'',
						''9492530''
					)
				)
	';
	EXECUTE IMMEDIATE V_MSQL;   
	COMMIT;
   
	DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO FINALIZADO CORRECTAMENTE ');
 

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
