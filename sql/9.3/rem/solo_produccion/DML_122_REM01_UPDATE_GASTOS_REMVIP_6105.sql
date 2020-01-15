--###########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6105
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar fechas en gastos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-6105';

 
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('	[INFO]: ACTUALIZAR GASTO');


	V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
		   SET PRO_ID = 558,
		       USUARIOMODIFICAR = ''REMVIP-6105'',
		       FECHAMODIFICAR = SYSDATE
		   WHERE 1 = 1
		   AND GPV_NUM_GASTO_HAYA IN
			(

			 10144256,
			 10144263,
			 10144264,
			 10144234

			)
		   AND BORRADO = 0';
     
	EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO]  '||SQL%ROWCOUNT||' Gastos actualizados');     

 -----------------------------------------------------------------


    REM01.SP_EXT_REENVIO_GASTO ( '''10144256''', ''||V_USUARIO||'', V_NUM_TABLAS );
    REM01.SP_EXT_REENVIO_GASTO ( '''10144263''', ''||V_USUARIO||'', V_NUM_TABLAS );
    REM01.SP_EXT_REENVIO_GASTO ( '''10144264''', ''||V_USUARIO||'', V_NUM_TABLAS );
    REM01.SP_EXT_REENVIO_GASTO ( '''10144234''', ''||V_USUARIO||'', V_NUM_TABLAS );


    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
