			ALTER TABLE LIN001.LIN_LOTES_NUEVOS
ADD (PROCURADOR VARCHAR2(10 BYTE));

DROP VIEW LIN001.VLIN_LOTES_NUEVOS;

/* Formatted on 2014/04/22 17:05 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW lin001.vlin_lotes_nuevos (n_caso,
                                                       creado,
                                                       fecha_alta,
                                                       n_referencia,
                                                       despacho,
                                                       letrado,
                                                       grupo,
                                                       tipo_proc,
                                                       con_procurador,
                                                       procurador,
                                                       con_contrato,
                                                       ID,
                                                       VERSION,
                                                       n_lote,
                                                       con_testimonio
                                                      )
AS
   SELECT "N_CASO", "CREADO", "FECHA_ALTA", "N_REFERENCIA", "DESPACHO", "LETRADO", "GRUPO", "TIPO_PROC",
          "CON_PROCURADOR", "PROCURADOR","CON_CONTRATO", "ID", "VERSION", "N_LOTE", "CON_TESTIMONIO"
     FROM lin_lotes_nuevos;