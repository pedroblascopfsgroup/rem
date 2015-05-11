package es.capgemini.pfs.zona.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.zona.dao.NivelDao;
import es.capgemini.pfs.zona.model.Nivel;

/**
 * Implementación del dao de subtipos de tareas.
 * @author pamuller
 *
 */
@Repository("NivelDao")
public class NivelDaoImpl extends AbstractEntityDao<Nivel, Long> implements NivelDao{


}
