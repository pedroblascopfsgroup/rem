package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoExportarDetalleDictarInstruccionesHistorico;

/**
 * Interfaz para el Manager de exportación de las operaciones del historico de procedimientos
 * @author Guillem
 *
 */
public interface ExportarHistoricoOperacionesManagerApi {

	public final static String HISTORICO_OPERACIONES_MANAGER_EXPORTAR_DICTARINSTRUCCIONES_HISTORICO = "plugin.agendaMultifuncion.historicooperaciones.manager.exportar.dictarinstrucciones";	
	
	/**
	 * Exporta la ventana de detalle de la operacion de dictar instrucciones del historico de un procedimiento
	 * @param Object[]
	 * @return
	 */
	@BusinessOperationDefinition(HISTORICO_OPERACIONES_MANAGER_EXPORTAR_DICTARINSTRUCCIONES_HISTORICO)
	public DtoExportarDetalleDictarInstruccionesHistorico exportaOperacionDictarInstruccionesHistorico(Long id);
	
}
