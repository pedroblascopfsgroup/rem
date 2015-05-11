package es.pfsgroup.concursal.credito.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.concursal.credito.dao.DDTipoCreditoDao;
import es.pfsgroup.concursal.credito.model.DDTipoCredito;

@Repository("DDTipoCreditoDao")
public class DDTipoCreditoDaoImpl extends AbstractEntityDao<DDTipoCredito, Long> implements DDTipoCreditoDao{

}
