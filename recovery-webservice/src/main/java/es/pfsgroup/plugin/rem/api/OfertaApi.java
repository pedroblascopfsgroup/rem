package es.pfsgroup.plugin.rem.api;

import java.util.HashMap;
import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;

public interface OfertaApi {

	/**
	 * Devuelve una Oferta por id.
	 * 
	 * @param id
	 *            de la Oferta a consultar
	 * @return Oferta
	 */
	public Oferta getOfertaById(Long id);

	/**
	 * Devuelve una Oferta por idOfertaWebcom.
	 * 
	 * @param idOfertaWebcom
	 *            a consultar
	 * @return Oferta
	 */
	public Oferta getOfertaByIdOfertaWebcom(Long idOfertaWebcom);

	/**
	 * Devuelve una Oferta por numOfertaRem
	 * 
	 * @param numOfertaRem
	 *            a consultar
	 * @return Oferta
	 */
	public Oferta getOfertaByNumOfertaRem(Long numOfertaRem);

	/**
	 * Devuelve una Oferta por idOfertaWebcom y numOfertaRem.
	 * 
	 * @param idOfertaWebcom
	 *            a consultar
	 * @param numOfertaRem
	 *            a consultar
	 * @return Oferta
	 */
	public Oferta getOfertaByIdOfertaWebcomNumOfertaRem(Long idOfertaWebcom, Long numOfertaRem) throws Exception;

	/**
	 * Devuelve un Page de Ofertas aplicando el filtro que recibe.
	 * 
	 * @param dtoOfertasFilter
	 *            con los parametros de filtro
	 * @return Page<Oferta>
	 */
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter);

	/**
	 * Devuelve una lista de Ofertas aplicando el filtro que recibe.
	 * 
	 * @param ofertaDto
	 *            con los parametros de filtro
	 * @return List<Oferta>
	 */
	public List<Oferta> getListaOfertas(OfertaDto ofertaDto);

	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de
	 * las peticiones POST.
	 * 
	 * @param OfertaDto
	 *            con los parametros de entrada
	 * @param jsonFields
	 *            estructura de parámetros para validar campos en caso de venir
	 *            informados
	 * @param alta
	 *            true si es para validar el alta, false para validar la
	 *            actualización
	 * @return List<String>
	 */
	public HashMap<String, List<String>> validateOfertaPostRequestData(OfertaDto ofertaDto, Object jsonFields,
			Boolean alta) throws Exception;

	/**
	 * Crea una nueva Oferta a partir de la información pasada por parámetro.
	 * 
	 * @param ofertaDto
	 *            con la información de la Oferta a dar de alta
	 * @return List<String> con la lista de errores detectados
	 */
	public HashMap<String, List<String>> saveOferta(OfertaDto ofertaDto) throws Exception;

	/**
	 * Actualiza una Oferta a partir de la información pasada por parámetro.
	 * 
	 * @param ofertaDto
	 *            con la información de la Oferta a actualizar
	 * @param jsonFields
	 *            estructura con los parámetros a actualizar. Si no vienen, no
	 *            hay que actualizar. Si vienen y están a null, hay que seterlos
	 *            a null
	 * @return List<String> con la lista de errores detectados
	 */
	public HashMap<String, List<String>> updateOferta(Oferta oferta, OfertaDto ofertaDto, Object jsonFields)
			throws Exception;

	/**
	 * Actualizar el estado de disponibilidad comercial en los activos
	 * 
	 * @param oferta
	 */
	public void updateStateDispComercialActivosByOferta(Oferta oferta);

	/**
	 * Método que obtiene uno de los estados posibles de la oferta relacionado
	 * con una determinado código
	 * 
	 * @param codigo
	 * @return
	 */
	public DDEstadoOferta getDDEstadosOfertaByCodigo(String codigo);

	/**
	 * Método que saca la oferta a partir de una tarea externa
	 * 
	 * @param tareaExterna
	 * @return Oferta
	 */
	public Oferta tareaExternaToOferta(TareaExterna tareaExterna);

	/**
	 * Método que obtiene la oferta aceptada de un activo en caso de haberla.
	 * 
	 * @param activo
	 * @return Oferta
	 */
	public Oferta getOfertaAceptadaByActivo(Activo activo);

	/**
	 * Método que comprueba si un activo tiene reserva.
	 * 
	 * @param tareaExterna
	 * @return true si tiene reserva, false si no la tiene.
	 */
	public boolean checkReserva(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo tiene derecho de tanteo por la
	 * Generalitat
	 * 
	 * @param tareaExterna
	 * @return true si tiene derecho de tanteo, false si lo tiene
	 */
	public boolean checkDerechoTanteo(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si la oferta viene de una oferta de tanteo de la
	 * Generalitat
	 * 
	 * @param tareaExterna
	 * @return true si viene, false si es nueva
	 */
	public boolean checkDeDerechoTanteo(TareaExterna tareaExterna);

	
	/**
	 * Método que comprueba si el activo tiene riesgo reputacional
	 * @param tareaExterna
	 * @return
	 */
	public boolean checkSinRiesgoReputacional(TareaExterna tareaExterna);
	
	

}
