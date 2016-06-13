--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20160531
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc11
--## INCIDENCIA_LINK=PRODUCTO-1726
--## PRODUCTO=NO
--##
--## Finalidad: -- Modificaciones Integración GD-Haya
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

    V_TABLENAME1 := V_ESQUEMA_M || '.fun_funciones';
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en '||V_TABLENAME1 || '.');

	V_SQL := q'[MERGE INTO ]' || V_TABLENAME1 || q'[ f  USING (select max(fun_id)+1 fun_id, 'BOTON_BORRAR_INVISIBLE' fun_descripcion, 
'Boton borrar adjuntos invisible' fun_descripcion_larga, 'GDCAJAMAR' usuariocrear, sysdate fechacrear, 0 version, 0 borrado 
from ]' || V_TABLENAME1 || q'[) actual
ON (f.fun_descripcion=actual.fun_descripcion)
WHEN NOT MATCHED THEN
INSERT (fun_id, fun_descripcion, fun_descripcion_larga, usuariocrear, fechacrear, version, borrado)
VALUES (actual.fun_id, actual.fun_descripcion, actual.fun_descripcion_larga, actual.usuariocrear, 
actual.fechacrear, actual.version, actual.borrado)]';
	EXECUTE IMMEDIATE V_SQL; 
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '... registros afectados: ' || sql%rowcount);
    DBMS_OUTPUT.PUT_LINE('[FIN] Inserción en '||V_TABLENAME1 || '.');

    V_TABLENAME2 := V_ESQUEMA || '.fun_pef';
    V_TABLENAME3 := V_ESQUEMA || '.pef_perfiles';
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en ' ||V_TABLENAME2 || '.');
	V_SQL := q'[MERGE INTO ]' || V_TABLENAME2 || q'[ fp USING (SELECT f.fun_id fun_id, p.pef_id pef_id, 
'GDCAJAMAR' usuariocrear, sysdate fechacrear, 0 version, 0 borrado
from ]' || V_TABLENAME1 || q'[ f, ]' || V_TABLENAME3 || q'[ p
where f.fun_descripcion='BOTON_BORRAR_INVISIBLE' and f.borrado=0 and p.borrado=0) nuevo_fp
ON (fp.fun_id=nuevo_fp.fun_id and fp.pef_id=nuevo_fp.pef_id)
WHEN NOT MATCHED THEN
INSERT (fp_id, fun_id, pef_id, usuariocrear, fechacrear, version, borrado)
VALUES (]' || V_ESQUEMA || q'[.s_fun_pef.nextval, nuevo_fp.fun_id, nuevo_fp.pef_id, 
nuevo_fp.usuariocrear, nuevo_fp.fechacrear, nuevo_fp.version, nuevo_fp.borrado)]';
	EXECUTE IMMEDIATE V_SQL; 
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '... registros afectados: ' || sql%rowcount);
    DBMS_OUTPUT.PUT_LINE('[FIN] Inserción en '||V_TABLENAME2 || '.');

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
