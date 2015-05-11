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
 * B�squeda de impulsos procesales autom�ticos a procesar.
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
	 * Ejecuta la b�squeda y procesado de los impulsos autom�ticos.
	 * @param workingCode c�digo de la entidad
	 */
	@ManagedOperation(description = "B�squeda y procesado de impulsos autom�ticos")
	public void recorrerConfImpulsos(final String workingCode) {
		
		final Entidad entidad = entidadDao.findByWorkingCode(workingCode);
		DbIdContextHolder.setDbId(entidad.getId());
		
		logger.info("Iniciando el proceso de generaci�n de impulsos autom�tico. Entidad: " + workingCode);
		
		msvProcesoImpulsoAutomaticoApi.procesadoPeriodico();
		
		logger.info("Finalizado el proceso de generaci�n de impulsos autom�tico.");
		
	}
	

}
