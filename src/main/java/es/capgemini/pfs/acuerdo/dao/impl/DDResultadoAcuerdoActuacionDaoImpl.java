package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDResultadoAcuerdoActuacionDao;
import es.capgemini.pfs.acuerdo.model.DDResultadoAcuerdoActuacion;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDResultadoAcuerdoActuacionDao")
public class DDResultadoAcuerdoActuacionDaoImpl extends AbstractEntityDao<DDResultadoAcuerdoActuacion, Long> implements DDResultadoAcuerdoActuacionDao {

	/**
	 * Busca un DDResultadoAcuerdoActuacion.
	 * @param codigo String: el codigo del DDResultadoAcuerdoActuacion
	 * @return DDResultadoAcuerdoActuacion
	 */
    @SuppressWarnings("unchecked")
    public DDResultadoAcuerdoActuacion buscarPorCodigo(String codigo) {
		String hql = "from DDResultadoAcuerdoActuacion where codigo = ?";
		List<DDResultadoAcuerdoActuacion> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
}
