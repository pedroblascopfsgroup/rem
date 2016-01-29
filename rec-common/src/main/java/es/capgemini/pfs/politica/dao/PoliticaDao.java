package es.capgemini.pfs.politica.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;
import es.capgemini.pfs.politica.model.DDTipoPolitica;
import es.capgemini.pfs.politica.model.Politica;

/**
 * Dao para las politicas.
 * @author aesteban
*/
public interface PoliticaDao extends AbstractDao<Politica, Long> {

    /**
     * Recupera todas las políticas para la persona indicada.
     * @param idPersona Long
     * @return Lista de ciclos de políticas
     */
    List<CicloMarcadoPolitica> buscarPoliticasParaPersona(Long idPersona);

    /**
     * Devuelve la política vigente para la persona pasadaPorParámetro.
     * @param idPersona el id de la persona para la que se busca la plítica.
     * @return la política vigente o null si no hay.
     */
    Politica buscarPoliticaVigente(Long idPersona);

    /**
     * Devuelve la última política del último ciclo de marcado de la persona.
     * @param idPersona Long
     * @return la política vigente o null si no hay.
     */
    Politica buscarUltimaPolitica(Long idPersona);

    /**
     * Devuelve la política propuesta para una persona en un estado de itinerario en concreto.
     * @param persona Persona que se debe buscar
     * @param expediente Expediente que se debe buscar
     * @param estadoItinerario Estado del itinerario donde se encuentra la política
     * @return La política de la persona
     */
    Politica getPoliticaPropuestaExpedientePersonaEstadoItinerario(Persona persona, Expediente expediente, DDEstadoItinerario estadoItinerario);

    /**
     * Cantidad de ciclos de marcado de política que pertenezca al expediente
     * y tengan una política con estadoItinerario  en 'Politica DC'.
     * @param idExpediente Long
     * @return Long
     */
    Long getNumPoliticasGeneradas(Long idExpediente);

    /**
     * Busca un ciclo de marcado de política para un expediente y una persona en concreto
     * @param idPersona
     * @param idExpediente
     * @return
     */
    CicloMarcadoPolitica buscarPoliticasParaPersonaExpediente(Long idPersona, Long idExpediente);
    
    List<Politica> buscarPoliticasPorCmp(Long cmpId);
}
