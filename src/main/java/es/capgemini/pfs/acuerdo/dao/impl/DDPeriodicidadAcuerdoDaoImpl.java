package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDPeriodicidadAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDPeriodicidadAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author pamuller
 *
 */
@Repository("DDPeriodicidadAcuerdoDao")
public class DDPeriodicidadAcuerdoDaoImpl extends AbstractEntityDao<DDPeriodicidadAcuerdo, Long> implements DDPeriodicidadAcuerdoDao {

	/**
	 * Busca un DDPeriodicidadAcuerdo.
	 * @param codigo String: el codigo del DDPeriodicidadAcuerdo
	 * @return DDPeriodicidadAcuerdo
	 */
    @SuppressWarnings("unchecked")
    public DDPeriodicidadAcuerdo buscarPorCodigo(String codigo) {
		String hql = "from DDPeriodicidadAcuerdo where codigo = ?";
		List<DDPeriodicidadAcuerdo> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
