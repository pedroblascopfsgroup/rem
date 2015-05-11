--Tabla del Diccionario Editable de Gestorías
  CREATE TABLE "BANK01"."DD_GES_GESTORIA" 
   (	"DD_GES_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"DD_GES_CODIGO" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
	"DD_GES_DESCRIPCION" VARCHAR2(50 CHAR), 
	"DD_GES_DESCRIPCION_LARGA" VARCHAR2(250 CHAR), 
	"VERSION" NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
	"USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE, 
	"USUARIOMODIFICAR" VARCHAR2(10 CHAR), 
	"FECHAMODIFICAR" TIMESTAMP (6), 
	"USUARIOBORRAR" VARCHAR2(10 CHAR), 
	"FECHABORRAR" TIMESTAMP (6), 
	"BORRADO" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "UK_DD_GES_GESTORIA" UNIQUE ("DD_GES_CODIGO"), 
	 CONSTRAINT "PK_DD_GES_GESTORIA" PRIMARY KEY ("DD_GES_ID")
   );

CREATE SEQUENCE  "BANK01"."S_DD_GES_GESTORIA"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER NOCYCLE;
