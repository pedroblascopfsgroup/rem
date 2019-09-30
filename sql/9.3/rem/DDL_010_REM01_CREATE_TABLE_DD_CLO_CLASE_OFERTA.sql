--/*
--##########################################
--## AUTOR=David Benavente
--## FECHA_CREACION=20190708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6905
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla OGR_OFERTAS_AGRUPADAS_LBK.
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
    V_TABLA VARCHAR2(27 CHAR) := 'DD_CLO_CLASE_OFERTA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-6905';
    
    
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
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 0 THEN 
		V_SQL := 'CREATE TABLE ' || V_ESQUEMA || '.'||V_TABLA||'
                    (
                      DD_CLO_ID         		NUMBER(16)          NOT NULL,
                      DD_CLO_CODIGO            		VARCHAR2(10 CHAR)   NOT NULL,
                      DD_CLO_DESCRIPCION        	VARCHAR2(50 CHAR)   NOT NULL,
                      DD_CLO_DESCRIPCION_LARGA  	VARCHAR2(300 CHAR)  NOT NULL,
                      VERSION                   	INTEGER             DEFAULT 0                     NOT NULL,
                      USUARIOCREAR             		VARCHAR2(50 CHAR)   NOT NULL,
                      FECHACREAR                	TIMESTAMP(6)        NOT NULL,
                      USUARIOMODIFICAR          	VARCHAR2(50 CHAR),
                      FECHAMODIFICAR            	TIMESTAMP(6),
                      USUARIOBORRAR             	VARCHAR2(50 CHAR),
                      FECHABORRAR               	TIMESTAMP(6),
                      BORRADO                   	NUMBER(1)           DEFAULT 0                     NOT NULL
                    )';
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
