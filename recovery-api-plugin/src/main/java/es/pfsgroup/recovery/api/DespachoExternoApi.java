package es.pfsgroup.recovery.api;

import java.util.List;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Operacioness de negocio de Recovery relacionadas con Despachos Externos
 * @author Diana
 *
 */
public interface DespachoExternoApi {

	/**
	 * Nos devuelve una lista de despachos externos por tipo y por zona
	 * @param zonas C�digos de zona separados por comas
	 * @param tipoDespacho C�digo del tipo de despacho.
	 * @return
	 */
	@BusinessOperationDefinition("despachoExternoManager.getDespachosPorTipoZona")
	List<DespachoExterno> getDespachosPorTipoZona(String zonas, String tipoDespacho);
	
	/**
	 * Nos devuelve una lista de gestores externos de un despacho
	 * @param id del despacho externo
	 * @return la lista de gestores
	 */
	@BusinessOperationDefinition("despachoExternoManager.getGestoresDespacho")
	List<GestorDespacho> getGestoresDespacho(Long id);
	
}
