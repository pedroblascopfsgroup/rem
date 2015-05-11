package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDImpactoDao;
import es.capgemini.pfs.politica.model.DDImpacto;

/**
 * Implementación del dao de DDTipoAnalisis.
 * @author pamuller
 *
 */
@Repository("DDImpactoDao")
public class DDImpactoDaoImpl extends AbstractEntityDao<DDImpacto, Long> implements DDImpactoDao {

	/**
	 * Devuelve el DDImpacto por su código.
	 * @param codigo el codigo del DDImpacto.
	 * @return el DDImpacto.
	 */
	@SuppressWarnings("unchecked")
    @Override
	public DDImpacto findByCodigo(String codigo) {
		String hql = "from DDImpacto where codigo = ?";
		List<DDImpacto> impactos = getHibernateTemplate().find(hql, codigo);
		if (impactos.size()>0){
			return impactos.get(0);
		}
		return null;
	}



}
