package es.capgemini.pfs.batch.revisar.personas;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.revisar.personas.dao.PersonasBatchDao;

/**
 * Clase manager para la entidad personas.
 * @author pjimene
 *
 */
public class PersonasBatchManager {

    @Autowired
    private PersonasBatchDao personasDao;

    /**
     * Realiza una serie de precalculos de variables estáticas.
     */
    public void realizaPrecalculosCarga() {
        personasDao.realizaPrecalculosCarga();
    }

    /**
     * Realiza una historificación de las prepoliticas de las personas
     */
    public void historificaPrepoliticas() {
        personasDao.historificaPrepoliticas();
    }

    /**
     * Retorna el id del arquetipo calculado de la persona.
     *
     * @param personaId
     *            Long
     * @return arquetipo
     */
    public Long buscarArquetipoCalculado(Long personaId) {
        return personasDao.buscarArquetipoCalculado(personaId);
    }

    /**
     * Recupera los IDs de las personas que deben generar cliente.
     * @return Listado de ids de persona
     */
    public List<Long> buscarFuturosClientesSeguimiento() {
        return personasDao.buscarFuturosClientesSeguimiento();
    }
    
    /**
     * Realiza una actualizacion de los arquetipos por el valor calculado
     */
    public void actualizarArquetiposPorCalculados() {
        personasDao.actualizarArquetiposPorCalculados();
    }
    
    /**
     * Recupera los IDs de todas las personas activas.
     * @return Listado de ids de persona
     */
    public List<Long> buscarPersonasActivas() {
        return personasDao.buscarPersonasActivas();
    }
    
    /**
     * Recupera los IDs de todos los contratos de una persona
     * @param perId
     * @return Listado de ids de contratos
     */
    public List<Long> buscarContratos(Long perId) {
        return personasDao.buscarContratos(perId);
    }

}
