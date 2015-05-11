package es.pfsgroup.plugin.recovery.masivo.launcher;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Esta interfaz servir� para publicar en JMX el MBean que ejecutar� el servicio de demonio en espera de la carga de
 * ficheros en el directorio especificado
 * 
 * @author pedro
 * 
 */
public interface MSVCargaDocumentacionLauncherApi {

	final static String KEY_DIRECTORIO = "cargadocs.directorio";
	final static String KEY_RUTABACKUP = "cargadocs.rutaBackup";
	final static String KEY_HACERBACKUP = "cargadocs.hacerBackup";
	final static String KEY_BORRARFILES = "cargadocs.borrarDocs";
	final static String KEY_MASCARA = "cargadocs.mascara";

	String BO_CARGADOCS_ARRANCAR_SERVICIO = "es.pfsgroup.plugin.recovery.masivo.launcher.ejecutarServicio";

	/**
	 * Inicio del servicio: se deber� invocar al arrancar la aplicaci�n
	 * o por parte del componente batch
	 * 
	 * @param workingCode: el codigo de la entidad
	 * @throws NumberFormatException
	 * @throws InterruptedException
	 */
	@BusinessOperationDefinition(BO_CARGADOCS_ARRANCAR_SERVICIO)
	String ejecutarServicio(String workingCode);

	public void setDirectorio(String directorio);
	
	public void setRutaBackup(String rutaBackup);
	
	public void setHacerBackup(Boolean hacerBackup);
	
	public void setBorrarArchivos(Boolean borrarArchivos);

	public void setMascara(String mascara);
	
}
