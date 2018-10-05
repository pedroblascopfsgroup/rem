--/*
--##########################################
--## AUTOR=JIN LI, HU
--## FECHA_CREACION=20181002
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4528
--## PRODUCTO=NO
--## Finalidad: DDL Creación de tabla REP_REVISION_POSESION
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'REP_REVISION_POSESION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
  
BEGIN
    
    -----------------------
    ---     TABLA       ---
    -----------------------
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME ='''||V_TEXT_TABLA||''' AND OWNER='''||V_ESQUEMA||''''
    INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
		V_SQL:= ' CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ( 
		  ACT_ID					   NUMBER(16,0),
		  REP_POSESION				   NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
		  REP_OCUPADO				   NUMBER(1,0) DEFAULT 0,
		  REP_CON_TITULO			   NUMBER(1,0) DEFAULT 0,
	      VERSION                      NUMBER(3,0) DEFAULT 0 NOT NULL ENABLE,
	      USUARIOCREAR                 VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	      FECHACREAR                   TIMESTAMP (6) NOT NULL ENABLE, 
	      USUARIOMODIFICAR             VARCHAR2(50 CHAR), 
	      FECHAMODIFICAR               TIMESTAMP (6), 
	      USUARIOBORRAR                VARCHAR2(50 CHAR), 
	      FECHABORRAR                  TIMESTAMP (6), 
	      BORRADO                      NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
		  )';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('['||V_TEXT_TABLA||' CREADA]');

		-- Creamos comentario tabla
		V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS ''Revision Posesion, Modulo Ocupacion'' ';      
		EXECUTE IMMEDIATE V_SQL;
		
    END IF;
    
    COMMIT;  
      
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
