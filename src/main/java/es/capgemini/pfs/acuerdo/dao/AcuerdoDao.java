package es.capgemini.pfs.acuerdo.dao;

import java.util.List;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * @author maruiz
 *
 */
public interface AcuerdoDao extends AbstractDao<Acuerdo, Long> {

    /**
     * Busca Acuerdos de un asunto.
     * @param idAsunto id del asunto
     * @return lista Acuerdo.
     */
    List<Acuerdo> getAcuerdosDelAsunto(Long idAsunto);

    /**
     * Devuelve el �ltimo acuerdo dado de alta para el Usuario pasado por par�metro.
     * @param usuario el Usuario
     * @return su �ltimo acuerdo.
     */
    Acuerdo getUltimoAcuerdoUsuario(Usuario usuario);

    /**
     * Devuelve los acuerdos de un expediente
     * @param despacho
     * @return
     */
    List<Acuerdo> getAcuerdosDelExpediente(Long idExpediente);

    /**
     * Devuelve los acuerdos de un expediente y despacho
     * @param despacho
     * @return
     */
    List<Acuerdo> getAcuerdosDelExpedienteDespacho(Long idExpediente, Long idDespacho);
    
    /**
     * Buscar otros Acuerdos vigentes para el mismo Asunto.
     * @param idAsunto el id del asunto.
     * @param idAcuerdo el id del acuerdo que se quiere guardar.
     * @return boolean
     */
    boolean hayAcuerdosVigentes(Long idAsunto, Long idAcuerdo);
}
