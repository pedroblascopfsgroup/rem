package es.pfsgroup.plugin.rem.api;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.ui.ModelMap;

import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface ParamReportsApi {

	/* Devuelve lista de parametros necesarios para pintar el PDF de HojaDatos */
    public Map<String, Object> paramsHojaDatos(ActivoOferta activoOferta, ModelMap model);
    
    /* Devuelve el dataSource necesario para pintar el PDF de HojaDatos */
    public List<Object> dataSourceHojaDatos(ActivoOferta activoOferta, ModelMap model);

    /* Devuelve lista de parametros necesarios para pintar el PDF de CABECERA de la agrupación */
	public Map<String, Object> paramsCabeceraHojaDatos(ActivoOferta activoOferta, ModelMap model);
        
    public File getPDFFile(Map<String, Object> params, List<Object> dataSource, String template, ModelMap model, Long numExpediente);
  

}
