--/*
--##########################################
--## AUTOR=JUANJO ARBONA
--## FECHA_CREACION=20171102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3110
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar ECO_EXPEDIENTE_COMERCIAL.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_MSQL2 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_SQL2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA2 VARCHAR2(2400 CHAR) := 'DD_EEC_EST_EXP_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    
BEGIN
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización de la tabla '||V_TEXT_TABLA);
		
		V_SQL := 'SELECT COUNT(1) FROM ALL_TABlES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando ECO_EXPEDIENTE_COMERCIAL');

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ECO 
				SET ECO.ECO_ESTADO_PBC = 1, ECO.FECHAMODIFICAR = sysdate, ECO.USUARIOMODIFICAR = ''HREOS-3110''  
				WHERE ECO.DD_EEC_ID = (SELECT EEC.DD_EEC_ID
							FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' EEC
							WHERE EEC.DD_EEC_CODIGO = ''08'')
				AND ECO.ECO_ESTADO_PBC IS NULL';
		    EXECUTE IMMEDIATE V_MSQL;
		    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||sql%rowcount||' registros en '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');
		   
		 ELSE
		 
			DBMS_OUTPUT.PUT_LINE('[INICIO] La tabla '||V_TEXT_TABLA||' no existe. No se hace nada');
		  
		END IF;

		DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de actualización de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||' a finalizado correctamente');

		
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
