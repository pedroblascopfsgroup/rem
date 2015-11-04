package es.pfsgroup.plugin.precontencioso;

import java.util.Map;
import java.util.List;
import java.util.Set;

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
	
	/**
	 * Devuelve la configuracion para saber si hay que generar el archivo del burofax o no
	 * @return
	 */
	public boolean isGenerarArchivoBurofax();

}
