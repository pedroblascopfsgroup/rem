--/*
--###########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181022
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2330
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar datos de REM de unos activos.
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

	--ANTES DEL CAMBIO, TODOS TENIAN EN ESOS DOS CAMPOS:       PROMOTORIA HOLDING 140 BV	      N0030224J
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS
					SET
						PDV_ACREEDOR_NOMBRE = NULL,
						PDV_ACREEDOR_NIF = NULL,
						USUARIOMODIFICAR = ''REMVIP-2330'',
						FECHAMODIFICAR = SYSDATE
				WHERE
					ACT_ID IN (
						SELECT
							ACT.ACT_ID
						FROM
							'||V_ESQUEMA||'.ACT_ACTIVO ACT
						WHERE
							ACT.ACT_NUM_ACTIVO IN 
							(
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
					)';
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
