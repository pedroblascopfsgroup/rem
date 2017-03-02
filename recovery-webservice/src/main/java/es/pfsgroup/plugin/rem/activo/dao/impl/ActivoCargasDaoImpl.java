package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoCargasDao;
import es.pfsgroup.plugin.rem.model.ActivoCargas;

@Repository("activoCargasDao")
public class ActivoCargasDaoImpl extends AbstractEntityDao<ActivoCargas, Long> implements ActivoCargasDao{

	@Resource
	private PaginationManager paginationManager;
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public Boolean esActivoConCargasNoCanceladas(Long idActivo) {

		HQLBuilder hb = new HQLBuilder(" from ActivoCargas ac");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ac.activo.id", idActivo);
		hb.appendWhere("ac.fechaCancelacionRegistral IS NULL");
		
		List<ActivoCargas> lista = HibernateQueryUtils.list(this, hb);
		
		return !Checks.estaVacio(lista);
	}

}
