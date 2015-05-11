package es.capgemini.pfs.plazoTareasDefault.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.plazoTareasDefault.dao.EXTPlazoTareasDefaultDao;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;

@Repository("EXTPlazoTareasDefaultDao")
public class EXTPlazoTareasDefaultDaoImpl extends AbstractEntityDao<PlazoTareasDefault, Long> implements EXTPlazoTareasDefaultDao{

	@Override
	public PlazoTareasDefault buscaPlazoPorDescripcion(String descripcion) {
		HQLBuilder hb = new HQLBuilder("from PlazoTareasDefault p");
		
		hb.appendWhere("p.auditoria.borrado=false");
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "p.descripcion", descripcion,true);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
		
	}

}
