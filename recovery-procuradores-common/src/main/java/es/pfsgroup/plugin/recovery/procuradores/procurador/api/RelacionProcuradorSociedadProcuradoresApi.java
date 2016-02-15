package es.pfsgroup.plugin.recovery.procuradores.procurador.api;

import java.util.List;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.RelacionProcuradorSociedadProcuradoresDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorProcedimiento;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorSociedadProcuradores;

public interface RelacionProcuradorSociedadProcuradoresApi {

	
	public static final String PLUGIN_PROCURADORES_SOCIEDADPROCURADORES_GUARDAR_RELACION = "plugin.procuradores.procurador.guardarRelacionProcuradorSociedadProcuradores";
	public static final String PLUGIN_PROCURADORES_SOCIEDADPROCURADORES_GET_RELACION_DEL_PROCURADOR = "plugin.procuradores.procurador.getRelacionProcuradorSociedadProcuradoresDelProcurador";
	public static final String PLUGIN_PROCURADORES_SOCIEDADPROCURADORES_GET_RELACION_DE_LA_SOCIEDAD = "plugin.procuradores.procurador.getRelacionProcuradorSociedadProcuradoresDeLaSociedad";
	
	
	/**
	 * Guarda los datos de la {@link RelacionProcuradorProcedimiento}
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_SOCIEDADPROCURADORES_GUARDAR_RELACION)
	public RelacionProcuradorSociedadProcuradores guardarRelacionProcuradorSociedadProcuradores(RelacionProcuradorSociedadProcuradoresDto dto) throws BusinessOperationException;
	
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_SOCIEDADPROCURADORES_GET_RELACION_DEL_PROCURADOR)
	public List<RelacionProcuradorSociedadProcuradores> getRelacionProcuradorSociedadProcuradoresDelProcurador(Long idProcurador);
	
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_SOCIEDADPROCURADORES_GET_RELACION_DE_LA_SOCIEDAD)
	public List<RelacionProcuradorSociedadProcuradores> getRelacionProcuradorSociedadProcuradoresDeLaSociedad(Long idSociedad, String nombreProcurador);

	
}
