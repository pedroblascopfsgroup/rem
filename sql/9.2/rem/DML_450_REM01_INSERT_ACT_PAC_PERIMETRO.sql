--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-846
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

    
BEGIN	

    V_TABLENAME1 := V_ESQUEMA || '.ACT_ACTIVO';
    V_TABLENAME2 := V_ESQUEMA || '.ACT_PAC_PERIMETRO_ACTIVO';
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en ' ||V_TABLENAME2 || '.');
	
    V_SQL := q'[MERGE INTO ]' || V_TABLENAME2 || q'[ pac  USING (select act_id, 1 check_ok, 'HEROS-846' usuariocrear, 
sysdate fechacrear, 0 version, 0 borrado from ]' || V_TABLENAME1 || q'[) act
ON (act.act_id = pac.act_id)
WHEN NOT MATCHED THEN
INSERT (PAC_ID, ACT_ID, PAC_CHECK_TRA_ADMISION, PAC_FECHA_TRA_ADMISION, PAC_CHECK_GESTIONAR, PAC_FECHA_GESTIONAR, 
PAC_CHECK_ASIGNAR_MEDIADOR, PAC_FECHA_ASIGNAR_MEDIADOR, PAC_CHECK_COMERCIALIZAR, PAC_FECHA_COMERCIALIZAR,
PAC_CHECK_FORMALIZAR, PAC_FECHA_FORMALIZAR, usuariocrear, fechacrear, version, borrado)
VALUES (]' || V_ESQUEMA || q'[.S_ACT_PAC_PERIMETRO_ACTIVO.nextval, act.act_id, act.check_ok, act.fechacrear, act.check_ok, act.fechacrear, 
act.check_ok, act.fechacrear, act.check_ok, act.fechacrear, 
act.check_ok, act.fechacrear, act.usuariocrear, act.fechacrear, act.version, act.borrado)]';
	
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
