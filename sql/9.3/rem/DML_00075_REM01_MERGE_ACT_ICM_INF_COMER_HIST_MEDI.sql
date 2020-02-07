--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20190118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8668
--## PRODUCTO=NO
--## Finalidad:
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

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(30 CHAR):= 'ACT_ICM_INF_COMER_HIST_MEDI';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-8668';
    
 BEGIN
 
 	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI T1
				USING (SELECT ICM_ID FROM '||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI WHERE ICM_FECHA_HASTA IS NOT NULL) T2
				ON (T1.ICM_ID = T2.ICM_ID)
				WHEN MATCHED THEN UPDATE
				SET DD_TRL_ID = (SELECT DD_TRL_ID FROM '||V_ESQUEMA||'.DD_TRL_TIPO_ROLES_MEDIADOR WHERE DD_TRL_CODIGO = ''03''),
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHACREAR = SYSDATE
			  ';
    				
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('Mergeados ' ||SQL%ROWCOUNT|| ' registros -> ICM_FECHA_HASTA IS NOT NULL');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI T1
				USING (SELECT ICM_ID FROM '||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI WHERE DD_TRL_ID IS NULL) T2
				ON (T1.ICM_ID = T2.ICM_ID)
				WHEN MATCHED THEN UPDATE
				SET DD_TRL_ID = (SELECT DD_TRL_ID FROM '||V_ESQUEMA||'.DD_TRL_TIPO_ROLES_MEDIADOR WHERE DD_TRL_CODIGO = ''01''),
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHACREAR = SYSDATE
			  ';
    				
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('Mergeados ' ||SQL%ROWCOUNT|| ' registros restantes');
      
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_TABLA||' actualizada correctamente ');
      
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
