package es.capgemini.pfs.tareaNotificacion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.dao.SubtipoTareaDao;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

/**
 * Implementación del dao de subtipos de tareas.
 * @author pamuller
 *
 */
@Repository("SubtipoTareaDao")
public class SubtipoTareaDaoImpl extends AbstractEntityDao<SubtipoTarea, Long> implements SubtipoTareaDao{

	private static final String BUSCAR_POR_CODIGO_HQL = "from SubtipoTarea where codigoSubtarea = ?";

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
    public SubtipoTarea buscarPorCodigo(String codigoSubtarea){
		List<SubtipoTarea> subtiposTareas = getHibernateTemplate().find(BUSCAR_POR_CODIGO_HQL, codigoSubtarea);
		if (subtiposTareas.size()>0){
			return subtiposTareas.get(0);
		}
		return null;
	}
}
