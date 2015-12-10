package es.capgemini.devon.stubs.hibernate.events.defered.dao;

import java.util.Date;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.events.defered.DeferedEvent;
import es.capgemini.devon.events.defered.DeferedEventDao;
import es.capgemini.devon.stubs.hibernate.dao.StubAbstractHibernateDao;

/**
 * @author Nicolás Cornaglia
 */
@Repository("DeferedEventDao")
public class StubDeferedEventDaoImpl extends StubAbstractHibernateDao<DeferedEvent, Long> implements DeferedEventDao {

    /**
     * @see es.capgemini.pfs.jobs.DeferedEventDao#findChannelsByName(java.lang.String)
     */
    @Override
    public List<DeferedEvent> findJobsToExecuteByName(String channelName, Date before) throws DataAccessException {
        return null;
    }

}
