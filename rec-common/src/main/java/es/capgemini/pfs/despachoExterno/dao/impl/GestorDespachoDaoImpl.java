package es.capgemini.pfs.despachoExterno.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

/**
 * Implementación del dao de GestorDespacho.
 * @author pamuller
 *
 */
@Repository("GestorDespachoDao")
public class GestorDespachoDaoImpl extends AbstractEntityDao<GestorDespacho,Long> implements GestorDespachoDao{

	@Override
	public GestorDespacho getGestorDespachoPorUsuarioyDespacho(Long usuarioId, Long despachoId) {
		Criteria query = getSession().createCriteria(GestorDespacho.class);

		query.createAlias("usuario", "usuario");
		query.createAlias("despachoExterno", "despachoExterno");

		query.add(Restrictions.eq("usuario.id", usuarioId));
		query.add(Restrictions.eq("despachoExterno.id", despachoId));

		List<GestorDespacho> gestorDespachoList = query.list();

		GestorDespacho gestorDespacho = null;
		if (gestorDespachoList.size() > 0) {
			gestorDespacho = gestorDespachoList.get(0);
		}

		return gestorDespacho;
	}

	@Override
	public List<GestorDespacho> getGestorDespachoByUsuId(Long usuId) {
		Criteria query = getSession().createCriteria(GestorDespacho.class);

		query.createAlias("usuario", "usuario");
		query.add(Restrictions.eq("usuario.id", usuId));
		
		query.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		
		List<GestorDespacho> gestorDespachoList = query.list();

		return gestorDespachoList;
	}

	@Override
	public List<GestorDespacho> getGestorDespachoByUsuIdAndTipoDespacho(Long usuId, String tipoDespachoExterno) {
		Criteria query = getSession().createCriteria(GestorDespacho.class);

		query.createAlias("usuario", "usuario");
		query.createAlias("despachoExterno", "despachoExterno");
		query.createAlias("despachoExterno.tipoDespacho", "tipoDespacho");

		query.add(Restrictions.eq("usuario.id", usuId));
		query.add(Restrictions.eq("tipoDespacho.codigo", tipoDespachoExterno));

		query.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);

		List<GestorDespacho> gestorDespachoList = query.list();

		return gestorDespachoList;
	}
}
