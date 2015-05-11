package es.capgemini.pfs.cliente.process;

import java.util.Date;

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
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.telecobro.dao.MotivosExclusionTelecobroDao;
import es.capgemini.pfs.telecobro.dao.SolicitudExclusionTelecobroDao;
import es.capgemini.pfs.telecobro.model.EstadoTelecobro;
import es.capgemini.pfs.telecobro.model.SolicitudExclusionTelecobro;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Inicia el proceso de solicitar un exclusión para telecobro.
 * @author aesteban
 *
 */
@Component
public class SolicitarExcluirTelecobroActionHandler extends JbpmActionHandler implements ClienteBPMConstants {

    private static final long serialVersionUID = 1L;
    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ClienteManager clienteManager;
    @Autowired
    private JBPMProcessManager jbpmUtil;
    @Autowired
    private MotivosExclusionTelecobroDao motivosExclusionTelecobroDao;
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
        logger.debug("SolicitarExcluirTelecobroActionHandler......");

        Long clienteId = (Long) executionContext.getVariable(CLIENTE_ID);

        Cliente cliente = clienteManager.getWithEstado(clienteId);

        Long milliseconds = calcularPlazo(cliente);

        // Borro el timer de verificarTelecobro
        BPMUtils.deleteTimer(executionContext, TIMER_TELECOBRO);

        //Obtengo la tarea de verificarTelecobro y la elimino
        Long idTareaTelecobro = new Long(executionContext.getVariable(TAREA_ASOCIADA_TELECOBRO).toString());
        notificacionManager.borrarNotificacionTarea(idTareaTelecobro);

        SolicitudExclusionTelecobro solicitud = new SolicitudExclusionTelecobro();
        solicitud.setObservaciones((String) executionContext.getVariable(OBSERVACION));
        solicitud.setCliente(cliente);
        solicitud.setMotivoExclusion(motivosExclusionTelecobroDao.buscarPorCodigo((String) executionContext.getVariable(MOTIVO_EXCLUSION_ID)));
        solicitudExclusionTelecobroDao.save(solicitud);

        executionContext.setVariable(SOLICITUD_ASOCIADA_TELECOBRO_ID, solicitud.getId());

        // Creo la tarea de solicitar exclusión de telecobro
        DtoGenerarTarea dto = new DtoGenerarTarea(clienteId, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE,
                SubtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO, true, false, milliseconds, null);
        idTareaTelecobro = notificacionManager.crearTarea(dto);

        TareaNotificacion tarea = notificacionManager.get(idTareaTelecobro);
        tarea.setSolicitudExclusionTelecobro(solicitud);
        notificacionManager.saveOrUpdate(tarea);
        executionContext.setVariable(TAREA_ASOCIADA_TELECOBRO, idTareaTelecobro);

        String durationString = milliseconds / MILLISECONDS + " seconds";

        BPMUtils.createTimer(executionContext, TIMER_TELECOBRO, durationString, TRANSITION_CON_TELECOBRO);
    }

    /**
     * Calcula el plazo para el inicio del telecobro
     * <ul>
     * <li>Retorna el plazo si el tiempo transcurrido mas el plazo es menor a la fecha de inicio del telecobro.</li>
     * <li>Retorna los segundos que falta del timer actual si el tiempo transcurrido mas el plazo es mayor a la fecha de inicio del telecobro.</li>
     * </ul>
     * @param cliente
     * @return integer
     */
    private Long calcularPlazo(Cliente cliente) {
        Date fechaFin = jbpmUtil.obtenerFechaFinProceso(cliente.getProcessBPM(), TIMER_TELECOBRO);
        Estado estadoCarencia = cliente.getArquetipo().getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        EstadoTelecobro estTelecobro = estadoCarencia.getEstadoTelecobro();

        Date hoy = new Date();

        Long milesecondLeft = fechaFin.getTime() - hoy.getTime();

        Long plazo = milesecondLeft + estTelecobro.getPlazoRespuesta();
        if (plazo < estTelecobro.getPlazoInicial()) {
            //return plazo.intValue() / MILLISECONDS;
            return plazo;
        }
        //return milesecondLeft.intValue() / MILLISECONDS;
        return milesecondLeft;
    }
}
