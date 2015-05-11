package es.pfsgroup.recovery.bpmframework.batch.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.bpmframework.batch.model.RecoveryBPMfwkPeticionBatch;

/**
 * Capa DAO del objeto {@link RecoveryBPMfwkPeticionBatchDao}
 * @author manuel
 *
 */
public interface RecoveryBPMfwkPeticionBatchDao  extends AbstractDao< RecoveryBPMfwkPeticionBatch, Long>{

	/**
	 * Devuelve un identificador único que se utilizará para realizar las peticiones
	 * de ejecución de procesos en batch. 
	 * @return
	 */
	Long getToken();
	
	/**
	 * Obtiene el numero de inputs pendientes de procesar
	 * @return
	 */
	Long obtenerNumeroPeticionesPendientes();
	
}
