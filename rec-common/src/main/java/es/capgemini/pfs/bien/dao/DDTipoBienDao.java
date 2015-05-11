package es.capgemini.pfs.bien.dao;

import es.capgemini.pfs.bien.model.DDTipoBien;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * DAO para los tipos de bienes.
 * @author marruiz
 */
public interface DDTipoBienDao extends AbstractDao<DDTipoBien, Long> {

    /**
     * Obtiene el tipo bien por su código.
     * @param codigo String
     * @return DDTipoBien
     */
    DDTipoBien getByCodigo(String codigo);

}
