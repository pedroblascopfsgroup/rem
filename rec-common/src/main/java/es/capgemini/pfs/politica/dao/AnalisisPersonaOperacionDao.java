package es.capgemini.pfs.politica.dao;

import java.util.List;

import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.AnalisisPersonaOperacion;

/**
 * Interfaz de acceso a datos de AnalisisPersonaOperacion.
 * @author pamuller
 *
 */
public interface AnalisisPersonaOperacionDao extends AbstractDao<AnalisisPersonaOperacion, Long> {

    /**
     * devuelve las operaciones para la persona.
     * @param idPersona la persona para la que se buscan las operaciones.
     * @return las operaciones de la persona.
     */
    List<AnalisisPersonaOperacion> buscarOperaciones(Long idPersona);

    /**
     * Devuelve un listado de las operaciones que no se han completado todavia para una persona y un expediente
     * @param idPersona
     * @param idExpediente
     * @return
     */
    List<Contrato> getOperacionesSinCompletar(Long idPersona, Long idExpediente);

}
