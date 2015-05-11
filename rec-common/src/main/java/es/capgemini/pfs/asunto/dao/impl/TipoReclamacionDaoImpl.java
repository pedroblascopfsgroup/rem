package es.capgemini.pfs.asunto.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dao.TipoReclamacionDao;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase de acceso a datos para procedimientos.
 * @author pamuller
 *
 */
@Repository("TipoReclamacionDao")
public class TipoReclamacionDaoImpl extends AbstractEntityDao<DDTipoReclamacion,Long> implements
	TipoReclamacionDao   {

	/**
	 * Devuelve un TipoReclamacion por su código.
	 * @param codigo el codigo del TipoReclamacion
	 * @return el TipoReclamacion.
	 */
	@SuppressWarnings("unchecked")
    public DDTipoReclamacion getByCodigo(String codigo){
		String hql = "from DDTipoReclamacion where codigo = ?";
		List<DDTipoReclamacion> lista = getHibernateTemplate().find(hql, new Object[] { codigo });
		if (lista.size()>0){
			return lista.get(0);
		}
		return null;
	}
}
