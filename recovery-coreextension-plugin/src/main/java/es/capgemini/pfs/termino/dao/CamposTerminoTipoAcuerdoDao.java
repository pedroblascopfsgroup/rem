package es.capgemini.pfs.termino.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.termino.model.CamposTerminoTipoAcuerdo;

/**
 * @author Carlos Gil
 *
 */
public interface CamposTerminoTipoAcuerdoDao extends AbstractDao<CamposTerminoTipoAcuerdo, Long> {

	public List<CamposTerminoTipoAcuerdo> getCamposTerminosPorTipoAcuerdo(Long idTipoAcuerdo);
}
