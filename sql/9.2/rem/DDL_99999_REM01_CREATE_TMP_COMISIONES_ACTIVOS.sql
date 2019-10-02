--/*
--##########################################
--## AUTOR=ALBERT PASTOR
--## FECHA_CREACION=20190725
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6985
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla temporales para el cálculo de comisiones.
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
    V_NUM_TABLAS NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(27 CHAR) := 'TMP_COMISIONES_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	  V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla final con las comisiones'; -- Vble. para los comentarios de las tablas	
    
 BEGIN 
	
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla 
    IF V_NUM_TABLAS = 1 THEN 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla existente');
  	
  	ELSE
  	
		DBMS_OUTPUT.PUT_LINE('[INICIO] ' || V_ESQUEMA || '.'||V_TABLA||'... Se va ha crear.');  		
		--Creamos la tabla
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
                COMISION_ID NUMBER(16)  
                ,CARTERA  VARCHAR2(20 CHAR)
                ,SUBCARTERA VARCHAR2(20 CHAR)
                ,LEADORIGIN VARCHAR2(20 CHAR)
                ,ASSETTYPE  VARCHAR2(20 CHAR)
                ,ASSETSUBTYPE VARCHAR2(20 CHAR)
                ,OFFERTYPE  VARCHAR2(20 CHAR)
                ,COMISSIONTYPE  VARCHAR2(20 CHAR)
                ,COMERCIALTYPE  VARCHAR2(20 CHAR)
                ,STRECHMIN  NUMBER(16,0)
                ,STRECHMAX  NUMBER(16,0)
                ,COMISSIONPERCENTAGE  NUMBER(16,2)
                ,MAXCOMISSIONAMMOUNT  NUMBER(16,2)
                ,MINCOMISSIONAMOUNT NUMBER(16,2)
                ,CREATEDATE DATE
                ,CREATEUSER VARCHAR2(50 CHAR)
                ,MODIFYDATE DATE
                ,MODIFYUSER VARCHAR2(50 CHAR)
                ,TRAMO VARCHAR2(10 CHAR)
  )';

		EXECUTE IMMEDIATE V_SQL;
    COMMIT;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
		
		--Creamos comentario
		V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_SQL;
    COMMIT;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');
  		

    DBMS_OUTPUT.PUT_LINE('[INFO] Creamos los indices de la tabla' );  

    V_SQL := 'CREATE INDEX comision_idx
    ON '||V_TABLA||' (COMISION_ID)
    COMPUTE STATISTICS';
    EXECUTE IMMEDIATE V_SQL;
    COMMIT;
    END IF;    
	

DBMS_OUTPUT.PUT_LINE('[INFO] Proceso terminado.');
 
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
