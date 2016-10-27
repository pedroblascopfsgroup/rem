package es.pfsgroup.plugin.rem.api;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.ModelMap;

public interface PropuestaOfertaApi {

	/* Devuelve lista de parametros necesarios para pintar el PDF de PropuestaSimple */
    public Map<String, Object> paramsPropuestaSimple(Long numOfertaHRE, ModelMap model);
    
    /* Devuelve el dataSource necesario para pintar el PDF de PropuestaSimple */
    public List<Object> dataSourcePropuestaSimple(Long numOfertaHRE, ModelMap model);
    
    /* Generar un fichero PDF de la propuesta simple, dados unos parametros y unas listas */
    public File getPDFFilePropuestaSimple(Map<String, Object> params, List<Object> dataSource, ModelMap model);
    
    /* Envia un fichero a traves del response pero cifrado en Base64*/
    public void sendFileBase64 (HttpServletResponse response, File file, ModelMap model);
}
