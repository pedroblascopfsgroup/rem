package es.pfsgroup.recovery.bpmframework.batch.dao;

import java.math.BigDecimal;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.bpmframework.batch.model.RecoveryBPMfwkPeticionBatch;

/**
 * Implementación del DAO {@link RecoveryBPMfwkPeticionBatchDao}
 * @author manuel
 *
 */
@Repository("RecoveryBPMfwkPeticionBatchDao")
public class RecoveryBPMfwkPeticionBatchImpl extends AbstractEntityDao<RecoveryBPMfwkPeticionBatch, Long> implements RecoveryBPMfwkPeticionBatchDao {

	private static final String QUERY_NEXT_TOKEN = "select s_bpm_proceso_token.nextval from dual";
	private static final String QUERY_OBTENER_PETICIONES_PENDIENTES = "select count(1) from BPM_PET_PETICIONES_BATCH "
			+ " where BPM_PET_PROCESADO = " + RecoveryBPMfwkPeticionBatch.NO_PROCESADO + " and BORRADO = 0 ";

	/* (non-Javadoc)
	 * @see es.pfsgroup.recovery.bpmframework.batch.dao.RecoveryBPMfwkPeticionBatchDao#getToken()
	 */
	@Override
	public Long getToken() {
		
		Query query = this.getSession().createSQLQuery(QUERY_NEXT_TOKEN);
		Long resultado = ((BigDecimal) query.uniqueResult()).longValue();
		return resultado;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Long obtenerNumeroPeticionesPendientes() {
		Query query = this.getSession().createSQLQuery(QUERY_OBTENER_PETICIONES_PENDIENTES);
		Long resultado = ((BigDecimal) query.uniqueResult()).longValue();
		return resultado;		
	}

}
