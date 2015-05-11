package es.capgemini.pfs.asunto.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.cliente.dto.DtoListadoAsuntos;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Clase que agrupa mï¿½todo para la creaciï¿½n y acceso de datos de los
 * asuntos.
 * @author mtorrado
 *
 */
public interface AsuntoDao extends AbstractDao<Asunto, Long> {

    /**
     * Obtiene los asuntos de una persona.
     * @param idPersona persona
     * @return asuntos
     */
    List<Asunto> obtenerAsuntosDeUnaPersona(Long idPersona);

    /**
     * Obtiene los asuntos de un asunto.
     * @param idAsunto el id del asunto
     * @return la lista de asuntos asociados
     */
    List<Asunto> obtenerAsuntosDeUnAsunto(Long idAsunto);

    /**
     * Obtiene los asuntos de un expediente.
     * @param idExpediente el id del expediente
     * @return la lista de asuntos asociados
     */
    List<Asunto> obtenerAsuntosDeUnExpediente(Long idExpediente);

    /**
     * @param idAsunto Long
     * @return List Persona: todas las personas demandadas en los procedimientos del asunto.
     */
    List<Persona> obtenerPersonasDeUnAsunto(Long idAsunto);

    /**
     * @param idAsunto Long
     * @return List Persona: todas las personas demandadas en los procedimientos del asunto, con adjuntos.
     */
    List<Persona> obtenerPersonasDeUnAsuntoConAdjuntos(Long idAsunto);

    /**
     * Crea un asunto con un gestor determinado y estado ESTADO_ASUNTO_EN_CONFORMACION.
     * @param gestorDespacho el gestor seleccionado.
     * @param supervisor El supervisor seleccionado.
     * @param procurador El procurador (si existe) o null
     * @param nombreAsunto el nombre del asunto.
     * @param expediente el expediente al que corresponde el asunto.
     * @param observaciones las observaciones
     * @return el id del asunto que se generï¿½.
     */
    Long crearAsunto(GestorDespacho gestorDespacho, GestorDespacho supervisor, GestorDespacho procurador, String nombreAsunto, Expediente expediente,
            String observaciones);

    /**
     * Modifica un Asunto.
     * @param idAsunto el id del asunto a modificar
     * @param gestorDespacho el gestor nuevo.
     * @param supervisor el supervisor nuevo.
     * @param nombreAsunto el nuevo nombre del Asunto.
     * @param observaciones las obeservaciones.
     * @return el id del asunto.
     */
    Long modificarAsunto(Long idAsunto, GestorDespacho gestorDespacho, GestorDespacho supervisor, GestorDespacho procurador, String nombreAsunto,
            String observaciones);

    /**
     * Hace la busqueda de asuntos.
     * @param dto los parámetros de los asuntos
     * @return Asuntos paginados
     */
    Page buscarAsuntosPaginated(DtoBusquedaAsunto dto);

    /**
     * Indica si el usuario logueado tiene que responder alguna comunicaciÃ³n.
     * @param idAsunto el id del asunto.
     * @param usuarioLogado el usuario logueado
     * @return true o false;
     */
    TareaNotificacion buscarTareaPendiente(Long idAsunto, Long usuarioLogado);

    /**
     * Devuelve todos los contratos relacionados al asunto que tengan archivos adjuntos.
     * @param asuntoId Long
     * @return List Contrato
     */
    List<Contrato> getContratosQueTienenAdjuntos(Long asuntoId);

    /**
     * Devuelve una lista de procedimientos ordenados por nro de Procedimiento en el Juzgado, ID.
     * @param idAsunto Long
     * @return lista de procedimientos
     */
    List<Procedimiento> getProcedimientosOrderNroJuzgado(Long idAsunto);

    /**
     * Busca de entre todos los asuntos si existe otro con el mismo nombre
     * @param nombreAsunto
     * @param idAsuntoOriginal Si es un asunto ya existente se comprueba que el nombre seleccionado sea de otro asunto y no del original
     * @return
     */
    Boolean isNombreAsuntoDuplicado(String nombreAsunto, Long idAsuntoOriginal);

    /**
     * Recupera el número de asuntos con el mismo nombre
     * @param nombreAsunto
     * @return
     */
    Long getNumAsuntosMismoNombre(String nombreAsunto);

    /**
     * Recupera los asuntos de una persona paginados
     * @param dto
     * @return
     */
    Page obtenerAsuntosDeUnaPersonaPaginados(DtoListadoAsuntos dto);
}
