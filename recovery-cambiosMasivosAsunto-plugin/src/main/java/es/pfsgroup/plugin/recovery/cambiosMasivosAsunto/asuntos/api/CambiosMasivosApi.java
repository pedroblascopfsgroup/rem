package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.dto.CambioMasivoGestoresPorAsuntosDtoImpl;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.PeticionCambioMasivoGestoresDto;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.model.PeticionCambioMasivoGestoresAsunto;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;

public interface CambiosMasivosApi {

	/**
     * Recupera el historico de cambios de gestor para un asunto dado
     * @param idAsunto Long
     * @return Pagina de resultados
     */
    @BusinessOperationDefinition("CambiosMasivosManager.getCambiosGestoresHistorico")
	public List<? extends MEJRegistroInfo> getCambiosGestoresHistoricoPaginados(Long idAsunto);

	/**
     * Recupera la lista de cambios de gestor pendientes de aplicar al asunto
     * @param idAsunto Long
     * @return Pagina de resultados
     */
    @BusinessOperationDefinition("CambiosMasivosManager.getCambiosGestoresPendientes")
	public List<PeticionCambioMasivoGestoresAsunto> getCambiosGestoresPendientesPaginados(Long idAsunto);

	/**
	 * Anota en BBDD una petici�n de cambio masivo de gestores de un asunto para
	 * su posterior proceso en el batch
	 * 
	 * @param dto
	 */
	@BusinessOperationDefinition("CambiosMasivosManager.anotarCambiosPendientesPorAsuntos")
	void anotarCambiosPendientesPorAsuntos(CambioMasivoGestoresPorAsuntosDtoImpl dto);
}
