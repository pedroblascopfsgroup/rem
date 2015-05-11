package es.pfsgroup.procedimientos.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.procedimientos.dto.DtoQuery;

public interface TipoPlazaDao extends AbstractDao<TipoPlaza, Long> {

	/**
	 * Busca plazas que contengan la subcaden especificada en la descripción. No
	 * distingue mayúsculas de minúsculas
	 * 
	 * @param dto DTO con la cadena de búsqueda. Soporta paginación
	 * @return
	 */
	public Page buscarPorDescripcion(DtoQuery dto);
	
	public List<TipoPlaza> getListOrderedByDescripcion();
}
