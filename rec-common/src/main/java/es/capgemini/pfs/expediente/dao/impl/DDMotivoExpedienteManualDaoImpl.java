package es.capgemini.pfs.expediente.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.DDMotivoExpedienteManualDao;
import es.capgemini.pfs.expediente.model.DDMotivoExpedienteManual;

/**
 * Clase que agrupa m�todo para la creaci�n y acceso de datos de los
 * contratos del expedientes.
 *
 * @author jbosnjak
 */
@Repository("DDMotivoExpedienteManualDao")
public class DDMotivoExpedienteManualDaoImpl extends AbstractEntityDao<DDMotivoExpedienteManual, Long> implements DDMotivoExpedienteManualDao {

	/**
	 * Devuelve un tipo de estado expediente por su código.
	 * @param codigo el codigo
	 * @return el estado expediente.
	 */
	@SuppressWarnings("unchecked")
    public DDMotivoExpedienteManual getByCodigo(String codigo){
		String hql = "from DDMotivoExpedienteManual where codigo = ?";
		List<DDMotivoExpedienteManual> lista = getHibernateTemplate().find(hql, new Object[] { codigo });
		if (lista.size()>0){
			return lista.get(0);
		}
		return null;
	}
}
