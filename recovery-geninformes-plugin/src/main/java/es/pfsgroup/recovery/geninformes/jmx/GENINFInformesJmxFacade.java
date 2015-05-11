package es.pfsgroup.recovery.geninformes.jmx;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.pfsgroup.recovery.geninformes.api.GENINFEmailsPendientesApi;

/**
 * Fachada JMX para el lanzamiento del procesado de emails pendientes.
 * Utilizado por el BATCH.
 * 
 * @author manuel
 *
 */
@Component
@ManagedResource("devon:type=GENINFEmailsPendientes")
public class GENINFInformesJmxFacade {
	
	@Autowired
	private EntidadDao entidadDao;
	
	@Autowired
	GENINFEmailsPendientesApi genINFEmailsPendientesApi;

	private final Log logger = LogFactory.getLog(getClass());
	
	/**
	 * Inicia el procesado de emails pendientes.
	 * 
	 * @param workingCode código de la entidad.
	 */
	@ManagedOperation(description = "Iniciar el servicio de ejecución de procesado de emails pendientes")
	public void procesarEmailsPendientes(final String workingCode) {
		
		final Entidad entidad = entidadDao.findByWorkingCode(workingCode);
		DbIdContextHolder.setDbId(entidad.getId());
		
		logger.info("Iniciando el proceso ejecución de procesado de emails pendientes. Entidad: " + workingCode);
		
		genINFEmailsPendientesApi.procesarEmailsPendientes();
		
		logger.info("Finalizado el proceso ejecución de procesado de emails pendientes.");
		
		
	}
    
}
