--/*
--##########################################
--## AUTOR=Rafael Aracil
--## FECHA_CREACION=20160615
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1963
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


DBMS_OUTPUT.PUT_LINE('[INFO] MERGEAMOS REGISTROS EN '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS');


execute immediate'
MERGE INTO '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS A
USING
(
SELECT
DES_ID,
DD_DCV_ID,
DD_DCP_ID,
DD_DRE_ID,
DD_DCE_ID,
DD_DID_ID
FROm '||V_ESQUEMA||'.MIG_TMP_LETRADOS_GESTORIAS  ges
inner join '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des on ges.anagrama=des.des_codigo
LEFT JOIN '||V_ESQUEMA||'.MIG_TMP_LETRADO_DATOS DAT ON GES.ANAGRAMA=DAT.ANAGRAMA
LEFT JOIN '||V_ESQUEMA||'.DD_DCV_DESPACHO_CNT_VIGOR DCV ON DCV.DD_DCV_CODIGO=DAT.CONTRATO_VIGOR
LEFT JOIN '||V_ESQUEMA||'.DD_DCP_DESPACHO_CLASI_PERFIL DCP ON DCP.DD_DCP_CODIGO=DAT.CLASIF_PERFIL
LEFT JOIN '||V_ESQUEMA||'.DD_DRE_DESPACHO_REL_ENTIDAD DRB ON DRB.DD_DRE_CODIGO=DAT.REL_BANKIA
LEFT JOIN '||V_ESQUEMA||'.DD_DCE_DESPACHO_COD_ESTADO DCE ON DCE.DD_DCE_CODIGO=des.BORRADO
LEFT JOIN '||V_ESQUEMA||'.DD_DID_DESPACHO_IVA_DES DID ON DID.DD_DID_CODIGO=GES.IVA_DES
)B
ON ( A.DES_ID=B.DES_ID)
WHEN MATCHED THEN UPDATE SET  A.DD_DCV_ID = b.DD_DCV_ID , a.DD_DCP_ID =b.DD_DCP_ID , A.DD_DRE_ID = B.DD_DRE_ID , A.DD_DCE_ID = B.DD_DCE_ID , A.DD_DID_ID = B.DD_DID_ID';

DBMS_OUTPUT.PUT_LINE('[INFO] Registros MERGEADOS en '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS');



	
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
