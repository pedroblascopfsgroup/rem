package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import java.math.BigDecimal;

import org.hibernate.Hibernate;
import org.hibernate.type.Type;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVContratoDao;

@Repository("MSVContratoDao")
public class MSVContratoDaoImpl extends AbstractEntityDao<EXTContrato, Long>  implements MSVContratoDao {

	@Override
	public BigDecimal getRestanteDemanda(Long idContrato) {
		try {
			String sql = "(SELECT CASE " +
					"    WHEN iac1.iac_value IS NOT NULL " +
					"    AND TO_NUMBER (NVL (iac1.iac_value, 0)) <= " +
					"             NVL (prc2.prc_saldo_recuperacion, 0) " +
					"           - NVL (ipagposdem.importe_pagos_post_demanda, 0) " +
					"       THEN TO_NUMBER (NVL (iac1.iac_value, 0)) " +
					"    ELSE   NVL (prc2.prc_saldo_recuperacion, 0) " +
					"         - NVL (ipagposdem.importe_pagos_post_demanda, 0) " +
					" END " +
					" FROM asu_asuntos asu JOIN linmaster.dd_eas_estado_asuntos eas " +
					" ON eas.dd_eas_id = asu.dd_eas_id " +
					" JOIN cex_contratos_expediente cex ON asu.exp_id = cex.exp_id and cex.cnt_id = ?" +
					" JOIN cnt_contratos cnt ON cnt.cnt_id = cex.cnt_id " +
					" LEFT JOIN " +
					" (SELECT   prc.asu_id, MAX (prc.prc_id) AS prc_id " +
					"      FROM prc_procedimientos prc " +
					"     WHERE prc.dd_tpo_id = 1148 " +
					"  GROUP BY prc.asu_id) prc1 ON prc1.asu_id = asu.asu_id " +
					" LEFT JOIN prc_procedimientos prc2 ON prc2.prc_id = prc1.prc_id " +
					" LEFT JOIN ext_iac_info_add_contrato iac1 " +
					" ON iac1.cnt_id = cex.cnt_id AND iac1.dd_ifc_id = 6  " +
					" LEFT JOIN " +
					" (SELECT   asu_id, MAX (f_interposicion) fecha_presentacion_demanda " +
					"      FROM v_lin_fechas_procedimientos v_lin " +
					"     WHERE v_lin.f_interposicion IS NOT NULL " +
					"  GROUP BY v_lin.asu_id) f_inter ON f_inter.asu_id = asu.asu_id " +
					" LEFT JOIN " +
					" (SELECT   cpa.cnt_id, SUM (cpa.cpa_importe) importe_pagos " +
					"      FROM cpa_cobros_pagos cpa " +
					"  GROUP BY cpa.cnt_id) ipag ON ipag.cnt_id = cnt.cnt_id " +
					" LEFT JOIN " +
					" (SELECT   cnt_id, SUM (cpa_importe) importe_pagos_post_demanda " +
					"      FROM cpa_cobros_pagos cpa " +
					"           LEFT JOIN " +
					"           (SELECT   v_lin2.asu_id, " +
					"                     MAX (v_lin2.f_interposicion) fecha_presentacion_demanda " +
					"                FROM v_lin_fechas_procedimientos v_lin2 " +
					"               WHERE v_lin2.f_interposicion IS NOT NULL " +
					"            GROUP BY v_lin2.asu_id) f_inter ON f_inter.asu_id = cpa.asu_id " +
					"     WHERE cpa.cpa_fecha > f_inter.fecha_presentacion_demanda " +
					"  GROUP BY cnt_id) ipagposdem ON ipagposdem.cnt_id = cnt.cnt_id " +
					" WHERE eas.dd_eas_id = 8)";
			
			 Object[] args = new Object[] { idContrato };
	         Type[] argsTypes = new Type[] { Hibernate.LONG };
	         
			return ((BigDecimal) getSession().createSQLQuery(sql).setParameters(args, argsTypes).uniqueResult());
		} catch (EmptyResultDataAccessException e) {
	        logger.error("Ha ocurrido un error al obtener el restante demanda del contrato: " + idContrato + "\n"+e.getMessage());
	        return null;
	    }
	}


}
