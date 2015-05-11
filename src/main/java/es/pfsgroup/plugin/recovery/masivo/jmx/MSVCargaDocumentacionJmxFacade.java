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
import es.pfsgroup.plugin.recovery.masivo.launcher.MSVCargaDocumentacionLauncherApi;


/**
 * Fachada JMX para el lanzamiento del proceso de carga masiva de documentos adjuntos.
 * Utilizado por el BATCH.
 * 
 * @author manuel
 *
 */
@Component
@ManagedResource("devon:type=MSVCargaDocumentacion")
public class MSVCargaDocumentacionJmxFacade {

	
	@Autowired
	private EntidadDao entidadDao;
	
	@Autowired
	MSVCargaDocumentacionLauncherApi msvCargaDocumentacionLauncherApi;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	private String directorio;
	private String rutaBackup;
	private Boolean hacerBackup;
	private Boolean borrarArchivos;
	private String mascara;
	

	/**
	 * Ejecuta el proceso de carga masiva de adjuntos.
	 * @param workingCode código de la entidad
	 */
	@ManagedOperation(description = "Iniciar el servicio de carga de adjuntos automática")
	public void procesarCargaDocumentos(final String workingCode) {
		
		final Entidad entidad = entidadDao.findByWorkingCode(workingCode);
		DbIdContextHolder.setDbId(entidad.getId());
		
		this.initValues(workingCode);
		logger.info("Iniciando el proceso de carga de adjuntos automático. Entidad: " + workingCode);
		
		msvCargaDocumentacionLauncherApi.ejecutarServicio(workingCode);
		
		logger.info("Finalizado el proceso de carga de adjuntos automático.");
		
	}
	

	private void initValues(String workingCode) {
		if (this.directorio != null){
			msvCargaDocumentacionLauncherApi.setDirectorio(directorio);
		}
		if (this.rutaBackup != null) {
			msvCargaDocumentacionLauncherApi.setDirectorio(rutaBackup);
		}
		if (this.hacerBackup != null) {
			msvCargaDocumentacionLauncherApi.setHacerBackup(hacerBackup);
		}
		if (this.borrarArchivos != null) {
			msvCargaDocumentacionLauncherApi.setBorrarArchivos(borrarArchivos);
		}
		if (this.mascara != null) {
			msvCargaDocumentacionLauncherApi.setMascara(mascara);
		}
	}
    
}
