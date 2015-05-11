package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao;

import java.util.List;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.CambiosMasivosAsuntoPluginConfig;

/**
 * Fachada para el acceso a datos a través del {@link GenericABMDao}
 * @author bruno
 *
 */
public interface CambioMasivoGestoresAsuntoGenericDaoFacade {

	/**
	 * Devuelve la lista de tipos de gestores teniendo en cuenta los criterios establecidos en la configuraciond el plugin
	 * 
	 * @param config Configuración del plugin
	 * @return
	 */
	List<EXTDDTipoGestor> getTiposGestor(CambiosMasivosAsuntoPluginConfig config);

	List<DespachoExterno> getTodosLosDespachos();
	
	
}
