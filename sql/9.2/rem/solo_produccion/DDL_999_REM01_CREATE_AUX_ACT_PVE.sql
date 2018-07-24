--/*
--######################################### 
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180615
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4220
--## PRODUCTO=SI
--## 
--## Finalidad: Creacion de la tabla temporal AUX_ACT_PVE
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE


  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  
 BEGIN
    
	-----------------------
	---     TABLA       ---
	-----------------------
	
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME =''AUX_ACT_PVE'' AND OWNER='''||V_ESQUEMA||''''
	INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
		EXECUTE IMMEDIATE 'DROP TABLE AUX_ACT_PVE';
		DBMS_OUTPUT.PUT_LINE('Borrada la tabla: AUX_ACT_PVE');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('Creamos la tabla AUX_ACT_PVE');
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'."AUX_ACT_PVE" (		
		"PVE_COD_UVEM"			VARCHAR2(50 CHAR),
		"DD_TPR_CODIGO"			VARCHAR2(20 CHAR),
		"PVE_NOMBRE"			VARCHAR2(250 CHAR),
		"PVE_NOMBRE_COMERCIAL"	VARCHAR2(250 CHAR),
		"DD_TDI_CODIGO"			VARCHAR2(20 CHAR),
		"PVE_DOCIDENTIF"		VARCHAR2(20 CHAR),
		"DD_ZNG_CODIGO"			VARCHAR2(20 CHAR),
		"DD_PRV_CODIGO"			VARCHAR2(20 CHAR),
		"DD_LOC_CODIGO"			VARCHAR2(20 CHAR),
		"PVE_CP"				NUMBER(8,0),
		"PVE_DIRECCION"			VARCHAR2(250 CHAR),
		"PVE_TELF1"				VARCHAR2(20 CHAR),	
		"PVE_TELF2"				VARCHAR2(20 CHAR),
		"PVE_FAX"				VARCHAR2(20 CHAR),	
		"PVE_EMAIL"				VARCHAR2(50 CHAR),
		"PVE_PAGINA_WEB"		VARCHAR2(50 CHAR),
		"PVE_FRANQUICIA"		NUMBER(16,2),
		"PVE_IVA_CAJA"			NUMBER(1,0),
		"PVE_NUM_CUENTA"		VARCHAR2(50 CHAR),
		"DD_TPC_CODIGO"			VARCHAR2(20 CHAR),
		"DD_TPE_CODIGO"			VARCHAR2(10 BYTE),	
		"PVE_NIF"				VARCHAR2(20 CHAR),	
		"PVE_FECHA_ALTA"		DATE,
		"PVE_FECHA_BAJA"		DATE,
		"PVE_LOCALIZADA"		NUMBER(1,0),
		"DD_EPR_CODIGO"			VARCHAR2(20 CHAR),
		"PVE_FECHA_CONSTITUCION"	DATE,
		"PVE_AMBITO"			VARCHAR2(100 CHAR),
		"PVE_OBSERVACIONES"		VARCHAR2(200 CHAR),
		"PVE_HOMOLOGADO"		NUMBER(1,0),
		"DD_CPR_CODIGO"			VARCHAR2(20 CHAR),
		"PVE_TOP"				NUMBER(1,0),
		"PVE_TITULAR_CUENTA"	VARCHAR2(200 CHAR),
		"PVE_RETENER"			NUMBER(1,0),
		"DD_MRE_CODIGO"			VARCHAR2(20 CHAR),
		"PVE_FECHA_RETENCION"	DATE,
		"PVE_FECHA_PBC"			DATE,
		"DD_RPB_CODIGO"			VARCHAR2(20 CHAR),
		"PVE_COD_API_PROVEEDOR"	VARCHAR2(4 CHAR),
		"PVE_AUTORIZACION_WEB"	NUMBER(1,0)
	)';
	
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('AUX_ACT_PVE creada');
	
	
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
