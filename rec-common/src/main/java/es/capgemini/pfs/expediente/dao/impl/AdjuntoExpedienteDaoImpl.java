package es.capgemini.pfs.expediente.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.AdjuntoExpedienteDao;
import es.capgemini.pfs.expediente.model.AdjuntoExpediente;

/**
 * Implementación del dao de adjuntos.
 *
 * @author Nicolás Cornaglia
 */
@Repository("AdjuntoExpedienteDao")
public class AdjuntoExpedienteDaoImpl extends AbstractEntityDao<AdjuntoExpediente, Long> implements AdjuntoExpedienteDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<AdjuntoExpediente> getAdjuntoExpedienteByIdNombreTipoDocumento(Long idExpediente, String nombre, String tipoDocumento) {
		StringBuffer hql = new StringBuffer();
		hql.append(" select aa from AdjuntoExpediente aa where aa.auditoria.borrado = false and aa.expediente.id = ");
		hql.append(idExpediente);
		hql.append(" and aa.nombre like '");
		hql.append(nombre);
		hql.append("%'");
		hql.append(" and aa.tipoAdjuntoEntidad.codigo = '");
		hql.append(tipoDocumento);
		hql.append("'");
		return getSession().createQuery(hql.toString()).list();
	}
	
	
	
}
