--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3396
--## PRODUCTO=NO
--##
--## Finalidad: Avanzar trámite
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
    V_TABLA VARCHAR2(25 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3396';
    
    V_NUM_EXPEDIENTE NUMBER(16):= '132839'; --  Vble. auxiliar para registrar el num. expediente.
    V_EXISTE_EXPEDIENTE NUMBER(16); --  Vble. auxiliar para registrar la existencia del expediente.
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos que existe el registro con el ECO_NUM_EXPEDIENTE '||V_NUM_EXPEDIENTE||'.');

	V_SQL :=    'SELECT COUNT(*) 
                FROM '||V_ESQUEMA||'.'||V_TABLA||' 
                WHERE ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||' 
                AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_EXPEDIENTE;
    
    IF V_EXISTE_EXPEDIENTE > 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO] Se va a insertar la fecha en el expediente '||V_NUM_EXPEDIENTE||'.');

        V_SQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                SET ECO_FECHA_CONT_PROPIETARIO = TO_DATE(''21/12/2018'', ''DD/MM/YYYY'')
                WHERE ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE;

	    EXECUTE IMMEDIATE V_SQL;

    ELSE 
        DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado el expediente '||V_NUM_EXPEDIENTE||'.');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] Se ha terminado el proceso.');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          DBMS_OUTPUT.PUT_LINE(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
