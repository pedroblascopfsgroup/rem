--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220622
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11864
--## PRODUCTO=NO
--## 
--## Finalidad:
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

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
V_TABLA VARCHAR2(40 CHAR) := 'LOG_REMVIP_11864';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
create table '||V_ESQUEMA_1||'.'||V_TABLA||' (
  fecha date,
  usuario_so varchar2(40),
  nombre_pc varchar2(40),
  com_id_n number,
  com_id_o number,
  
  dd_tpe_id_n number,
  dd_tpe_id_o number,
  
  com_nombre_n VARCHAR2(256 CHAR),
  com_nombre_o VARCHAR2(256 CHAR),
  
  COM_APELLIDOS_n VARCHAR2(256 CHAR),
  COM_APELLIDOS_o VARCHAR2(256 CHAR),
  
  DD_TDI_ID_n number,
  DD_TDI_ID_o number,
  
  COM_DOCUMENTO_n VARCHAR2(50 CHAR),
  COM_DOCUMENTO_o VARCHAR2(50 CHAR),
  
  CLC_ID_n number,
  CLC_ID_o number,
  
  COM_ENVIADO_n TIMESTAMP,
  COM_ENVIADO_o TIMESTAMP,
  
  ID_PERSONA_HAYA_n number,
  ID_PERSONA_HAYA_o number,
  
  IAP_ID_n number,
  IAP_ID_o number,
  
  COM_ID_PERSONA_HAYA_CAIXA_n VARCHAR2(50 CHAR),
  COM_ID_PERSONA_HAYA_CAIXA_o VARCHAR2(50 CHAR),
  
  VERSION_n number,
  VERSION_o number,
  usuariocrear_n varchar2(250 char),
  usuariocrear_o varchar2(250 char),
    fechacrear_n date,
  fechacrear_o date,
  usuariomodificar_n varchar2(250 char),
  usuariomodificar_o varchar2(250 char),
  fechamodificar_n date,
  fechamodificar_o date,
  usuarioborrar_n varchar2(250 char),
  usuarioborrar_o varchar2(250 char),
  fechaborrar_n date,
  fechaborrar_o date)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;

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
