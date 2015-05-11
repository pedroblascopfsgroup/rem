package es.capgemini.pfs.procesosJudiciales.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.PlazoTareaExternaPlaza;

/**
 * Interfaz dao para las tareas TareaExterna.
 *
 * @author pajimene
 *
 */
public interface PlazoTareaExternaPlazaDao extends AbstractDao<PlazoTareaExternaPlaza, Long> {
    /**
     * getByTipoTareaTipoPlazaTipoJuzgado.
     * @param idTipoTarea id
     * @param idTipoPlaza id
     * @param idTipoJuzgado id
     * @return pt
     */
    PlazoTareaExternaPlaza getByTipoTareaTipoPlazaTipoJuzgado(Long idTipoTarea, Long idTipoPlaza, Long idTipoJuzgado);
}
