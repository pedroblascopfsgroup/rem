--/*
--##########################################
--## AUTOR=DANIEL ALBERT PEREZ
--## FECHA_CREACION=20160331
--## ARTEFACTO=9.1
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=HR-1466
--## PRODUCTO=NO
--## Finalidad: DDL modificación tabla TMP_PCO_REC_BUROFAX
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script

BEGIN
DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE('[INICIO] Modificar tabla: '||V_ESQUEMA||'.TMP_PCO_REC_BUROFAX.');
    
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_PCO_REC_BUROFAX'' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN
    V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.TMP_PCO_REC_BUROFAX
    MODIFY
    (
		ID_BUROFAX	NUMBER (16) ,
		ID_PROCEDIMIENTO	NUMBER (16) ,
		CODIGO_PERSONA	NUMBER (16) ,
		NIF_CIF_PASAP_NIE	VARCHAR2 (20),
		NOM_COMPLETO	VARCHAR2 (300) ,
		CODIGO_ENTIDAD	NUMBER (4) ,
		CODIGO_PROPIETARIO	NUMBER (5) ,
		TIPO_PRODUCTO	VARCHAR2 (5) ,
		NUMERO_CONTRATO	NUMBER (17) ,
		TIPO_INTERVENCION	VARCHAR2 (50 CHAR) ,
		DIRECCION	VARCHAR2 (200) ,
		TIPO_VIA	VARCHAR2 (100),
		NOMBRE_VIA	VARCHAR2 (100),
		NUM_DOMICILIO	VARCHAR2 (10),
		PORTAL	VARCHAR2 (15),
		PISO	VARCHAR2 (10),
		ESCALERA	VARCHAR2 (10),
		PUERTA	VARCHAR2 (10),
		CODIGO_POSTAL	VARCHAR2 (10),
		PROVINCIA	VARCHAR2 (100),
		POBLACION	VARCHAR2 (100),
		MUNICIPIO	VARCHAR2 (100),
		PAIS	VARCHAR2 (100),
		CODIGO_INE_PROVINCIA	NUMBER (10),
		CODIGO_INE_POBLACION	NUMBER (10),
		CODIGO_INE_MUNICIPIO	NUMBER (10),
		CODIGO_INE_VIA	NUMBER (10),
		TIPO_BUROFAX	VARCHAR2 (50) ,
		FECHA_SOLICITUD	VARCHAR2(8 CHAR) ,
		CONTENIDO_BUROFAX	VARCHAR2 (4000) ,
		CERTIFICADO_REQUERIDO	NUMBER (1)
	)';

EXECUTE IMMEDIATE V_SQL;
  DBMS_OUTPUT.PUT_LINE('    [INFO] Tabla modificada.');		
ELSE
	DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla no existe.');
END IF;

V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''TMP_PCO_REC_BUROFAX'' AND COLUMN_NAME LIKE ''ID_ADJ''AND OWNER = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN
V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.TMP_PCO_REC_BUROFAX
          DROP COLUMN ID_ADJ';
EXECUTE IMMEDIATE V_SQL;
  DBMS_OUTPUT.PUT_LINE('    [INFO] Tabla modificada.');	
ELSE
  DBMS_OUTPUT.PUT_LINE('    [INFO] El campo a eliminar no se encuentra en la tabla.');
END IF;

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;          
END;

/

EXIT
