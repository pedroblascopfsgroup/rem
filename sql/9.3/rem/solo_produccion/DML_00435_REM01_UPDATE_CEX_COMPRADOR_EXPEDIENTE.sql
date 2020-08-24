--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso Canovas
--## FECHA_CREACION=20200824
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7980
--## PRODUCTO=NO
--## 
--## Finalidad: Reactivar compradores expediente comercial 215665
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_USUARIO VARCHAR2(100 CHAR):= 'REMVIP-7980'; --Vble. auxiliar para almacenar el usuario
	V_TABLA VARCHAR2(100 CHAR):='CEX_COMPRADOR_EXPEDIENTE'; --Vble. auxiliar para almacenar la tabla a actualizar
	V_NUM_EXPEDIENTE NUMBER(16):='215665'; --Vble. auxiliar para almacenar el numero de expediente
	V_COUNT NUMBER(16); --Vble. auxilizar para realizar comprobaciones de existencia del expediente
    V_SQL VARCHAR2(4000 CHAR);  --Sentencia a ejecutar


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	DBMS_OUTPUT.PUT_LINE('[INICIO] INICIO COMPROBACION EXISTE EXPEDIENTE');

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE='||V_NUM_EXPEDIENTE||'';

	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

	IF V_COUNT = 1 then	

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando compradores con expediente 215665 ');
										
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
		   SET BORRADO = 0,
		       FECHAMODIFICAR = SYSDATE,
		       USUARIOMODIFICAR = '''||V_USUARIO||''',
			   FECHABORRAR=NULL,
			   USUARIOBORRAR=NULL
		   WHERE ECO_ID = (SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE='||V_NUM_EXPEDIENTE||') ';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en '||V_TABLA||' ');  
	ELSE
	  DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL EXPEDIENTE A MODIFICAR, NO SE REALIZAN CAMBIOS'); 
	END IF;


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
