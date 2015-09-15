--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20150711
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=PRODUCTO-109
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia  
    V_NUM_IDX NUMBER(16); -- Vble. para validar la existencia de un indice
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN
	

--##COMPROBACION EXISTENCIA SECUENCIA, BORRAR PRIMERO
V_NUM_SEQ := 0;
select count(1) INTO V_NUM_SEQ from all_sequences
where sequence_owner = V_ESQUEMA
and sequence_name = 'S_DD_RVN_RES_VALIDACION_NUSE';

if V_NUM_SEQ > 0 then 
--YA existe una versión de la secuencia , se elimina primero
  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la secuencia S_DD_RVN_RES_VALIDACION_NUSE: se ELIMINA...');
  EXECUTE IMMEDIATE 'drop sequence '||V_ESQUEMA||'.S_CDD_CRN_RESULTADO_NUSE';
  DBMS_OUTPUT.PUT_LINE('OK');
END IF;


--##COMPROBACION EXISTENCIA TABLA, BORRAR PRIMERO
V_NUM_TABLAS := 0;
select count(1) INTO V_NUM_TABLAS from all_tables 
where table_name = 'DD_RVN_RES_VALIDACION_NUSE' and OWNER = V_ESQUEMA;

if V_NUM_TABLAS > 0 then 
--YA existe una versión de la tabla , se elimina primero

  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la tabla DD_RVN_RES_VALIDACION_NUSE: se ELIMINA...');
	EXECUTE IMMEDIATE 'drop table '||V_ESQUEMA||'.DD_RVN_RES_VALIDACION_NUSE';
  DBMS_OUTPUT.PUT_LINE('OK');

END IF;


EXECUTE IMMEDIATE 'CREATE SEQUENCE '||V_ESQUEMA||'.S_DD_RVN_RES_VALIDACION_NUSE'; 	 
	 
EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.DD_RVN_RES_VALIDACION_NUSE
(
  DD_RVN_ID                 NUMBER(16)          NOT NULL,
  DD_RVN_CODIGO             VARCHAR2(50 BYTE)   NOT NULL,
  DD_RVN_DESCRIPCION        VARCHAR2(100 BYTE)  NOT NULL,
  DD_RVN_DESCRIPCION_LARGA  VARCHAR2(250 BYTE),
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 BYTE)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 BYTE),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 BYTE),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
)';


EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_DD_RVN_RES_VALIDACION_NUSE ON '||V_ESQUEMA||'.DD_RVN_RES_VALIDACION_NUSE
(DD_RVN_ID)
LOGGING
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
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL';


EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.DD_RVN_RES_VALIDACION_NUSE ADD (
  CONSTRAINT PK_DD_RVN_RES_VALIDACION_NUSE
 PRIMARY KEY
 (DD_RVN_ID)
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
			   
DBMS_OUTPUT.PUT_LINE('[INFO] CREADOS DICCIONARIOS DD_RVN_RES_VALIDACION_NUSE'); 			   

			   
			 
	
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
