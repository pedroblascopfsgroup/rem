package es.capgemini.devon.hibernate.events.defered.dao;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.SessionFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.events.defered.DeferedEvent;
import es.capgemini.devon.events.defered.DeferedEventDao;
import es.capgemini.devon.hibernate.dao.AbstractHibernateDao;

/**
 * @author Nicolás Cornaglia
 */
@Repository("DeferedEventDao")
public class HibernateDeferedEventDao extends AbstractHibernateDao<DeferedEvent, Long> implements DeferedEventDao {

    private static final String FIND_JOBS_TO_EXECUTE_BY_NAME = "from HibernateDeferedEvent j where j.state='N' and j.queue like ? and j.willProcess <= ? order by j.arrived ASC";

    @Resource
    public void setMasterSessionFactory(SessionFactory masterSessionFactory) {
        super.setSessionFactory(masterSessionFactory);
    }

    /**
     * @see es.capgemini.pfs.jobs.DeferedEventDao#findChannelsByName(java.lang.String)
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DeferedEvent> findJobsToExecuteByName(String channelName, Date before) throws DataAccessException {
        String channelNameToFind = ((channelName != null) ? channelName : "") + "%";
        return (getHibernateTemplate().find(FIND_JOBS_TO_EXECUTE_BY_NAME, new Object[] { channelNameToFind,
                new Date(new Date().getTime() + 1000 * 60 * 60) }));
    }

}
