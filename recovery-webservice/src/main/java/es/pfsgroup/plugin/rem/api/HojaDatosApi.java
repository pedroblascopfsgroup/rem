package es.pfsgroup.plugin.rem.api;

import java.util.List;
import java.util.Map;

import org.springframework.ui.ModelMap;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface HojaDatosApi {

	/* Devuelve lista de parametros necesarios para pintar el PDF de HojaDatos */
    public Map<String, Object> paramsHojaDatos(Oferta oferta, ModelMap model);
    
    /* Devuelve el dataSource necesario para pintar el PDF de HojaDatos */
    public List<Object> dataSourceHojaDatos(Oferta oferta, Activo activo, ModelMap model);

}
