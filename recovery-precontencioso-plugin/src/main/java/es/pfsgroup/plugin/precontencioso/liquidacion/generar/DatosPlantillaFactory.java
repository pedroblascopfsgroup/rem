package es.pfsgroup.plugin.precontencioso.liquidacion.generar;

import java.util.HashMap;
import java.util.Map;

public interface DatosPlantillaFactory {

	/**
	 * Devuelve el codigo del tipo de liquidacion al que aplican dichos datos.
	 * 
	 * Se utiliza para comprobar que implementacion aplica.
	 * 
	 * @return
	 */
	String codigoTipoLiquidacion();

	/**
	 * Obtiene los datos de una liquidacion para rellenar una plantilla
	 * 
	 * @param idLiquidacion
	 * @return datos para rellenar la plantilla de liquidacion
	 */
	HashMap<String, Object> obtenerDatos(Long idLiquidacion);

}
