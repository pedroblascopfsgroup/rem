package es.pfsgroup.recovery.panelcontrol.letrados.vistas.columnaTareaExp.dao.impl;

import java.util.List;


import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.columnaTareaExp.dao.PCColumnaTareaExpDao;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.columnaTareaExp.model.PCColumnaTareaExp;

@Repository
public class PCColumnaTareaExpDaoImpl extends AbstractEntityDao<PCColumnaTareaExp, Long> implements PCColumnaTareaExpDao {

	@Override
	public List<PCColumnaTareaExp> getColumns(String tipo) {
		HQLBuilder b = new HQLBuilder("from PCColumnaTareaExp col");
		b.appendWhere(" col.formulario = '"+ tipo +"'");
		b.orderBy("col.orden", HQLBuilder.ORDER_ASC);

		return HibernateQueryUtils.list(this, b);
	}

	@Override
	public Integer getNumeroColumns(String tipo) {

		StringBuffer query = new StringBuffer();
		query.append("select count(col.header) from PCColumnaTareaExp col ");

		query.append(" where col.formulario = '"+ tipo + "'");

		Integer total =  (Integer) getSession().createQuery(query.toString()).uniqueResult();

		return total;
	}

}
