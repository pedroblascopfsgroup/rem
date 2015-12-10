package es.capgemini.devon.hibernate.pagination;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.engine.SessionFactoryImplementor;
import org.hibernate.hql.ParameterTranslations;
import org.hibernate.hql.QueryTranslator;
import org.hibernate.hql.QueryTranslatorFactory;
import org.hibernate.hql.ast.ASTQueryTranslatorFactory;
import org.springframework.orm.hibernate3.HibernateCallback;

import es.capgemini.devon.pagination.PageImpl;
import es.capgemini.devon.pagination.PaginationParams;

public class PageHibernate extends PageImpl implements HibernateCallback {

    private static final long serialVersionUID = 1L;

    HashMap<String, Object> parameters = new HashMap<String, Object>();

    public PageHibernate() {
    }

    public PageHibernate(String queryString, PaginationParams paginationParams) {
        if (paginationParams.getLimit() > 0) {
            this.setResultsPerPage(paginationParams.getLimit());
        }
        this.setQueryString(queryString);
        this.setStart(paginationParams.getStart());
        this.setDir(paginationParams.getDir());
        this.setSort(paginationParams.getSort());
    }

    public PageHibernate(String queryString, PaginationParams paginationParams, HashMap<String, Object> parameters) {
        if (paginationParams.getLimit() > 0) {
            this.setResultsPerPage(paginationParams.getLimit());
        }
        this.setQueryString(queryString);
        this.setStart(paginationParams.getStart());
        this.setDir(paginationParams.getDir());
        this.setSort(paginationParams.getSort());
        this.parameters = parameters;
    }

    public Object doInHibernate(Session session) throws HibernateException {

        String queryStr = creaQuery();

        Query q = session.createSQLQuery("SELECT COUNT(*) FROM (" + hqlToSql(queryStr, session) + ")");
        setParameters(q);
        List<?> count = q.list();
        this.setTotalCount(Integer.parseInt(count.get(0).toString()));
        
        if(this.getTotalCount()>0){
            Query query = session.createQuery(queryStr);
            setParameters(query);
            query.setFirstResult(getStart());
            query.setMaxResults(getResultsPerPage());

            List<?> results = this.results = query.list();
        }else{
            results=new ArrayList();
        }
        return results;
    }
    
    protected String hqlToSql(String hqlQueryText, Session session) {
        if (hqlQueryText != null && hqlQueryText.trim().length() > 0) {
            final QueryTranslatorFactory translatorFactory = new ASTQueryTranslatorFactory();
            final SessionFactoryImplementor factory = (SessionFactoryImplementor) session.getSessionFactory();
            final QueryTranslator translator = translatorFactory.createQueryTranslator(hqlQueryText, hqlQueryText, Collections.EMPTY_MAP, factory);
            translator.compile(Collections.EMPTY_MAP, false);
            return convertSQLParameters(translator.getSQLString(), translator.getParameterTranslations());
        }
        return null;
    }
    
  

    /**
     * Este método sirve para recuperar un SQL en String y sustituir los '?' por los nombres de los parametros originales para generar un PreparedStatement
     * @param query
     * @param pt
     * @return
     */
    protected String convertSQLParameters(String query, ParameterTranslations pt) {
        if (parameters == null || parameters.size() == 0) { return query; }

        int contador = 0;
        while (StringUtils.contains(query, '?')) {
            query = StringUtils.replaceOnce(query, "?", ":" + contador);
            contador++;
        }

        for (String key : parameters.keySet()) {

            int locations[] = pt.getNamedParameterSqlLocations(key);
            for (int location : locations) {
                query = StringUtils.replaceOnce(query, ":" + location, ":" + key);
            }
        }

        return query;
    }

    protected void setParameters(Query query) {
        if (parameters == null) { return; }
        for (String key : parameters.keySet()) {
            Object param = parameters.get(key);
            query.setParameter(key, param);
        }
    }

    protected String creaQuery() {
        if (this.getSort() == null || this.getQueryString().toUpperCase().indexOf("ORDER BY") > 0) {
            //no tenemos paginación
            return this.getQueryString();
        }
        String order = this.getDir() != null ? this.getDir() : "ASC";

        return this.getQueryString() + " order by " + this.getSort() + " " + order;

    }
}