package es.capgemini.pfs.procesosJudiciales;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.dao.PlazoTareaExternaPlazaDao;
import es.capgemini.pfs.procesosJudiciales.model.PlazoTareaExternaPlaza;

/**
 * Tarea externa manager.
 *
 * @author pajimene
 *
 */
@Service
public class PlazoTareaExternaPlazaManager {
    @Autowired
    private PlazoTareaExternaPlazaDao plazoTareaExternaPlazaDao;

    /**
     * PONER JAVADOC FO.
     * @param idTipoTarea id
     * @param idTipoPlaza id
     * @param idTipoJuzgado id
     * @return pt
     */
    @Transactional(readOnly = false)
    @BusinessOperation(ExternaBusinessOperation.BO_PLAZO_TAREA_EXT_PLAZA_MGR_GET_BY_TIPO_TAREA_PLAZA_JUSZADO)
    public PlazoTareaExternaPlaza getByTipoTareaTipoPlazaTipoJuzgado(Long idTipoTarea, Long idTipoPlaza, Long idTipoJuzgado) {
        return plazoTareaExternaPlazaDao.getByTipoTareaTipoPlazaTipoJuzgado(idTipoTarea, idTipoPlaza, idTipoJuzgado);
    }

    /**
     * PONER JAVADOC FO.
     * @param id id
     * @return pt
     */
    @BusinessOperation(ExternaBusinessOperation.BO_PLAZO_TAREA_EXT_PLAZA_MGR_GET)
    public PlazoTareaExternaPlaza get(Long id) {
        return plazoTareaExternaPlazaDao.get(id);
    }
}
