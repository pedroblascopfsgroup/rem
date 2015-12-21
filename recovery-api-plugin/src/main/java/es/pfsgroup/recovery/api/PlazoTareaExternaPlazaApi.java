package es.pfsgroup.recovery.api;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.PlazoTareaExternaPlaza;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
public interface PlazoTareaExternaPlazaApi {

	
	/**
     * PONER JAVADOC FO.
     * @param idTipoTarea id
     * @param idTipoPlaza id
     * @param idTipoJuzgado id
     * @return pt
     */
	@Transactional(readOnly = false)
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PLAZO_TAREA_EXT_PLAZA_MGR_GET_BY_TIPO_TAREA_PLAZA_JUSZADO)
    PlazoTareaExternaPlaza getByTipoTareaTipoPlazaTipoJuzgado(Long idTipoTarea, Long idTipoPlaza, Long idTipoJuzgado);
}
