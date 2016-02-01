package es.capgemini.devon.hibernate;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.hibernate.SessionFactory;
import org.hibernate.cache.Cache;
import org.hibernate.impl.SessionFactoryImpl;
import org.hibernate.stat.Statistics;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.FwkBusinessOperations;
import es.capgemini.devon.bo.annotations.BusinessOperation;

@Service
@ManagedResource("type=HibernateManager")
public class HibernateManager {

    @Autowired(required = false)
    @Qualifier("monitoredSessionFactory1")
    private SessionFactory sessionFactory1;

    @Autowired(required = false)
    @Qualifier("monitoredSessionFactory2")
    private SessionFactory sessionFactory2;

    private List<Object> generateStatistics(Statistics stats) {
        List<Object> dataList = new ArrayList<Object>();

        List<String> data = null;

        data = new ArrayList<String>();
        data.add("SecondLevelCacheHitCount");
        data.add(String.valueOf(stats.getSecondLevelCacheHitCount()));
        dataList.add(data);

        data = new ArrayList<String>();
        data.add("SecondLevelCacheMissCount");
        data.add(String.valueOf(stats.getSecondLevelCacheMissCount()));
        dataList.add(data);

        data = new ArrayList<String>();
        data.add("SecondLevelCachePutCount");
        data.add(String.valueOf(stats.getSecondLevelCachePutCount()));
        dataList.add(data);

        data = new ArrayList<String>();
        data.add("ConnectCount");
        data.add(String.valueOf(stats.getConnectCount()));
        dataList.add(data);

        data = new ArrayList<String>();
        data.add("QueryCacheHitCount");
        data.add(String.valueOf(stats.getQueryCacheHitCount()));
        dataList.add(data);

        data = new ArrayList<String>();
        data.add("QueryCacheMissCount");
        data.add(String.valueOf(stats.getQueryCacheMissCount()));
        dataList.add(data);

        data = new ArrayList<String>();
        data.add("QueryCachePutCount");
        data.add(String.valueOf(stats.getQueryCachePutCount()));
        dataList.add(data);

        return dataList;

    }

    @ManagedOperation
    @BusinessOperation(FwkBusinessOperations.HIBERNATE_GET_STATISTICS1)
    public List<Object> getStatistics1() {
        return generateStatistics(sessionFactory1.getStatistics());
    }

    @ManagedOperation
    @BusinessOperation(FwkBusinessOperations.HIBERNATE_GET_STATISTICS2)
    public List<Object> getStatistics2() {
        return generateStatistics(sessionFactory2.getStatistics());
    }

    @BusinessOperation
    public void enableStatistics1() {
        sessionFactory1.getStatistics().setStatisticsEnabled(true);
    }

    @BusinessOperation
    public void enableStatistics2() {
        sessionFactory2.getStatistics().setStatisticsEnabled(true);
    }

    @BusinessOperation
    public void disableStatistics1() {
        sessionFactory1.getStatistics().setStatisticsEnabled(false);
    }

    @BusinessOperation
    public void disableStatistics2() {
        sessionFactory2.getStatistics().setStatisticsEnabled(false);
    }

    @BusinessOperation(FwkBusinessOperations.HIBERNATE_CHANGE_STATISTICS_MODE1)
    public void changeStatisticsMode1() {
        sessionFactory1.getStatistics().setStatisticsEnabled(!sessionFactory1.getStatistics().isStatisticsEnabled());
    }

    @BusinessOperation(FwkBusinessOperations.HIBERNATE_CHANGE_STATISTICS_MODE2)
    public void changeStatisticsMode2() {
        sessionFactory2.getStatistics().setStatisticsEnabled(!sessionFactory2.getStatistics().isStatisticsEnabled());
    }

    @BusinessOperation(FwkBusinessOperations.HIBERNATE_CLEAR_SESSION1)
    public void clearSession1() {
        SessionFactoryUtils.getSession(sessionFactory1, true).flush();
        SessionFactoryUtils.getSession(sessionFactory1, true).clear();
    }

    @BusinessOperation(FwkBusinessOperations.HIBERNATE_CLEAR_SESSION2)
    public void clearSession2() {
        SessionFactoryUtils.getSession(sessionFactory2, true).flush();
        SessionFactoryUtils.getSession(sessionFactory2, true).clear();
    }

    /**
    * Performs the actual disabling of the Hibernate second-level cache.
    */
    @SuppressWarnings("unchecked")
    protected void disableSecondLevelCache1() {
        SessionFactoryImpl sessionFactoryImpl = (SessionFactoryImpl) sessionFactory1;
        Map cacheRegionsMap = sessionFactoryImpl.getAllSecondLevelCacheRegions();
        Collection<Cache> cacheRegions = cacheRegionsMap.values();
        for (Cache cache : cacheRegions) {
            cache.clear();
        }
    }

    @SuppressWarnings("unchecked")
    protected void disableSecondLevelCache2() {
        SessionFactoryImpl sessionFactoryImpl = (SessionFactoryImpl) sessionFactory2;
        Map cacheRegionsMap = sessionFactoryImpl.getAllSecondLevelCacheRegions();
        Collection<Cache> cacheRegions = cacheRegionsMap.values();
        for (Cache cache : cacheRegions) {
            cache.clear();
        }
    }
}
