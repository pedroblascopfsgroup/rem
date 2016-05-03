package es.capgemini.pfs.acuerdo.dao;

import java.util.List;

import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDSolicitanteDao extends AbstractDao<DDSolicitante, Long> {

    /**
     * Busca un DDSolicitante.
     * @param codigo String: el codigo del DDSolicitante
     * @return DDSolicitante
     */
    DDSolicitante buscarPorCodigo(String codigo);
    
    List<DDSolicitante> getListTiposSolicitante();

}
