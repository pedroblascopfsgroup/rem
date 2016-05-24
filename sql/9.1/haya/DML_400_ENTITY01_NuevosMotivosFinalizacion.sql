--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20160128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=.1.16-hr-rc04
--## INCIDENCIA_LINK=HR-1820
--## PRODUCTO=NO
--##
--## Finalidad: -- Nuevos motivos de Finalizacion para Haya
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
SET LINESIZE 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TABLENAME1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TABLENAME2 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TABLENAME3 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN	

    V_TABLENAME1 := V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR';
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en '||V_TABLENAME1 || '.');

	V_SQL := q'[MERGE INTO ]' || V_TABLENAME1 || q'[ f  USING (SELECT 'VENTA CARTERA' dd_dfi_codigo, 'Venta de cartera' dd_dfi_descripcion, 'Venta de cartera' dd_dfi_descripcion_larga, 'DD' usuariocrear, sysdate fechacrear, 0 version, 0 borrado 
from DUAL) actual
ON (f.dd_dfi_codigo=actual.dd_dfi_codigo)
WHEN NOT MATCHED THEN
INSERT (dd_dfi_id, dd_dfi_codigo, dd_dfi_descripcion, dd_dfi_descripcion_larga, usuariocrear, fechacrear, version, borrado)
VALUES (]' || V_ESQUEMA || q'[.S_DD_DFI_DECISION_FINALIZAR.NEXTVAL, actual.dd_dfi_codigo, actual.dd_dfi_descripcion, actual.dd_dfi_descripcion_larga, actual.usuariocrear, 
actual.fechacrear, actual.version, actual.borrado)]';
	EXECUTE IMMEDIATE V_SQL; 
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '... registros afectados: ' || sql%rowcount);
    DBMS_OUTPUT.PUT_LINE('[FIN] Inserción en '||V_TABLENAME1 || '.');

	V_SQL := q'[MERGE INTO ]' || V_TABLENAME1 || q'[ f  USING (SELECT 'SOLVIA' dd_dfi_codigo, 'Cerrado por migración a SOLVIA' dd_dfi_descripcion, 'Cerrado por migración a SOLVIA' dd_dfi_descripcion_larga, 'DD' usuariocrear, sysdate fechacrear, 0 version, 0 borrado 
from DUAL) actual
ON (f.dd_dfi_codigo=actual.dd_dfi_codigo)
WHEN NOT MATCHED THEN
INSERT (dd_dfi_id, dd_dfi_codigo, dd_dfi_descripcion, dd_dfi_descripcion_larga, usuariocrear, fechacrear, version, borrado)
VALUES (]' || V_ESQUEMA || q'[.S_DD_DFI_DECISION_FINALIZAR.NEXTVAL, actual.dd_dfi_codigo, actual.dd_dfi_descripcion, actual.dd_dfi_descripcion_larga, actual.usuariocrear, 
actual.fechacrear, actual.version, actual.borrado)]';
	EXECUTE IMMEDIATE V_SQL; 
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '... registros afectados: ' || sql%rowcount);
    DBMS_OUTPUT.PUT_LINE('[FIN] Inserción en '||V_TABLENAME1 || '.');

	V_SQL := q'[MERGE INTO ]' || V_TABLENAME1 || q'[ f  USING (SELECT 'VENTA/CESIÓN CRÉDITO' dd_dfi_codigo, 'Venta/cesión crédito' dd_dfi_descripcion, 'Venta/cesión crédito' dd_dfi_descripcion_larga, 'DD' usuariocrear, sysdate fechacrear, 0 version, 0 borrado 
from DUAL) actual
ON (f.dd_dfi_codigo=actual.dd_dfi_codigo)
WHEN NOT MATCHED THEN
INSERT (dd_dfi_id, dd_dfi_codigo, dd_dfi_descripcion, dd_dfi_descripcion_larga, usuariocrear, fechacrear, version, borrado)
VALUES (]' || V_ESQUEMA || q'[.S_DD_DFI_DECISION_FINALIZAR.NEXTVAL, actual.dd_dfi_codigo, actual.dd_dfi_descripcion, actual.dd_dfi_descripcion_larga, actual.usuariocrear, 
actual.fechacrear, actual.version, actual.borrado)]';
	EXECUTE IMMEDIATE V_SQL; 
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '... registros afectados: ' || sql%rowcount);
    DBMS_OUTPUT.PUT_LINE('[FIN] Inserción en '||V_TABLENAME1 || '.');

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
EXIT
