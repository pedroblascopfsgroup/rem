package es.pfsgroup.plugin.rem.oferta.dao;


import java.math.BigDecimal;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
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
	
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter);

	public Long getNextNumOfertaRem();
	
	public List<Oferta> getListaOfertas(OfertaDto ofertaDto);

	/**
	 * Este método obtiene automaticamente el importe cálculo para los honorarios según la
	 * oferta y el tipo comisión.
	 * 
	 * @param id : ID de la oferta.
	 * @param tipoComision: Especifica la letra para el tipo de cálculo. 'C' para colaboración
	 * y 'P' para tipo prescripción.
	 * @return Devuelve el porcentaje si está asignado o null si no se aplican honorarios.
	 */
	public BigDecimal getImporteCalculo(Long idOferta, String tipoComision);

}
