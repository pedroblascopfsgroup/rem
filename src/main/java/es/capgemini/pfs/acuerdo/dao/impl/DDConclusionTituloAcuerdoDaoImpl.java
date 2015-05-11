package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDConclusionTituloAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDConclusionTituloAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDConclusionTituloAcuerdoDao")
public class DDConclusionTituloAcuerdoDaoImpl extends AbstractEntityDao<DDConclusionTituloAcuerdo, Long> implements DDConclusionTituloAcuerdoDao {

	/**
	 * Busca un DDConclusionTituloAcuerdo.
	 * @param codigo String: el codigo del DDConclusionTituloAcuerdo
	 * @return DDConclusionTituloAcuerdo
	 */
    @SuppressWarnings("unchecked")
    public DDConclusionTituloAcuerdo buscarPorCodigo(String codigo) {
		String hql = "from DDConclusionTituloAcuerdo where codigo = ?";
		List<DDConclusionTituloAcuerdo> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
