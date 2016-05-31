package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.util.Collection;
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
	 * Recupera un esquema de turnado por su ID
	 * 
	 * @param id
	 * @return
	 */
	EsquemaTurnadoProcurador save(EsquemaTurnadoDto dto);

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
	 * Elimina un esquema
	 * 
	 * @param id
	 */
	void delete(Long id);

	/**
	 * Copia un esquema
	 * 
	 * @param id
	 */
	void copy(Long id);

	/**
	 * Comprueba si un esquema se puede o no activar.
	 * 
	 * @param id
	 *            Id del esquema
	 * @return True si se puede activar el esquema/false en caso contrario
	 */
	boolean checkActivarEsquema(Long id);

	/**
	 * Limpia el turnado de todos los despachos activos.
	 * 
	 * @param id
	 */
	void limpiarTurnadoTodosLosDespachos(Long id);

	/**
	 * Comprueba si el procurador asignado automÃ¡ticamente por el turnado de
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
	 * Devuelve una lista con las plazas disponibles
	 * @return listaPlazas
	 */
	List<TipoPlaza> getPlazasEsquemaTurnadoProcu();
	
	/**
	 * Devuelve una lista con las tipos de procedimientos disponibles
	 * @return listaTPO
	 */
	List<TipoProcedimiento> getTPOsEsquemaTurnadoProcu();

	Collection<? extends TipoPlaza> getPlazas(String query);
	
	Collection<? extends TipoProcedimiento> getTPOs(String query);
	
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
	 * Devuelve todos los rangos configurados para un esquema:
	 * - Si idPlaza = null && idTPO = null -> todos los rangos configurados para el esquema
	 * - Si solo idTPO = null -> solo los rangos 
	 * @param idEsquema
	 * @param idPlaza
	 * @param idTPO
	 * @return
	 */
	List<EsquemaPlazasTpo> getRangosGrid(Long idEsquema, Long idPlaza, Long idTPO);
	
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
	 * Añadir una configuracion plaza-tpo nueva a un esquema de turnado de procuradores
	 * @param idEsquema
	 * @param codTpo
	 * @param arrayPlazas
	 * @return 
	 */
	List<Long> añadirNuevoTpoAPlazas(Long idEsquema, String codTpo, String[] arrayPlazas);
	
	/**
	 * Borra todas las configuraciones plaza-tpo relacionadas con el tpo o plaza recibido
	 * @param idEsquema
	 * @param plazaCod
	 * @param tpoCod
	 * @param arrayPlazas
	 * @return 
	 */
	List<Long> borrarConfigParaPlazaOTpo(Long idEsquema, String plazaCod, String tpoCod, String[] arrayPlazas);

	/**
	 * Comprueba si ya existe una configuracion para un esquema y una plaza dadas
	 * @param idEsquema
	 * @param plazaCod
	 * @return
	 */
	Boolean checkSiPlazaYaTieneConfiguracion(Long idEsquema, String plazaCod);
	
}
