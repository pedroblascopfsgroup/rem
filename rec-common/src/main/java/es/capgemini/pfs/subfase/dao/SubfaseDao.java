package es.capgemini.pfs.subfase.dao;

import java.util.List;
import java.util.Set;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.subfase.model.Subfase;

/**
 * Interfaz para el DAO de Subfase.
 */

public interface SubfaseDao extends AbstractDao<Subfase, Long> {

    /**
     * Busca la fase que corresponda al codigo indicado.
     * @param codigoFase String
     * @return List Subfase
     */
    List<Subfase> findByCodigoDeLaFase(String codigoFase);

    /**
     * Lista todos las subfases con los códigos pasados.
     * @param codigos Set String
     * @return List Subfase
     */
    List<Subfase> getByCodigos(Set<String> codigos);
}
