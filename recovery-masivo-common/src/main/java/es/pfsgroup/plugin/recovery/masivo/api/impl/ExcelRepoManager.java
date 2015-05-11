package es.pfsgroup.plugin.recovery.masivo.api.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelRepoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDiccionarioApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVPlantillaOperacionDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVPlantillaOperacion;

/**
 * Repositorio de ficheros Excel.
 * @author manuel
 *
 */
@Component
public class ExcelRepoManager implements ExcelRepoApi{
	
	
	public final static String RUTA_EXCEL_PROPERTY = "rutaPlantillas";
	
	
//    @Resource(name="masivoProperties")
//	Properties masivoProperties;

    @Autowired(required=false)
    ServletContext servletContext;
    
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	MSVPlantillaOperacionDao msvPlantillaOperacionDao;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.ExcelRepoApi#dameExcel(java.lang.Long)
	 */
	@Override
	@BusinessOperation(MSV_BO_DAME_EXCEL)
	public FileItem dameExcel(Long tipoPlantilla) throws FileNotFoundException {

		FileItem fileItem = new FileItem();
		
		String rutaExcel = this.getRuta(tipoPlantilla);
		File file = new File(rutaExcel);
		if (!file.exists()) throw new FileNotFoundException("El fichero no existe.");

		fileItem.setFile(file);
		fileItem.setContentType(TIPO_EXCEL);
		fileItem.setFileName("\"" + file.getName() + "\"");
		return fileItem;
	}
	

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.ExcelRepoApi#dameExcelByTipoOperacion(java.lang.Long)
	 */
	@Override
	@BusinessOperation(MSV_BO_DAME_EXCEL_BY_TIPO_OPERACION)
	public FileItem dameExcelByTipoOperacion(Long idTipoOperacion) throws FileNotFoundException{

		MSVPlantillaOperacion plantilla = msvPlantillaOperacionDao.obtenerRutaExcelByTipoOperacion(idTipoOperacion);
		return this.dameExcel(plantilla.getId());
	}

	private String getRuta(Long tipoPlantilla) {
		String rutaExcel = proxyFactory.proxy(MSVDiccionarioApi.class).obtenerRutaExcel(tipoPlantilla);
		//String rutaBase = masivoProperties.getProperty(RUTA_EXCEL_PROPERTY);
		return servletContext.getRealPath(this.getPropiedad(RUTA_EXCEL_PROPERTY) + rutaExcel);
	}
	
	private String getPropiedad(String propiedad) {
		Properties propiedades = new Properties();
		try {
			InputStream is = this.getClass().getClassLoader().getResourceAsStream("masivoProperties.properties");
			//InputStream is = ClassLoader.getSystemResourceAsStream("masivoProperties.properties");
			if (is != null) {
				propiedades.load(is);
				return propiedades.getProperty(propiedad);
			}
		} catch (IOException e1) {
	        logger.error("Error al recuperar el fichero de properties: " + e1.getMessage());
	    }
		return new String("");
	}

}
