-- Añadir flagPermiteProrrogas en el tipo de procedimiento, para controlar que procedimientos permiten prorrogas
-- de sus tareas. Esta funcionalidad surge de la UGAS-2993

alter table dd_tpo_tipo_procedimiento add (FLAG_PRORROGA NUMBER(1) DEFAULT 1 NOT NULL);

alter table dd_tpo_tipo_procedimiento add (DTYPE VARCHAR2 (20 CHAR) DEFAULT 'MEJTipoProcedimiento' NOT NULL);