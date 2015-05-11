package es.capgemini.pfs.comite.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.comite.model.SesionComite;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * @author Andrés Esteban
 *
 */
public interface SesionComiteDao extends AbstractDao<SesionComite, Long> {

    /**
     * Devuelve el usuario supervisor de una sesión de comité.
     * @param sesionId el id de la sesion
     * @return el usuario supervisor
     */
    Usuario getSupervisorSesion(Long sesionId);

    /**
     * Busca los asuntos relacionados con la sesión.
     * @param idSesion long
     * @return lista de asuntos
     */
    List<Asunto> buscarAsuntos(Long idSesion);

    /**
     * Busca los expedientes relacionados con la sesión.
     * @param idSesion long
     * @return lista de expedientes
     */
    List<Expediente> buscarExpedientes(Long idSesion);

    /**
     * Busca los ciclos de marcado de políticas de las personas de
     * los expedientes relacionados con la sesión.
     * @param idSesion long
     * @return List CicloMarcadoPolitica
     */
    List<CicloMarcadoPolitica> buscarMarcadosPoliticaExpedientes(Long idSesion);
}
