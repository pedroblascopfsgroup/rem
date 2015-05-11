package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDTipoAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDTipoAcuerdoDao")
public class DDTipoAcuerdoDaoImpl extends AbstractEntityDao<DDTipoAcuerdo, Long> implements DDTipoAcuerdoDao {

	/**
	 * Busca un DDTipoAcuerdo.
	 * @param codigo String: el codigo del DDTipoAcuerdo
	 * @return DDTipoAcuerdo
	 */
    @SuppressWarnings("unchecked")
    public DDTipoAcuerdo buscarPorCodigo(String codigo) {
		String hql = "from DDTipoAcuerdo where codigo = ?";
		List<DDTipoAcuerdo> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
