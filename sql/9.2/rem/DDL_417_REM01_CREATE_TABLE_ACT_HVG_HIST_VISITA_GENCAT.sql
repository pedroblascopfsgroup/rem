--/*
--##########################################
--## AUTOR=ELISA OCCHIPINTI
--## FECHA_CREACION=20181204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4929
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla ACT_HVG_HIST_VISITA_GENCAT
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'ACT_HVG_HIST_VISITA_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    VN_COUNT NUMBER(16); -- Vble. para consulta que valida la existencia de una secuencia.

    BEGIN

    -- ******** ACT_HVG_HIST_VISITA_GENCAT*******
    DBMS_OUTPUT.PUT_LINE('******** ACT_HVG_HIST_VISITA_GENCAT ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla ACT_HVG_HIST_VISITA_GENCAT
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
               (HVG_ID                   NUMBER(16,0) NOT NULL PRIMARY KEY,
			    HCG_ID                   NUMBER(16,0) NOT NULL,
			    VIS_ID                   NUMBER(16,0) NOT NULL,
			    VERSION 				 INTEGER DEFAULT 0 NOT NULL,
			    USUARIOCREAR             VARCHAR2(50 CHAR) NOT NULL,
			    FECHACREAR               DATE DEFAULT SYSDATE NOT NULL,
			    BORRADO                  NUMBER(*,0) DEFAULT 0 NOT NULL,
			    USUARIOMODIFICAR         VARCHAR2(50 CHAR),
			    FECHAMODIFICAR           DATE,
			    USUARIOBORRAR            VARCHAR2(50 CHAR),
			    FECHABORRAR              DATE,
                CONSTRAINT FK_HVG_HIST_HCG_HIST FOREIGN KEY (HCG_ID) REFERENCES '|| V_ESQUEMA ||'.ACT_HCG_HIST_COM_GENCAT (HCG_ID),
                CONSTRAINT FK_HVG_HIST_VIS_VISITAS FOREIGN KEY (VIS_ID) REFERENCES '|| V_ESQUEMA ||'.VIS_VISITAS (VIS_ID)
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Tabla creada');		
		
    END IF;
    
    	--Secuencia para la tabla ACT_HAG_HIST_ADECUACION_GENCAT
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_OWNER='''||V_ESQUEMA||''' AND SEQUENCE_NAME=''S_'||V_TEXT_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
	IF VN_COUNT = 0 THEN
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||' MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Secuencia S_'||V_TEXT_TABLA||' creada OK');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Secuencia S_'||V_TEXT_TABLA||' ya existia');
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
