package es.capgemini.pfs.cliente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.cliente.ClienteManager;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.telecobro.dao.SolicitudExclusionTelecobroDao;
import es.capgemini.pfs.telecobro.model.EstadoTelecobro;
import es.capgemini.pfs.telecobro.model.SolicitudExclusionTelecobro;

/**
 * Inicia el proceso de un cliente con telecobro.
 * @author aesteban
 *
 */
@Component
public class ConTelecobroActionHandler extends JbpmActionHandler implements ClienteBPMConstants {

    private static final long serialVersionUID = 1L;
    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ClienteManager clienteManager;
    @Autowired
    private TareaNotificacionManager notificacionManager;
    @Autowired
    private SolicitudExclusionTelecobroDao solicitudExclusionTelecobroDao;

    /**
     * Envia a Gestion de vencidos.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        logger.debug("ConTelecobroActionHandler......");

        Long clienteId = (Long) executionContext.getVariable(CLIENTE_ID);

        // Borro el timer de solicitarExclusiónTelecobro o verificarTelecobro
        BPMUtils.deleteTimer(executionContext, TIMER_TELECOBRO);

        Cliente cliente = clienteManager.getWithEstado(clienteId);

        Estado estadoCarencia = cliente.getArquetipo().getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        EstadoTelecobro estTelecobro = estadoCarencia.getEstadoTelecobro();

        cliente.setTelecobro(true);
        cliente.setProveedorTelecobro(estTelecobro.getProveedor());
        if (!estTelecobro.getAutomatico()) {
            // Obtengo la tarea de verificarTelecobro o solicitatExclusionTelecobro y la elimino
            Long idTareaTelecobro = new Long(executionContext.getVariable(TAREA_ASOCIADA_TELECOBRO).toString());
            notificacionManager.borrarNotificacionTarea(idTareaTelecobro);

            // Si la solicitud es rechazada
            Long solicitudId = (Long) executionContext.getVariable(SOLICITUD_ASOCIADA_TELECOBRO_ID);
            if (solicitudId != null) {
                SolicitudExclusionTelecobro solicitud = solicitudExclusionTelecobroDao.get(solicitudId);
                solicitud.setRespuesta((String) executionContext.getVariable(RESPUESTA));
                solicitud.setAceptada(false);
                solicitudExclusionTelecobroDao.saveOrUpdate(solicitud);

                Long notificacionId = notificacionManager.crearNotificacion(clienteId, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE,
                        SubtipoTarea.CODIGO_TAREA_RESPUESTA_SOLICITUD_EXCLUSION_TELECOBRO, null);

                TareaNotificacion notificacion = notificacionManager.get(notificacionId);
                notificacion.setTareaId(notificacionManager.get(idTareaTelecobro));
                notificacion.setSolicitudExclusionTelecobro(solicitud);
                notificacionManager.saveOrUpdate(notificacion);
            }
        }
        executionContext.setVariable(TAREA_ASOCIADA_TELECOBRO, null);

        clienteManager.saveOrUpdate(cliente);

    }

}
