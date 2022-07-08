--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220623
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11864
--## PRODUCTO=NO
--## 
--## Finalidad: Crear trigger cambios_id_persona_haya_caixa
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [REMVIP-11864]- DAP
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_TRIGGER VARCHAR2(40 CHAR) := 'CAMBIOS_ID_PERSONA_HAYA_CAIXA';
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN
	/***** CAMBIOS_PVE_COD_UVEM *****/
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TRIGGERS WHERE TRIGGER_NAME = '''||V_TRIGGER||''' AND OWNER= '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO TABLE_COUNT;

	IF TABLE_COUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TRIGGER '||V_ESQUEMA||'.'||V_TRIGGER||' NO EXISTENTE. SE PROCEDE A CREAR.');
		EXECUTE IMMEDIATE 'create or replace TRIGGER rem01.cambios_id_persona_haya_caixa
	AFTER INSERT OR UPDATE OF COM_ID_PERSONA_HAYA_CAIXA OR DELETE ON REM01.COM_COMPRADOR 
	FOR EACH ROW when (OLD.COM_ID = 411299)
BEGIN
insert into REM01.LOG_REMVIP_11864 (
fecha,
  usuario_so,
  nombre_pc,
  com_id_n,
  com_id_o,
  dd_tpe_id_n,
  dd_tpe_id_o,
  com_nombre_n,
  com_nombre_o,
  COM_APELLIDOS_n,
  COM_APELLIDOS_o,
  DD_TDI_ID_n,
  DD_TDI_ID_o,
  COM_DOCUMENTO_n,
  COM_DOCUMENTO_o,
  CLC_ID_n,
  CLC_ID_o,
  COM_ENVIADO_n,
  COM_ENVIADO_o,
  ID_PERSONA_HAYA_n,
  ID_PERSONA_HAYA_o,
  IAP_ID_n,
  IAP_ID_o,
  COM_ID_PERSONA_HAYA_CAIXA_n,
  COM_ID_PERSONA_HAYA_CAIXA_o,
  VERSION_n,
  VERSION_o,
  usuariocrear_n,
  usuariocrear_o,
    fechacrear_n,
  fechacrear_o,
  usuariomodificar_n,
  usuariomodificar_o,
  fechamodificar_n,
  fechamodificar_o,
  usuarioborrar_n,
  usuarioborrar_o,
  fechaborrar_n,
  fechaborrar_o)
values
(sysdate, sys_context(''USERENV'', ''OS_USER''), sys_context(''SERENV'',''TERMINAL''), :NEW.COM_ID, :OLD.COM_ID, :NEW.DD_TPE_ID, :OLD.DD_TPE_ID, :NEW.COM_NOMBRE, :OLD.COM_NOMBRE,
 :NEW.COM_APELLIDOS, :OLD.COM_APELLIDOS,
  :NEW.DD_TDI_ID, :OLD.DD_TDI_ID,
  :NEW.COM_DOCUMENTO, :OLD.COM_DOCUMENTO,
  :NEW.CLC_ID, :OLD.CLC_ID,
  :NEW.COM_ENVIADO, :OLD.COM_ENVIADO,
  :NEW.ID_PERSONA_HAYA, :OLD.ID_PERSONA_HAYA,
  :NEW.IAP_ID, :OLD.IAP_ID,
  :NEW.COM_ID_PERSONA_HAYA_CAIXA, :OLD.COM_ID_PERSONA_HAYA_CAIXA,
  :NEW.VERSION, :OLD.VERSION,
  :NEW.USUARIOCREAR, :OLD.USUARIOCREAR, 
  :NEW.FECHACREAR, :OLD.FECHACREAR,
  :NEW.USUARIOMODIFICAR, :OLD.USUARIOMODIFICAR, 
  :NEW.FECHAMODIFICAR, :OLD.FECHAMODIFICAR,
  :NEW.USUARIOBORRAR, :OLD.USUARIOBORRAR,
  :NEW.FECHABORRAR, :OLD.FECHABORRAR);
  end;';
    ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] TRIGGER '||V_ESQUEMA||'.'||V_TRIGGER||' YA EXISTE.');

	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TRIGGER||' BORRADO');  
	

    COMMIT;
	
EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;