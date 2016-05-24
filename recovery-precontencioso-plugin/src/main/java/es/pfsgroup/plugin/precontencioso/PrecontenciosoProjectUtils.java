package es.pfsgroup.plugin.precontencioso;

import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.precontencioso.liquidacion.dto.DDPropietarioPCODto;

/** Interface que definirá utilidades particulares del proyecto 
 * 
 * @author pedro
 *
 */
public interface PrecontenciosoProjectUtils {

	/**
	 * Devuelve la lista de entidades propietarias definidas para el combo
	 * @return lista de entidades propietarias originales
	 */
	public Map<String, String> getListaEntidades();

	/**
	 * Devuelve la lista de localidades de firma para el combo
	 * @return lista de localidades de firma
	 */
	public List<String> getListaLocalidades();

	public void setListaEntidades(Map<String, String> listaEntidades);

	public void setListaLocalidades(List<String> listaLocalidades);

	public List<DDPropietarioPCODto> getListaEntidadesPropietarias();
	
	public String obtenerNombre(String valor);
	
	public String obtenerInfoExtra(String valor);
	
	public String obtenerNombrePorClave(String clave);
	
	public String obtenerInfoPorClave(String clave);

	public List<String> getListaCentros();
	
	public List<String> getListaCentrosRecuperacion();
	
	public void setListaCentrosRecuperacion(List<String> listaCentrosRecuperacion);
	
}
