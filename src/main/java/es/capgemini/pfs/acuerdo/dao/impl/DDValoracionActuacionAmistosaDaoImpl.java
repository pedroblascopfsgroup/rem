package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDValoracionActuacionAmistosaDao;
import es.capgemini.pfs.acuerdo.model.DDValoracionActuacionAmistosa;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDValoracionActuacionAmistosaDao")
public class DDValoracionActuacionAmistosaDaoImpl extends AbstractEntityDao<DDValoracionActuacionAmistosa, Long> implements DDValoracionActuacionAmistosaDao {

	/**
	 * Busca un DDValoracionActuacionAmistosa.
	 * @param codigo String: el codigo del DDValoracionActuacionAmistosa
	 * @return DDValoracionActuacionAmistosa
	 */
    @SuppressWarnings("unchecked")
    public DDValoracionActuacionAmistosa buscarPorCodigo(String codigo) {
		String hql = "from DDValoracionActuacionAmistosa where codigo = ?";
		List<DDValoracionActuacionAmistosa> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
