package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;

public interface OfertaApi {
	
	

	
	/**
     * Devuelve una Oferta por id.
     * @param id de la Oferta a consultar
     * @return Oferta
     */
    public Oferta getOfertaById(Long id);
    
	/**
     * Devuelve una Oferta por idOfertaWebcom.
     * @param idOfertaWebcom a consultar
     * @return Oferta
     */
    public Oferta getOfertaByIdOfertaWebcom(Long idOfertaWebcom) ;
    
    
	/**
     * Devuelve una Oferta por numOfertaRem
     * @param numOfertaRem a consultar
     * @return Oferta
     */
    public Oferta getOfertaByNumOfertaRem(Long numOfertaRem);
    
    /**
     * Devuelve una Oferta por idOfertaWebcom y numOfertaRem.
     * @param idOfertaWebcom a consultar
     * @param numOfertaRem a consultar
     * @return Oferta
     */
    public Oferta getOfertaByIdOfertaWebcomNumOfertaRem(Long idOfertaWebcom, Long numOfertaRem) throws Exception;
    
	 /**
	 * Devuelve un Page de Ofertas aplicando el filtro que recibe.
	 * @param dtoOfertasFilter con los parametros de filtro
	 * @return Page<Oferta> 
	 */
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter);
	
	/**
	 * Devuelve una lista de Ofertas aplicando el filtro que recibe.
	 * @param ofertaDto con los parametros de filtro
	 * @return List<Oferta> 
	 */
	public List<Oferta> getListaOfertas(OfertaDto ofertaDto);
	
	
	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de las peticiones POST.
	 * @param OfertaDto con los parametros de entrada
	 * @param jsonFields estructura de parámetros para validar campos en caso de venir informados
	 * @param alta true si es para validar el alta, false para validar la actualización
	 * @return List<String> 
	 */
	public List<String> validateOfertaPostRequestData(OfertaDto ofertaDto, Object jsonFields, Boolean alta);

	
	/**
	 * Crea una nueva Oferta a partir de la información pasada por parámetro.
	 * @param ofertaDto con la información de la Oferta a dar de alta
	 * @return List<String> con la lista de errores detectados
	 */
	public List<String> saveOferta(OfertaDto ofertaDto);
	
	
	/**
	 * Actualiza una Oferta a partir de la información pasada por parámetro.
	 * @param ofertaDto con la información de la Oferta a actualizar
	 * @param jsonFields estructura con los parámetros a actualizar. Si no vienen, no hay que actualizar. Si vienen y están a null, hay que seterlos a null
	 * @return List<String> con la lista de errores detectados
	 */
	public List<String> updateOferta(Oferta oferta, OfertaDto ofertaDto, Object jsonFields);
	
	
	/**
	 * Actualizar el estado de disponibilidad comercial en los activos
	 * @param oferta
	 */
	public void updateStateDispComercialActivosByOferta(Oferta oferta);

	/**
	 * Método que obtiene uno de los estados posibles de la oferta
	 * relacionado con una determinado código
	 * @param codigo
	 * @return
	 */	
	public DDEstadoOferta getDDEstadosOfertaByCodigo (String codigo);
	
	
// En caso de conflicto MERGE, quedarse con lo de Dani	
	public Oferta getOfertaAceptadaByActivo(Activo activo);
	
	public boolean checkDeDerechoTanteo(Long idActivo);
	
	public boolean checkReserva(Long idActivo);
	

}
