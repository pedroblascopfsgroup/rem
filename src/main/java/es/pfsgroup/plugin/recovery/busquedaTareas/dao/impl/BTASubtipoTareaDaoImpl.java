package es.pfsgroup.plugin.recovery.busquedaTareas.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.pfsgroup.plugin.recovery.busquedaTareas.dao.BTASubtipoTareaDao;

@Repository("BTASubtipoTareaDao")
public class BTASubtipoTareaDaoImpl extends AbstractEntityDao<SubtipoTarea, Long> implements BTASubtipoTareaDao {

	private static final String BUSCAR_POR_TAREA_HQL = "from SubtipoTarea where tipoTarea.codigoTarea = ?";
	
	@SuppressWarnings("unchecked")
	public List<SubtipoTarea> buscarPorCodigoTipo(String codigoTipo) {
		List<SubtipoTarea> subtiposTarea = getHibernateTemplate().find(BUSCAR_POR_TAREA_HQL, codigoTipo);
		if (subtiposTarea.size()>0){
			return subtiposTarea;
		}
		return null;
	}

	
}
