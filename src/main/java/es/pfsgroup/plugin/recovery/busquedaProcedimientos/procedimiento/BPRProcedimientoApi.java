package es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento;

import java.util.Collection;

import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface BPRProcedimientoApi {

	final static String BPR_GET_DEMANDADOS = "es.pfsgroup.plugin.recovery.busquedaProcedimientos.getDemandados";
	
	/**
	 * Recupera los usuarios cuyo nombre contiene el texto query
	 * 
	 * @param query
	 *            Es la query que envia desde la Web para filtrar
	 * @return
	 */
	@BusinessOperationDefinition(BPR_GET_DEMANDADOS)
	public Collection<? extends Persona> getDemandadosInstant(String query);

	

}
