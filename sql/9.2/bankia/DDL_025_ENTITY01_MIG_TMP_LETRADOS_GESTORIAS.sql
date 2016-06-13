--/*
--##########################################
--## AUTOR=Rafael Aracil Lopez
--## FECHA_CREACION=20160602
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-
--## PRODUCTO=SI
--## Finalidad: CREAR TABLA TEMPORAL MIG_TMP_LETRADOS_GESTORIAS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    
    V_NUM NUMBER; 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG_TMP_LETRADOS_GESTORIAS'' AND OWNER='''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM=0 THEN
  		DBMS_OUTPUT.PUT_LINE('CREAMOS TABLA '||V_ESQUEMA||'.MIG_TMP_LETRADOS_GESTORIAS');

EXECUTE IMMEDIATE'
CREATE TABLE '||V_ESQUEMA||'.MIG_TMP_LETRADOS_GESTORIAS
(
ANAGRAMA VARCHAR2 (15 CHAR),
NOMBRE VARCHAR2 (100 CHAR),
TIPO_AGENTE VARCHAR2 (5 CHAR),
TELEFONO2 VARCHAR2 (15 CHAR),
FAX VARCHAR2 (15 CHAR),
OFICINA_CONTACTO VARCHAR2 (5 CHAR),
ENTIDAD_CONTACTO VARCHAR2 (5 CHAR),
FECHA_ALTA DATE,
ENTIDAD_LIQUIDACION  VARCHAR2 (4 CHAR),
OFICINA_LIQUIDACION VARCHAR2 (4 CHAR),
DIGCON_LIQUIDACION VARCHAR2 (2 CHAR),
CUENTA_LIQUIDACION VARCHAR2 (10 CHAR),
ENTIDAD_PROVISIONES VARCHAR2 (4 CHAR),
OFICINA_PROVISIONES VARCHAR2 (4 CHAR),
DIGCON_PROVISIONES VARCHAR2 (2 CHAR),
CUENTA_PROVISIONES VARCHAR2 (10 CHAR),
TIPO_DOC VARCHAR2 (1 CHAR),
DOCUMENTO VARCHAR2 (10 CHAR),
ASESORIA VARCHAR2 (1 CHAR),
IVA_DES VARCHAR2 (4 CHAR),
IRPF_APL number (5,2)
)';
		DBMS_OUTPUT.PUT_LINE('TABLA '||V_ESQUEMA||'.MIG_TMP_LETRADOS_GESTORIAS');

ELSE
		DBMS_OUTPUT.PUT_LINE('TABLA '||V_ESQUEMA||'.MIG_TMP_LETRADOS_GESTORIAS');
EXECUTE IMMEDIATE'
DROP TABLE '||V_ESQUEMA||'.MIG_TMP_LETRADOS_GESTORIAS';

		DBMS_OUTPUT.PUT_LINE('TABLA '||V_ESQUEMA||'.MIG_TMP_LETRADOS_GESTORIAS');
EXECUTE IMMEDIATE'
CREATE TABLE '||V_ESQUEMA||'.MIG_TMP_LETRADOS_GESTORIAS
(
ANAGRAMA VARCHAR2 (15 CHAR),
NOMBRE VARCHAR2 (100 CHAR),
TIPO_AGENTE VARCHAR2 (5 CHAR),
TELEFONO2 VARCHAR2 (15 CHAR),
FAX VARCHAR2 (15 CHAR),
OFICINA_CONTACTO VARCHAR2 (5 CHAR),
ENTIDAD_CONTACTO VARCHAR2 (5 CHAR),
FECHA_ALTA DATE,
ENTIDAD_LIQUIDACION  VARCHAR2 (4 CHAR),
OFICINA_LIQUIDACION VARCHAR2 (4 CHAR),
DIGCON_LIQUIDACION VARCHAR2 (2 CHAR),
CUENTA_LIQUIDACION VARCHAR2 (10 CHAR),
ENTIDAD_PROVISIONES VARCHAR2 (4 CHAR),
OFICINA_PROVISIONES VARCHAR2 (4 CHAR),
DIGCON_PROVISIONES VARCHAR2 (2 CHAR),
CUENTA_PROVISIONES VARCHAR2 (10 CHAR),
TIPO_DOC VARCHAR2 (1 CHAR),
DOCUMENTO VARCHAR2 (10 CHAR),
ASESORIA VARCHAR2 (1 CHAR),
IVA_DES VARCHAR2 (4 CHAR),
IRPF_APL number (5,2)
)';
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




