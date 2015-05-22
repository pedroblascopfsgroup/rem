package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.recobroCommon.core.model.RecobroAdjuntos;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api.RecobroAdjuntosDao;

@Repository("RecobroAdjuntosDao")
public class RecobroAdjuntosDaoImpl extends AbstractEntityDao<RecobroAdjuntos, Long> implements RecobroAdjuntosDao {

}
