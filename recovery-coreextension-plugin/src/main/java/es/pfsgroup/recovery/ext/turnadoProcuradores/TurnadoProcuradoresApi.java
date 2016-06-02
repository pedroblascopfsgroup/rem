package es.pfsgroup.recovery.ext.turnadoProcuradores;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.recovery.ext.turnadodespachos.AplicarTurnadoException;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;

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
}
