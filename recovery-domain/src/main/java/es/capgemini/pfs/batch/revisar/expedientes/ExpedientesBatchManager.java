package es.capgemini.pfs.batch.revisar.expedientes;

import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.batch.revisar.expedientes.dao.ExpedientesBatchDao;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Clase manager de la entidad expediente.
 * 
 * @author mtorrado
 * 
 */
public class ExpedientesBatchManager {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ExpedientesBatchDao expedientesDao;

	@Autowired
	private Executor executor;
	
	@Autowired
	private JBPMProcessManager jbpmProcessUtils;

	/**
	 * Libera un contrato de un expediente.
	 * 
	 * @param idContrato
	 *            el contrato a liberar
	 * @param idExpediente
	 *            el expediente que contiene al contrato
	 */
	public void liberarContrato(Long idContrato, Long idExpediente) {
		expedientesDao.liberarContrato(idContrato, idExpediente);
	}

	/**
	 * Cancela un Expediente.
	 * 
	 * @param idExpediente
	 *            el expediente a cancelar.
	 * @param idJBPM
	 *            proceso jbpm
	 */
	@Transactional(readOnly = false)
	public void cancelarExpediente(Long idExpediente, Long idJBPM) {
		expedientesDao.cancelarExpediente(idExpediente, idJBPM);
		
		// Destruimos el BPM
		if (idJBPM != null) {
            jbpmProcessUtils.destroyProcess(idJBPM);
        }
		// Borramos todas las tareas asociadas del expediente
		executor
				.execute(
						ComunBusinessOperation.BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_EXPEDIENTE,
						idExpediente);
		// Enviamos una notificación
		executor.execute(
				ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION,
				idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
				SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_CERRADO, null);
		
		// Eliminamos el expediente de Favoritos
		executor
				.execute(
						ComunBusinessOperation.BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD_ELIMINADA,
						idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
		logger.debug("Notificación de expediente cancelado enviada");
	}

	/**
	 * Devuelve la lista de expedientes activos para la fecha de extracción
	 * indicada.
	 * 
	 * @return la lista de expedientes activos
	 */
	public Set<ExpedienteBatch> buscarExpedientesActivos() {
		return expedientesDao.buscarExpedientesActivos();
	}

}
