package es.capgemini.pfs.bien.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.bien.dao.BienDao;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Implementacion de BienDao.
 *
 */
@Repository("BienDao")
public class BienDaoImpl extends AbstractEntityDao<Bien, Long> implements BienDao {

}
