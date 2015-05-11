package es.capgemini.pfs.asunto.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dao.EstadoAsuntoDao;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Implementaci�n  del Dao de Estados de Asunto.
 * @author pamuller
 *
 */
@Repository("EstadoAsuntoDao")
public class EstadoAsuntoDaoImpl extends AbstractEntityDao<DDEstadoAsunto, Long> implements EstadoAsuntoDao {

	/**
	 * Busca un estado de Asunto por su código.
	 * @param codigo el codigo del Estado del Asunto,
	 * @return el Estado del Asunto.
	 */
	@SuppressWarnings("unchecked")
    public DDEstadoAsunto buscarPorCodigo(String codigo){
		String hql = "from DDEstadoAsunto where codigo = ?";
		List<DDEstadoAsunto> estados = getHibernateTemplate().find(hql, codigo);
		if (estados==null || estados.size()==0){
			return null;
		}
		return estados.get(0);
	}
}
