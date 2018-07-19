--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180719
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1373
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla ACT_ILB_NFO_LIBERBANK.
--## INSTRUCCIONES:
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'ACT_ILB_NFO_LIBERBANK'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1373';
    USUARIO_CONSULTA_REM VARCHAR2(50 CHAR):= 'REM_QUERY';
    
 BEGIN
 
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	 
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
 
	IF V_COUNT = 0 THEN
	 
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
		
		EXECUTE IMMEDIATE V_SQL;
			
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);

	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la secuencia S_'||V_TABLA);	
	  
	END IF;
 
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 0 THEN
 
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
				  ACT_ID NUMBER(16,0) 
				, DD_CCO_ID NUMBER(16,0) 
				, ILB_COD_PROMOCION VARCHAR2(100 CHAR)
				, DD_TBE_ID NUMBER(16,0) 
				, DD_SBE_ID NUMBER(16,0) 
				, CONSTRAINT FK2_ACT_ID
					FOREIGN KEY (ACT_ID)
					REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO(ACT_ID)
				, CONSTRAINT FK_DD_CCO_ID
					FOREIGN KEY (DD_CCO_ID)
					REFERENCES '||V_ESQUEMA||'.DD_CCO_CATEGORIA_CONTABLE(DD_CCO_ID)
				, CONSTRAINT FK_DD_TBE_ID
					FOREIGN KEY (DD_TBE_ID)
					REFERENCES '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO_BDE(DD_TBE_ID)
				, CONSTRAINT FK_DD_SBE_ID
					FOREIGN KEY (DD_SBE_ID)
					REFERENCES '||V_ESQUEMA||'.DD_SBE_SUBTIPO_ACTIVO_BDE(DD_SBE_ID)
				)
			  ';
	  
		EXECUTE IMMEDIATE V_SQL;
 
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la tabla '||V_TABLA);	
	
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
