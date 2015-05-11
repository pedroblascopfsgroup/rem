package es.capgemini.pfs.recurso.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.recurso.model.DDActor;

/**
 * poner javadoc FO.
 * @author FO.
 *
 */
public interface DDActorDao extends AbstractDao<DDActor, Long> {
    
    List<DDActor> getList();
    
    Long save(DDActor ddActor);
}
