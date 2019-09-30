--/*
--##########################################
--## AUTOR=ALBERT PASTOR
--## FECHA_CREACION=20190717
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2 
--## INCIDENCIA_LINK=HREOS-6985
--## PRODUCTO=NO
--## 
--## FINALIDAD: Creamos función para calcular uuid          
--## VERSIONES:
--##           0.1 [HREOS-6985] Version inicial (ALBERT PASTOR)
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN
  DBMS_OUTPUT.PUT_LINE('[INFO] Función GENERATE_UUID: INICIANDO...');      
    EXECUTE IMMEDIATE '
create or replace function generate_uuid return varchar2 is
    v_uuid varchar2(36);
    v_guid varchar2(32);
begin
    v_guid := sys_guid();
    v_uuid := lower(
                substr(v_guid, 1,8) || ''-'' || 
                substr(v_guid, 9,4) || ''-'' || 
                substr(v_guid, 13,4) || ''-'' || 
                substr(v_guid, 17,4) || ''-'' || 
                substr(v_guid, 21)
                );
    return v_uuid;
END generate_uuid;
';
  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Function creada.');
    
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

EXIT