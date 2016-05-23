--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20160415
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.3
--## INCIDENCIA_LINK=PRODUCTO-1092
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_NUM NUMBER;
    V_DD_TIT_ID NUMBER;
    V_ITI_ID NUMBER;
    V_PEF_ID_GESTOR NUMBER;
    V_PEF_ID_SUPER NUMBER;
    V_DD_EST_ID NUMBER;
BEGIN	
	
	-- Necesario obtener un tipo recuperación
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = ''REC'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM > 0 THEN
		V_SQL := 'SELECT DD_TIT_ID FROM '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = ''REC'' AND BORRADO = 0 AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_DD_TIT_ID;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tipo recuperación DD_TIT_ID: '||V_DD_TIT_ID);
		
		-- Nuevo itinerario 
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Itinerario gestión'' AND DD_TIT_ID = '||V_DD_TIT_ID||' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM = 0 THEN
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_ITI_ITINERARIOS.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_ITI_ID;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ITI_ITINERARIOS  (ITI_ID, ITI_NOMBRE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TIT_ID,  DD_AEX_ID,  TPL_ID )
			  VALUES ('||V_ITI_ID||', ''Itinerario gestión'',0,''DML'',SYSDATE, 0, '||V_DD_TIT_ID||', NULL, NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Nuevo itinerario gestión insertado con ITI_ID: '||V_ITI_ID);
		ELSE
			V_SQL := 'SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Itinerario gestión'' AND DD_TIT_ID = '||V_DD_TIT_ID||' AND BORRADO = 0 AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_ITI_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya se disponía de un itinerario de recuperación con nombre Itinerario gestión, ITI_ID: '||V_ITI_ID);
		END IF;
		
		-- Nuevo pefil gestor gestión expedientes
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GESTEXP'' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM = 0 THEN
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_PEF_ID_GESTOR;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES  ( PEF_ID, PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PEF_CODIGO)
  				VALUES ('||V_PEF_ID_GESTOR||',''Gestor gestión expedientes'',''Gestor gestión expedientes'', 0, ''DML'', SYSDATE, 0, ''GESTEXP'')';
  			EXECUTE IMMEDIATE V_MSQL;
  			DBMS_OUTPUT.PUT_LINE('[INFO] Nuevo perfil Gestor gestión expedientes insertado con PEF_ID: '||V_PEF_ID_GESTOR);
		ELSE
			V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GESTEXP'' AND BORRADO = 0 AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_PEF_ID_GESTOR;
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya se disponía de un perfil gestor gestión expedientes(GESTEXP) con PEF_ID: '||V_PEF_ID_GESTOR);
		END IF;
		
		-- Nuevo perfil supervisor gestión expedientes
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUPGESTEXP'' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM = 0 THEN
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_PEF_ID_SUPER;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES  ( PEF_ID, PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PEF_CODIGO)
				VALUES ('||V_PEF_ID_SUPER||',''Supervisor gestión expedientes'',''Supervisor gestión expedientes'',0,''DML'',SYSDATE, 0, ''SUPGESTEXP'')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Nuevo perfil Supervisor gestión expedientes insertado con PEF_ID: '||V_PEF_ID_SUPER);
		ELSE
			V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUPGESTEXP'' AND BORRADO = 0 AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_PEF_ID_SUPER;
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya se disponía de un perfil supervisor gestión expedientes(SUPGESTEXP) con PEF_ID: '||V_PEF_ID_SUPER);
		END IF;
		
		-- ***************************** Estados para el nuevo itinerario **************************************
		-- CAR (Periodo carencia)
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CAR'' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM > 0 THEN
			V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CAR'' AND BORRADO = 0 AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_EST_ID;
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE DD_EST_ID = '||V_DD_EST_ID||' AND ITI_ID='||V_ITI_ID||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM;
			IF V_NUM = 0 THEN
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_PLAZO, EST_AUTOMATICO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
  					VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL, NULL, NULL ,'||V_ITI_ID||','||V_DD_EST_ID||',0,0,0,''DML'',SYSDATE,0)';
  				EXECUTE IMMEDIATE V_MSQL;
  				DBMS_OUTPUT.PUT_LINE('[INFO] Agregado el estado CAR al itinerario Gestión Expedientes');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba agregado el estado CAR al itinerario Gestión Expedientes');
			END IF;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[ERROR] No se ha encontrado un DD_EST_ID con DD_EST_CODIGO = ''CAR''');
		END IF;
		
		-- GV (Gestion vencidos)
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''GV'' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM > 0 THEN
			V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''GV'' AND BORRADO = 0 AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_EST_ID;
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE DD_EST_ID = '||V_DD_EST_ID||' AND ITI_ID='||V_ITI_ID||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM;
			IF V_NUM = 0 THEN
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_PLAZO, EST_AUTOMATICO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
  					VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL, NULL, NULL,'||V_ITI_ID||','||V_DD_EST_ID||',0,0,0,''DML'',SYSDATE,0)';
  				EXECUTE IMMEDIATE V_MSQL;
  				DBMS_OUTPUT.PUT_LINE('[INFO] Agregado el estado GV al itinerario Gestión Expedientes');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba agregado el estado GV al itinerario Gestión Expedientes');
			END IF;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[ERROR] No se ha encontrado un DD_EST_ID con DD_EST_CODIGO = ''GV''');
		END IF;

		-- CE (Completar expedientes)
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CE'' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM > 0 THEN
			V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CE'' AND BORRADO = 0 AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_EST_ID;
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE DD_EST_ID = '||V_DD_EST_ID||' AND ITI_ID='||V_ITI_ID||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM;
			IF V_NUM = 0 THEN
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_PLAZO, EST_AUTOMATICO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
  					VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL, '||V_PEF_ID_GESTOR||','||V_PEF_ID_SUPER||','||V_ITI_ID||','||V_DD_EST_ID||',1296000000,0,0,''DML'',SYSDATE,0)';
  				EXECUTE IMMEDIATE V_MSQL;
  				DBMS_OUTPUT.PUT_LINE('[INFO] Agregado el estado CE al itinerario Gestión Expedientes');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba agregado el estado CE al itinerario Gestión Expedientes');
			END IF;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[ERROR] No se ha encontrado un DD_EST_ID con DD_EST_CODIGO = ''CE''');
		END IF;
		
		-- RE (Revisar expedientes)
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''RE'' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM > 0 THEN
			V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''RE'' AND BORRADO = 0 AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_EST_ID;
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE DD_EST_ID = '||V_DD_EST_ID||' AND ITI_ID='||V_ITI_ID||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM;
			IF V_NUM = 0 THEN
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_PLAZO, EST_AUTOMATICO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
  					VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL, '||V_PEF_ID_GESTOR||','||V_PEF_ID_SUPER||','||V_ITI_ID||','||V_DD_EST_ID||',0,1,0,''DML'',SYSDATE,0)';
  				EXECUTE IMMEDIATE V_MSQL;
  				DBMS_OUTPUT.PUT_LINE('[INFO] Agregado el estado RE al itinerario Gestión Expedientes');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba agregado el estado RE al itinerario Gestión Expedientes');
			END IF;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[ERROR] No se ha encontrado un DD_EST_ID con DD_EST_CODIGO = ''RE''');
		END IF;
		
		-- DC (Decisión comite)
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''DC'' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM > 0 THEN
			V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''DC'' AND BORRADO = 0 AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_EST_ID;
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE DD_EST_ID = '||V_DD_EST_ID||' AND ITI_ID='||V_ITI_ID||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM;
			IF V_NUM = 0 THEN
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_PLAZO, EST_AUTOMATICO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
  					VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL, '||V_PEF_ID_GESTOR||','||V_PEF_ID_SUPER||','||V_ITI_ID||','||V_DD_EST_ID||',864000000,0,0,''DML'',SYSDATE,0)';
  				EXECUTE IMMEDIATE V_MSQL;
  				DBMS_OUTPUT.PUT_LINE('[INFO] Agregado el estado DC al itinerario Gestión Expedientes');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba agregado el estado DC al itinerario Gestión Expedientes');
			END IF;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[ERROR] No se ha encontrado un DD_EST_ID con DD_EST_CODIGO = ''DC''');
		END IF;		
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[ERROR] No se encontró el tipo itinerario recuperación');
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
