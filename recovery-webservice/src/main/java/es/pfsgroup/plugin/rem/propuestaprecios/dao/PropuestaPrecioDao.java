package es.pfsgroup.plugin.rem.propuestaprecios.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;

public interface PropuestaPrecioDao extends AbstractDao<PropuestaPrecio, Long>{
	
	/* Nombre que le damos al Activo buscado en la HQL */
	public static final String NAME_OF_ENTITY_ACT = "prp";
	
	public Page getListPropuestasPrecio(DtoPropuestaFilter dto);

	public Long getNextNumPropuestaPrecio();
}
