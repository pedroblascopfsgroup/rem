package es.pfsgroup.plugin.recovery.masivo.launcher.impl;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVCargaDocumentacionApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVCargaDocumentacionInitDto;
import es.pfsgroup.plugin.recovery.masivo.launcher.MSVCargaDocumentacionLauncherApi;

@Component("msvCargaDocumentacionLauncher")
public class MSVCargaDocumentacionLauncher implements MSVCargaDocumentacionLauncherApi {

	@Resource(name = "appProperties")
	private Properties appProperties;

	@Autowired
	private ApiProxyFactory proxyFactory;

	private String directorio;
	private String rutaBackup;
	private Boolean hacerBackup;
	private Boolean borrarArchivos;
	private String mascara;
	
	private SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");


	private final Log logger = LogFactory.getLog(getClass());

    public Properties getAppProperties() {
		return appProperties;
	}

	public void setAppProperties(Properties appProperties) {
		this.appProperties = appProperties;
	}

	public String getDirectorio() {
		return directorio;
	}

	/**
	 * Ruta donde buscar los ficheros.
	 * @param directorio
	 */
	public void setDirectorio(String directorio) {
		this.directorio = directorio;
	}
	
	/**
	 * Ruta para realizar la copia de seguridad
	 * @return
	 */
	public String getRutaBackup() {
		return rutaBackup;
	}

	public void setRutaBackup(String rutaBackup) {
		this.rutaBackup = rutaBackup;
	}
	
	/**
	 * Indica si se copia los archivos a un zip
	 * @return
	 */
	public Boolean getHacerBackup() {
		return hacerBackup;
	}

	public void setHacerBackup(Boolean hacerBackup) {
		this.hacerBackup = hacerBackup;
	}

	/**
	 * Indica si se borran los archivos adjuntados
	 * @return
	 */
	public Boolean getBorrarArchivos() {
		return borrarArchivos;
	}

	public void setBorrarArchivos(Boolean borrarArchivos) {
		this.borrarArchivos = borrarArchivos;
	}

	
	/**
	 * Indica la mascara que se aplicara para obtener los excel de relación de archivos y asuntos
	 * @return
	 */
	public String getMascara() {
		return mascara;
	}

	public void setMascara(String mascara) {
		this.mascara = mascara;
	}


	/**
	 * Variable usada para llevar registro del resultado de la carga
	 */
	private String resultado;

    public String getResultado() {
		return resultado;
	}

	public void setResultado(String resultado) {
		this.resultado = resultado;
	}

	@BusinessOperation(BO_CARGADOCS_ARRANCAR_SERVICIO)
	public String ejecutarServicio(String workingCode) {
		
		// Obtenemos hora actual y la formateamos
		String horaActual = formatter.format(new Date());

		logger.info("Parámetros de configuración: ");
		logger.info("directorio: " + this.directorio);
		
		// Comprobamos que nos encontramos en la ventana horaria adecuada
		logger.info("MSVCargaDocumentacionLauncher: " + horaActual + ". - " + getDirectorio());
		
		//Construir el Dto que usaremos para invocar al Manager
		MSVCargaDocumentacionInitDto dto = new MSVCargaDocumentacionInitDto();
		dto.setDirectorio(directorio);
		dto.setBorrarArchivos(borrarArchivos);
		dto.setMascara(mascara, workingCode);
		dto.setHacerBackup(hacerBackup); 
		dto.setRutaBackup(rutaBackup);
		
		//Invocar al ejecutor del manager que realiza el escaneo en el directorio
		try {
//			proxyFactory.proxy(MSVCargaDocumentacionApi.class).ejecuta(dto);
			
			List<File> listaFicheros = proxyFactory.proxy(MSVCargaDocumentacionApi.class).getConfigFiles(dto);
			
			for (File file : listaFicheros ) {
				List<File> listAllAdjuntos = proxyFactory.proxy(MSVCargaDocumentacionApi.class).procesarFichero(file, dto);
				if (dto.getBorrarArchivos()) proxyFactory.proxy(MSVCargaDocumentacionApi.class).eliminarFicheros(listAllAdjuntos);
			}
			
			
		} catch (IllegalArgumentException e1) {
			logger.error("MSVCargaDocumentacionLauncher: error argumento ilegal " + e1.getMessage()); 
		} catch (IOException e1) {
			logger.error("MSVCargaDocumentacionLauncher: error de entrada/salida " + e1.getMessage()); 
		} catch (Exception e1) {
			logger.error("MSVCargaDocumentacionLauncher: error al invocar MSVCargaDocumentacionApi.ejecuta " + e1.getMessage()); 
		}
		
		return getResultado();
		
	}

	@PostConstruct
	public void init() {

		String defDirectorio = "/tmp";
		String defRutaBackup = defDirectorio + "/backup";
		Boolean defHacerBackup = false;
		Boolean defBorrarArchivos = false;
		String defMascara = "*.xls";
		
		if (appProperties == null) {
			directorio = defDirectorio;
			rutaBackup = defRutaBackup;
			hacerBackup = defHacerBackup;
			borrarArchivos = defBorrarArchivos;
			mascara = defMascara;
		} else {
			directorio = (appProperties.getProperty(KEY_DIRECTORIO) == null ? defDirectorio	: appProperties.getProperty(KEY_DIRECTORIO));
			rutaBackup = (appProperties.getProperty(KEY_RUTABACKUP) == null ? defRutaBackup	: appProperties.getProperty(KEY_RUTABACKUP));
			hacerBackup= (appProperties.getProperty(KEY_HACERBACKUP) == null ? Boolean.valueOf(defHacerBackup) : Boolean.valueOf(appProperties.getProperty(KEY_HACERBACKUP)));
			borrarArchivos = (appProperties.getProperty(KEY_BORRARFILES) == null ? Boolean.valueOf(defBorrarArchivos) : Boolean.parseBoolean(appProperties.getProperty(KEY_BORRARFILES)));
			mascara = (appProperties.getProperty(KEY_MASCARA) == null ? defMascara : appProperties.getProperty(KEY_MASCARA));
		}

	}

}
