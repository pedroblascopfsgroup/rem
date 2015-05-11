package es.capgemini.pfs.alerta.dao;

import es.capgemini.pfs.alerta.model.NivelGravedad;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Andrés Esteban.
 */
public interface NivelGravedadDao extends AbstractDao<NivelGravedad, Long> {

    /**
     * Busca el nivel de gravedad por codigo.
     * @param codigo string;
     * @return NivelGravedad
     */
    NivelGravedad findByCodigo(String codigo);

    /**
     * Busca el nivel de gravedad por orden.
     * @param orden int
     * @return NivelGravedad
     */
    NivelGravedad buscarPorOrden(Integer orden);
}
