package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDMotivo;

/**
 * Interfaz para acceso a datos del DDMotivo.
 * @author Andrés Esteban
 *
 */
public interface DDMotivoDao extends AbstractDao<DDMotivo, Long> {

    /**
     * Recupera el motivo correspondiente al codigo indicado.
     * @param codigo String
     * @return DDMotivo
     */
    DDMotivo buscarPorCodigo(String codigo);
}
