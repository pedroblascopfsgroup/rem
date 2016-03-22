package es.pfsgroup.plugin.recovery.liquidaciones.api;

import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;



/**
 * Interfaz que define los metodos del DAO de Contabilidad Cobros.
 * 
 * @author Kevin
 * 
 */
public interface ContabilidadCobrosApi {

	/**
	 * Guarda la contabilidad cobros
	 * 
	 * @param dto
	 */
	void saveContabilidadCobro(DtoContabilidadCobros dto);
	
	
	/**
	 * Guarda la contabilidad cobros
	 * 
	 * @param dto
	 */
	void deleteContabilidadCobro(Long idContabilidadCobro);
	
}