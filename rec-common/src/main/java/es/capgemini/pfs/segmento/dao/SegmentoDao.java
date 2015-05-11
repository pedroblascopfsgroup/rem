package es.capgemini.pfs.segmento.dao;

import java.util.List;
import java.util.Set;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.segmento.model.DDSegmento;

/**
 * @author Mariano Ruiz
 */
public interface SegmentoDao extends AbstractDao<DDSegmento, Long> {

    /**
     * Retorna la lista de segmentos en base a la lista de códigos pasada.
     * @param codigos Set String
     * @return List Segmento
     */
    List<DDSegmento> getSegmentosByCodigos(Set<String> codigos);

    /**
     * Busca el tipo de segmento por codigo.
     * @param codigo string;
     * @return Segmento
     */
    DDSegmento findByCodigo(String codigo);

}
