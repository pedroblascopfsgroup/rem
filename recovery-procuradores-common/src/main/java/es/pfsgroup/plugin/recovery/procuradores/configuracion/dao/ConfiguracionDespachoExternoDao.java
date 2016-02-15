package es.pfsgroup.plugin.recovery.procuradores.configuracion.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.model.ConfiguracionDespachoExterno;


/**
 * Dao de la clase {@link ConfiguracionDespachoExterno}
 * 
 * @author manuel
 *
 */
public interface ConfiguracionDespachoExternoDao  extends AbstractDao<ConfiguracionDespachoExterno, Long>{

	/**
	 * Obtiene la Configuración de un {@link DespachoExterno}.
	 * @param id Identificador del despacho.
	 * @return {@link ConfiguracionDespachoExterno}.
	 */
	public ConfiguracionDespachoExterno getConfiguracionDespachoExterno(Long idDespachoExterno);
}
