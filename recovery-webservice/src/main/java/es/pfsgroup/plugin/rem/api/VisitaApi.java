package es.pfsgroup.plugin.rem.api;

import java.util.List;
import java.util.Map;

import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;

public interface VisitaApi {
	
	
	/**
     * Devuelve una Visita por id.
     * @param id de la Visita a consultar
     * @return Visita
     */
    public Visita getVisitaById(Long id);
    
	/**
     * Devuelve una Visita por idVisitaWebcom.
     * @param idVisitaWebcom a consultar
     * @return Visita
     */
    public Visita getVisitaByIdVisitaWebcom(Long idVisitaWebcom) ;
    
    
	/**
     * Devuelve una Visita por numVisitaRem
     * @param numVisitaRem a consultar
     * @return Visita
     */
    public Visita getVisitaByNumVisitaRem(Long numVisitaRem);
    
    /**
     * Devuelve una Visita por idVisitaWebcom y numVisitaRem.
     * @param idVisitaWebcom a consultar
     * @param numVisitaRem a consultar
     * @return Visita
     */
    public Visita getVisitaByIdVisitaWebcomNumVisitaRem(Long idVisitaWebcom, Long numVisitaRem) throws Exception;
       
    /**
	 * Devuelve un Page de Visitas aplicando el filtro que recibe.
	 * @param dtoVisitasFilter con los parametros de filtro
	 * @return Page<Visita> 
	 */
    public DtoPage getListVisitas(DtoVisitasFilter dtoVisitasFilter);
    
	/**
	 * Devuelve una lista de Visitas aplicando el filtro que recibe.
	 * @param visitaDto con los parametros de filtro
	 * @return List<Visita> 
	 */
	public List<Visita> getListaVisitas(VisitaDto visitaDto);
	
	
	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de las peticiones POST.
	 * @param VisitaDto con los parametros de entrada
	 * @param jsonFields estructura de parámetros para validar campos en caso de venir informados
	 * @param alta true si es para validar el alta, false para validar la actualización
	 * @return List<String> 
	 */
	public List<String> validateVisitaPostRequestData(VisitaDto visitaDto,  Object jsonFields, Boolean alta);

	
	/**
	 * Crea una nueva Visita a partir de la información pasada por parámetro.
	 * @param visitaDto con la información de la Visita a dar de alta
	 * @return List<String> con la lista de errores detectados
	 */
	public List<String> saveVisita(VisitaDto visitaDto);
	
	
	/**
	 * Actualiza una Visita a partir de la información pasada por parámetro.
	 * @param visitaDto con la información de la Visita a actualizar
	 * @param jsonFields estructura de parámetros a actualizar. Si no vienen, no hay que actualizar. Si vienen y están a null, hay que seterlos a null
	 * @return List<String> con la lista de errores detectados
	 */
	public List<String> updateVisita(Visita visita, VisitaDto visitaDto, Object jsonFields);
	
	
	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de las peticiones DELETE.
	 * @param visitaDto con los parametros de entrada
	 * @return List<String> 
	 */
	public List<String> validateVisitaDeleteRequestData(VisitaDto visitaDto);
	
	/**
	 * Elimina una Visita a partir de los datos pasados por parámetro.
	 * @param visitaDto con la información de la Visita a borrar
	 * @return List<String> con la lista de errores detectados
	 */
	public List<String> deleteVisita(VisitaDto visitaDto);
	
	
	

}
