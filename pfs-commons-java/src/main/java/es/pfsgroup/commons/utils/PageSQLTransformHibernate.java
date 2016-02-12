package es.pfsgroup.commons.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.PaginationParams;

public class PageSQLTransformHibernate extends PageTransformHibernate {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@SuppressWarnings("rawtypes")
	private Class clazz;

	@SuppressWarnings("rawtypes")
	public PageSQLTransformHibernate(String queryString,
			Class clazz) {
		this(queryString, new WebDto(), null, clazz);
	}	
	
	@SuppressWarnings("rawtypes")
	public PageSQLTransformHibernate(String queryString,
			PaginationParams paginationParams, HashMap params, Class clazz) {
		super(queryString, paginationParams, params, clazz);
		
		this.clazz = clazz;
	}
	
	@SuppressWarnings("rawtypes")
	@Override
    public Object doInHibernate(Session session) throws HibernateException {
        String queryStr = creaQuery();

        Query q = session.createSQLQuery("SELECT COUNT(*) FROM (" + queryStr + ")");
        List count = q.list();
        setTotalCount(Integer.parseInt(count.get(0).toString()));
        if (getTotalCount() > 0) {
            Query query = session.createSQLQuery(queryStr);
            query.setFirstResult(getStart());
            query.setMaxResults(getResultsPerPage());
            query.setResultTransformer(Transformers.aliasToBean(clazz)); //Transforma el resultado en un Dto

            this.results = query.list();
        } 
        else {
            this.results = new ArrayList<Object>();
        }
        
        return this.results;
    }
}
