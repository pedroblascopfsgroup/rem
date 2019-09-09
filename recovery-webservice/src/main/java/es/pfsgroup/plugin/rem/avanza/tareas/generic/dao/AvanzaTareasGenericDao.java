package es.pfsgroup.plugin.rem.avanza.tareas.generic.dao;

import java.util.Map;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface AvanzaTareasGenericDao extends AbstractDao<TareaExterna, Long>{
	
	/**
	 * Valida si los campos que nos pasan el la llamada son correctos
	 * @param Map<String,String[]> valores
	 * @return boolean
	 */
	public boolean validaCamposTarea(String tapCodigo, Map<String,String[]> valores);

}
