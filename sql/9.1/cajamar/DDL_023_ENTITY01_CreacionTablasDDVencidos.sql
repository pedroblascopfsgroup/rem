--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20150803
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-455
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas DD_MAD_MOTIVO_ALTA_DUDOSO
--##                               DD_MBD_MOTIVO_BAJA_DUDOSO
--##                               DD_TVE_TIPO_VENCIDO
--##                               , esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
  CREATE TABLE "CM01"."DD_MAD_MOTIVO_ALTA_DUDOSO" 
   (	"DD_MAD_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"DD_MAD_CODIGO" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
	"DD_MAD_DESCRIPCION" VARCHAR2(50 CHAR), 
	"DD_MAD_DESCRIPCION_LARGA" VARCHAR2(250 CHAR), 
	"VERSION" NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
	"USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE, 
	"USUARIOMODIFICAR" VARCHAR2(10 CHAR), 
	"FECHAMODIFICAR" TIMESTAMP (6), 
	"USUARIOBORRAR" VARCHAR2(10 CHAR), 
	"FECHABORRAR" TIMESTAMP (6), 
	"BORRADO" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "PK_DD_MAD_MOTIVO_ALTA_DUDOSO" PRIMARY KEY ("DD_MAD_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE "DRECOVERYONL8M"  ENABLE
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE "DRECOVERYONL8M" ;
  

  CREATE TABLE "CM01"."DD_MBD_MOTIVO_BAJA_DUDOSO" 
   (	"DD_MBD_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"DD_MBD_CODIGO" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
	"DD_MBD_DESCRIPCION" VARCHAR2(50 CHAR), 
	"DD_MBD_DESCRIPCION_LARGA" VARCHAR2(250 CHAR), 
	"VERSION" NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
	"USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE, 
	"USUARIOMODIFICAR" VARCHAR2(10 CHAR), 
	"FECHAMODIFICAR" TIMESTAMP (6), 
	"USUARIOBORRAR" VARCHAR2(10 CHAR), 
	"FECHABORRAR" TIMESTAMP (6), 
	"BORRADO" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "PK_DD_MBD_MOTIVO_BAJA_DUDOSO" PRIMARY KEY ("DD_MBD_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE "DRECOVERYONL8M"  ENABLE
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE "DRECOVERYONL8M" ;
  

  
  CREATE TABLE "CM01"."DD_TVE_TIPO_VENCIDO" 
   (	"DD_TVE_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"DD_TVE_CODIGO" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
	"DD_TVE_DESCRIPCION" VARCHAR2(50 CHAR), 
	"DD_TVE_DESCRIPCION_LARGA" VARCHAR2(250 CHAR), 
	"VERSION" NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
	"USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE, 
	"USUARIOMODIFICAR" VARCHAR2(10 CHAR), 
	"FECHAMODIFICAR" TIMESTAMP (6), 
	"USUARIOBORRAR" VARCHAR2(10 CHAR), 
	"FECHABORRAR" TIMESTAMP (6), 
	"BORRADO" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "PK_DD_TVE_TIPO_VENCIDO" PRIMARY KEY ("DD_TVE_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE "DRECOVERYONL8M"  ENABLE
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  TABLESPACE "DRECOVERYONL8M" ;