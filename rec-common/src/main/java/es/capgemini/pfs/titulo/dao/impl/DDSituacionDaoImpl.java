package es.capgemini.pfs.titulo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.titulo.dao.DDSituacionDao;
import es.capgemini.pfs.titulo.model.DDSituacion;


/**
 * Clase que implementa los mÃ©todos de la interfaz DDSituacionDao.
 * @@SuppressWarnings("unchecked")
author mtorrado
 *
 */
@Repository("DDSituacionDao")
public class DDSituacionDaoImpl extends AbstractEntityDao<DDSituacion, Long> implements DDSituacionDao {

	/**
	 * Retorna la situaciï¿½n para un cÃ³digo determinado.
	 * @param codigo String
	 * @return DDSituacion
	 */
	@SuppressWarnings("unchecked")
	@Override
	public DDSituacion obtenerSituacion(String codigo) {

		logger.debug("Buscando situación con código: "
				+ codigo);

		String hsql = "from DDSituacion where ";
		hsql += "UPPER(codigo) = UPPER(?) and auditoria.borrado = false";
		List<DDSituacion> listaSituacion = getHibernateTemplate().find(hsql, new Object[] {codigo});
		if (listaSituacion!=null && listaSituacion.size()>0){
			return listaSituacion.get(0);
		}
		return null;

	}


}
