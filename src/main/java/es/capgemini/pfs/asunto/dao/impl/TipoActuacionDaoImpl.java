package es.capgemini.pfs.asunto.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dao.TipoActuacionDao;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase de acceso a datos para procedimientos.
 * @author pamuller
 *
 */
@Repository("TipoActuacionDao")
public class TipoActuacionDaoImpl extends AbstractEntityDao<DDTipoActuacion,Long> implements
		TipoActuacionDao   {

	/**
	 * Devuelve un tipo de acutaci�n por su código.
	 * @param codigo el codigo del tipo de actuci�n
	 * @return el tipo de actuaci�n.
	 */
	@SuppressWarnings("unchecked")
    public DDTipoActuacion getByCodigo(String codigo){
		String hql = "from DDTipoActuacion where codigo = ?";
		List<DDTipoActuacion> lista = getHibernateTemplate().find(hql, new Object[] { codigo });
		if (lista.size()>0){
			return lista.get(0);
		}
		return null;
	}

}
