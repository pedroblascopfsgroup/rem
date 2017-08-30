package es.pfsgroup.plugin.rem.activo;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivoPropagacionFieldTabMap {

    public static final Map<String, List<String>> map;

    private static final String TAB_DATOS_BASICOS = "datosbasicos";

    static {
    	Map<String, List<String>> pmap = new HashMap<String, List<String>>();

    	pmap.put(TAB_DATOS_BASICOS, 
    			Arrays.asList(
   	    			// identificacion
	    			"tipoActivoCodigo", 
	    			"subtipoActivoCodigo", 
	    			"estadoActivoCodigo", 

	    			// direccion
	    			"tipoUsoDestinoCodigo",
	    			"longitud",
	    			"latitud",
	    			"piso",
	    			"inferiorMunicipioCodigo",
	    			"municipioCodigo",
	    			"provinciaCodigo",
	    			"puerta",
	    			"escalera",
	    			"numeroDomicilio",
	    			"tipoViaCodigo",
	    			"codPostal",
	    			"codPostalFormateado",

	    			// perimetro
	    			"motivoAplicaGestion",
	    			"motivoAplicaComercializarCodigo",
	    			"motivoAplicaFormalizar",
	    			"aplicaGestion",
	    			"aplicaFormalizar",
	    			"aplicaComercializar",
	    			
	    			// comercializacion
    				"tipoComercializarCodigo",
    				"tipoComercializacionCodigo",
    				"bloqueoTipoComercializacionAutomatico",
    				"tipoAlquilerCodigo",

    				// Activo bancario
    				"claseActivoCodigo",
    				"subtipoClaseActivoCodigo",
    				"numExpRiesgo",
    				"estadoExpRiesgoCodigo",
    				"productoDescripcion",
    				"estadoExpIncorrienteCodigo"
    			));

        map = Collections.unmodifiableMap(pmap);
    }
}
