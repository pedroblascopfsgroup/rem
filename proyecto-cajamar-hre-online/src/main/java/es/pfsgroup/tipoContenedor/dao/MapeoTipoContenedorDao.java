package es.pfsgroup.tipoContenedor.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.tipoContenedor.model.MapeoTipoContenedor;

public interface MapeoTipoContenedorDao extends AbstractDao<MapeoTipoContenedor,Long> {
	
	/**
	 * Retorna el mapeo correspondiente al tipoFicheroAdjunto y codigo TDN2
	 * @param tipoExp
	 * @param claseExp
	 * @param tipoFichero
	 * @return
	 */
	public MapeoTipoContenedor getMapeoByTfaAndTdn2(String tipoExp, String claseExp, String tipoFichero);
	
	/**
	 * Comprueba que existe mapeo por el codigo del tipo de fichero a adjuntar
	 * @param codTFA
	 * @return
	 */
	public boolean existeMapeoByFicheroAdjunto(String codTFA);

}
