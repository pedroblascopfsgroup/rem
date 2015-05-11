package es.capgemini.pfs.cliente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.cliente.ClienteManager;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.telecobro.dao.SolicitudExclusionTelecobroDao;
import es.capgemini.pfs.telecobro.model.SolicitudExclusionTelecobro;

/**
 * Inicia el proceso de un cliente sin telecobro.
 * @author aesteban
 *
 */
@Component
public class SinTelecobroActionHandler extends JbpmActionHandler implements ClienteBPMConstants {

    /**
	 * serial.
	 */
	private static final long serialVersionUID = -6637787816506547314L;

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
        logger.debug("SinTelecobroActionHandler......");

        Long clienteId = (Long) executionContext.getVariable(CLIENTE_ID);

        // Borro el timer de solicitarExclusi�nTelecobro
        BPMUtils.deleteTimer(executionContext, TIMER_TELECOBRO);

        Cliente cliente = clienteManager.getWithEstado(clienteId);

        cliente.setTelecobro(false);
        cliente.setProveedorTelecobro(null);

        // Obtengo la tarea de solicitatExclusionTelecobro y la elimino
        Long idTareaTelecobro = new Long(executionContext.getVariable(TAREA_ASOCIADA_TELECOBRO).toString());
        notificacionManager.borrarNotificacionTarea(idTareaTelecobro);
        executionContext.setVariable(TAREA_ASOCIADA_TELECOBRO, null);

        clienteManager.saveOrUpdate(cliente);

        //La solicitud es aceptada
        Long solicitudId = (Long) executionContext.getVariable(SOLICITUD_ASOCIADA_TELECOBRO_ID);
        SolicitudExclusionTelecobro solicitud = solicitudExclusionTelecobroDao.get(solicitudId);
        solicitud.setRespuesta((String) executionContext.getVariable(RESPUESTA));
        solicitud.setAceptada(true);
        solicitudExclusionTelecobroDao.saveOrUpdate(solicitud);

        Long notificacionId = notificacionManager.crearNotificacion(clienteId, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE,
                SubtipoTarea.CODIGO_TAREA_RESPUESTA_SOLICITUD_EXCLUSION_TELECOBRO, null);

        TareaNotificacion notificacion = notificacionManager.get(notificacionId);
        notificacion.setTareaId(notificacionManager.get(idTareaTelecobro));
        notificacion.setSolicitudExclusionTelecobro(solicitudExclusionTelecobroDao.get(solicitudId));
        notificacionManager.saveOrUpdate(notificacion);
    }

}
