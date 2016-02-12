package es.pfsgroup.plugin.recovery.procuradores.procurador.api;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.RelacionProcuradorProcedimientoDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorProcedimiento;

public interface RelacionProcuradorProcedimientoApi {

	
	public static final String PLUGIN_PROCURADORES_PROCEDIMIENTO_GUARDAR_RELACION = "plugin.procuradores.procurador.guardarRelacionCategorias";
	public static final String PLUGIN_PROCURADORES_PROCEDIMIENTO_GET_PROCURADOR = "plugin.procuradores.procurador.getProcurador";
	
	
	/**
	 * Guarda los datos de la {@link RelacionProcuradorProcedimiento}
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_PROCEDIMIENTO_GUARDAR_RELACION)
	public RelacionProcuradorProcedimiento guardarRelacionProcuradorProcedimiento(RelacionProcuradorProcedimientoDto dto) throws BusinessOperationException;
	
	
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_PROCEDIMIENTO_GET_PROCURADOR)
	public Procurador getProcurador(Long idProcedimiento);

	
}
