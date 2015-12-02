package es.pfsgroup.concursal.credito.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.concursal.credito.dao.DDEstadoCreditoDao;
import es.pfsgroup.concursal.credito.model.DDEstadoCredito;

@Repository("DDEstadoCreditoDao")
public class DDEstadoCreditoDaoImpl extends AbstractEntityDao<DDEstadoCredito, Long> implements DDEstadoCreditoDao{

}
