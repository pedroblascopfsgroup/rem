package es.capgemini.pfs.procesosJudiciales.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;

/**
 * Interfaz dao para las tareas TareaExternaValor.
 *
 */
public interface TareaExternaValorDao extends AbstractDao<TareaExternaValor, Long> {

    /**
     * getByTareaExterna.
     * @param idTareaExterna id
     * @return te
     */
    List<TareaExternaValor> getByTareaExterna(Long idTareaExterna);
}
