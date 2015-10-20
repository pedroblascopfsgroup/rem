package es.pfsgroup.recovery.ext.turnadodespachos;

import es.capgemini.devon.pagination.Page;


public interface TurnadoDespachosManager {

	/**
	 * Recupera un listado de esquemas de turnado.
	 * En el Dto se le pasan los posibles valores de filtro para el listado.
	 *  
	 * @param dto Valores con los filtros
	 * @return
	 */
	Page listaEsquemasTurnado(EsquemaTurnadoBusquedaDto dto);
	
	/**
	 * Recupera un esquema de turnado por su ID
	 * 
	 * @param id
	 * @return
	 */
	EsquemaTurnado get(Long id);

	/**
	 * Recupera un esquema de turnado Vigente
	 * 
	 * @param id
	 * @return
	 */
	EsquemaTurnado getEsquemaVigente();
	
	/**
	 * Recupera un esquema de turnado por su ID
	 * 
	 * @param id
	 * @return
	 */
	EsquemaTurnado save(EsquemaTurnadoDto dto);

	/**
	 * Indica si es o no modificable
	 * 
	 * @param esquema
	 * @return true modificable / false no modificable
	 */
	boolean isModificable(EsquemaTurnado esquema);
	
	/**
	 * Activa el esquema de turnado.
	 * 
	 * @param idEsquema Esquema que se necesita activar.
	 * 
	 * @throws ActivarEsquemaDeTurnadoException
	 */
	void activarEsquema(Long idEsquema) throws ActivarEsquemaDeTurnadoException;
	
	/**
	 * Asignar un letrado a un asunto.
	 * 
	 * @param idAsunto
	 */
	void turnar(Long idAsunto) throws AplicarTurnadoException;

	/**
	 * Elimina un esquema
	 * 
	 * @param id
	 */
	void delete(Long id);

	/**
	 * Copia un esquema
	 * @param id
	 */
	void copy(Long id);
	
}
