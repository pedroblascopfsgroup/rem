package es.capgemini.pfs.cobropago.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cobropago.dao.DDEstadoCobroPagoDao;
import es.capgemini.pfs.cobropago.model.DDEstadoCobroPago;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Implementacion de DDEstadoCobroPagoDao.
 * @author: Lisandro Medrano
 */
@Repository("DDEstadoCobroPagoDao")
public class DDEstadoCobroPagoDaoImpl extends AbstractEntityDao<DDEstadoCobroPago, Long> implements DDEstadoCobroPagoDao {
}
