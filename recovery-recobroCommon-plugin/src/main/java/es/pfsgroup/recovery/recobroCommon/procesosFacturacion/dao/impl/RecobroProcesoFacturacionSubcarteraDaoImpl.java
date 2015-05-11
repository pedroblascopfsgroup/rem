package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api.RecobroProcesoFacturacionSubcarteraDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;

@Repository("RecobroProcesoFacturacionSubcarteraDao")
public class RecobroProcesoFacturacionSubcarteraDaoImpl extends AbstractEntityDao<RecobroProcesoFacturacionSubcartera, Long> implements RecobroProcesoFacturacionSubcarteraDao {

	@Override
	public void updateSumProcesoFacturacionSubcartera(long procesoFacturacionId) {
		String sql = "MERGE INTO PFS_PROC_FAC_SUBCARTERA P " +
					 "USING (WITH TMP AS ( " +
					        "SELECT PFS_ID, COUNT(1) COBROS , SUM(RDF_IMPORTE_A_PAGAR) TOTAL " +
					        "FROM TMP_RECOBRO_DETALLE_FACTURA " +
					        "GROUP BY PFS_ID) " +
					       "SELECT * FROM TMP) T " +
					 "ON (P.PFS_ID = T.PFS_ID AND P.PRF_ID = "+ procesoFacturacionId + ") " +
					 "WHEN MATCHED THEN UPDATE " +
					 "SET RCF_TOTAL_COBROS = T.COBROS, " +
					 "RCF_TOTAL_FACTURABLE = T.TOTAL";	
		
		getSession().createSQLQuery(sql).executeUpdate();
	}
}
