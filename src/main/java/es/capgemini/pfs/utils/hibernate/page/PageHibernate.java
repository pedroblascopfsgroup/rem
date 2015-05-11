package es.capgemini.pfs.utils.hibernate.page;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;

import es.capgemini.devon.pagination.PaginationParams;

public class PageHibernate extends es.capgemini.devon.hibernate.pagination.PageHibernate {

    private static final long serialVersionUID = 1L;
    
    private final Log logger = LogFactory.getLog(getClass());

    HashMap<String, Object> parameters = new HashMap<String, Object>();
    
    public PageHibernate(String queryString, PaginationParams paginationParams) {
        super(queryString,paginationParams);
    }

    public PageHibernate(String queryString, PaginationParams paginationParams, HashMap<String, Object> parameters) {
         super(queryString,paginationParams,parameters);
    }

    public final Object doInHibernate(Session session) throws HibernateException {
       try{
        String queryStr = creaQuery();
        HQLOptimized hqlO=new HQLOptimized(queryStr);
        
        if(hqlO.canOptimize()){
            Query q = session.createSQLQuery(hqlToSql(hqlO.getOptimizedHQL(), session));
            setParameters(q);
            List<BigDecimal> idList=q.list();
            this.setTotalCount(idList.size());
            if(idList.size()>=getStart()+getResultsPerPage())
                idList=idList.subList(getStart(), getStart()+getResultsPerPage());
            else
                idList=idList.subList(getStart(),idList.size());
            
            List<Object> resultsObj=new ArrayList<Object>(idList.size());
            for (BigDecimal objId : idList) {
                Query qObj = session.createQuery("from "+hqlO.getObjectHibernate()+" obj where obj.id = "+objId);
                resultsObj.add(qObj.list().get(0));
            }
            results=resultsObj;
            return results;
        }
       }catch(Exception ex){
           logger.debug("ERROR optimizing hibernate query. Runing default",ex);
           
       }
       return super.doInHibernate(session);
    }
   
}