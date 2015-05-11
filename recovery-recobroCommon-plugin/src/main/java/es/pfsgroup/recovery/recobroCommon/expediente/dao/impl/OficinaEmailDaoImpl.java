package es.pfsgroup.recovery.recobroCommon.expediente.dao.impl;

import java.math.BigDecimal;

import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.oficina.model.Oficina;
import es.pfsgroup.recovery.recobroCommon.expediente.dao.OficinaEmailDao;

@Repository("OficinaEmailDao")
public class OficinaEmailDaoImpl extends AbstractEntityDao<Oficina, Long>
		implements OficinaEmailDao {

	@Override
	public String obtenerEmailOficina(Long id) {

		String sql = "SELECT OFI_CORREO_ELECTRONICO FROM ${entity.schema}.OFI_OFICINAS WHERE OFI_ID = " + id;
		return  (String) getSession().createSQLQuery(sql).uniqueResult();
		
	}

}
