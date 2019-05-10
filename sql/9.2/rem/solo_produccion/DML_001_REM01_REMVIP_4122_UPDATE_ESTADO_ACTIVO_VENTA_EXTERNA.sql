--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190509
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4122
--## PRODUCTO=NO
--##
--## Finalidad: MODIFICAR ESTADO ACTIVO DE VENDIDO A EN VENTA, QUITAR IMPORTE Y FECHA DE VENTA EXTERNA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-4122';    
    
BEGIN	
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
 				    FECHAMODIFICAR	 = SYSDATE  
				  , USUARIOMODIFICAR = '''||V_USUARIO||''' 
	 			  , DD_SCM_ID = ''2'' 
				  , ACT_VENTA_EXTERNA_FECHA = null 
				  , ACT_VENTA_EXTERNA_IMPORTE = null 
				    WHERE ACT_NUM_ACTIVO in ( ''5943630'',''5952036'',''5966480'' )
	 			  ';
    EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
	   
    COMMIT;

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
