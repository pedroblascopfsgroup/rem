package es.capgemini.pfs.antecedente;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.antecedente.dao.AntecedenteDao;
import es.capgemini.pfs.antecedente.dto.DtoAntecedente;
import es.capgemini.pfs.antecedente.model.Antecedente;
import es.capgemini.pfs.antecedenteexterno.dto.DtoAntecedenteExterno;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;

/**
 * Clase de servicios de acceso de datos de los antecedente.
 * @author Andrés Esteban / Mariano Ruiz
 *
 */
@Service
public class AntecedenteManager {

    @Autowired
    private Executor executor;
    @Autowired
    private AntecedenteDao antecedenteDao;

    /**
     * Recupera el antecedente indicado.
     * @param id long
     * @return Antecedente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_MGR_GET)
    @Transactional
    public Antecedente get(Long id) {
        return antecedenteDao.get(id);
    }

    /**
     * Retorna el antecedente de la persona.
     * @param idPersona Long: el id de la Persona
     * @return Antecedente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_MGR_FIND_BY_PERSONA_ID)
    public Antecedente findByPersonaId(Long idPersona) {
        return antecedenteDao.findByPersonaId(idPersona);
    }

    /**
     * Save or update.
     * @param antecedente antecedente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_MGR_SAVE_OR_UPDATE)
    @Transactional
    public void saveOrUpdate(Antecedente antecedente) {
        antecedenteDao.saveOrUpdate(antecedente);
    }

    /**
     * Guarda el antecedente, y se lo asigna a la persona.
     * @param antecedente Persona
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_MGR_SAVE_OR_UPDATE_DTO)
    @Transactional
    public void saveOrUpdateDto(DtoAntecedente antecedente) {
        if (antecedente.getAntecedente().getAntecedenteExterno() != null) {
            DtoAntecedenteExterno dtoAntecedenteExterno = new DtoAntecedenteExterno();
            dtoAntecedenteExterno.setAntecedenteExterno(antecedente.getAntecedente().getAntecedenteExterno());
            executor.execute(PrimariaBusinessOperation.BO_ANTECEDENTE_EXTERNO_MGR_UPDATE, dtoAntecedenteExterno);
        }
        antecedenteDao.update(antecedente.getAntecedente());
    }
}
