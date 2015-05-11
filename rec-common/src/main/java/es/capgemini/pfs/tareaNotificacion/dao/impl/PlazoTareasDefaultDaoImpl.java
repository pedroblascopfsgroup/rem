package es.capgemini.pfs.tareaNotificacion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.dao.PlazoTareasDefaultDao;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;

/**
 * Implementaci�n del dao de subtipos de tareas.
 * @author pamuller
 *
 */
@Repository("PlazoTareasDefaultDao")
public class PlazoTareasDefaultDaoImpl extends AbstractEntityDao<PlazoTareasDefault, Long> implements PlazoTareasDefaultDao{

	private static final String BUSCAR_POR_CODIGO_HQL = "from PlazoTareasDefault where codigo = ?";

	/**
	 * Busca un PlazoTareasDefault por su código.
	 * @param codigo el código del subtipo de tarea que se busca.
	 * @return el subtipo de tarea si existe.
	 */
	@SuppressWarnings("unchecked")
    public PlazoTareasDefault buscarPorCodigo(String codigo){
		List<PlazoTareasDefault> plazo = getHibernateTemplate().find(BUSCAR_POR_CODIGO_HQL,codigo);
		if (plazo.size()>0){
			return plazo.get(0);
		}
		return null;
	}
}
