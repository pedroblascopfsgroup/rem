package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDCambioSolvenciaAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDCambioSolvenciaAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author pamuller
 *
 */
@Repository("DDCambioSolvenciaAcuerdoDao")
public class DDCambioSolvenciaAcuerdoDaoImpl extends AbstractEntityDao<DDCambioSolvenciaAcuerdo, Long> implements DDCambioSolvenciaAcuerdoDao {

	/**
	 * Busca un DDCambioSolvenciaAcuerdo.
	 * @param codigo String: el codigo del DDCambioSolvenciaAcuerdo
	 * @return DDCambioSolvenciaAcuerdo
	 */
    @SuppressWarnings("unchecked")
    public DDCambioSolvenciaAcuerdo buscarPorCodigo(String codigo) {
		String hql = "from DDCambioSolvenciaAcuerdo where codigo = ?";
		List<DDCambioSolvenciaAcuerdo> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
