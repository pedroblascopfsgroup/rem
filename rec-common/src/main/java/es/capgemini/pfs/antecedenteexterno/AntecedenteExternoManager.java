package es.capgemini.pfs.antecedenteexterno;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.antecedente.model.Antecedente;
import es.capgemini.pfs.antecedenteexterno.dao.AntecedenteExternoDao;
import es.capgemini.pfs.antecedenteexterno.dto.DtoAntecedenteExterno;
import es.capgemini.pfs.antecedenteexterno.model.AntecedenteExterno;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;

/**
 * @author Mariano Ruiz
 */
@Service
public class AntecedenteExternoManager {

    @Autowired
    private Executor executor;
    @Autowired
    private AntecedenteExternoDao antecedenteExternoDao;

    /**
     * Retorna el antecedente externo.
     * @param id Long
     * @return AntecedenteExterno
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_EXTERNO_MGR_GET)
    @Transactional
    public AntecedenteExterno get(Long id) {
        return antecedenteExternoDao.get(id);
    }

    /**
     * Retorna todos los antecedentes externos no borrados.
     * @return List
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_EXTERNO_MGR_GET_LIST)
    @Transactional
    public List<AntecedenteExterno> getList() {
        return antecedenteExternoDao.getList();
    }

    /**
     * Retorna el antecedente externo de la persona.
     * @param id Long: el id de la Persona
     * @return List
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_EXTERNO_MGR_GET_ANTECEDENTE_EXTERNO_PERSONA)
    @Transactional
    public AntecedenteExterno getAntecedenteExternoPersona(Long id) {
        List<AntecedenteExterno> antecedentesExterno = antecedenteExternoDao.findByPersonaId(id);
        if (antecedentesExterno.size() == 0) {
            return null;
        }
        return antecedentesExterno.get(0);
    }

    /**
     * Guarda en la BBDD el objeto.
     * @param antecedenteExterno AntecedenteExterno
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_EXTERNO_MGR_SAVE_OR_UPDATE)
    @Transactional
    public void saveOrUpdate(AntecedenteExterno antecedenteExterno) {
        antecedenteExternoDao.saveOrUpdate(antecedenteExterno);
    }

    /**
     * Guarda en la BBDD el objeto.
     * @param dtoAntecedenteExterno DtoAntecedenteExterno
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_EXTERNO_MGR_UPDATE)
    @Transactional
    public void update(DtoAntecedenteExterno dtoAntecedenteExterno) {
        antecedenteExternoDao.saveOrUpdate(dtoAntecedenteExterno.getAntecedenteExterno());
    }

    /**
     * Guarda en la BBDD el Externo, relacionándolo con el antecedente de persona pasado.
     * @param dtoAntecedenteExterno DtoAntecedenteExterno
     * @param antecedente Antecedente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_EXTERNO_MGR_SAVE)
    @Transactional
    public void save(DtoAntecedenteExterno dtoAntecedenteExterno, Antecedente antecedente) {
        antecedente.setAntecedenteExterno(dtoAntecedenteExterno.getAntecedenteExterno());
        antecedenteExternoDao.saveOrUpdate(dtoAntecedenteExterno.getAntecedenteExterno());
        executor.execute(PrimariaBusinessOperation.BO_ANTECEDENTE_MGR_SAVE_OR_UPDATE, antecedente);
    }

    /**
     * Borra el objecto de la BBDD.
     * @param antecedenteExterno AntecedenteExterno
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_ANTECEDENTE_EXTERNO_MGR_DELETE)
    @Transactional
    public void delete(AntecedenteExterno antecedenteExterno) {
        antecedenteExternoDao.delete(antecedenteExterno);
    }
}
