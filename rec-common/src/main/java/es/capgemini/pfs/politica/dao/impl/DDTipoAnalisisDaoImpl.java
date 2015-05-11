package es.capgemini.pfs.politica.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDTipoAnalisisDao;
import es.capgemini.pfs.politica.model.DDTipoAnalisis;

/**
 * Implementación del dao de DDTipoAnalisis.
 * @author pamuller
 *
 */
@Repository("DDTipoAnalisisDao")
public class DDTipoAnalisisDaoImpl extends AbstractEntityDao<DDTipoAnalisis, Long> implements DDTipoAnalisisDao {

	/**
	 * Devuelve el tipo de análisis por su código.
	 * @param codigo el codigo del DDTipoAnalisis.
	 * @return el DDTipoAnalisis.
	 */
	@Override
	public DDTipoAnalisis findByCodigo(String codigo) {
		return null;
	}



}
