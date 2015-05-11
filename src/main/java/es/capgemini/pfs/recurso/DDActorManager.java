package es.capgemini.pfs.recurso;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.recurso.dao.DDActorDao;
import es.capgemini.pfs.recurso.model.DDActor;

/**
 * PONER JAVADOC FO.
 * @author FO
 *
 */
@Service
public class DDActorManager {

    @Autowired
    private DDActorDao dao;

    @BusinessOperation(ExternaBusinessOperation.BO_ACTOR_MGR_GET_LIST)
    public List<DDActor> getList() {
        return dao.getList();
    }
    
    @BusinessOperation(ExternaBusinessOperation.BO_ACTOR_MGR_SAVE)
    public long save(DDActor ddActor) {
        return dao.save(ddActor);
    }



}
