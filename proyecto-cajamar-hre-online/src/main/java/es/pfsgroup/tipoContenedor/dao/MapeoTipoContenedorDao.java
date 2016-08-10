package es.pfsgroup.tipoContenedor.dao;

import java.util.List;

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

	/**
	 * Obtener los mapeos válidos
	 * @param tiposClasesContenedor tiposContenedor para los que vamos a obtener los mapeos válidos
	 * @return lista ids de TFA que son válidos para la lista de contenedores
	 */
	public List<Long> obtenerIdsTiposDocMapeados(List<String> tiposClasesContenedor);

}
