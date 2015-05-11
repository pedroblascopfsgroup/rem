package es.capgemini.pfs.politica.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.politica.model.DDParcelasPersonas;
import es.capgemini.pfs.segmento.model.DDSegmento;

/**
 * Interfaz para acceso a datos del DDParcelasPersonas.
 * @author pamuller
 *
 */
public interface DDParcelasPersonasDao extends AbstractDao<DDParcelasPersonas,Long>{

	/**
	 * Devuelve la lista de DDParcelasPersonas correspondiente a ese tipo de persona y segmento de cliente.
	 * Si no hay un registro para tipo de persona + segmento se devuelve el correspondiente a tipo de persona
	 * y segmento null.
	 * @param tipoPersona el tipo de persona.
	 * @param segmento el segmento del cliente.
	 * @return la lista de parcelas de ese tipo de persona y tipo de cliente
	 */
	List<DDParcelasPersonas> buscarPorTipoPersonaYSegmento(DDTipoPersona tipoPersona, DDSegmento segmento);

}
