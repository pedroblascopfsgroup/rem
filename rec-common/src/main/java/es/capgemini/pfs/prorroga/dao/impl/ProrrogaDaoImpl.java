package es.capgemini.pfs.prorroga.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.prorroga.dao.ProrrogaDao;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Interfaz dao para las prorrogas.
 * @author pamuller
 *
 */
@Repository("ProrrogaDao")
public class ProrrogaDaoImpl extends AbstractEntityDao<Prorroga, Long> implements ProrrogaDao {
    @Autowired
    private TareaNotificacionDao tareaNotificacionDao;

    /**
     * Obtiene la decision asociada a una solicitud de prorroga.
     * @param idTareaOriginal Long
     * @return Prorroga
     */
    @Override
    public Prorroga obtenerDecisionProrroga(Long idTareaOriginal) {
        TareaNotificacion tn = tareaNotificacionDao.get(idTareaOriginal);
        return tn.getProrroga();

    }

}
