--/*
--##########################################
--## AUTOR=Rafael Aracil Lopez
--## FECHA_CREACION=20160603
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-
--## PRODUCTO=SI
--## Finalidad: INSERCIÓN DATOS EN TABLA  DEE_DESPACHO_EXTRAS
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
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DEE_DESPACHO_EXTRAS'' AND OWNER='''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM=1 THEN
execute immediate'
DELETE FROM '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS';


DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAMOS REGISTROS EN '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS');


execute immediate'
INSERT INTO '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS
SELECT
DES_ID,
cASE 
WHEN translate(upper(DAT.CONTRATO_VIGOR), ''ÁÀÉÈÍÓÒÚÄËÏÖÜÑ'', ''AAEEIOOUAEIOU#'')=''ACUERDO 2011'' THEN ''1''
WHEN translate(upper(DAT.CONTRATO_VIGOR), ''ÁÀÉÈÍÓÒÚÄËÏÖÜÑ'', ''AAEEIOOUAEIOU#'')=''2014'' THEN ''2''
WHEN translate(upper(DAT.CONTRATO_VIGOR), ''ÁÀÉÈÍÓÒÚÄËÏÖÜÑ'', ''AAEEIOOUAEIOU#'')=''2015'' THEN ''3''
WHEN translate(upper(DAT.CONTRATO_VIGOR), ''ÁÀÉÈÍÓÒÚÄËÏÖÜÑ'', ''AAEEIOOUAEIOU#'')=''HISTORICO CAJA'' THEN ''0''
END,
cASE WHEN DAT.SERV_INTEGRAL=''Si'' THEN 1 WHEN DAT.SERV_INTEGRAL=''No'' THEN 0 END,
DAT.FECHA_SERV_INTEGRAL,
cASE WHEN DAT.CLASIF_CONCURSOS=''Si'' THEN 1 WHEN DAT.CLASIF_CONCURSOS=''No'' THEN 0 END,
cASE WHEN DAT.CLASIF_PERFIL=''A'' THEN 0 WHEN DAT.CLASIF_PERFIL=''B'' THEN 1 WHEN DAT.CLASIF_PERFIL=''C'' THEN 2 END,
cASE 
WHEN translate(upper(REL_BANKIA), ''ÁÀÉÈÍÓÒÚÄËÏÖÜÑ'', ''AAEEIOOUAEIOU#'')=''EN DESVINCULACION'' THEN 0
WHEN translate(upper(REL_BANKIA), ''ÁÀÉÈÍÓÒÚÄËÏÖÜÑ'', ''AAEEIOOUAEIOU#'')=''SIN TURNO'' THEN 1
WHEN translate(upper(REL_BANKIA), ''ÁÀÉÈÍÓÒÚÄËÏÖÜÑ'', ''AAEEIOOUAEIOU#'')=''SIN ACCESO'' THEN 2 
WHEN translate(upper(REL_BANKIA), ''ÁÀÉÈÍÓÒÚÄËÏÖÜÑ'', ''AAEEIOOUAEIOU#'')=''TURNO ACTIVO'' THEN 3 
WHEN translate(upper(REL_BANKIA), ''ÁÀÉÈÍÓÒÚÄËÏÖÜÑ'', ''AAEEIOOUAEIOU#'')=''HISTORICO'' THEN 4
END,
FAX,
NULL,
cASE WHEN DES.BORRADO=0 THEN 0 WHEN DES.BORRADO=1 THEN 1 END,
OFICINA_CONTACTO,
ENTIDAD_CONTACTO,
FECHA_ALTA,
ENTIDAD_LIQUIDACION,
OFICINA_LIQUIDACION,
DIGCON_LIQUIDACION,
CUENTA_LIQUIDACION,
ENTIDAD_PROVISIONES,
OFICINA_PROVISIONES,
DIGCON_PROVISIONES,
CUENTA_PROVISIONES,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
CASE 
WHEN TIPO_DOC=''D'' THEN 2
WHEN TIPO_DOC=''C'' THEN 3
WHEN TIPO_DOC=''T'' THEN 4
WHEN TIPO_DOC=''N'' THEN 14
WHEN TIPO_DOC=''S'' THEN 38
END,
DOCUMENTO,
case
WHEN asesoria=''N'' THEN 0
WHEN asesoria=''S'' THEN 1
END,
NULL,
case
when IVA_DES=''IGIC'' THEN 0
when IVA_DES=''IVA'' THEN 1
END,
IRPF_APL,
NULL,
NULL,
0,
''PRODUCTO-1275'',
SYSDATE,
NULL,
NULL,
NULL,
NULL,
0
FROm '||V_ESQUEMA||'.MIG_TMP_LETRADOS_GESTORIAS  ges
inner join '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des on ges.anagrama=des.des_codigo
LEFT JOIN '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID ON TIPO_DOC=DD_TDI_TIPO_DOCUMENTO_ID.DD_TDI_CODIGO
LEFT JOIN '||V_ESQUEMA||'.MIG_TMP_LETRADO_DATOS DAT ON GES.ANAGRAMA=DAT.ANAGRAMA';

DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertado en '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS');
ELSE
		DBMS_OUTPUT.PUT_LINE('TABLA '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS INEXISTENTE');
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
