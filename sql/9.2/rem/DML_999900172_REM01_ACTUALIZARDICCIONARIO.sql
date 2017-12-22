--/*
--##########################################
--## AUTOR=Sergio Ortuño Gigante
--## FECHA_CREACION=20171219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK= HREOS-3468
--## PRODUCTO=NO
--##
--## Finalidad: Adaptar el diccionario del campo Situación del Título de REM al de UVEM (COSTIT)
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualizaciÃ³n de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL2 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_DD_TVI_ID NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

BEGIN 

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO (DD_ETI_ID, DD_ETI_CODIGO, DD_ETI_DESCRIPCION, DD_ETI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
	VALUES (
	5,
	''05'',
	''Inmatriculados'',
	''Inmatriculados'',
	0,
	''HREOS-3468'',
	SYSDATE,
	0
	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('Insertados '|| sql%rowcount ||' registros.');


	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO (DD_ETI_ID, DD_ETI_CODIGO, DD_ETI_DESCRIPCION, DD_ETI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
	VALUES (
	6,
	''06'',
	''Subsanar'',
	''Subsanar'',
	0,
	''HREOS-3468'',
	SYSDATE,
	0
	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('Insertados '|| sql%rowcount ||' registros.');



	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO (DD_ETI_ID, DD_ETI_CODIGO, DD_ETI_DESCRIPCION, DD_ETI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
	VALUES (
	7,
	''07'',
	''Nulo'',
	''Nulo'',
	0,
	''HREOS-3468'',
	SYSDATE,
	0
	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('Insertados '|| sql%rowcount ||' registros.');


	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] - INSERTADOS EN EL DICCIONARIO');




	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_EQV_BANKIA_REM SET DD_CODIGO_REM = ''07'' WHERE DD_CODIGO_BANKIA = ''1'' AND DD_NOMBRE_BANKIA = ''DD_SITUACION_TITULO'' ';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('Updateados '|| sql%rowcount ||' registros.');


	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_EQV_BANKIA_REM SET DD_CODIGO_REM = ''06'' WHERE DD_CODIGO_BANKIA = ''3'' AND DD_NOMBRE_BANKIA = ''DD_SITUACION_TITULO'' ';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('Updateados '|| sql%rowcount ||' registros.');


	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_EQV_BANKIA_REM SET DD_CODIGO_REM = ''05'' WHERE DD_CODIGO_BANKIA = ''5'' AND DD_NOMBRE_BANKIA = ''DD_SITUACION_TITULO'' ';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('Updateados '|| sql%rowcount ||' registros.');

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] - MAPEADO');


    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
	
