package es.pfsgroup.plugin.recovery.iplus;

import java.io.File;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.iplus.driver.GestionIplus;
import es.pfsgroup.plugin.recovery.iplus.manager.GestionIplusApi;

import org.springframework.web.util.HtmlUtils;

@Service
public class GestionIplusFacade {
	
	private static final String IPLUS_DRIVER = "iplus.driver";
	private static final String IPLUS_DRIVER_DEFAULT = "es.pfsgroup.plugin.recovery.iplus.driver.GestionIplusStubImpl";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Resource
	private Properties appProperties;

	private GestionIplus driver;

	public GestionIplusFacade() {
		String nombreDriver = IPLUS_DRIVER_DEFAULT;
		if (appProperties == null) {
			System.out.println("GestionIplusFacade no inicializado por Spring");
			return;
		} else {
			nombreDriver = (appProperties.containsKey(IPLUS_DRIVER) ? appProperties.getProperty(IPLUS_DRIVER) : IPLUS_DRIVER_DEFAULT);
		}
		obtenerDriver(nombreDriver);
	}
	
	public void almacenar(String idProcedi, String tipoDoc, String nombreFichero, File file) {
		
		if (driver == null) {
			obtenerDriver();
		}
		//Obtener el equivalente tipo de fichero en IPLUS y su número de orden
		int orden = obtenerOrden(tipoDoc);
		
		//Corregir nombreFichero (quitar carácteres extraños)
		nombreFichero = normalizar(nombreFichero);
		
		driver.almacenar(idProcedi, orden, nombreFichero, file);
		
	}

	
	public List<IplusDocDto> listaDocumentos (String idProcedi) {
		if (driver == null) {
			obtenerDriver();
		}
		List<IplusDocDto> resultado = new ArrayList<IplusDocDto>();
		//TODO: resolver problema con el mapeo de documentos de IPLUS con Recovery
		resultado = driver.listaDocumentos(idProcedi);
		return resultado;
	}
	
	public FileItem abrirDocumento(String idProcedi, String nombre, String descripcion) {
		
		//FASE-1166 Intento de diagnostico error solo produccion (eliminar siguiente linea al resolver link)
		System.out.println("[GestionIplusFacade.abrirDocumento] (1) (antes normalizar)  Driver: "+ driver.toString());
		
		if (driver == null) {
			obtenerDriver();
		}
		
		//FASE-1166 Intento de diagnostico error solo produccion (eliminar siguiente linea al resolver link)
		System.out.println("[GestionIplusFacade.abrirDocumento] (2) (antes normalizar) idProcedi: " + idProcedi + ", Nombre: "+ nombre + ", Descripcion: " + descripcion + ", driver: "+ driver.toString());
		
		//Corregir nombre y descripcion de ficheros (quitar carácteres extraños)
		nombre = normalizar(nombre);
		descripcion = normalizar(descripcion);

		//FASE-1166 Intento de diagnostico error solo produccion (eliminar siguiente linea al resolver link)
		System.out.println("[GestionIplusFacade.abrirDocumento] (3) (despues normalizar) idProcedi: " + idProcedi + ", Nombre: "+ nombre + ", Descripcion: " + descripcion + ", driver: "+ driver.toString());
		
		return driver.abrirDocumento(idProcedi, nombre, descripcion);
	}
	
	public void borrarDocumento(String idProcedi, String nombre, String descripcion) {
		if (driver == null) {
			obtenerDriver();
		}
		driver.borrarDocumento(idProcedi, nombre, descripcion);
	}

	public void modificarDocumento(String idProcedi, String tipoDoc, String nombreFichero, IplusDocDto dto) {
		if (driver == null) {
			obtenerDriver();
		}
		//Obtener el equivalente tipo de fichero en IPLUS y su número de orden
		int orden = obtenerOrden(tipoDoc);
		driver.modificarDocumento(idProcedi, orden, nombreFichero, dto);
	}

	private int obtenerOrden(String tipoDoc) {
		
		return proxyFactory.proxy(GestionIplusApi.class).obtenerNumOrdenDeTipoDoc(tipoDoc);
		
	}

	private void obtenerDriver(String classNameDriver) {

		// Recuperar el driver del Integrador con IPLUS de Bankia (o del Stub)
		if (!classNameDriver.equals("")) {
			try {
				driver = (GestionIplus) (Class.forName(classNameDriver)).newInstance();
				System.out.println("[GestionIplusFacade.classNameDriver] = " + classNameDriver);
			} catch (InstantiationException e) {
				System.out.println("[GestionIplusFacade.classNameDriver] = " + classNameDriver + ":" + e.getMessage());				
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				System.out.println("[GestionIplusFacade.classNameDriver] = " + classNameDriver + ":" + e.getMessage());				
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				System.out.println("[GestionIplusFacade.classNameDriver] = " + classNameDriver + ":" + e.getMessage());				
				e.printStackTrace();
			}
		}
		setAppProperties();

	}
	
	private void obtenerDriver() {
		String nombreDriver = (appProperties.containsKey(IPLUS_DRIVER) ? appProperties.getProperty(IPLUS_DRIVER) : IPLUS_DRIVER_DEFAULT);
		obtenerDriver(nombreDriver);
	}
	
	private void setAppProperties() {
		if (appProperties != null && driver != null) {
			System.out.println("[GestionIplusFacade.setAppProperties]");
			driver.setAppProperties(appProperties);
		}
	}

	/**
	 * Función que elimina acentos y caracteres especiales de
	 * una cadena de texto.
	 * @param input
	 * @return cadena de texto limpia de acentos y caracteres especiales.
	 */
	public static String normalizarOld(String input) {
		
		String original = "áàäéèëíìïóòöúùüñÁÀÄÉÈËÍÌÏÓÒÖÚÙÜÑçÇ";
	    String ascii =    "aaaeeeiiiooouuunAAAEEEIIIOOOUUUNcC";
	    String output = HtmlUtils.htmlUnescape(input);
	    int longitud = original.length();
	    for (int i=0; i<longitud; i++) {
	        output = output.replace(original.charAt(i), ascii.charAt(i));
	    }
	    return output;
	}

	public static String normalizar(String input) {

		String aux = Normalizer.normalize(input, Normalizer.Form.NFD);
		String resultado = aux.replaceAll("[^\\x00-\\x7F]", "");
		return resultado;

	}
}
