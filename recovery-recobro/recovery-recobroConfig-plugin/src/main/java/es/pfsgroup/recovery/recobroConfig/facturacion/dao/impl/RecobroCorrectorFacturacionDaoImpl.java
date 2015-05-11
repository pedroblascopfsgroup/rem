package es.pfsgroup.recovery.recobroConfig.facturacion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroCorrectorFacturacion;
import es.pfsgroup.recovery.recobroConfig.facturacion.dao.api.RecobroCorrectorFacturacionDao;

@Repository("RecobroCorrectorFacturacionDao")
public class RecobroCorrectorFacturacionDaoImpl extends AbstractEntityDao<RecobroCorrectorFacturacion, Long> implements RecobroCorrectorFacturacionDao{

}
