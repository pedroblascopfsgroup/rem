--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150804
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-466
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla TEMPORAL DIRECCIONES
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DROP TABLE  "CM01"."TMP_DIRECCIONES" ;

CREATE TABLE "CM01"."TMP_DIRECCIONES" 
   (	
  	"TMP_DIR_ID" NUMBER(16,0)  NOT NULL ENABLE, 
	"TMP_DIR_FECHA_EXTRACCION" DATE  NOT NULL ENABLE, 
	"TMP_DIR_FECHA_DATO" DATE NOT NULL ENABLE, 
	"TMP_DIR_COD_ENTIDAD" NUMBER(4,0) NOT NULL ENABLE, 
	"TMP_DIR_CODIGO_PROPIETARIO" NUMBER(5,0) NOT NULL ENABLE, 
	"TMP_DIR_COD_CLIENTE_ENTIDAD" NUMBER(16,0) NOT NULL ENABLE, 
	"TMP_DIR_COD_DIRECCION" VARCHAR2(33 CHAR) , 
	"TMP_DIR_TIPOVIA" VARCHAR2(100 CHAR) , 
	"TMP_DIR_DOMICILIO" VARCHAR2(100 CHAR) , 
	"TMP_DIR_DOM_N" VARCHAR2(10 CHAR), 
	"TMP_DIR_DOM_PORTAL" VARCHAR2(15 CHAR), 
	"TMP_DIR_DOM_PISO" VARCHAR2(10 CHAR), 
	"TMP_DIR_DOM_ESC" VARCHAR2(10 CHAR), 
	"TMP_DIR_DOM_PUERTA" VARCHAR2(10 CHAR), 
	"TMP_DIR_CODIGO_POSTAL" VARCHAR2(10), 
	"TMP_DIR_PROVINCIA" VARCHAR2(100 CHAR) , 
	"TMP_DIR_POBLACION" VARCHAR2(100 CHAR) , 
	"TMP_DIR_MUNICIPIO" VARCHAR2(100 CHAR) , 
  	"TMP_DIR_PAIS" VARCHAR2(100 CHAR) , 
	"TMP_DIR_INE_PROV" NUMBER(10,0), 
	"TMP_DIR_INE_POB" NUMBER(10,0), 
	"TMP_DIR_INE_MUN" NUMBER(10,0), 
	"TMP_DIR_INE_VIA" NUMBER(10,0), 
  	"TMP_DIR_TIPO_DIR" VARCHAR2(10 CHAR), 
	"TMP_DIR_CHAR_EXTRA1" VARCHAR2(50 CHAR), 
	"TMP_DIR_CHAR_EXTRA2" VARCHAR2(50 CHAR), 
	"TMP_DIR_CHAR_EXTRA3" VARCHAR2(50 CHAR), 
	"TMP_DIR_CHAR_EXTRA4" VARCHAR2(50 CHAR), 
	"TMP_DIR_CHAR_EXTRA5" VARCHAR2(50 CHAR), 
	"TMP_DIR_CHAR_EXTRA6" VARCHAR2(50 CHAR), 
	"TMP_DIR_CHAR_EXTRA7" VARCHAR2(50 CHAR), 
	"TMP_DIR_CHAR_EXTRA8" VARCHAR2(50 CHAR), 
	"TMP_DIR_CHAR_EXTRA9" VARCHAR2(50 CHAR), 
	"TMP_DIR_CHAR_EXTRA10" VARCHAR2(50 CHAR), 
	"TMP_DIR_FLAG_EXTRA1" VARCHAR2(1 CHAR), 
	"TMP_DIR_FLAG_EXTRA2" VARCHAR2(1 CHAR), 
	"TMP_DIR_FLAG_EXTRA3" VARCHAR2(1 CHAR), 
	"TMP_DIR_FLAG_EXTRA4" VARCHAR2(1 CHAR), 
	"TMP_DIR_FLAG_EXTRA5" VARCHAR2(1 CHAR), 
	"TMP_DIR_FLAG_EXTRA6" VARCHAR2(1 CHAR), 
	"TMP_DIR_FLAG_EXTRA7" VARCHAR2(1 CHAR), 
	"TMP_DIR_FLAG_EXTRA8" VARCHAR2(1 CHAR), 
	"TMP_DIR_FLAG_EXTRA9" VARCHAR2(1 CHAR), 
	"TMP_DIR_FLAG_EXTRA10" VARCHAR2(1 CHAR),
	"TMP_DIR_DATE_EXTRA1" DATE, 
	"TMP_DIR_DATE_EXTRA2" DATE, 
	"TMP_DIR_DATE_EXTRA3" DATE, 
	"TMP_DIR_DATE_EXTRA4" DATE, 
	"TMP_DIR_DATE_EXTRA5" DATE, 
	"TMP_DIR_DATE_EXTRA6" DATE, 
	"TMP_DIR_DATE_EXTRA7" DATE, 
	"TMP_DIR_DATE_EXTRA8" DATE, 
	"TMP_DIR_DATE_EXTRA9" DATE, 
	"TMP_DIR_DATE_EXTRA10" DATE,
	"TMP_DIR_NUM_EXTRA1" NUMBER(14,2), 
	"TMP_DIR_NUM_EXTRA2" NUMBER(14,2), 
	"TMP_DIR_NUM_EXTRA3" NUMBER(14,2), 
	"TMP_DIR_NUM_EXTRA4" NUMBER(14,2), 
	"TMP_DIR_NUM_EXTRA5" NUMBER(14,2), 
	"TMP_DIR_NUM_EXTRA6" NUMBER(14,2), 
	"TMP_DIR_NUM_EXTRA7" NUMBER(14,2), 
	"TMP_DIR_NUM_EXTRA8" NUMBER(14,2), 
	"TMP_DIR_NUM_EXTRA9" NUMBER(14,2), 
	"TMP_DIR_NUM_EXTRA10" NUMBER(14,2), 
	"VERSION" NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
	"USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE, 
	"USUARIOMODIFICAR" VARCHAR2(10 CHAR), 
	"FECHAMODIFICAR" TIMESTAMP (6), 
	"USUARIOBORRAR" VARCHAR2(10 CHAR), 
	"FECHABORRAR" TIMESTAMP (6), 
	"BORRADO" NUMBER(1,0) DEFAULT 0
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DRECOVERYONL8M" ;
 

  CREATE UNIQUE INDEX "CM01"."PK_TMP_DIRECCIONES" ON "CM01"."TMP_DIRECCIONES" ("TMP_DIR_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DRECOVERYONL8M" ;
 

  CREATE INDEX "CM01"."TMP_DIRECCIONES_INDEX0" ON "CM01"."TMP_DIRECCIONES" ("TMP_DIR_COD_DIRECCION") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DRECOVERYONL8M" ;
 

  CREATE INDEX "CM01"."TMP_DIRECCIONES_INDEX1" ON "CM01"."TMP_DIRECCIONES" ("TMP_DIR_INE_POB") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DRECOVERYONL8M" ;
 

  CREATE INDEX "CM01"."TMP_DIRECCIONES_INDEX2" ON "CM01"."TMP_DIRECCIONES" ("TMP_DIR_INE_PROV") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DRECOVERYONL8M" ;
 

  CREATE INDEX "CM01"."TMP_DIRECCIONES_INDEX3" ON "CM01"."TMP_DIRECCIONES" ("TMP_DIR_TIPOVIA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DRECOVERYONL8M" ;
EXIT;