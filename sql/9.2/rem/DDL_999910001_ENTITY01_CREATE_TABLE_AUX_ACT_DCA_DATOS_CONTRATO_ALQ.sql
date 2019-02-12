--/*
--##########################################
--## AUTOR=Sonia García
--## FECHA_CREACION=20190116
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=func-rem-alquileres
--## INCIDENCIA_LINK=HREOS-5234
--## PRODUCTO=NO
--## 
--## Finalidad: DDL
--## INSTRUCCIONES: Crear tabla auxiliar para recoger datos de BI-HAYA-DWH AUX_ACT_DCA_DTS_CNT_ALQ.
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
    V_EXISTE NUMBER (1); -- Vlbe. para consultar si la sequencia existe.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(32 CHAR) := 'AUX_ACT_DCA_DTS_CNT_ALQ'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    BEGIN

    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la tabla la borramos
    IF V_NUM_TABLAS = 1 THEN 

	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe');  
		
    ELSE
	
    --Creamos la tabla
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(

		  DCA_FECHA_CREACION		DATE,
		  DCA_NOM_PRINEX                VARCHAR2(255 CHAR),
		  ACT_ID                     	NUMBER(16,0),
		  DCA_UHEDIT                  	VARCHAR2(255 CHAR),
		  DCA_ID_CONTRATO              	VARCHAR2(255 CHAR),
		  DCA_EST_CONTRATO              VARCHAR2(255 CHAR),
		  DCA_FECHA_FIRMA               DATE,
		  DCA_FECHA_FIN_CONTRATO        DATE,
		  DCA_CUOTA                     NUMBER(16,2),
		  DCA_NOMBRE_CLIENTE            VARCHAR2(255 CHAR), 
		  DCA_DEUDA_PENDIENTE        	NUMBER(16,2),
	      	  DCA_RECIBOS_PENDIENTES        NUMBER(16,0),
	       	  DCA_F_ULTIMO_PAGADO           DATE, 
	      	  DCA_F_ULTIMO_ADEUDADO         DATE

		   )';

DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
    
    END IF;


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
