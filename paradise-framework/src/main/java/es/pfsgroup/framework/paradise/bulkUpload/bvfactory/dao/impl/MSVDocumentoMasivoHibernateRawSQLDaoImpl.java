package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.MSVDocumentoMasivoRawSQLDao;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;

@Repository
public class MSVDocumentoMasivoHibernateRawSQLDaoImpl extends AbstractEntityDao<MSVDocumentoMasivo, Long> implements MSVDocumentoMasivoRawSQLDao {

	@Resource
	private Properties appProperties;

	@Autowired
	private SessionFactoryFacade sesionFactoryFacade;
	
	private Map<String,Object> bindVariables;
	
	public void addParams(Map<String,Object> hashMap) {
		bindVariables = hashMap;
	}
	
	private Query parametize(Query query){
		if (bindVariables != null && !bindVariables.isEmpty()){
			for(Map.Entry<String, Object> entry : bindVariables.entrySet()) {
			   query.setParameter(entry.getKey(), entry.getValue());
			}
			bindVariables = null;
		}
		return query;
	}

	@Override
	public int getCount(String sqlQuery) {
		StringBuilder builder = new StringBuilder("select count(*) from (");
		builder.append(sqlQuery);
		builder.append(")");

		Query query = this.sesionFactoryFacade.getSession(this).createSQLQuery(builder.toString().replaceAll("\\$\\{master.schema\\}", getMasterSchema()));

		Object result = parametize(query).uniqueResult();

		return Integer.parseInt(result.toString());
	}

	@Override
	public String getMasterSchema() {
		return appProperties.getProperty("master.schema");
	}

	@Override
	public String getExecuteSQL(String sqlValidacion) {
		if (Checks.esNulo(sqlValidacion)) {
			throw new IllegalArgumentException("'sqlValidacion' no puede ser NULL");
		}

		Query query = this.sesionFactoryFacade.getSession(this).createSQLQuery(sqlValidacion);

		Object result = parametize(query).uniqueResult();

		if(Checks.esNulo(result)) return null;

		return result.toString();
	}

	@Override
	public Object[] getExecuteSQLArray(String sqlValidacion) {
		if (Checks.esNulo(sqlValidacion)) {
			throw new IllegalArgumentException("'sqlValidacion' no puede ser NULL");
		}

		Query query = this.sesionFactoryFacade.getSession(this).createSQLQuery(sqlValidacion);

		Object[] result = (Object[]) parametize(query).uniqueResult();

		return result;
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<Object> getExecuteSQLList(String sqlValidacion) {
		if (Checks.esNulo(sqlValidacion)) {
			throw new IllegalArgumentException("'sqlValidacion' no puede ser NULL");
		}

		Query query = this.sesionFactoryFacade.getSession(this).createSQLQuery(sqlValidacion);

		List<Object> result = (List<Object>) parametize(query).list();

		return result;
	}
}