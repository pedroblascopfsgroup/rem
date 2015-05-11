package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDTipoActuacionAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDTipoActuacionAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDTipoActuacionAcuerdoDao")
public class DDTipoActuacionAcuerdoDaoImpl extends AbstractEntityDao<DDTipoActuacionAcuerdo, Long> implements DDTipoActuacionAcuerdoDao {

	/**
	 * Busca un DDTipoActuacionAcuerdo.
	 * @param codigo String: el codigo del DDTipoActuacionAcuerdo
	 * @return DDTipoActuacionAcuerdo
	 */
    @SuppressWarnings("unchecked")
    public DDTipoActuacionAcuerdo buscarPorCodigo(String codigo) {
		String hql = "from DDTipoActuacionAcuerdo where codigo = ?";
		List<DDTipoActuacionAcuerdo> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
