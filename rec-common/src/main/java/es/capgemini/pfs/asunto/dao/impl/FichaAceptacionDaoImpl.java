package es.capgemini.pfs.asunto.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dao.FichaAceptacionDao;
import es.capgemini.pfs.asunto.model.FichaAceptacion;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Implementación  del Dao de Estados de Asunto.
 * @author pamuller
 *
 */
@Repository("FichaAceptacionDao")
public class FichaAceptacionDaoImpl extends AbstractEntityDao<FichaAceptacion, Long> implements FichaAceptacionDao {

}
