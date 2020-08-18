--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200721
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7979
--## PRODUCTO=NO
--##
--## Finalidad: insertar registro formalizazion
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'FOR_FORMALIZACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-7979';
    
    V_COUNT_1 NUMBER(16); -- Vble. para contar.
    V_COUNT_2 NUMBER(16); -- Vble. para contar.
    V_NUM_OFERTA NUMBER(16) := '90251506';  

    V_ECO_ID NUMBER(16); -- Vble. para kontar.
    V_OFR_ID NUMBER(16); -- Vble. para kontar.

 BEGIN
 
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA  = '||V_NUM_OFERTA||'' INTO V_COUNT_1;

	IF V_COUNT_1 > 0 
		THEN

	EXECUTE IMMEDIATE 'SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA  = '||V_NUM_OFERTA||'' INTO V_OFR_ID;
	EXECUTE IMMEDIATE 'SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE OFR_ID  = '||V_OFR_ID||'' INTO V_ECO_ID;

	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ECO_ID  = '||V_ECO_ID||'' INTO V_COUNT;

	IF V_COUNT = 0 

		THEN

		V_SQL := '
		INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
			FOR_ID,
			ECO_ID,
			FECHACREAR,
			USUARIOCREAR,
			VERSION
			)
			VALUES
			(
			'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,            		 		
			'||V_ECO_ID||',	
			SYSDATE,
			'''||V_USUARIO||''',
			0)'; 

		EXECUTE IMMEDIATE V_SQL ;
			
		DBMS_OUTPUT.put_line('[INFO] Se ha insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

		ELSE

			DBMS_OUTPUT.put_line('[INFO] YA EXISTE REGISTRO');

		END IF;
	    
    	ELSE

		DBMS_OUTPUT.put_line('[INFO] YA EXISTE REGISTRO');

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

