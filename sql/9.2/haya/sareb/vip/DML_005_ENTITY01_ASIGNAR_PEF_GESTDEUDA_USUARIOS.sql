--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-796
--## PRODUCTO=NO
--## Finalidad: Asigna a los usuarios los perfiles para la gestión de Expedientes de Deuda
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
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_PEF_GESTOR NUMBER;
    V_PEF_SUPER NUMBER;
    V_ZON_ID NUMBER := 18915;  -- Id de la ZON_ID
    V_USU_ID NUMBER;
    
	TYPE T_USUARIOS IS TABLE OF VARCHAR2(250);
	
	V_USU_GESTORES T_USUARIOS := T_USUARIOS('afernandezd','abarado','aabadv','agarciar','cfontanals','driquelme','esanzgr','flara','fcastro');
											
	V_USU_SUPER T_USUARIOS := T_USUARIOS('acebrianc',
										'acarrasco',
										'brodriguezca',
										'esanchezr',
										'jpalli',
										'jcaturla',
										'jsoto',
										'lavila',
										'valonso');
	
BEGIN
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GESTDEUDA''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 1 THEN
		V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GESTDEUDA''';
		EXECUTE IMMEDIATE V_SQL INTO V_PEF_GESTOR;
	ELSE
		RAISE_APPLICATION_ERROR(-20101, 'Todavía no se ha creado el perfil Gestor Gestión Deuda. Ejecutar primero: sql/9.2/haya/sareb/vip/DML_004_ENTITY01_DELETE_INSERT_ITINERARIOS.sql');
	END IF;
		
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUPGESTDEUDA''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 1 THEN
		V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUPGESTDEUDA''';
		EXECUTE IMMEDIATE V_SQL INTO V_PEF_SUPER;
	ELSE
		RAISE_APPLICATION_ERROR(-20101, 'Todavía no se ha creado el perfil Supervisor Gestión Deuda. Ejecutar primero: sql/9.2/haya/sareb/vip/DML_004_ENTITY01_DELETE_INSERT_ITINERARIOS.sql');
	END IF;	

	DBMS_OUTPUT.PUT_LINE('[INFO] Agregando perfil Gestor Gestión Deuda a usuarios.');
	FOR I IN V_USU_GESTORES.FIRST .. V_USU_GESTORES.LAST
	LOOP
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USU_GESTORES(I)||'''';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM > 0 THEN
			V_SQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USU_GESTORES(I)||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_USU_ID;
	
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, FECHACREAR, USUARIOCREAR, BORRADO)
					VALUES ('||V_ZON_ID||','||V_PEF_GESTOR||','||V_USU_ID||','||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL, SYSDATE, ''DML'', 0)';
			DBMS_OUTPUT.PUT_LINE('[INFO] Usuario: '||V_USU_GESTORES(I)||' agregado perfil gestor Gestion Deuda');
      EXECUTE IMMEDIATE V_MSQL;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] *** No se ha encontrado usuario con USU_USERNAME = '||V_USU_GESTORES(I));
		END IF;
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Agregando perfil Supervisor Gestión Deuda a usuarios.');
	FOR I IN V_USU_SUPER.FIRST .. V_USU_SUPER.LAST
	LOOP
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USU_SUPER(I)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM > 0 THEN
			V_SQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USU_SUPER(I)||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_USU_ID;
	
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, FECHACREAR, USUARIOCREAR, BORRADO)
					VALUES ('||V_ZON_ID||','||V_PEF_SUPER||','||V_USU_ID||','||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL, SYSDATE, ''DML'', 0)';
			DBMS_OUTPUT.PUT_LINE('[INFO] Usuario: '||V_USU_SUPER(I)||' agregado perfil gestor Gestion Deuda');
      EXECUTE IMMEDIATE V_MSQL;
    ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] *** No se ha encontrado usuario con USU_USERNAME = '||V_USU_SUPER(I));
		END IF;
	END LOOP;	

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
