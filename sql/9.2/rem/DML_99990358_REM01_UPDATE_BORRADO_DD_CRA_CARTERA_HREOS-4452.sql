--/*
--##########################################
--## AUTOR=Rasul Abdulaev
--## FECHA_CREACION=20180802
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4452
--## PRODUCTO=SI
--##
--## Finalidad: DML Actualizar BORRADO 0 cartera EGEO en tabla DD_CRA_CARTERA.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_REGISTROS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_DDNAME VARCHAR2(30):= 'DD_CRA_CARTERA'; -- Vble. del nombre de la tabla
    V_ID NUMBER(16); -- Vble.auxiliar para sacar un ID.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.  

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'...  Actualizando cartera "EGEO"');
    V_SQL := 'SELECT count(1) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE DD_CRA_CODIGO = ''13'' AND BORRADO != 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

    IF V_NUM_REGISTROS = 1 THEN
        
		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_DDNAME||' SET BORRADO= 0, USUARIOMODIFICAR= ''HREOS-4452'', FECHAMODIFICAR= SYSDATE WHERE DD_CRA_ID = 122 ';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.'||V_DDNAME||'');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No se han podido actualizar los registros de la tabla '||V_ESQUEMA||'.'||V_DDNAME||'');
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
EXIT