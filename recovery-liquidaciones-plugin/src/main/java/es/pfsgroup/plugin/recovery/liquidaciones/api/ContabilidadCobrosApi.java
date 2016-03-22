package es.pfsgroup.plugin.recovery.liquidaciones.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;
import es.pfsgroup.plugin.recovery.liquidaciones.model.ContabilidadCobros;

/**
 * Interfaz que define los metodos del DAO de Contabilidad Cobros.
 * 
 * @author Kevin
 * 
 */
public interface ContabilidadCobrosApi {

	public static final String BO_GET_LISTADO_CONTABILIDAD_COBROS = "es.pfsgroup.plugin.recovery.liquidaciones.api.getListadoContabilidadCobros";
	public static final String BO_GET_CONTABILIDAD_COBRO_BY_ID = "es.pfsgroup.plugin.recovery.liquidaciones.api.getContabilidadCobroByID";

	@BusinessOperationDefinition(BO_GET_LISTADO_CONTABILIDAD_COBROS)
	List<ContabilidadCobros> getListadoContabilidadCobros(DtoContabilidadCobros dto);
	
	@BusinessOperationDefinition(BO_GET_CONTABILIDAD_COBRO_BY_ID)
	ContabilidadCobros getContabilidadCobroByID(DtoContabilidadCobros dto);
}