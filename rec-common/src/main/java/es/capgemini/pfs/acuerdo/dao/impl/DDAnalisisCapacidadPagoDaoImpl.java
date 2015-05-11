package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDAnalisisCapacidadPagoDao;
import es.capgemini.pfs.acuerdo.model.DDAnalisisCapacidadPago;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDAnalisisCapacidadPagoDao")
public class DDAnalisisCapacidadPagoDaoImpl extends AbstractEntityDao<DDAnalisisCapacidadPago, Long> implements DDAnalisisCapacidadPagoDao {

	/**
	 * Busca un DDAnalisisCapacidadPago.
	 * @param codigo String: el codigo del DDAnalisisCapacidadPago
	 * @return DDAnalisisCapacidadPago
	 */
    @SuppressWarnings("unchecked")
    public DDAnalisisCapacidadPago buscarPorCodigo(String codigo) {
		String hql = "from DDAnalisisCapacidadPago where codigo = ?";
		List<DDAnalisisCapacidadPago> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
