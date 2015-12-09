--/*
--##########################################
--## AUTOR=Agustín Mompó
--## FECHA_CREACION=20151028
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=BKREC-1143
--## PRODUCTO=SI
--## Finalidad: DDL
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_SEQ  NUMBER(16); -- Vble. para validar la existencia de una secuencia.
    V_NUM_CONSTRAINT NUMBER(16); -- Vble para validar la existencia de una constraint
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN

--##COMPROBACION EXISTENCIA TABLA, BORRAR PRIMERO
V_NUM_TABLAS := 0;
select count(1) INTO V_NUM_TABLAS from all_tables 
where table_name = 'MINIRECOVERY_PREP_PRELIT_RCV' and OWNER = V_ESQUEMA;

V_NUM_CONSTRAINT := 0;
select count(1) INTO V_NUM_CONSTRAINT from all_constraints 
where constraint_name = 'MINIRECOVERY_PREP_PRELIT_R_PK' and OWNER = V_ESQUEMA;

if V_NUM_TABLAS > 0 then 
--YA existe una versión de la tabla , se elimina primero

  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la tabla CNV_AUX_BUROFAX_MES: se ELIMINA...');
	EXECUTE IMMEDIATE 'drop table '||V_ESQUEMA||'.MINIRECOVERY_PREP_PRELIT_RCV';
  DBMS_OUTPUT.PUT_LINE('OK');

END IF;

EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.MINIRECOVERY_PREP_PRELIT_RCV
(	CODIGO_PREPARACION_NUSE NUMBER(16,0) NOT NULL ENABLE, 
	ID_CUENTA_RCV NUMBER(16,0) NOT NULL ENABLE, 
	ID_EXPEDIENTE_RCV NUMBER(16,0) NOT NULL ENABLE, 
	ID_ASUNTO_RCV NUMBER(16,0) NOT NULL ENABLE, 
	SOCIEDAD VARCHAR2(60 CHAR) NOT NULL ENABLE, 
	ESTADO VARCHAR2(100 CHAR) NOT NULL ENABLE, 
	FECHA_ALTA DATE NOT NULL ENABLE, 
	USUARIO_ALTA VARCHAR2(15 CHAR) NOT NULL ENABLE, 
	FECHA_BAJA DATE, 
	MOTIVO_BAJA VARCHAR2(1000 CHAR), 
	DEUDA_TOTAL NUMBER(15,2), 
	CODIGO_ENTIDAD NUMBER(4,0) NOT NULL ENABLE, 
	CODIGO_PROPIETARIO NUMBER(5,0) NOT NULL ENABLE, 
	TIPO_PRODUCTO VARCHAR2(5 CHAR) NOT NULL ENABLE, 
	NUMERO_CONTRATO NUMBER(17,0) NOT NULL ENABLE, 
	NUMERO_ESPEC NUMBER(15,0) NOT NULL ENABLE, 
	TIPO_PROCEDI VARCHAR2(16 CHAR) NOT NULL ENABLE, 
	TOTAL_LIQUIDACION NUMBER(15,2), 
	DEMANDA_POR VARCHAR2(1 CHAR)
)
TABLESPACE '||V_ESQUEMA||'
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING';

DBMS_OUTPUT.PUT_LINE('[INFO] CREADA TABLA MINIRECOVERY_PREP_PRELIT_RCV'); 

if V_NUM_CONSTRAINT > 1 then
	EXECUTE IMMEDIATE '
	ALTER TABLE '||V_ESQUEMA||'.MINIRECOVERY_PREP_PRELIT_RCV DROP
	  CONSTRAINT MINIRECOVERY_PREP_PRELIT_R_PK';
	DBMS_OUTPUT.PUT_LINE('ALTER TABLE.MINIRECOVERY_PREP_PRELIT_RCV... Borrada PK - OK');

end if;

	EXECUTE IMMEDIATE '
	ALTER TABLE '||V_ESQUEMA||'.MINIRECOVERY_PREP_PRELIT_RCV ADD (
	  CONSTRAINT MINIRECOVERY_PREP_PRELIT_R_PK
	 PRIMARY KEY
	 (CODIGO_PREPARACION_NUSE, ID_CUENTA_RCV)
	    USING INDEX 
	    TABLESPACE '||V_ESQUEMA||'
	    PCTFREE    10
	    INITRANS   2
	    MAXTRANS   255
	    STORAGE    (
		        INITIAL          64K
		        NEXT             1M
		        MINEXTENTS       1
		        MAXEXTENTS       UNLIMITED
		        PCTINCREASE      0
		       ))';
	
	DBMS_OUTPUT.PUT_LINE('ALTER TABLE.MINIRECOVERY_PREP_PRELIT_RCV... Añadida PK - OK');
			   			   
			 	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN
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
