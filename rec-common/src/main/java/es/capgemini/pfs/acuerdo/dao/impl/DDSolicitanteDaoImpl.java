package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDSolicitanteDao;
import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDSolicitanteDao")
public class DDSolicitanteDaoImpl extends AbstractEntityDao<DDSolicitante, Long> implements DDSolicitanteDao {

	/**
	 * Busca un DDSolicitante.
	 * @param codigo String: el codigo del DDSolicitante
	 * @return DDSolicitante
	 */
    @SuppressWarnings("unchecked")
    public DDSolicitante buscarPorCodigo(String codigo) {
		String hql = "from DDSolicitante where codigo = ?";
		List<DDSolicitante> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
