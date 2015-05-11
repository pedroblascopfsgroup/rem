package es.capgemini.pfs.comite;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comite.dao.DecisionComiteDao;
import es.capgemini.pfs.comite.model.DecisionComite;
import es.capgemini.pfs.interna.InternaBusinessOperation;

/**
 * @author Andrés Esteban
 *
 */
@Service
public class DecisionComiteManager {

   @Autowired
   private DecisionComiteDao decisionComiteDao;

   /**
    * Retorna la SesionComite que corresponde al id indicado.
    * @param id arquetipo id
    * @return arquetipo
    */
   @BusinessOperation(InternaBusinessOperation.BO_DECISIONN_COMITE_GET)
   public DecisionComite get(Long id) {
      return decisionComiteDao.get(id);
   }

   /**
    * save.
    * @param dc Decision del comite
    * @return id
    */
   @BusinessOperation(InternaBusinessOperation.BO_DECISIONN_COMITE_MRG_SAVE)
   public Long save(DecisionComite dc){
	   return decisionComiteDao.save(dc);
   }

   /**
    * save or update.
    * @param dc dc
    */
   @BusinessOperation(InternaBusinessOperation.BO_DECISIONN_COMITE_SAVE_OR_UPDATE)
   public void saveOrUpdate(DecisionComite dc){
	   decisionComiteDao.saveOrUpdate(dc);
   }
}
	