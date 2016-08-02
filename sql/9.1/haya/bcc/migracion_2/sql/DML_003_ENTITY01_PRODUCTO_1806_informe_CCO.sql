--/*
--##########################################
--## AUTOR=JTD
--## FECHA_CREACION=20160609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-18
--## PRODUCTO=SI
--##
--## Finalidad: DML Carga MIG_CCO_CONTABILIDAD_COBROS
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
SET HEADING OFF
SET FEEDBACK OFF
SET ECHO OFF
SET PAGESIZE 0
SET LINESIZE 10000
SPOOL informe_cobros_insertados.csv

SELECT informe FROM
( 
SELECT 1 AS orden, 
   'CCO_FECHA_ENTREGA;CCO_FECHA_VALOR;CCO_IMPORTE;DD_ATE_ID;DD_ACE_ID;CCO_NOMINAL;CCO_INTERESES;CCO_DEMORAS;CCO_IMPUESTOS;CCO_GASTOS_PROCURADOR;CCO_GASTOS_LETRADO;CCO_OTROS_GASTOS;CCO_QUITA_NOMINAL;CCO_QUITA_INTERESES;CCO_QUITA_DEMORAS;CCO_QUITA_IMPUESTOS;CCO_QUITA_GASTOS_PROCURADOR;CCO_QUITA_GASTOS_LETRADO;CCO_QUITA_OTROS_GASTOS;CCO_TOTAL_ENTREGA;CCO_NUM_ENLACE;CCO_NUM_MANDAMIENTO;CCO_CHEQUE;CCO_OBSERVACIONES;ASU_ID;CCO_OPERACIONES_TRAMITE;CCO_OPERACIONES_EN_TRAMITE;CCO_TOTAL_QUITA;CCO_QUITA_OPERACION_EN_TRAMITE;TAR_ID;CCO_CONTABILIZADO' informe
FROM dual
UNION 
SELECT
    2,    
    cco_fecha_entrega|| ';' || cco_fecha_valor|| ';' || cco_importe|| ';' ||
    dd_ate_id|| ';' || dd_ace_id|| ';' || cco_nominal|| ';' || cco_intereses|| ';' ||
    cco_demoras|| ';' || cco_impuestos|| ';' || cco_gastos_procurador|| ';' ||
    cco_gastos_letrado|| ';' || cco_otros_gastos|| ';' || cco_quita_nominal|| ';' ||
    cco_quita_intereses|| ';' || cco_quita_demoras|| ';' || cco_quita_impuestos|| ';' ||
    cco_quita_gastos_procurador|| ';' || cco_quita_gastos_letrado|| ';' ||
    cco_quita_otros_gastos|| ';' || cco_total_entrega|| ';' || cco_num_enlace|| ';' ||
    cco_num_mandamiento|| ';' || cco_cheque|| ';' || replace(replace(cco_observaciones, chr(13),''),chr(10),'')|| ';' || asu_id|| ';' ||
    cco_operaciones_tramite|| ';' || cco_operaciones_en_tramite|| ';' ||
    cco_total_quita|| ';' || cco_quita_operacion_en_tramite|| ';' || tar_id|| ';' ||
    cco_contabilizado
FROM HAYA02.cco_contabilidad_cobros
WHERE usuariocrear = 'PRODU-1806'
ORDER BY 1
);
SPOOL OFF;

SPOOL informe_cobros_no_insertados.csv

SELECT informe FROM
( 
SELECT 1 AS orden, 
   'CONTRATO; ID_COBRO; ID_EXPEDIENTE; CIERRE; NOMINAL;INTERESES; DEMORAS; GTO_ABOGADO; GTO_PROCURADOR; GTO_OTROS;OPER_TRAMITE; PASE_FALLIDO; QUITA_NOMINAL; QUITA_INTERESES;QUITA_DEMORAS; NUM_MANDAMIENTO; CONCEPTO_MANDAMIENTO;NUM_CHEQUE; NUM_ENLACE; OBSERVACIONES; TIPO_ENTREGA;EMPLEADO; FECHA_COBRO; FECHA_VALOR; ID_PROCESO;QUITA_GTO_ABOGADO; QUITA_GTO_PROCURADOR; QUITA_GTO_OTROS;QUITA_OPER_TRAMITE; ENVIADO; PROCEDE_OT; IVA; QUITA_IVA;CONCEPTO_ENTREGA' informe
FROM dual
UNION 
SELECT
    2,   
    contrato|| ';' || id_cobro|| ';' || id_expediente|| ';' || cierre|| ';' || nominal|| ';' ||
    intereses|| ';' || demoras|| ';' || gto_abogado|| ';' || gto_procurador|| ';' || gto_otros|| ';' ||
    oper_tramite|| ';' || pase_fallido|| ';' || quita_nominal|| ';' || quita_intereses|| ';' ||
    quita_demoras|| ';' || num_mandamiento|| ';' || concepto_mandamiento|| ';' ||
    num_cheque|| ';' || num_enlace|| ';' || replace(replace(observaciones, chr(13),''),chr(10),'')|| ';' || tipo_entrega|| ';' ||
    empleado|| ';' || fecha_cobro|| ';' || fecha_valor|| ';' || id_proceso|| ';' ||
    quita_gto_abogado|| ';' || quita_gto_procurador|| ';' || quita_gto_otros|| ';' ||
    quita_oper_tramite|| ';' || enviado|| ';' || procede_ot|| ';' || iva|| ';' || quita_iva|| ';' ||
    concepto_entrega
FROM HAYA02.mig_cco_contabilidad_cobros
WHERE NOT EXISTS (SELECT 1 FROM HAYA02.cco_contabilidad_cobros cco, HAYA02.asu_asuntos a 
                   WHERE cco.asu_id = a.asu_id
                     AND id_expediente = a.exp_id 
                     AND cco.usuariocrear = 'PRODU-1806')
ORDER BY 1
);
SPOOL OFF;
SET FEEDBACK ON
SET HEADING ON

EXIT;