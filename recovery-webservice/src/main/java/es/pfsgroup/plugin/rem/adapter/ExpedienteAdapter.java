package es.pfsgroup.plugin.rem.adapter;


import java.util.Properties;

import javax.annotation.Resource;

import es.capgemini.devon.beans.Service;

@Service
public class ExpedienteAdapter {
	
	
	// ENDPOINT EXISTE TAREA
	private static final String EXISTE_TAREA_URL = "endpoint.haya.existe.endpoint";
	private static final String EXISTE_TAREA_PORT = "edpoint.haya.existe.tarea.port";
	private static final String EXISTE_TAREA_SERVICE = "endpoint.haya.existe.tarea.service";
	
	// ENDPOINT CONTRASTE LISTAS
	private static final String REM3_URL = "rem3.base.url";
	private static final String CONTRASTE_LISTAS_SERVICE = "rem3.endpoint.comercial.contraste.listas";
	
	
	public static final String DEV = "DEV";
	
	@Resource
	private Properties appProperties;


	public String getExisteTareaHayaEndpoint() {
		String url = appProperties.getProperty(EXISTE_TAREA_URL);
		String port = appProperties.getProperty(EXISTE_TAREA_PORT);
		String service = appProperties.getProperty(EXISTE_TAREA_SERVICE);
		if ( url == null || port == null || service == null ) {
			return DEV;
		} else {
			return String.format("%s%s%s",url, port,service);
		}
	}
	
	
	public String getContrasteListasREM3Endpoint() {
		String url = appProperties.getProperty(REM3_URL);  
		String service = appProperties.getProperty(CONTRASTE_LISTAS_SERVICE);
		if ( url == null ) {
			// PONER URL DEL DOCKER
			url = "http://192.168.80.4:9096";
			service = "/contraste/listas";
			return String.format("%s%s",url,service);
		} else {
			return String.format("%s%s",url,service);
		}
	}

}
