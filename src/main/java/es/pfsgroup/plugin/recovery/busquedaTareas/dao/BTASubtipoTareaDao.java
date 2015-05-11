package es.pfsgroup.plugin.recovery.busquedaTareas.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

public interface BTASubtipoTareaDao extends AbstractDao<SubtipoTarea, Long>{
	
    /**
     * Busca los sub tipos de tarea a partir del codigo de tipo recivido.
     * @param código del tipo
     * @return lista de subtipos de tarea encontrados
     */
	public List<SubtipoTarea> buscarPorCodigoTipo(String codigoTipo);

}
