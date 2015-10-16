package es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoAmbitoActuacion;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoAmbitoActuacionDao;

@Repository("ADMDespachoAmbitoActuacionDao")
public class ADMDespachoAmbitoActuacionDaoImpl extends
		AbstractEntityDao<DespachoAmbitoActuacion, Long> implements
		ADMDespachoAmbitoActuacionDao {

	@Override
	public List<DespachoAmbitoActuacion> getAmbitoGeograficoDespacho(Long idDespachoExterno) {
		Assertions.assertNotNull(idDespachoExterno, "idDespachoExterno: No puede ser NULL");
		HQLBuilder b = new HQLBuilder("from DespachoAmbitoActuacion d");
		b.appendWhere(Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(b, "d.despacho.id", idDespachoExterno);
		return HibernateQueryUtils.list(this, b);
	}

}
