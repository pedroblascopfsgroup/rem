--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-796
--## PRODUCTO=NO
--## Finalidad: Borra los itinerarios no utilizados y crea uno nuevo de tipo Gestión de deuda 
--##			además crea un modelo de arquetipos en estado vigente, (MOA_MODELOS_ARQUETIPOS)
--##			un arquetipo del nuevo itinerario (ARQ_ARQUETIPOS y LIA_LISTA_ARQUETIPOS)
--##			y la relación entre el nuevo arquetipo y el nuevo modelo (MRA_REL_MODELO_ARQ)
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
    V_DD_TRE_ID NUMBER;
    V_PEF_GESTOR NUMBER;
    V_PEF_SUPER NUMBER;
    
    V_ITI NUMBER;
    V_DD_EST NUMBER;
    
    V_EST_CE NUMBER;
    V_EST_RE NUMBER;
    V_EST_FP NUMBER;
    V_EST_ENSAN NUMBER;
    V_EST_SANC NUMBER;
    
    V_LIA_ID NUMBER;
    V_ARQ_ID NUMBER;
    V_MOA_ID NUMBER;
    V_MRA_ID NUMBER;
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	--Borramos los itinerarios que no estén asociasdos a expedientes
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ITI_ITINERARIOS SET BORRADO = 1 WHERE NOT ITI_ID IN
				(SELECT DISTINCT ARQ.ITI_ID
				 FROM '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP
  				 	INNER JOIN '||V_ESQUEMA||'.ARQ_ARQUETIPOS ARQ ON EXP.ARQ_ID = ARQ.ARQ_ID
				 WHERE EXP.BORRADO = 0 AND NOT ARQ.ITI_ID IS NULL)
				AND DD_TIT_ID <> (SELECT DD_TIT_ID FROM '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = ''DEU'')';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados los itinerarios sin asignar a expedientes que no sea el de gestión de deuda');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = ''DEU''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM=0 THEN
		RAISE_APPLICATION_ERROR(-20101, 'Todavía no se ha creado el tipo itinerario Gestión Deuda. Ejecutar primero: sql/9.2/producto/DML_002_MASTER_INSERT_TIPO_ITINERARIO.sql');
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO = ''PPGRA''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM=0 THEN
		RAISE_APPLICATION_ERROR(-20102, 'No existe el Ambito de expediente: Persona de pase; personas del grupo de clientes y personas de primera generación.');
	END IF;		

	--Necesitamos encontrar los ids para DD_TIT_ID y DD_AEX_ID
	V_MSQL := 'SELECT DD_TIT_ID FROM '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = ''DEU''';
	EXECUTE IMMEDIATE V_MSQL INTO V_DD_TIT_ID;
	
	V_MSQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO = ''PPGRA''';
	EXECUTE IMMEDIATE V_MSQL INTO V_DD_AEX_ID;
		
		
	-- Insertamos si no existe el nuevo itinerario de tipo Gestión de deuda
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Estándar''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM=0 THEN
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_ITI_ITINERARIOS.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_ITI;

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ITI_ITINERARIOS (ITI_ID, ITI_NOMBRE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TIT_ID, DD_AEX_ID)
					VALUES ('||V_ITI||', ''Estándar'', 0, ''DML'', SYSDATE, 0, '||V_DD_TIT_ID||', '||V_DD_AEX_ID||')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha creado un nuevo itinerario de tipo Gestión Deuda con el nombre: Estándar, ITI_ID: '||V_ITI);
	ELSE
		V_SQL := 'SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Estándar'' AND DD_TIT_ID = '||V_DD_TIT_ID||' AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_ITI;
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existía un itinerario con nombre Estándar, ITI_ID: '||V_ITI);
	END IF;		
		
	-- ***************************************************** Estados **************************************
	-- Actualización del diccionario de estados itinerario
	-- Primero cambiamos el orden del estado Formalizar Propuesta, para anexar los 2 en medio
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS SET DD_EST_ORDEN = 7 WHERE DD_EST_CODIGO = ''FP'' 
				AND DD_EIN_ID = (SELECT DD_EIN_ID FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION WHERE DD_EIN_CODIGO = ''2'')';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Orden del estado Formalizar Propuesta actualizado');
	
	-- Creamos el nuevo estado En Sancion si no existe ya en el mismo orden que el estado Decision Comite
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''ENSAN''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM=0 THEN
		V_SQL := 'SELECT DD_EIN_ID FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION WHERE DD_EIN_CODIGO = ''2''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID, DD_EIN_ID, DD_EST_ORDEN, DD_EST_CODIGO, DD_EST_DESCRIPCION, DD_EST_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
					 VALUES ('||V_ESQUEMA_M||'.S_DD_EST_EST_ITI.NEXTVAL, '||V_NUM||', ''5'', ''ENSAN'', ''En sanción'', ''En sanción'', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Estado: En sanción insertado...');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia el estado En sanción');
	END IF;
	
	-- Creamos el nuevo estado Sancionado si no existe ya
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''SANC''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM=0 THEN
		V_SQL := 'SELECT DD_EIN_ID FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION WHER E DD_EIN_CODIGO = ''2''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID, DD_EIN_ID, DD_EST_ORDEN, DD_EST_CODIGO, DD_EST_DESCRIPCION, DD_EST_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
					 VALUES ('||V_ESQUEMA_M||'.S_DD_EST_EST_ITI.NEXTVAL, '||V_NUM||', ''6'', ''SANC'', ''Sancionado'', ''Sancionado'', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Estado: Sancionado insertado...');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el estado Sancionado');
	END IF;
	
	
		
		
	-- Creamos los perfiles de gestión y supervisión para los nuevos estados del itinerario
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GESTDEUDA''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_PEF_GESTOR;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES (PEF_ID, PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PEF_CODIGO, PEF_ES_CARTERIZADO)
					VALUES ('||V_PEF_GESTOR||',''Gestor para la gestión de deuda'',''Gestor para la gestión de deuda'',0,''DML'',SYSDATE,0,''GESTDEUDA'',0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha creado un perfil gestor deuda(GESTDEUDA), con PEF_ID: '||V_PEF_GESTOR);
	ELSE		
		V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GESTDEUDA''';
		EXECUTE IMMEDIATE V_SQL INTO V_PEF_GESTOR;
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia el perfil gestor deuda(GESTDEUDA), con PEF_ID: '||V_PEF_GESTOR);
	END IF;
		
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUPGESTDEUDA''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_PEF_SUPER;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES (PEF_ID, PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PEF_CODIGO, PEF_ES_CARTERIZADO)
					VALUES ('||V_PEF_SUPER||',''Supervisor para la gestión de deuda'',''Supervisor para la gestión de deuda'',0,''DML'',SYSDATE,0,''SUPGESTDEUDA'',0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha creado un perfil gestor deuda(SUPGESTDEUDA), con PEF_ID: '||V_PEF_SUPER);
	ELSE			
		V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUPGESTDEUDA''';
		EXECUTE IMMEDIATE V_SQL INTO V_PEF_SUPER;
	END IF;
    
	-- Ahora creamos los registros para enlazar los estados a este nuevo itinerario
	-- CE Completar expediente
	V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO=''CE'' AND DD_EIN_ID = 2';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_EST;
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_EST_CE;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_TELECOBRO, EST_PLAZO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_EST_CE||', '||V_PEF_GESTOR||', '||V_PEF_SUPER||', '||V_ITI||', '||V_DD_EST||', 0, 864000000, 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertado estado Completar expediente al itinerario: Estándar.');
	ELSE
		V_SQL := 'SELECT EST_ID FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0 AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_EST_CE;
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba insertado el estado Completar expediente al itinerario: Estándar con id, EST_ID: '||V_EST_CE);
	END IF;
		
	-- RE Revisar expediente
	V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO=''RE'' AND DD_EIN_ID = 2';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_EST;
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN		
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_EST_RE;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_TELECOBRO, EST_PLAZO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_EST_RE||', '||V_PEF_GESTOR||', '||V_PEF_SUPER||', '||V_ITI||', '||V_DD_EST||', 0, 864000000, 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertado estado Revisar expediente al itinerario: Estándar.');
	ELSE
		V_SQL := 'SELECT EST_ID FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0 AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_EST_RE;
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba insertado el estado Revisar expediente al itinerario: Estándar con id, EST_ID: '||V_EST_RE);
	END IF;			
		
	-- FP Formalizar propuesta
	V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO=''FP'' AND DD_EIN_ID = 2';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_EST;
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN		
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_EST_FP;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_TELECOBRO, EST_PLAZO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_EST_FP||', '||V_PEF_GESTOR||', '||V_PEF_SUPER||', '||V_ITI||', '||V_DD_EST||', 0, 864000000, 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertado estado Formalizar propuesta al itinerario: Estándar.');
	ELSE
		V_SQL := 'SELECT EST_ID FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0 AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_EST_FP;
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba insertado el estado Formular propuesta al itinerario: Estándar con id, EST_ID: '||V_EST_FP);
	END IF;		
		
	-- ENSAN En sanción
	V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO=''ENSAN'' AND DD_EIN_ID = 2';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_EST;
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN		
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_EST_ENSAN;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_TELECOBRO, EST_PLAZO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_EST_ENSAN||', '||V_PEF_GESTOR||', '||V_PEF_SUPER||', '||V_ITI||', '||V_DD_EST||', 0, 864000000, 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertado estado En sanción al itinerario: Estándar.');
	ELSE
		V_SQL := 'SELECT EST_ID FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0 AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_EST_ENSAN;
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba insertado el estado En sancion al itinerario: Estándar con id, EST_ID: '||V_EST_ENSAN);
	END IF;		
						
	-- SANC Sancionado
	V_SQL := 'SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO=''SANC'' AND DD_EIN_ID = 2';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_EST;
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN		
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_EST_ESTADOS.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_EST_SANC;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID, PEF_ID_GESTOR, PEF_ID_SUPERVISOR, ITI_ID, DD_EST_ID, EST_TELECOBRO, EST_PLAZO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_EST_SANC||', '||V_PEF_GESTOR||', '||V_PEF_SUPER||', '||V_ITI||', '||V_DD_EST||', 0, 864000000, 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertado estado Sancionado al itinerario: Estándar.');
	ELSE
		V_SQL := 'SELECT EST_ID FROM '||V_ESQUEMA||'.EST_ESTADOS WHERE ITI_ID = '||V_ITI||' AND DD_EST_ID = '||V_DD_EST||' AND BORRADO = 0 AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_EST_SANC;
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba insertado el estado Sancionado al itinerario: Estándar con id, EST_ID: '||V_EST_SANC);
	END IF;		
		
	-- ***************************************************** Reglas de elevación **************************************
	-- ***************************************************** CE Completar expediente **************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] Reglas elevación para estado CE Completar expediente.********************************');
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''GESTION_PROPUESTA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''EXP''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_CE||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_CE||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada GESTION PROPUESTA para EXPEDIENTE');
	END IF;
		
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''POLITICA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''PPGRA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_CE||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_CE||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada POLITICA para PPGRA');
	END IF;

	-- ***************************************************** RE Revisar expediente **************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] Reglas elevación para estado RE Revisar expediente.********************************');
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''GESTION_PROPUESTA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''EXP''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_RE||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_RE||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada GESTION PROPUESTA para EXPEDIENTE');
	END IF;
		
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''POLITICA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''PPGRA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_RE||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_RE||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada POLITICA para PPGRA');
	END IF;
		
	-- ***************************************************** FP Formularizar propuesta **************************************
	/*
	DBMS_OUTPUT.PUT_LINE('[INFO] Reglas elevación para estado FP Formularizar propuesta.********************************');
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''GESTION_PROPUESTA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''EXP''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_FP||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_FP||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada GESTION PROPUESTA para EXPEDIENTE');
	END IF;
		
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''POLITICA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''PPGRA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_FP||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_FP||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada POLITICA para PPGRA');
	END IF;
	*/		
		
	-- ***************************************************** ENSAN En sancion **************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] Reglas elevación para estado ENSAN EN sancion.********************************');
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''GESTION_PROPUESTA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''EXP''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_ENSAN||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_ENSAN||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada GESTION PROPUESTA para EXPEDIENTE');
	END IF;
		
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''POLITICA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''PPGRA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_ENSAN||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_ENSAN||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada POLITICA para PPGRA');
	END IF;
	
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''SANCIONAR_PROPUESTA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''EXP''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_ENSAN||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_ENSAN||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada SANCIONAR_PROPUESTA para EXP');
	END IF;	
		
	-- ***************************************************** SANC Sancionado **************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] Reglas elevación para estado SANC Sancionado. ********************************');
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''GESTION_PROPUESTA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''EXP''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_SANC||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_SANC||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada GESTION PROPUESTA para EXPEDIENTE');
	END IF;
		
	V_SQL := 'SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO=''POLITICA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TRE_ID;
	V_SQL := 'SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO=''PPGRA''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_AEX_ID;
	V_SQL := 'SELECT COUNT(1) FROM REE_REGLAS_ELEVACION_ESTADO WHERE DD_TRE_ID = '||V_DD_TRE_ID||' AND DD_AEX_ID = '||V_DD_AEX_ID||' AND EST_ID = '||V_EST_SANC||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO (REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_REE_REGLAS_ELEVACION_ESTADO.NEXTVAL, '||V_DD_TRE_ID||', '||V_DD_AEX_ID||', '||V_EST_SANC||', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertada POLITICA para PPGRA');
	END IF;
	
	-- ***************************************** Creación de modelo de arquetipos nuevo para la Gestión de deuda ***************************************************************************
	
	-- Comprobamos si ya existe un modelo llamado Gestión Deuda en estado '3' VIGENTE
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MOA_MODELOS_ARQ WHERE MOA_NOMBRE = ''Gestión Deuda'' AND DD_ESM_ID = (SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO WHERE DD_ESM_CODIGO=''3'')';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM = 0 THEN
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_MOA_MODELOS_ARQ.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_MOA_ID;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MOA_MODELOS_ARQ  (MOA_ID, MOA_NOMBRE, MOA_DESCRIPCION, DD_ESM_ID, MOA_FECHA_INI_VIGENCIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
					VALUES ('||V_MOA_ID||',''Gestión Deuda'',''Modelo con el arquetipo de Gestión de Deuda'', (SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO WHERE DD_ESM_CODIGO=''3''), SYSDATE, 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Creado el nuevo Modelo de arquetipos llamado Gestión Deuda en estado Vigente, MOA_ID: '||V_MOA_ID);
	ELSE
		V_SQL := 'SELECT MOA_ID FROM '||V_ESQUEMA||'.MOA_MODELOS_ARQ WHERE MOA_NOMBRE = ''Gestión Deuda'' AND DD_ESM_ID = (SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO WHERE DD_ESM_CODIGO=''3'') AND ROWNUM=1';
		EXECUTE IMMEDIATE V_SQL INTO V_MOA_ID;
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existía un Modelo de arquetipos llamado Gestión Deuda en estado Vigente, MOA_ID: '||V_MOA_ID);
	END IF;
	
	-- Pasamos a estado HISTORICO el resto de modelos
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.MOA_MODELOS_ARQ 
				SET DD_ESM_ID = (SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO WHERE DD_ESM_CODIGO=''4'')
					,MOA_FECHA_FIN_VIGENCIA = SYSDATE
					,USUARIOMODIFICAR = ''DML''
					,FECHAMODIFICAR = SYSDATE
				WHERE DD_ESM_ID = (SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO WHERE DD_ESM_CODIGO=''3'')
					AND MOA_ID <> '||V_MOA_ID;
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han historizado el resto de Modelos de arquetipos.');
	
	-- Creamos en LIA el arquetipo para el nuevo itinerario
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.LIA_LISTA_ARQUETIPOS WHERE ITI_ID = '||V_ITI||' AND LIA_NOMBRE = ''Gestión Deuda''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_LIA_LISTA_ARQUETIPOS.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_LIA_ID;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.LIA_LISTA_ARQUETIPOS  (LIA_ID,  ITI_ID,  LIA_PRIORIDAD,  LIA_NOMBRE,  VERSION, USUARIOCREAR,  FECHACREAR,  BORRADO,  LIA_NIVEL,  LIA_GESTION,  LIA_PLAZO_DISPARO,  DD_TSN_ID,  RD_ID )
					VALUES ('||V_LIA_ID||', '||V_ITI||',0,''Gestión Deuda'', 0, ''DML'', SYSDATE, 0, 0, 1, 10, 
						(SELECT DD_TSN_ID FROM '||V_ESQUEMA_M||'.DD_TSN_TIPO_SALTO_NIVEL WHERE DD_TSN_CODIGO = ''TODOS''),
						(SELECT RD_ID FROM '||V_ESQUEMA||'.RULE_DEFINITION WHERE RD_NAME = ''REGLA GENERICA''))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha creado un registro en lista arquetipos. LIA_ID: '||V_LIA_ID);
	ELSE
		V_SQL := 'SELECT LIA_ID FROM '||V_ESQUEMA||'.LIA_LISTA_ARQUETIPOS WHERE ITI_ID = '||V_ITI||' AND LIA_NOMBRE = ''Gestión Deuda'' AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_LIA_ID;
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existía un registro en lista arquetipos. LIA_ID: '||V_LIA_ID);
	END IF;	
	
	-- Creamos en ARQ el arquetipo para el nuevo itinerario
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ARQ_ARQUETIPOS WHERE ITI_ID = '||V_ITI||' AND ARQ_NOMBRE = ''Gestión Deuda''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_ARQ_ARQUETIPOS.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_ARQ_ID;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ARQ_ARQUETIPOS (ARQ_ID,  ITI_ID,  ARQ_PRIORIDAD,  ARQ_NOMBRE,  VERSION,  USUARIOCREAR,  FECHACREAR, BORRADO, ARQ_NIVEL, ARQ_GESTION, ARQ_PLAZO_DISPARO, DD_TSN_ID, RD_ID)
					VALUES ('||V_ARQ_ID||','||V_ITI||',0,''Gestión Deuda'',0,''DML'',SYSDATE,0,0,1,10,
						(SELECT DD_TSN_ID FROM '||V_ESQUEMA_M||'.DD_TSN_TIPO_SALTO_NIVEL WHERE DD_TSN_CODIGO = ''TODOS''),
						(SELECT RD_ID FROM '||V_ESQUEMA||'.RULE_DEFINITION WHERE RD_NAME = ''REGLA GENERICA''))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha creado un nuevo arquetipo, ARQ_ITI: '||V_ARQ_ID);
	ELSE
		V_SQL := 'SELECT ARQ_ID FROM '||V_ESQUEMA||'.ARQ_ARQUETIPOS WHERE ITI_ID = '||V_ITI||' AND ARQ_NOMBRE = ''Gestión Deuda'' AND ROWNUM=1';
		EXECUTE IMMEDIATE V_SQL INTO V_ARQ_ID;
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existía un arquetipo de este tipo, ARQ_ID: '||V_ARQ_ID);
	END IF;
				
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MRA_REL_MODELO_ARQ WHERE MOA_ID = '||V_MOA_ID||' AND LIA_ID = '||V_LIA_ID||' AND ITI_ID='||V_ITI||' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		V_SQL := 'SELECT '||V_ESQUEMA||'.S_MRA_REL_MODELO_ARQ.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_MRA_ID;
	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MRA_REL_MODELO_ARQ (MRA_ID, MOA_ID, LIA_ID, MRA_NIVEL, ITI_ID, MRA_PRIORIDAD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, MRA_PLAZO_DISPARO)
					VALUES ('||V_MRA_ID||','||V_MOA_ID||','||V_LIA_ID||',0,'||V_ITI||',1,0,''DML'',SYSDATE,0,10)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Creado la relación entre MOA y LIA con MRA_ID: '||V_MRA_ID);
		
		-- Actualizamos el MRA_ID de ARQ_ARQUETIPOS para poder relacionarlo con su correspondiente LIA
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ARQ_ARQUETIPOS SET MRA_ID = '||V_MRA_ID||' WHERE ARQ_ID = '||V_ARQ_ID;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Relacionado el nuevo ARQ_ARQUETIPO con su LIA_LISTA_ARQUETIPOS a través de su MRA');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existía la relación entre el MOA_ID: '||V_MOA_ID||' y el LIA_ID: '||V_LIA_ID);
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
