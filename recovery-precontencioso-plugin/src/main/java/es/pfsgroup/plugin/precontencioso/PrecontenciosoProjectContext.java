package es.pfsgroup.plugin.precontencioso;


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

}
