package es.capgemini.pfs.tareaNotificacion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.dao.TipoEntidadDao;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * Implementación del dao de subtipos de tareas.
 * @author pamuller
 *
 */
@Repository("TipoEntidadDao")
public class TipoEntidadDaoImpl extends AbstractEntityDao<DDTipoEntidad, Long> implements TipoEntidadDao{

	private static final String BUSCAR_POR_CODIGO = "from DDTipoEntidad where codigo = ?";

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
    public DDTipoEntidad buscarPorCodigo(String codigoEntidad){
		List<DDTipoEntidad> subtiposTareas = getHibernateTemplate().find(BUSCAR_POR_CODIGO, codigoEntidad);
		if (subtiposTareas.size()>0){
			return subtiposTareas.get(0);
		}
		return null;
	}
}
