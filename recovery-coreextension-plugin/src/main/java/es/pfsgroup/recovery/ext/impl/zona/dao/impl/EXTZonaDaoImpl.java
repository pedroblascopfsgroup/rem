package es.pfsgroup.recovery.ext.impl.zona.dao.impl;

import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.recovery.ext.impl.zona.dao.EXTZonaDao;

@Repository("EXTZonaDao")
public class EXTZonaDaoImpl extends AbstractEntityDao<DDZona, Long> implements
		EXTZonaDao {

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<DDZona> buscarZonasPorCodigoNivel(Integer codigoNivel,
			Set<String> codigoZonasUsuario) {
		String hql = " from DDZona z where z.auditoria.borrado = 0 and z.nivel.codigo = ?";
		if (codigoZonasUsuario != null && codigoZonasUsuario.size() > 0) {
			hql += " and ( ";
			for (String cz : codigoZonasUsuario) {
				hql += " z.codigo like '" + cz + "%' or";
			}
			hql = hql.substring(0, hql.length() - 2);
			hql += " ) ";
		}
		return getHibernateTemplate().find(hql, codigoNivel);
	}

}