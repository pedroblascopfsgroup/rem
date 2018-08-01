--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180717
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1076
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla de historico de estados de EXPEDIENTE , RESERVA , OFERTA.
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
    V_TABLA VARCHAR2(27 CHAR) := 'H_TRANS_EST_EOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1076';
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
				   '||V_TABLA||'_ID NUMBER(16,0) NOT NULL
				 , ECO_NUM_EXPEDIENTE NUMBER(16,0) 
				 , DD_EOF_COD_ANT VARCHAR(50 CHAR)
                 , DD_EOF_DES_ANT VARCHAR(50 CHAR)
				 , DD_EEC_COD_ANT VARCHAR(50 CHAR)
                 , DD_EEC_DES_ANT VARCHAR(50 CHAR)
				 , DD_ERE_COD_ANT VARCHAR(50 CHAR)
                 , DD_ERE_DES_ANT VARCHAR(50 CHAR)
				 , DD_EOF_COD_POST VARCHAR(50 CHAR)
                 , DD_EOF_DES_POST VARCHAR(50 CHAR)
				 , DD_EEC_COD_POST VARCHAR(50 CHAR) 
                 , DD_EEC_DES_POST VARCHAR(50 CHAR)
				 , DD_ERE_COD_POST VARCHAR(50 CHAR) 
                 , DD_ERE_DES_POST VARCHAR(50 CHAR)
                 , FECHA_VENTA_ANT DATE 
                 , FECHA_VENTA_POST DATE 
                 , FECHA_ING_CHEQUE_ANT DATE 
                 , FECHA_ING_CHEQUE_POST DATE
                 , FECHA_FIR_RES_ANT DATE
                 , FECHA_FIR_RES_POST DATE
				 , VERSION NUMBER(16,0) DEFAULT 0 NOT NULL 
				 , USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL ENABLE
				 , FECHACREAR TIMESTAMP (6) NOT NULL ENABLE
				 , USUARIOMODIFICAR VARCHAR2(50 CHAR)
				 , FECHAMODIFICAR TIMESTAMP (6)
				 , USUARIOBORRAR VARCHAR2(50 CHAR)
				 , FECHABORRAR TIMESTAMP (6)
				 , BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL
				 , CONSTRAINT '||V_TABLA||'_ID_PK PRIMARY KEY ('||V_TABLA||'_ID)
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
