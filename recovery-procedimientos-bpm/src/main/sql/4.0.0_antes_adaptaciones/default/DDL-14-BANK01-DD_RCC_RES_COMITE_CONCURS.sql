  CREATE TABLE "BANK01"."DD_RCC_RES_COMITE_CONCURS" 
   (	"DD_RCC_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"DD_RCC_CODIGO" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"DD_RCC_DESCRIPCION" VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	"DD_RCC_DESCRIPCION_LARGA" VARCHAR2(200 CHAR) NOT NULL ENABLE, 
	"VERSION" NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
	"USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE, 
	"USUARIOMODIFICAR" VARCHAR2(10 CHAR), 
	"FECHAMODIFICAR" TIMESTAMP (6), 
	"USUARIOBORRAR" VARCHAR2(10 CHAR), 
	"FECHABORRAR" TIMESTAMP (6), 
	"BORRADO" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "PK_DD_RCC_RES_COMITE_CONCURS" PRIMARY KEY ("DD_RCC_ID"));
	 
CREATE SEQUENCE  "BANK01"."S_DD_RCC_RES_COMITE_CONCURS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
