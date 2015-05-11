package es.capgemini.pfs.acuerdo.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.AnalisisAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.AnalisisAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author marruiz
 *
 */
@Repository("AnalisisAcuerdoDao")
public class AnalisisAcuerdoDaoImpl extends AbstractEntityDao<AnalisisAcuerdo, Long> implements AnalisisAcuerdoDao {

}
