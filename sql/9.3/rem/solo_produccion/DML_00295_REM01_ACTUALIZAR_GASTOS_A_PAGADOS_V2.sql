--/*
--###########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6398
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR GASTOS A PAGADO
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
  V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  GPV_NUM_GASTO NUMBER(16);
  GDE_FECHA_PAGO VARCHAR2(50 CHAR);
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-6398';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    	DBMS_OUTPUT.PUT_LINE('[INFO]: CAMBIAR ESTADO A PAGADO');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR SET DD_EGA_ID = 5 
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
			WHERE GPV_NUM_GASTO_HAYA IN (9171098,
						10502170,
						9171717,
						9171911,
						9174431,
						9175658,
						9176972,
						9180157,
						9180516,
						9180942,
						9182670,
						9171118,
						10493677,
						10464365,
						10409940,
						10398913,
						10398910,
						10381109,
						10381108,
						10370860,
						10343644,
						10343592,
						10343565,
						10343554,
						10280319,
						9184237,
						9199846,
						9199848,
						9464223,
						9466653,
						9474949,
						9496173,
						9497378,
						9556271,
						9586370,
						9474948,
						9474946,
						9474945,
						9474943,
						9474942,
						9474940,
						9183519,
						9562661,
						9208107,
						9474951,
						9199847,
						9474950,
						9562663,
						9562662,
						9424253)';
				
	EXECUTE IMMEDIATE V_SQL;
   
	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros ');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

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
