package es.pfsgroup.recovery.recobroCommon.esquema.dao.api;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

/**
 * Interfaz de acceso a base de datos para la clase RecobroSubCartera
 * @author vanesa
 *
 */
public interface RecobroSubCarteraDao extends AbstractDao<RecobroSubCartera, Long>{
	
	/**
	 * Método que obtiene las subcarteras asociadas a un determinado Itinerario de metas volantes
	 * @param id del Itinerario de metas volantes
	 * @return Lista de subcarteras
	 */
	List<RecobroSubCartera> getSubCarteraByItinerario(Long idItinerario);

	/**
	 * A partir de un esquema y una subcaretera, devuelve la subcartera del esquema
	 * recibido que tiene el mismo 'nombre' que la subcartera recibida
	 */
	RecobroSubCartera getSubcarteraPorNombreYEsquema(RecobroEsquema esquema,
			RecobroSubCartera subcarteraOriginal);
	
}
