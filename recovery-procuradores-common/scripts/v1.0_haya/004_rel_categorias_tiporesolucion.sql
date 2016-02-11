CREATE TABLE REL_CATEGORIAS_TIPORESOL
(
  REL_ID  NUMBER                                NOT NULL,
  TR_ID  NUMBER                                NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
NOMONITORING;

CREATE UNIQUE INDEX REL_CATEGORIAS_TIPORESOL_PK ON REL_CATEGORIAS_TIPORESOL(REL_ID);

ALTER TABLE REL_CATEGORIAS_TIPORESOL ADD (
  CONSTRAINT REL_CATEGORIAS_TIPORESOL_PK
 PRIMARY KEY
 (REL_ID)USING INDEX);
