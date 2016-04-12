--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160412
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-796
--## PRODUCTO=NO
--## Finalidad: Crea los registros para enlazar los estados Carencia(CAR) y Gestión 
--##			de vencidos(GV) al itinerario con nombre Estándar. Comprueba si 
--##			existe este itinerario si no da error. Tambien comprueba si existe 
--##			el perfil de Gestor de Deuda(GESTDEUDA) si no da error.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    
    V_NUM NUMBER; 
    
    V_DD_TIT_ID NUMBER;
    V_DD_AEX_ID NUMBER;
    V_PEF_GESTOR NUMBER;
    
    V_ITI NUMBER;
    V_DD_EST NUMBER;

    V_EST_CAR NUMBER;
    V_EST_GV NUMBER;
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN

	-- Encontrar los ids para DD_TIT_ID y DD_AEX_ID
	V_MSQL := 'SELECT DD_TIT_ID FROM '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = ''DEU''';
	EXECUTE IMMEDIATE V_MSQL INTO V_DD_TIT_ID;
	
	V_MSQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO = ''PPGRA''';
	EXECUTE IMMEDIATE V_MSQL INTO V_DD_AEX_ID;
		
		
	-- Comprobar si existe el itinerario de tipo Gestión de deuda con nombre Estándar
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Estándar'' AND borrado = 0 AND DD_TIT_ID = '||V_DD_TIT_ID||'';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM > 0 THEN
		V_SQL := 'SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Estándar'' AND DD_TIT_ID = '||V_DD_TIT_ID||' AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_ITI;

		-- Comprobar si existe el perfil de gestión para los nuevos estados del itinerario
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GESTDEUDA''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM > 0 THEN
			V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GESTDEUDA''';
			EXECUTE IMMEDIATE V_SQL INTO V_PEF_GESTOR;
			
			-- Ahora creamos los registros para enlazar los estados a este nuevo itinerario
			-- CAR Carencia
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO=''CAR'' AND DD_EIN_ID = 1 AND borrado = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM;
			IF V_NUM > 0 THEN
				V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO=''CAR'' AND DD_EIN_ID = 1 AND borrado = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_DD_EST;
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM;
				IF V_NUM = 0 THEN		
					V_SQL := 'SELECT '||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL FROM DUAL';
					EXECUTE IMMEDIATE V_SQL INTO V_EST_CAR;
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_TELECOBRO, EST_PLAZO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
								VALUES ('||V_EST_CAR||', '||V_PEF_GESTOR||', '||V_PEF_GESTOR||', '||V_ITI||', '||V_DD_EST||', 0, 0, 0, ''DML'', SYSDATE, 0)';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Insertado estado Carencia al itinerario: Estándar.');
				ELSE
					V_SQL := 'SELECT EST_ID FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0 AND ROWNUM = 1';
					EXECUTE IMMEDIATE V_SQL INTO V_EST_CAR;
					DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba insertado el estado Carencia al itinerario: Estándar con id, EST_ID: '||V_EST_CAR);
				END IF;
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] NO se ha encontrado el estado itinerario Carencia(CAR). No se puede asociar la fase al itinerario..');
			END IF;
			
			-- GV Gestión de vencidos
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO=''GV'' AND DD_EIN_ID = 1 AND borrado = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM;
			IF V_NUM > 0 THEN
				V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO=''GV'' AND DD_EIN_ID = 1  AND borrado = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_DD_EST;
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM;
				IF V_NUM = 0 THEN		
					V_SQL := 'SELECT '||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL FROM DUAL';
					EXECUTE IMMEDIATE V_SQL INTO V_EST_GV;
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_TELECOBRO, EST_PLAZO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
								VALUES ('||V_EST_GV||', '||V_PEF_GESTOR||', '||V_PEF_GESTOR||', '||V_ITI||', '||V_DD_EST||', 0, 0, 0, ''DML'', SYSDATE, 0)';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Insertado estado Gestión de vencidos al itinerario: Estándar.');
				ELSE
					V_SQL := 'SELECT EST_ID FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0 AND ROWNUM = 1';
					EXECUTE IMMEDIATE V_SQL INTO V_EST_GV;
					DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba insertado el estado Gestión de vencidos al itinerario: Estándar con id, EST_ID: '||V_EST_GV);
				END IF;
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] NO se ha encontrado el estado itinerario Gestion de Vencidos(GV). No se puede asociar la fase al itinerario..');
			END IF;
			
		ELSE		
			DBMS_OUTPUT.PUT_LINE('[INFO] NO existe el perfil gestor deuda(GESTDEUDA). No se puede continuar..');
		END IF;

	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] NO existe un itinerario con nombre Estándar. No se puede continuar..');
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
