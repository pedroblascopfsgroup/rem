package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoCargas;

public interface ActivoCargasDao extends AbstractDao<ActivoCargas, Long>{
	
	/* Nombre que le damos al Activo buscado en la HQL */
	public static final String NAME_OF_ENTITY_ACT = "car";

	public Boolean esActivoConCargasNoCanceladas(Long idActivo);
	
	public Boolean esActivoConCargasNoCanceladasRegistral(Long idActivo);
	
	public Boolean esActivoConCargasNoCanceladasEconomica(Long idActivo);
}
