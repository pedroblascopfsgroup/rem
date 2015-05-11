package es.capgemini.pfs.telecobro.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.telecobro.dao.MotivosExclusionTelecobroDao;
import es.capgemini.pfs.telecobro.model.DDMotivosExclusionTelecobro;

/**
 * Clase que implementa CausaExclusionDao.
 * @author aesteban
 *
 */
@Repository("MotivosExclusionTelecobroDao")
public class MotivosExclusionTelecobroDaoImpl extends AbstractEntityDao<DDMotivosExclusionTelecobro, Long> implements MotivosExclusionTelecobroDao {

	/**
	 * busca un motivo de exclusión por su código.
	 * @param codigo el codigo
	 * @return el motivo de exclusión
	 */
	@SuppressWarnings("unchecked")
    public DDMotivosExclusionTelecobro buscarPorCodigo(String codigo){
		String hql = "from DDMotivosExclusionTelecobro where codigo = ?";
		List<DDMotivosExclusionTelecobro> lista =  getHibernateTemplate().find(hql, codigo);
		if (lista.size()>0){
			return lista.get(0);
		}
		return null;
	}
}
