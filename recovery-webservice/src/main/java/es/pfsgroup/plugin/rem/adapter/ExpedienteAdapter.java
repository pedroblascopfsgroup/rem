package es.pfsgroup.plugin.rem.adapter;


import java.util.Properties;

import javax.annotation.Resource;

import es.capgemini.devon.beans.Service;

@Service
public class ExpedienteAdapter {
	
	private static final String URL = "endpoint.haya.existe.endpoint";
	private static final String PORT = "edpoint.haya.existe.tarea.port";
	private static final String SERVICE = "endpoint.haya.existe.tarea.service";
	public static final String DEV = "DEV";
	
	@Resource
	private Properties appProperties;


	public String getExisteTareaHayaEndpoint() {
		String url = appProperties.getProperty(URL);
		String port = appProperties.getProperty(PORT);
		String service = appProperties.getProperty(SERVICE);
		if ( url == null || port == null || service == null ) {
			return DEV;
		} else {
			return String.format("%s%s%s",url, port,service);
		}
	}

}
