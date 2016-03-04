package es.pfsgroup.recovery.ext.impl.adjunto.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.ext.impl.adjunto.dao.EXTAdjuntoAsuntoDao;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;

/**
 * @author maruiz
 * 
 */
@Repository
public class EXTAdjuntoAsuntoDaoImpl extends AbstractEntityDao<EXTAdjuntoAsunto, Long> implements
		EXTAdjuntoAsuntoDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<EXTAdjuntoAsunto> getAdjuntoAsuntoByNombreByAsu(Long idAsunto, String nombre) {
		StringBuffer hql = new StringBuffer();
		hql.append(" select aa from AdjuntoAsunto aa where aa.auditoria.borrado = false and aa.asunto.id = ");
		hql.append(idAsunto);
		hql.append(" and aa.nombre like '");
		hql.append(nombre);
		hql.append("%'");
		return getSession().createQuery(hql.toString()).list();
	}
}
