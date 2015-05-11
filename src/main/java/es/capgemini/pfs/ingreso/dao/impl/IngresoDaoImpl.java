package es.capgemini.pfs.ingreso.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.ingreso.dao.IngresoDao;
import es.capgemini.pfs.ingreso.model.Ingreso;

/**
 * @author Mariano Ruiz
 */
@Repository("IngresoDao")
public class IngresoDaoImpl extends AbstractEntityDao<Ingreso, Long> implements IngresoDao {

}
