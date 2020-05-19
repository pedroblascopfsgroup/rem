--/*
--###########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200508
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6575
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR INFORMACION GASTOS
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
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-6575';
	
  
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR SET DD_EGA_ID = 1
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
					WHERE GPV_NUM_GASTO_HAYA IN (9648809,
9648810,
10420296,
10439222,
10644619,
10644621,
10644712,
10682442,
10710992,
10711016,
10830957,
10875522,
10875525,
10875532,
10875533,
10875535,
10875537,
10876934,
10878695,
10878707,
10896033,
10983161,
10984916,
10984971,
10992024,
10992071,
10995735,
10995742,
10995743,
11004452,
11062312,
11081089,
11104016,
11104017,
11105077,
11105102,
11105111,
11105118,
11105170,
11171028,
11181878,
11193597,
11193647,
11193654,
11193684,
11195466,
11195472,
11195473,
11195474,
11242728,
11253104)';
				
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.put_line('[INFO] Se haN actualizado '||SQL%ROWCOUNT||' registro ');

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

EXIT
