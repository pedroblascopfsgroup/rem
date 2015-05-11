package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDTipoSolucionAmistosaDao;
import es.capgemini.pfs.acuerdo.model.DDTipoSolucionAmistosa;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDTipoSolucionAmistosaDao")
public class DDTipoSolucionAmistosaDaoImpl extends AbstractEntityDao<DDTipoSolucionAmistosa, Long> implements DDTipoSolucionAmistosaDao {

	/**
	 * Busca un DDTipoSolucionAmistosa.
	 * @param codigo String: el codigo del DDTipoSolucionAmistosa
	 * @return DDTipoSolucionAmistosa
	 */
    @SuppressWarnings("unchecked")
    public DDTipoSolucionAmistosa buscarPorCodigo(String codigo) {
		String hql = "from DDTipoSolucionAmistosa where codigo = ?";
		List<DDTipoSolucionAmistosa> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
