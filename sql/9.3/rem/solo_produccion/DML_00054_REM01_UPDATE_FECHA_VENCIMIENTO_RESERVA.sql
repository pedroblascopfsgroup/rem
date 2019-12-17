--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5996
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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
    
    V_TABLA VARCHAR2(30 CHAR) := 'RES_RESERVAS';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5996'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                    SET RES_FECHA_VENCIMIENTO = NULL,
                    USUARIOMODIFICAR = '''|| V_USR ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ECO_ID IN  = (171437,
					178346,
					178441,
					182629,
					179147,
					172375,
					173173,
					174146,
					169289,
					173964,
					172795,
					172492,
					178190,
					175796,
					177742,
					176718,
					181114,
					176225,
					176342,
					177041,
					171601,
					171410,
					171411,
					174879,
					172942,
					173448)';

        EXECUTE IMMEDIATE V_MSQL;
		
        DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registros');

        DBMS_OUTPUT.PUT_LINE('[FIN]');
        
        COMMIT;
  
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT
