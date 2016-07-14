package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.util.HashMap;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;

public interface EsquemaTurnadoProcuradorDao extends AbstractDao<EsquemaTurnadoProcurador, Long> {
	
	/**
	 * Recupera el esquema de turnado activo
	 * 
	 * @return Esquema activo vigente
	 */
	EsquemaTurnadoProcurador getEsquemaVigente();
	
	/**
	 * Buscar esquemas de turnado paginados.
	 * 
	 * @param dto con los filtros de búsqueda
	 * 
	 * @return
	 */
	Page buscarEsquemasTurnado(EsquemaTurnadoBusquedaDto dto, Usuario usuLogado);
	
	/**
	 * Buscar en el historico de turnados.
	 * 
	 * @param dto con los filtros de búsqueda
	 * 
	 * @return
	 */
	Page buscarDetalleHistorico(TurnadoHistoricoDto dto, Usuario usuLogado);
	
	/**
	 * Asigna un despacho al asunto pasado como parámetro teniendo en cuenta la configuración del esquema de turnado vigente
	 * 
	 * @param prcId
	 * @param plaza TODO
	 * @param tpo TODO
	 */
	void turnarProcurador(Long prcId, String username, String plaza, String tpo);

	/**
	 * Cuenta los letrados que hay asignados a estos tipos de turnado.
	 * 
	 * @param codigosCI
	 * @param codigosCC
	 * @param codigosLI
	 * @param codigosLC
	 * @return
	 */
	int cuentaLetradosAsignados(List<String> codigosCI, List<String> codigosCC, List<String> codigosLI, List<String> codigosLC);
	
	/**
	 * Limpia el turnado de todos los despachos activos.
	 * 
	 */
	void limpiarTurnadoTodosLosDespachos();
	
	List<TipoPlaza> getPlazas(String query);

	List<TipoPlaza> getPlazasEquema(Long idEsquema);

	List<TipoProcedimiento> getTiposProcedimientoPorPlazaEsquema(Long idEsquema, Long idPlaza);
	
	List<Usuario> getDespachosProcuradores(List<String> despachosValidos);
	
	/**
	 * Borra fisicamente toda la configuracion asociada a una lista de plazas-tpos dados sus ids
	 * @param idsPlazasTpo
	 * @param plazaCod
	 */
	void borradoFisicoConfigPlazaTPO(List<Long> idsPlazasTpo);
	
	/**
	 * Dado un rango de configuracion devuelve todos los relacionados con este
	 * @param config
	 * @param listIdsPlazaTpo 
	 * @return
	 */
	List<TurnadoProcuradorConfig> dameListaRangosRelacionados(TurnadoProcuradorConfig config, List<Long> listIdsPlazaTpo);
	
	/**
	 * Devuelve todos los ids de las tuplas de TUP_EPT_ESQUEMA_PLAZAS_TPO que pertenezcan a la plaza especificada con el idPlaza
	 * @param idPlaza
	 * @param idEsquema 
	 * @return
	 */
	List<Long> getIdsEPTPorIdPlaza(Long idPlaza, Long idEsquema);
	
	/**
	 * Devuelve todos los ids de las tuplas de TUP_EPT_ESQUEMA_PLAZAS_TPO que pertenezcan a las plazas especificada con el idTPO
	 * @param idTpo
	 * @param idsPlazas
	 * @param idEsquema 
	 * @return
	 */
	List<Long> getIdsEPTPorIdTPO(Long idTpo, Long[] idsPlazas, Long idEsquema);
	
	/**
	 * Borra todos los rangos de los ids que recibe en la lista
	 * @param listIdsRC
	 */
	void borrarRangosFisico(List<Long> listIdsRC);

	List<TurnadoHistorico> buscarDetalleHistoricoConFiltro(TurnadoHistoricoDto filter);
	
}
