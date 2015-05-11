package es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import jxl.StringFormulaCell;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;

import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.PaginationParams;

public class PageTransformHibernateFAKE extends PageHibernate {

    private static final long serialVersionUID = 1L;
    private Class clazz;

    @SuppressWarnings({ "unchecked", "rawtypes" })
	public PageTransformHibernateFAKE(String queryString, PaginationParams paginationParams, HashMap params, Class clazz) {
        super(queryString, paginationParams, params);
        this.clazz = clazz;
    }

    @Override
    public Object doInHibernate(Session session) throws HibernateException {
        String queryStr = creaQuery();

      String query1 = queryStr;
      query1 = query1.replaceAll("^(.*?) order by.*?$", "$1");
      query1 = String.format("SELECT COUNT(*) FROM (%s)", hqlToSql(query1, session));
      Query q = session.createSQLQuery(query1);
      setParameters(q);
      BigDecimal count = (BigDecimal)q.uniqueResult();
      setTotalCount(count.intValue());
      if (getTotalCount() > 0) {
          Query query = session.createQuery(queryStr);
          setParameters(query);
          query.setFirstResult(getStart());
          query.setMaxResults(getResultsPerPage());
          query.setResultTransformer(Transformers.aliasToBean(clazz)); //Transforma el resultado en un Dto
          this.results = query.list();
       } else {
           this.results = new ArrayList<Object>();
       }
      return this.results;
    }
    
}