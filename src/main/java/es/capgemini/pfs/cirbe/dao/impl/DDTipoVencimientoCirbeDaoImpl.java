package es.capgemini.pfs.cirbe.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cirbe.dao.DDTipoVencimientoCirbeDao;
import es.capgemini.pfs.cirbe.model.DDTipoVencimientoCirbe;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Dao de clase DDCodigoOperacionCirbe.
 *  @author: Pablo Müller
 */
@Repository("DDTipoVencimientoCirbeDao")
public class DDTipoVencimientoCirbeDaoImpl extends AbstractEntityDao<DDTipoVencimientoCirbe, Long> implements DDTipoVencimientoCirbeDao {

	/**
	 * Busca los distintos tipos de vencimiento. En la pantalla se agrupa por descripción y no por código
	 * https://coconet.capgemini.com/sf/go/artf536565?nav=1&_pagenum=1&returnUrlKey=1245677561915
	 * @return las distintas descripciones de tipo de vencimientos, sin repetidos.
	 */
	@SuppressWarnings("unchecked")
    @Override
	public List<String> getDescripcionesTiposVencimiento() {
		String hql = "select distinct descripcion from DDTipoVencimientoCirbe";
		List<String> descripciones = getHibernateTemplate().find(hql);
		return descripciones;
	}
}
