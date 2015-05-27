package es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.dao.ResolucionesCategoriasDao;
import es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.model.ResolucionesCategorias;

@Repository
public class ResolucionesCategoriasDaoImpl extends AbstractEntityDao<ResolucionesCategorias, Long> implements ResolucionesCategoriasDao{

	@Override
	public List<ResolucionesCategorias> getResolucionesPendientes(Long idUsuario) {
		HQLBuilder hb = new HQLBuilder(" from ResolucionesCategorias ");
		HQLBuilder.addFiltroIgualQue(hb, "usuario", idUsuario);
		//HQLBuilder.addFiltroLikeSiNotNull(hb, "id", cat, true);
		return HibernateQueryUtils.list(this,hb);
	}
}