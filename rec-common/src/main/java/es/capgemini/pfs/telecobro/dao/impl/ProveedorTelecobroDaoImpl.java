package es.capgemini.pfs.telecobro.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.telecobro.dao.ProveedorTelecobroDao;
import es.capgemini.pfs.telecobro.model.ProveedorTelecobro;

/**
 * Clase que implementa ProveedorTelecobroDao.
 * @author aesteban
 *
 */
@Repository("ProveedorTelecobroDao")
public class ProveedorTelecobroDaoImpl extends AbstractEntityDao<ProveedorTelecobro, Long> implements ProveedorTelecobroDao {

}
