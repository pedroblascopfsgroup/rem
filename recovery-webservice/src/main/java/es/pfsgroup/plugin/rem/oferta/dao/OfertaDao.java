package es.pfsgroup.plugin.rem.oferta.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.Oferta;


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
		
	
	
}
