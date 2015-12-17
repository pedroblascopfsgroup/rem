package es.capgemini.devon.hibernate.pagination;

import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.orm.hibernate3.HibernateTemplate;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;

@Service
public class PaginationManager {

    @Resource
    Properties appProperties;

    public Page getHibernatePage(HibernateTemplate template, String queryString, PaginationParams paginationParams, HashMap params) {

        if (paginationParams.getLimit() == Page.LIMIT_NOT_DEFINED) {
            paginationParams.setLimit(Integer.parseInt(appProperties.getProperty("pagination.limit")));
        }
        PageHibernate page = new PageHibernate(queryString, paginationParams, params);

        template.executeFind(page);
        return page;
    }

    public Page getHibernatePage(HibernateTemplate template, String queryString, PaginationParams paginationParams) {

        if (paginationParams.getLimit() == Page.LIMIT_NOT_DEFINED) {
            paginationParams.setLimit(Integer.parseInt(appProperties.getProperty("pagination.limit")));
        }
        PageHibernate page = new PageHibernate(queryString, paginationParams);

        template.executeFind(page);
        return page;
    }
}
