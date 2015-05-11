package es.pfsgroup.recovery.bpmframework.jmx;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi;
import es.pfsgroup.recovery.bpmframework.batch.model.RecoveryBPMfwkPeticionBatch;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;

/**
 * Fachada JMX para el lanzamiento del procesado de peticiones batch pendientes.
 * Utilizado por el BATCH.
 * 
 * @author manuel
 *
 */
@Component
@ManagedResource("devon:type=BPMfwkBatchManager")
public class RecoveryBPMFwkJmxFacade {
	
	@Autowired
	private EntidadDao entidadDao;
	
	@Autowired
	private transient GenericABMDao genericDao;
	
	@Autowired
	private RecoveryBPMfwkBatchApi recoveryBPMfwkBatchApi;
	
	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Inicia el procesado de peticiones batch pendientes.
	 * 
	 * @param workingCode código de la entidad
	 * @throws RecoveryBPMfwkError
	 */
	@ManagedOperation(description = "Iniciar el servicio de ejecución de peticiones pendientes del framework bpm")
	public void ejecutaPeticionesBatchPendientes(final String workingCode) throws RecoveryBPMfwkError {
		
		final Entidad entidad = entidadDao.findByWorkingCode(workingCode);
		DbIdContextHolder.setDbId(entidad.getId());
		
		logger.info("Iniciando el proceso de ejecución de peticiones pendientes del framework bpm. Entidad: " + workingCode);
		
		logger.info("[RecoveryBPMFwkJmxFacade:ejecutaPeticionesBatchPendientes] - Inicio de proceso: " + new Date());
		// Recuperamos la lista de peticiones pendientes ordenada por token
		// marcados como no procesados (
		try {
			List<RecoveryBPMfwkPeticionBatch> listaPeticionesPendientes = recoveryBPMfwkBatchApi.obtenerListaPeticionesPendientes();
			// Recorremos la lista de peticiones pendientes y las marcamos como
			// procesadas
			int sizeLista = listaPeticionesPendientes.size();
			System.out.println("[RecoveryBPMFwkJmxFacade:ejecutaPeticionesBatchPendientes] - Numero de peticiones pendientes: " + sizeLista);
			final Date fechaProcesado = new Date();
			Long anteriorToken;
			Long actualToken = 0L;
			Long siguienteToken;
			RecoveryBPMfwkPeticionBatch peticion = null;
			boolean esNecesarioEjecutarOnEnd = false;
			for (int i = 0; i < sizeLista; i++) {
				try{
					peticion = listaPeticionesPendientes.get(i);
					anteriorToken = actualToken;
					actualToken = peticion.getIdToken();
					boolean esNecesarioEjecutarOnStart = (i == 0 || !actualToken
							.equals(anteriorToken));
					if (i + 1 == sizeLista) {
						siguienteToken = -1L;
					} else {
						siguienteToken = listaPeticionesPendientes.get(i + 1)
								.getIdToken();
					}
					esNecesarioEjecutarOnEnd = !siguienteToken
							.equals(actualToken);
					recoveryBPMfwkBatchApi.procesarInput(peticion, esNecesarioEjecutarOnStart,
							esNecesarioEjecutarOnEnd, fechaProcesado);
				}catch(Throwable e){
					recoveryBPMfwkBatchApi.gestionarProcesadoInputError(peticion, esNecesarioEjecutarOnEnd, fechaProcesado, e.getMessage());
				}
			}

		} catch (Exception e) {
			throw new RecoveryBPMfwkError(
					RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION,
					"Error en la ejecución del batch.", e);
		}catch(Throwable e){
			throw new RecoveryBPMfwkError(
					RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION,
					"Error en la ejecución del batch.", e);
		}		
		System.out.println("[RecoveryBPMFwkJmxFacade:ejecutaPeticionesBatchPendientes] - Fin de proceso: " + new Date());
		
		//recoveryBPMfwkBatchApi.ejecutaPeticionesBatchPendientes();
		
		logger.info("Finalizado el proceso de ejecución de peticiones pendientes del framework bpm");
		
	}
		
}
