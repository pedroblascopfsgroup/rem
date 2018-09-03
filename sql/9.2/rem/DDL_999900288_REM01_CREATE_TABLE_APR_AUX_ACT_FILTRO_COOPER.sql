--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1408
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla APR_AUX_ACT_FILTRO_COOPER.
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
    V_TABLA VARCHAR2(27 CHAR) := 'APR_AUX_ACT_FILTRO_COOPER'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1408';
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
					 ACT_ID                      NUMBER(16)        
					,NUMERO_ACTIVO               NUMBER(16)        
					,ACT_NUM_ACTIVO_REM          NUMBER(16)        
					,COACES              		 VARCHAR2(9 CHAR)  NOT NULL
					,COESVE                      VARCHAR2(2 CHAR)  
					,COESVE_DES 				 VARCHAR2(100 CHAR)  
					,BIACSI                      VARCHAR2(1 CHAR)  
					,BIACSI_DES 				 VARCHAR2(100 CHAR)  
					,FERLL6                      VARCHAR2(8 CHAR)  
					,CORPRO                      VARCHAR2(2 CHAR)  
					,IMVACT                      VARCHAR2(15 CHAR) 
					,FEVACT                      VARCHAR2(8 CHAR)  
					,OBRTOR                      VARCHAR2(40 CHAR) 
					,BIACSU                      VARCHAR2(1 CHAR)  
					,BIACSU_DES 				 VARCHAR2(100 CHAR)  
					,APRESH                      VARCHAR2(1 CHAR)  
					,APRESH_DES 				 VARCHAR2(100 CHAR)  
					,POPROP                      VARCHAR2(6 CHAR)  
					,COGRAP                      VARCHAR2(2 CHAR)  
					,COGRAP_DES 				 VARCHAR2(100 CHAR)  
					,COSPAT                      VARCHAR2(5 CHAR)  
					,FEFOAC                      VARCHAR2(8 CHAR)  
					,FEREPO                      VARCHAR2(8 CHAR)  
					,FESELA                      VARCHAR2(8 CHAR)  
					,FERELA                      VARCHAR2(8 CHAR)  
					,BINOCU                      VARCHAR2(1 CHAR)  
					,BINOCU_DES 				 VARCHAR2(100 CHAR)  
					,FICOAR                      VARCHAR2(8 CHAR)  
					,QCRSMR                      VARCHAR2(1 CHAR)  
					,QCRSMR_DES 				 VARCHAR2(100 CHAR)  
					,QFRSMR                      VARCHAR2(8 CHAR)  
					,BIARRE                      VARCHAR2(1 CHAR)  
					,BIARRE_DES 				 VARCHAR2(100 CHAR)  
					,FFCOAR                      VARCHAR2(8 CHAR)  
					,COSOCU                      VARCHAR2(2 CHAR)  
					,COSOCU_DES 			 	 VARCHAR2(100 CHAR)  
					,NOARRE                      VARCHAR2(35 CHAR) 
					,COENOR                      VARCHAR2(5 CHAR)  
					,IDCOEQ                      VARCHAR2(5 CHAR)  
					,FEPHAC                      VARCHAR2(8 CHAR)  
					,FEPREG                      VARCHAR2(8 CHAR)  
					,FEINAU                      VARCHAR2(8 CHAR)  
					,FEENAG                      VARCHAR2(8 CHAR)  
					,FEEAAU                      VARCHAR2(8 CHAR)  
					,FESEPR                      VARCHAR2(8 CHAR)  
					,FEADAC                      VARCHAR2(8 CHAR)  
					,FETIFI                      VARCHAR2(8 CHAR)  
					,IDAUTO                      VARCHAR2(10 CHAR) 
					,NOCURA                      VARCHAR2(40 CHAR) 
					,FESEPO                      VARCHAR2(8 CHAR)  
					,IMPADJ                      VARCHAR2(15 CHAR) 
  
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
