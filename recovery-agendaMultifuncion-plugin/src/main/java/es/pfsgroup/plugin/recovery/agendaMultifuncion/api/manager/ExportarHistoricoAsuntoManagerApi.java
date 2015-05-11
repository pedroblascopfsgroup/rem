package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoExportarDetalleAnotacionHistorico;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoExportarDetalleCorreoHistorico;

/**
 * Interfaz para el Manager de exportación de las anotaciones y correos del histórico de asuntos
 * @author Guillem
 *
 */
public interface ExportarHistoricoAsuntoManagerApi {

	public final static String HISTORICO_ASUNTOS_MANAGER_EXPORTAR_DETALLE_CORREO_HISTORICO = "plugin.agendaMultifuncion.historicoasuntos.manager.exportar.detallecorreohistorio";
	public final static String HISTORICO_ASUNTOS_MANAGER_EXPORTAR_DETALLE_ANOTACION_HISTORICO = "plugin.agendaMultifuncion.historicoasuntos.manager.exportar.detalleanotacionhistorio";
	
	/**
	 * Exporta la ventana de detalle de los correos del historico
	 * @param dtoExportarDetalleCorreoHistorico
	 * @return
	 */
	@BusinessOperationDefinition(HISTORICO_ASUNTOS_MANAGER_EXPORTAR_DETALLE_CORREO_HISTORICO)
	public DtoExportarDetalleCorreoHistorico exportaDetalleCorreoHistorico(DtoExportarDetalleCorreoHistorico dtoExportarDetalleCorreoHistorico);

	/**
	 * Exporta la ventana de detalle de las anotaciones del historico
	 * @param dtoExportarDetalleAnotacionHistorico
	 * @return
	 */
	@BusinessOperationDefinition(HISTORICO_ASUNTOS_MANAGER_EXPORTAR_DETALLE_ANOTACION_HISTORICO)
	public DtoExportarDetalleAnotacionHistorico exportaDetalleAnotacionHistorico(DtoExportarDetalleAnotacionHistorico dtoExportarDetalleAnotacionHistorico);
	
}
