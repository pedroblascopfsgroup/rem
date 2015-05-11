package es.pfsgroup.recovery.recobroCommon.metasVolantes.dao.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoItinerario;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroItinerarioMetasVolantes;

/**
 * 
 * Interfaz de acceso a base de datos para la clase RecobroItinerarioMetasVolantes
 * @author vanesa
 *
 */
public interface RecobroItinerarioDao extends AbstractDao<RecobroItinerarioMetasVolantes, Long>{

	/**
	 * Método que devuelve una página que contiene una lista de objetos RecobroItinerarioMetaVolante
	 * Esta lista contendrá la lista de itinerarios de metas volantes que cumplan los criterios de búsqueda
	 * Si no hay ningún criterio de búsqueda se devolverán todas los itinerarios dados de 
	 * alta en la base de datos que no estén borradas (borrado=0)
	 * @param dto
	 * @return pagina que contiene un listado de objetos RecobroDtoItinerario
	 */
	Page buscaItinerarios(RecobroDtoItinerario dto);

	/**
	 * Metodo que devuelve los modelos en estado Disponible o bloqueado
	 * @author Sergio
	 */
	List<RecobroItinerarioMetasVolantes> getModelosDSPoBLQ();
	
}
