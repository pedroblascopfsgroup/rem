package es.pfsgroup.recovery.ext.impl.tipoAdjuntoEntidad.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tipoFicheroAdjuntoEntidad.DDTipoAdjuntoEntidad;
import es.pfsgroup.recovery.ext.api.tipoAdjuntoEntidad.dao.DDTipoAdjuntoEntidadDao;

@Repository
public class DDTipoAdjuntoEntidadDaoImpl extends
		AbstractEntityDao<DDTipoAdjuntoEntidad, Long> implements
		DDTipoAdjuntoEntidadDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<DDTipoAdjuntoEntidad> obtenerTiposAdjuntosPorEntidad(String codigoEntidad) {

		StringBuffer hql = new StringBuffer();
		hql.append(" select tae from DDTipoAdjuntoEntidad tae "
				+ " join tae.tiposEntidad te "
				+ " where tae.auditoria.borrado = false "
				+ " and te.codigo =:codigoTipoEntidad ");
		hql.append(" order by tae.descripcion asc");
		return getSession().createQuery(hql.toString()).setParameter("codigoTipoEntidad", codigoEntidad).list();

	}

}
