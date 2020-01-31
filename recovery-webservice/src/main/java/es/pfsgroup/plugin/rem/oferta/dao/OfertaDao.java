package es.pfsgroup.plugin.rem.oferta.dao;


import java.math.BigDecimal;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;


public interface OfertaDao extends AbstractDao<Oferta, Long>{
	
	/* Nombre que le damos al trabajo buscado en la HQL */
	public static final String NAME_OF_ENTITY = "eco";

	/**
	 * Devuelve una página de textos de una oferta por id de oferta
	 * @param dto con datos paginación
	 * @param id de expediente
	 * @return
	 */
	public Page getListTextosOfertaById(DtoTextosOferta dto, Long id);
	
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter, Usuario usuarioGestor, Usuario usuarioGestoria);
	
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter);
	
	/**
	 * Devuelve un listado de ofertas por usuario gestoría, filtrando por número de activo.
	 * 
	 * @param dtoOfertasFilter Este filtro debe incluir el número de activo y el id de usuario gestoría. 
	 * @return
	 */
	DtoPage getListOfertasGestoria(DtoOfertasFilter dtoOfertasFilter);

	public Long getNextNumOfertaRem();
	
	public List<Oferta> getListaOfertas(OfertaDto ofertaDto);

	/**
	 * Este método obtiene automaticamente el importe cálculo para los honorarios según la
	 * oferta, el activo y el tipo de comisión.
	 * 
	 * @param idOferta : ID de la oferta.
	 * @param tipoComision: Especifica la letra para el tipo de cálculo. 'C' para colaboración
	 * y 'P' para tipo prescripción.
	 * @param idActivo ID del activo
	 * @param idProveedor ID del proveedor correspondiente
	 * @return Devuelve el porcentaje si está asignado o null si no se aplican honorarios.
	 */
	public BigDecimal getImporteCalculo(Long idOferta, String tipoComision, Long idActivo, Long idProveedor);

	public void deleteTitularesAdicionales(Oferta oferta);
	
	/**
	 * Obtiene una oferta dado su idWebcom
	 * @param idWebcom
	 * @return
	 */
	public Oferta getOfertaByIdwebcom(Long idWebcom);
	
	/**
	 * Obtiene la oferta por su id rem
	 * @param idRem
	 * @return
	 */
	public Oferta getOfertaByIdRem(Long idRem);

	/**
	 * Este método obtiene automaticamente el importe cálculo para los honorarios según la
	 * oferta de alquiler, el activo y el tipo de comisión.
	 *
	 * @param idOferta : ID de la oferta.
	 * @param tipoComision: Especifica la letra para el tipo de cálculo. 'C' para colaboración
	 * y 'P' para tipo prescripción.
	 * @param idActivo ID del activo
	 * @param idProveedor ID del proveedor correspondiente
	 * @return Devuelve el porcentaje si está asignado o null si no se aplican honorarios.
	 **/
	public BigDecimal getImporteCalculoAlquiler(Long idOferta, String tipoComision, Long idProveedor);

	public List<Oferta> getListOtrasOfertasVivasAgr(Long idOferta, Long idAgr);
	
	public void flush();
	
	public Oferta getOfertaPrincipal(Long numOferta);

	/**
	 * Devuelve una lista de ofertas CES
	 * 
	 * @param dtoOfertasFilter
	 * @return DtoPage
	 */
	DtoPage getListOfertasCES(DtoOfertasFilter dtoOfertasFilter);

	public Boolean tieneTareaActiva(String tarea, String numOferta);

	Boolean tieneTareaActivaOrFinalizada(String tarea, String numOferta);
	
}
