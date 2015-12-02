package es.pfsgroup.plugin.precontencioso;

import java.util.List;


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

}
