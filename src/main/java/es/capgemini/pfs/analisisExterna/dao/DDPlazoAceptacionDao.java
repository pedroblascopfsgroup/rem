package es.capgemini.pfs.analisisExterna.dao;

import es.capgemini.pfs.analisisExterna.model.DDPlazoAceptacion;
import es.capgemini.pfs.dao.AbstractDao;

public interface DDPlazoAceptacionDao extends AbstractDao<DDPlazoAceptacion, Long> {

    /**
     * Busca el plazo de aceptacion
     * @param codigo string;
     * @return DDPlazoAceptacion
     */
    DDPlazoAceptacion findByCodigo(String codigo);
}
