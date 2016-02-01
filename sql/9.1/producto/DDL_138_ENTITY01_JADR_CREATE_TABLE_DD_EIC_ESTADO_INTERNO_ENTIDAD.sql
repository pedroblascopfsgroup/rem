--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## MODIFICADO=CARLOS PEREZ
--## FECHA_CREACION=20151204
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-866
--## PRODUCTO=SI
--## 
--## Finalidad: Creación de tabla DD_EIC_ESTADO_INTERNO_ENTIDAD
--##                   
--##                               , esquema CM01. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE
 
 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master 
 TABLA1 VARCHAR(30) :='DD_EIC_ESTADO_INTERNO_ENTIDAD';
 SECUENCIA VARCHAR(30) := 'DD_EIC_EDO_INTERNO_ENTIDAD' ;
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;


BEGIN 

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA1||'';

 
  IF V_EXISTE = 1 THEN   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA1 );
     DBMS_OUTPUT.PUT_LINE(''||TABLA1||' BORRADA');
  END IF;   
          


  V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA1||'  
        (	"DD_EIC_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"DD_EIC_CODIGO" VARCHAR2(2 CHAR), 
	"DD_EIC_DESCRIPCION" VARCHAR2(100 CHAR), 
	"DD_EIC_DESCRIPCION_LARGA" VARCHAR2(200 CHAR), 
	"VERSION" NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
	"FECHACREAR" DATE NOT NULL ENABLE, 
	"USUARIOCREAR" VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	"FECHAMODIFICAR" DATE, 
	"USUARIOMODIFICAR" VARCHAR2(50 CHAR), 
	"FECHABORRAR" DATE, 
	"USUARIOBORRAR" VARCHAR2(50 CHAR), 
	"BORRADO" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "DD_EIC_EDO_INTERNO_ENTIDAD_PK" PRIMARY KEY ("DD_EIC_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
)
  ';
          

 EXECUTE IMMEDIATE V_MSQL1;
 DBMS_OUTPUT.PUT_LINE(''||TABLA1||' CREADA');

  
  V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||SECUENCIA and sequence_owner= V_ESQUEMA;

 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_'||SECUENCIA||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;



EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;   

