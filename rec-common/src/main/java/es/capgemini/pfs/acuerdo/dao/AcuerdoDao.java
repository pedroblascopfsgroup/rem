package es.capgemini.pfs.acuerdo.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.model.DDEntidadAcuerdo;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.acuerdo.dto.BusquedaAcuerdosDTO;

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
     * Devuelve el último acuerdo dado de alta para el Usuario pasado por parámetro.
     * @param usuario el Usuario
     * @return su último acuerdo.
     */
    Acuerdo getUltimoAcuerdoUsuario(Usuario usuario);
    
    /**
     * Devuelve los acuerdos de un expediente
     * @param idExpediente
     * @return
     */
    List<Acuerdo> getAcuerdosDelExpediente(Long idExpediente);

    /**
     * Devuelve los acuerdos de un expediente y los despachos
     * @param idExpediente
     * @param idsDespacho
     * @return
     */
    List<Acuerdo> getAcuerdosDelExpedienteDespacho(Long idExpediente, List<Long> idsDespacho);

    /**
     * Buscar otros Acuerdos vigentes para el mismo Asunto.
     * @param idAsunto el id del asunto.
     * @param idAcuerdo el id del acuerdo que se quiere guardar.
     * @return boolean
     */
    boolean hayAcuerdosVigentes(Long idAsunto, Long idAcuerdo);
    
    
    String getFechaPaseMora(Long idContrato);
    
    /**
     * Devuelve los tipos de entidad acuerdo
     * @return
     */
    List<DDEntidadAcuerdo> getListEntidadAcuerdo();

	Page buscarAcuerdos(BusquedaAcuerdosDTO dto);
    
}
