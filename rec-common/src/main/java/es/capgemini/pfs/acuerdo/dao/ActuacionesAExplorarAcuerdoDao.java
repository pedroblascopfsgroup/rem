package es.capgemini.pfs.acuerdo.dao;

import java.util.List;

import es.capgemini.devon.hibernate.dao.HibernateDao;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;

/**
 * @author maruiz
 *
 */
public interface ActuacionesAExplorarAcuerdoDao extends HibernateDao<ActuacionesAExplorarAcuerdo, Long> {

    /**
     * @param idAcuerdo Long
     * @return List ActuacionesAExplorarAcuerdo
     */
    List<ActuacionesAExplorarAcuerdo> getActuacionesAExplorarMarcadasByAcuerdo(Long idAcuerdo);

    /**
     * Retorna todos los subtipos en los que el acuerdo tiene una actuación
     * y todos los subtipos que al menos esten activos (tambien el tipo del subtipo).
     * @param idAcuerdo Long
     * @return List DDSubtipoSolucionAmistosaAcuerdo
     */
    List<DDSubtipoSolucionAmistosaAcuerdo> getSubtiposActivosOMarcadosByAcuerdo(Long idAcuerdo);
}
