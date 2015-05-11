package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api.RecobroDetalleFacturacionDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroDetalleFacturacion;

@Repository("RecobroDetalleFacturacionDao")
public class RecobroDetalleFacturacionDaoImpl extends AbstractEntityDao<RecobroDetalleFacturacion, Long> implements RecobroDetalleFacturacionDao {

	@Override
	public void vaciarRecobroDetalleFacturacion() {
		StringBuilder sb = new StringBuilder("delete from RecobroDetalleFacturacion");
		
		getSession().createQuery(sb.toString()).executeUpdate();
	}

}
