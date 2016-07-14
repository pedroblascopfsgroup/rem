package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.util.HashMap;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.turnadodespachos.AplicarTurnadoException;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoDto;

public interface TurnadoProcuradoresApi {

	/**
	 * Recupera un listado de esquemas de turnado. En el Dto se le pasan los
	 * posibles valores de filtro para el listado.
	 * 
	 * @param dto
	 *            Valores con los filtros
	 * @return
	 */
	Page listaEsquemasTurnado(EsquemaTurnadoBusquedaDto dto);
	
	/**
	 * Recupera un listado con el historico de turnados. En el Dto se le pasan los
	 * posibles valores de filtro para el listado.
	 * 
	 * @param dto
	 *            Valores con los filtros
	 * @return
	 */
	Page listaDetalleHistorico(TurnadoHistoricoDto dto);

	/**
	 * Recupera un esquema de turnado por su ID
	 * 
	 * @param id
	 * @return
	 */
	EsquemaTurnadoProcurador get(Long id);

	/**
	 * Recupera un esquema de turnado Vigente
	 * 
	 * @param id
	 * @return
	 */
	EsquemaTurnadoProcurador getEsquemaVigente();

	/**
	 * Indica si es o no modificable
	 * 
	 * @param esquema
	 * @return true modificable / false no modificable
	 */
	boolean isModificable(EsquemaTurnadoProcurador esquema);

	/**
	 * Activa el esquema de turnado.
	 * 
	 * @param idEsquema
	 *            Esquema que se necesita activar.
	 * 
	 * @throws ActivarEsquemaDeTurnadoException
	 */
	void activarEsquema(Long idEsquema);

	/**
	 * Asignar un letrado a un asunto.
	 * 
	 * @param idAsunto
	 * @param plaza TODO
	 * @param tpo TODO
	 */
	void turnarProcurador(Long idAsunto, String username, String plaza, String tpo) throws IllegalArgumentException, AplicarTurnadoException;

	/**
	 * Limpia el turnado de todos los despachos activos.
	 * 
	 * @param id
	 */
	void limpiarTurnadoTodosLosDespachos(Long id);

	/**
	 * Comprueba si el procurador asignado automáticamente por el turnado de
	 * procuradores, corresponde actualmente con el asignado en el propio asunto
	 * 
	 * @param prcId
	 * @return
	 */
	Boolean comprobarSiProcuradorHaSidoCambiado(Long prcId);

	/**
	 * Comprueba si el importe de la demanda o partido judicial han cambiado
	 * respecto lo rellenado en la propia tarea
	 * 
	 * @param prcId
	 * @return
	 */
	Boolean comprobarSiLosDatosHanSidoCambiados(Long prcId);
	
	/**
	 * Devuelve una lista con las tipos de procedimientos disponibles
	 * @return listaTPO
	 */
	List<TipoProcedimiento> getTPOsEsquemaTurnadoProcu();
	
	/**
	 * Devueve una lista de plazas segun la busqueda, junto a la plaza por defecto si procede (no existen ya plazas seleccionadas anteriormente)
	 * @param query
	 * @param otrasPlazasPresentes
	 * @param plazaDefectoPresente
	 * @return
	 */
	List<TipoPlaza> getPlazas(String query, Boolean otrasPlazasPresentes, Boolean plazaDefectoPresente);
	
	/**
	 * Devuelve las plazas configuradas para un esquema
	 * @param idEsquema
	 * @return
	 */
	List<TipoPlaza> getPlazasGrid(Long idEsquema);
	
	/**
	 * Devuelve los procedimientos configurados para un esquema:
	 * - Si idPlaza = null -> todos los procedimientos configurados para el esquema
	 * - Si idPlaza != null -> solo los procedimientos configurados para el esquema y la plaza dada
	 * @param idEsquema
	 * @param idPlaza
	 * @return
	 */
	List<TipoProcedimiento> getTPOsGrid(Long idEsquema, Long idPlaza);
	
	/**
	 * Devuelve todos las configuracion para un esquema:
	 * - Filtra en base a la lista de plazas y tpos que recibe como lista
	 * @param idEsquema
	 * @param idsPlazas
	 * @param idsTPOs
	 * @return
	 */
	List<EsquemaPlazasTpo> getRangosGrid(Long idEsquema, List<Long> idsPlazas, List<Long> idsTPOs);
	
	/**
	 * Devuelve una lista de usuarios que representan despachos de procuradorres
	 * @return
	 */
	List<Usuario> getDespachosProcuradores();
	
	/**
	 * Devuelve el esquema dado el id
	 * @param id
	 * @return EsquemaTurnadoProcurador
	 */
	EsquemaTurnadoProcurador getEsquemaById(Long id);
	
	/**
	 * A�adir una configuracion plaza-tpo nueva a un esquema de turnado de procuradores
	 * @param idEsquema
	 * @param idTpo
	 * @param arrayPlazas
	 * @return 
	 */
	List<Long> anyadirNuevoTpoAPlazas(Long idEsquema, Long idTpo, Long[] arrayPlazas);
	
	/**
	 * Borrado fisico de todas las configuraciones plaza-tpo relacionadas con el tpo o plaza recibido
	 * @param idEsquema
	 * @param idPlaza
	 * @param idTpo
	 * @param arrayPlazas
	 * @return 
	 */
	List<Long> borrarConfigParaPlazaOTpo(Long idEsquema, Long idPlaza, Long idTpo, Long[] arrayPlazas);
	
	void borrarConfigParaPlazaOTpo(List<Long> idsPlazaTpo);
	
	/**
	 * Comprueba si ya existe una configuracion para un esquema y una plaza dadas
	 * @param idEsquema
	 * @param idPlaza
	 * @return
	 */
	Boolean checkSiPlazaYaTieneConfiguracion(Long idEsquema, Long idPlaza);

	/**
	 * A�ade nuevo rango de configuracion al esquema
	 * @param idsplazasTpo
	 * @param idConf 
	 * @param impMin
	 * @param impMax
	 * @param arrayDespachos
	 * @return
	 * @throws Exception 
	 */
	List<Long> addRangoConfigEsquema(List<Long> idsplazasTpo, Long idConf, Double impMin, Double impMax,String[] arrayDespachos);

	/**
	 * Actualiza rangos
	 * @param idConf
	 * @param impMin
	 * @param impMax
	 * @param arrayDespachos
	 * @return
	 */
	HashMap<String, List<String>> updateRangoConfigEsquema(Long idConf, Double impMin, Double impMax,
			String[] arrayDespachos);
	
	/**
	 * Dado el id de un rango de configuracion, elimina logicamente esa entrada y todas las relacionadas
	 * @param idConfig
	 * @param listIdsPlazaTpo 
	 * @return
	 */
	List<Long> borrarRangoConfigEsquema(Long idConfig, List<Long> listIdsPlazaTpo);
	
	/**
	 * Borrado logico de todas las configuraciones plaza-tpo relacionadas con el tpo o plaza recibido
	 * @param idEsquema
	 * @param idPlaza
	 * @param idTpo
	 * @return 
	 */
	HashMap<String, List<Long>> borrarConfigParaPlazaOTpoLogico(Long idEsquema, Long idPlaza, Long idTpo);
	
	/**
	 * Devuelve lista de ids de los rangos relacionados con el dado
	 * @param idConfig
	 * @param listIdsPlazaTpo
	 * @return
	 */
	List<TurnadoProcuradorConfig> getIdsRangosRelacionados(Long idConfig, List<Long> listIdsPlazaTpo);
	
	/**
	 * Dada una lista de ids plaza-tpo,  cambia el borrado logico de true a false si procede
	 * @param listIdsTBC
	 */
	void reactivarPlazasTPO(List<Long> listIdsTBC);
	
	/**
	 * Dada una lista de ids de rangos,  cambia el borrado logico de true a false si procede
	 * @param listIdsTBC
	 */
	void reactivarRangos(List<Long> listIdsRBC);
	
	/**Dada una lista de ids de rangos, los elimina fisicamente de la base de datos
	 * @param listIdsRC
	 */
	void borrarRangosFisico(List<Long> listIdsRC);
	
	/**
	 * Dada una lista de string con el historico de valores de un rango de configuracion, lo devuelve a ese estado
	 * @param listModRangos
	 */
	void modificarRangosCancelacion(List<String> listModRangos);
	
	/**
	 * Dados un idEsquema y un idPlaza devuelve los tipos de procedimientos que aun estan disponibles de a�adir
	 * @param idEsquema
	 * @param idPlaza
	 * @return
	 */
	List<TipoProcedimiento> getTPODisponiblesByPlaza(Long idEsquema, Long idPlaza);

	boolean checkActivarEsquema(Long id);

	EsquemaTurnadoProcurador save(EsquemaTurnadoDto dto);

	void delete(Long id);

	void copy(Long id);
	
}
