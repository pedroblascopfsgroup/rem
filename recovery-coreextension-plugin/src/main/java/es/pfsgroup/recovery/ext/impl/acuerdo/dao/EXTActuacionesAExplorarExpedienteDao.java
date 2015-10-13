package es.pfsgroup.recovery.ext.impl.acuerdo.dao;

import java.util.List;

import es.capgemini.devon.hibernate.dao.HibernateDao;
import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesAExplorarExpediente;

/**
 * @author maruiz
 *
 */
public interface EXTActuacionesAExplorarExpedienteDao extends HibernateDao<EXTActuacionesAExplorarExpediente, Long> {

    /**
     * @param idAcuerdo Long
     * @return List ActuacionesAExplorarAcuerdo
     */
    List<EXTActuacionesAExplorarExpediente> getActuacionesAExplorarMarcadasByExpediente(Long idExpediente);

    /**
     * Retorna todos los subtipos en los que el acuerdo tiene una actuación
     * y todos los subtipos que al menos esten activos (tambien el tipo del subtipo).
     * @param idAcuerdo Long
     * @return List DDSubtipoSolucionAmistosaAcuerdo
     */
    List<DDSubtipoSolucionAmistosaAcuerdo> getSubtiposActivosOMarcadosByExpediente(Long idExpediente);
}
