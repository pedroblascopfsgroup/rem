package es.pfsgroup.plugin.recovery.masivo.jmx;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoImpulsoAutomaticoApi;

/**
 * Búsqueda de impulsos procesales automáticos a procesar.
 * Utilizado por el BATCH.
 * 
 * @author pedro
 *
 */
@Component
@ManagedResource("devon:type=MSVBusquedaImpulsos")
public class MSVBusquedaImpulsosJmxFacade {

	@Autowired
	private EntidadDao entidadDao;
	
	@Autowired
	MSVProcesoImpulsoAutomaticoApi msvProcesoImpulsoAutomaticoApi;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	/**
	 * Ejecuta la búsqueda y procesado de los impulsos automáticos.
	 * @param workingCode código de la entidad
	 */
	@ManagedOperation(description = "Búsqueda y procesado de impulsos automáticos")
	public void recorrerConfImpulsos(final String workingCode) {
		
		final Entidad entidad = entidadDao.findByWorkingCode(workingCode);
		DbIdContextHolder.setDbId(entidad.getId());
		
		logger.info("Iniciando el proceso de generación de impulsos automático. Entidad: " + workingCode);
		
		msvProcesoImpulsoAutomaticoApi.procesadoPeriodico();
		
		logger.info("Finalizado el proceso de generación de impulsos automático.");
		
	}
	

}
