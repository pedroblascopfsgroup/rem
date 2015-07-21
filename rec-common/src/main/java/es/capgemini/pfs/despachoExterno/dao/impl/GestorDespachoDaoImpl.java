package es.capgemini.pfs.despachoExterno.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

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
}
