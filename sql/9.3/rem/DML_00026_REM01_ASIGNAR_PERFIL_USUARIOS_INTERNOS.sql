--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5696
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error;
    
    V_USUARIO VARCHAR2(25 CHAR) := 'REMVIP-5696';
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    
    V_SEQUENCE VARCHAR2(32000 CHAR);
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_SQL := 'SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_SQL INTO V_SEQUENCE;
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU
				SELECT 19504, (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''USUINT'')
			        ,INTERNOS.USU_ID, ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY 1) + '||V_SEQUENCE||', 0, '''||V_USUARIO||''', SYSDATE
			        ,NULL, NULL, NULL, NULL, 0, NULL, NULL
			    FROM (
			        SELECT DISTINCT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
			        JOIN '||V_ESQUEMA||'.ZON_PEF_USU ZPU ON ZPU.USU_ID = USU.USU_ID
			        JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON PEF.PEF_ID = ZPU.PEF_ID 
			        WHERE PEF.PEF_CODIGO = ''HAYASUPER'' OR USU.USU_MAIL LIKE ''%@haya.es''
			    ) INTERNOS';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se ha añadido el perfil USUINT a '||SQL%ROWCOUNT||' usuarios.');

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');
    
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