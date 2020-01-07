--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6113
--## PRODUCTO=NO
--##
--## Finalidad: borrado relacion trabajo-gasto de gasto incompleto
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
    --V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'GPV_TBJ'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-6113';
    V_EXISTE_GASTO NUMBER(25);  

 BEGIN

	V_SQL := 'SELECT COUNT(1)
		  FROM '||V_ESQUEMA||'.GPV_TBJ 
		  WHERE GPV_TBJ_ID = 112441';

	EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_GASTO;

	IF V_EXISTE_GASTO > 0 THEN
 
  
	  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
		  					   BORRADO = 1
							 , USUARIOBORRAR = '''||V_USUARIO||'''
							 , FECHABORRAR = SYSDATE 
						 WHERE GPV_TBJ_ID = 112441';
		
	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

	ELSE 
		DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado el gasto');
	END IF;
 
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

