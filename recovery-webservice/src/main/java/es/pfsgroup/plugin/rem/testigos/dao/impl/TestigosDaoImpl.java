package es.pfsgroup.plugin.rem.testigos.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.TestigosObligatorios;
import es.pfsgroup.plugin.rem.testigos.dao.TestigosDao;

@Repository("TestigosDao")
public class TestigosDaoImpl extends AbstractEntityDao<TestigosObligatorios, Long> implements TestigosDao {
	
	@Override
	public List<TestigosObligatorios> getTestigosList() {

		HQLBuilder hb = new HQLBuilder("from TestigosObligatorios tob");
		hb.appendWhere("tob.auditoria.borrado = 0 ");

		List<TestigosObligatorios> lista = HibernateQueryUtils.list(this, hb);

		return lista;
	}
	
	@Override
	public void deleteTestigoById(Long id) {

		StringBuilder sb = new StringBuilder("delete from TestigosObligatorios tob where tob.id = " + id);
		this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();

	}

}
