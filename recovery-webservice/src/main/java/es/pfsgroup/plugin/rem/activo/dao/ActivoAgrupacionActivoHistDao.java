package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivoHistorico;

public interface ActivoAgrupacionActivoHistDao extends AbstractDao<ActivoAgrupacionActivoHistorico, Long>{
	
	/* Nombre que le damos al Agrupacion buscado en la HQL */
	public static final String NAME_OF_ENTITY_ACT = "act";

	ActivoAgrupacionActivoHistorico getHistoricoAgrupacionByActivoAndAgrupacion(long idActivo, long idAgrupacion);

}
