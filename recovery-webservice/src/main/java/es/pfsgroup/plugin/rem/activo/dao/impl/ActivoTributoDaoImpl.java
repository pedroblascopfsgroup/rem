package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTributoDao;
import es.pfsgroup.plugin.rem.model.ActivoTributos;

@Repository("ActivoTributoDao")
public class ActivoTributoDaoImpl extends AbstractEntityDao<ActivoTributos, Long> implements ActivoTributoDao {

	private static final String REST_USER_USERNAME = "REST-USER";

	@Override
	public Long getNumMaxTributo() {
		try {
			String sql = "SELECT MAX(ACT_NUM_TRIBUTO) FROM ACT_TRI_TRIBUTOS";
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
		}catch (Exception e){
			e.printStackTrace();
			return (long) 0;
		}
		
	}

}
