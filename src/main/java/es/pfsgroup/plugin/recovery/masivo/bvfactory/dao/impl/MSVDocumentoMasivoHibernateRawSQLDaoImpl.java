package es.pfsgroup.plugin.recovery.masivo.bvfactory.dao.impl;

import java.util.Properties;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.dao.MSVDocumentoMasivoRawSQLDao;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.dao.SessionFactoryFacade;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;

@Repository
public class MSVDocumentoMasivoHibernateRawSQLDaoImpl extends AbstractEntityDao<MSVDocumentoMasivo, Long> implements MSVDocumentoMasivoRawSQLDao {

	@Resource
	private Properties appProperties;

	@Autowired
	private SessionFactoryFacade sesionFactoryFacade;

	@Override
	public int getCount(String sqlQuery) {
		StringBuilder builder = new StringBuilder("select count(*) from (");
		builder.append(sqlQuery);
		builder.append(")");

		Query query = this.sesionFactoryFacade.getSession(this).createSQLQuery(builder.toString().replaceAll("\\$\\{master.schema\\}", getMasterSchema()));

		Object result = query.uniqueResult();

		return Integer.parseInt(result.toString());
	}

	@Override
	public String getMasterSchema() {
		return appProperties.getProperty("master.schema");
	}

	@Override
	public int getExecuteSQL(String sqlValidacion) {
		if (Checks.esNulo(sqlValidacion)) {
			throw new IllegalArgumentException("'sqlValidacion' no puede ser NULL");
		}

		Query query = this.sesionFactoryFacade.getSession(this).createSQLQuery(sqlValidacion);

		Object result = query.uniqueResult();

		return Integer.parseInt(result.toString());
	}

}
