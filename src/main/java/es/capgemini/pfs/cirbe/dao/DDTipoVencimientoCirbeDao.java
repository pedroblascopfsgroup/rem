package es.capgemini.pfs.cirbe.dao;

import java.util.List;

import es.capgemini.pfs.cirbe.model.DDTipoVencimientoCirbe;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Interfaz del dao de DDTipoVencimientoCirbe.
 * @author pamuller
 *
 */
public interface DDTipoVencimientoCirbeDao extends AbstractDao<DDTipoVencimientoCirbe, Long> {

	/**
	 * Busca los distintos tipos de vencimiento. En la pantalla se agrupa por descripción y no por código
	 * https://coconet.capgemini.com/sf/go/artf536565?nav=1&_pagenum=1&returnUrlKey=1245677561915
	 * @return las distintas descripciones de tipo de vencimientos, sin repetidos.
	 */
	List<String> getDescripcionesTiposVencimiento();

}
