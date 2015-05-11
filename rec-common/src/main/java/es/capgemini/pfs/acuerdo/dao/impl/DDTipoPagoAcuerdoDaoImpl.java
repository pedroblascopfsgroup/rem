package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDTipoPagoAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDTipoPagoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDTipoPagoAcuerdoDao")
public class DDTipoPagoAcuerdoDaoImpl extends AbstractEntityDao<DDTipoPagoAcuerdo, Long> implements DDTipoPagoAcuerdoDao {

	/**
	 * Busca un DDTipoPagoAcuerdo.
	 * @param codigo String: el codigo del DDTipoPagoAcuerdo
	 * @return DDTipoPagoAcuerdo
	 */
    @SuppressWarnings("unchecked")
    public DDTipoPagoAcuerdo buscarPorCodigo(String codigo) {
		String hql = "from DDTipoPagoAcuerdo where codigo = ?";
		List<DDTipoPagoAcuerdo> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
