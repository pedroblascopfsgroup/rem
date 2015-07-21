--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20150714
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=PRODUCTO-109
--## PRODUCTO=SI
--## Finalidad: DDL
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN

SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_cols  
         WHERE UPPER(table_name) = 'CDD_CRN_RESULTADO_NUSE' and (UPPER(column_name) = 'ID_ACUERDO_CIERRE') 
         AND OWNER = V_ESQUEMA; 
          
     if V_NUM_TABLAS = 0 then 
	 
		EXECUTE IMMEDIATE 'CREATE SEQUENCE '||V_ESQUEMA||'.S_CDD_CRN_RESULTADO_NUSE'; 	 
		     	 
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.CDD_CRN_RESULTADO_NUSE
		(
			CRN_ID				        NUMBER(16)          NOT NULL,
			ID_EXPEDIENTE	            NUMBER(16)          NOT NULL,
			ASU_ID_EXTERNO 		        VARCHAR2(50 BYTE)          NOT NULL,
			ID_ACUERDO_CIERRE		    NUMBER(16)			NOT NULL,
			CRN_FECHA_EXTRACCION		TIMESTAMP(6)        NOT NULL,
			CRN_FICHERO_DAT				VARCHAR2(50 BYTE)   NOT NULL,
			CRN_CLAVE_FICHERO			VARCHAR2(250 BYTE)	NOT NULL,
			CRN_RESULTADO				VARCHAR2(10 BYTE)	NOT NULL,
			CRN_DESC_RESULT				VARCHAR2(100 BYTE)  NOT NULL,
			CRN_FECHA_RESULT			TIMESTAMP(6)        NOT NULL,
		  VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
		  USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
		  FECHACREAR        TIMESTAMP(6)                NOT NULL,
		  USUARIOMODIFICAR  VARCHAR2(10 CHAR),
		  FECHAMODIFICAR    TIMESTAMP(6),
		  USUARIOBORRAR     VARCHAR2(10 CHAR),
		  FECHABORRAR       TIMESTAMP(6),
		  BORRADO           NUMBER(1)                   DEFAULT 0                     NOT NULL
		)';



	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.CDD_CRN_RESULTADO_NUSE ADD (
	  CONSTRAINT PK_CDD_CRN_RESULTADO_NUSE PRIMARY KEY
	 (CRN_ID))';
				   
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADOS CDD_CRN_RESULTADO_NUSE'); 			   
end if; 			  
			 
	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT	