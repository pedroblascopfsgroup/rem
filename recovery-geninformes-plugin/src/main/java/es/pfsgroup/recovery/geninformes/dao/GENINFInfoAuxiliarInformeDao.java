package es.pfsgroup.recovery.geninformes.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.geninformes.model.GENINFInforme;

/**
 * Dao creado para hacer una b�squeda en la tabla MEJ_REG_REGISTRO que est� mapeada en el plugin de mejoras 
 *  del cual no puede depender este plugin
 *  lo referenciamos a la clase GENINFInforme simplemente para que sepa que es un dao y pueda abrir sesi�n
 * @author Diana
 *
 */
public interface GENINFInfoAuxiliarInformeDao extends AbstractDao<GENINFInforme, Long>{
	
	/**
	 * 
	 * M�todo que devuelve un string con el nombre del juzgado anterior 
	 * que tiene guardado en la tabla mej_reg_registro, si es que lo tiene
	 * @param id del procedimiento
	 * @return String nombre del juzgado
	 */
	public String buscaJuzgadoAnterior(Long id);

	/**
	 * 
	 * M�todo que devuelve un string con el nombre de la plaza 
	 * que tiene guardado en la tabla mej_reg_registro, si es que lo tiene
	 * @param id del procedimiento
	 * @return String nombre de la plaza
	 */
	public String buscaPlazaAnterior(Long id);

}
