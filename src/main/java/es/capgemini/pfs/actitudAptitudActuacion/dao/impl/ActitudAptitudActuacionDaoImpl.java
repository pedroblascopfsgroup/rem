package es.capgemini.pfs.actitudAptitudActuacion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.actitudAptitudActuacion.dao.ActitudAptitudActuacionDao;
import es.capgemini.pfs.actitudAptitudActuacion.model.ActitudAptitudActuacion;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase que implementa los métodos de la interfaz ActitudAptitudActuacionDao.
 * @author mtorrado
 *
 */

@Repository("ActitudAptitudActuacionDao")
public class ActitudAptitudActuacionDaoImpl extends AbstractEntityDao<ActitudAptitudActuacion, Long> implements ActitudAptitudActuacionDao {

}
