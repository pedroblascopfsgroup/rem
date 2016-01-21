package es.pfsgroup.plugin.precontencioso;

import java.util.List;
import java.util.Map;

import es.capgemini.pfs.users.domain.Usuario;


/**
 * API con las operaciones de negocio para el coreextension.
 * @author carlos
 *
 */
public interface PrecontenciosoProjectContext {
	
	
	/**
	 * Devuelve los codigos (DD_STA_CODIGO) agrupadas por categorias (DECISION, ....)
	 * @return Set<String>
	 */
	public String getCodigoFaseComun();

	public String getRecovery();	
	
	/**
	 * Devuelve la configuracion para saber si hay que generar el archivo del burofax o no
	 * @return
	 */
	public boolean isGenerarArchivoBurofax();
	
	/**
	 * Devuelve la lista de variables que se utilizan en el envío de burofaxes
	 * @return List<String>
	 */
	public List<String> getVariablesBurofax();

	/**
	 * Devuelve los mapas con los datos de visibilidad de los botones 
	 * @return mapa con todos los datos de visibilida de los botones
	 */
	public Map<String,Map<String,Map<String,Boolean>>> getVisibilidadBotones();
	
	/**
	 * Devuelve los mapas con los datos de visibilidad de los botones de la sección especificada y para el usuario pasado como parámetro
	 * @return mapa con todos los datos de visibilida de los botones
	 */
	public Map<String, Boolean> getVisibilidadBotonesPorSeccionYUsuario(String seccion, Usuario usuario);


}
