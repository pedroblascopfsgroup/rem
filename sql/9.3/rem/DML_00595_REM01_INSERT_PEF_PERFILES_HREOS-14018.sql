--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20210502
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14018
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en USU_USUARIOS los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_NUM_FILAS NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(30 CHAR) := 'HREOS-14018'; -- USUARIOCREAR/USUARIOMODIFICAR.
	V_PERFIL VARCHAR2(30 CHAR) := 'PBC_HRE';
	V_PERFIL_DESC VARCHAR2(100 CHAR) := 'PBCHRE';

BEGIN	


	DBMS_OUTPUT.PUT_LINE('[INICIO] TABLA PEF_PERFILES');
	
	V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||V_PERFIL||''' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 0 THEN
	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES (PEF_ID, PEF_CODIGO, PEF_DESCRIPCION, PEF_DESCRIPCION_LARGA,
					USUARIOCREAR, FECHACREAR)
					SELECT '||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL,'''||V_PERFIL||''','''||V_PERFIL_DESC||''','''||V_PERFIL_DESC||''',
					'''||V_USU||''',SYSDATE FROM DUAL';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[FIN] PERFIL INSERTADO');
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[FIN] PERFIL YA EXISTE');
		
	END IF;

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] PERFIL CREADO '||V_PERFIL||'');
 
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
