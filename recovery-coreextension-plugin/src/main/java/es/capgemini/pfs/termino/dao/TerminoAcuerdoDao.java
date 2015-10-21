package es.capgemini.pfs.termino.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;

/**
 * @author AMQ
 *
 */
public interface TerminoAcuerdoDao extends AbstractDao<TerminoAcuerdo, Long> {
	 
	
	List<TerminoAcuerdo> buscarTerminosPorTipo(Long idAcuerdo, String CodigoTipoAcuerdo);
	

}
