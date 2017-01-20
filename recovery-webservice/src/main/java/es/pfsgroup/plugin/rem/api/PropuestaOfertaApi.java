package es.pfsgroup.plugin.rem.api;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;

import org.springframework.ui.ModelMap;

import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.rest.dto.OfertaSimpleDto;

public interface PropuestaOfertaApi{

	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de
	 * las peticiones POST.
	 * 
	 * @param PropuestaRequestDto con los parametros de entrada
	 * @param jsonFields estructura de parámetros para validar campos en caso de venir informados
	 * @return HashMap<String, String> 
	 */
	public HashMap<String, String> validatePropuestaOfertaRequestData(OfertaSimpleDto ofertaSimpleDto, Object jsonFields) throws Exception;
	
    
    
    public Map<String, Object> sendFileBase64(HttpServletResponse response, File file, ModelMap model) throws Exception;
    
 
    /**
	 * Devuelve lista de parametros necesarios para pintar el PDF de HojaDatos
	 * 
	 * @param activoOferta
	 * @param model
	 * @return HashMap<String, String> 
	 */
    public Map<String, Object> paramsHojaDatos(ActivoOferta activoOferta, ModelMap model) throws Exception;
    
    /**
	 * Devuelve el dataSource necesario para pintar el PDF de HojaDatos
	 * 
	 * @param activoOferta
	 * @param model
	 * @return List<Object>
	 */
    public List<Object> dataSourceHojaDatos(ActivoOferta activoOferta, ModelMap model) throws Exception;
    
    
    public File getPDFFile(Map<String, Object> params, List<Object> dataSource, String template, ModelMap model) throws JRException, IOException, Exception;

}
