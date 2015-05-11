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
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.telecobro.model.EstadoTelecobro;

/**
 * Inicia el proceso de verificar el telecobro.
 * @author aesteban
 *
 */
@Component
public class VerificarTelecobroActionHandler extends JbpmActionHandler implements ClienteBPMConstants {

    private static final long serialVersionUID = 1L;
    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ClienteManager clienteManager;

    @Autowired
    private TareaNotificacionManager notificacionManager;

    /**
     * Envia a Gestion de vencidos.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        logger.debug("VerificarTelecobroActionHandler......");

        Long clienteId = (Long) executionContext.getVariable(CLIENTE_ID);

        Cliente cliente = clienteManager.getWithEstado(clienteId);

        Estado estadoCarencia = cliente.getArquetipo().getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        EstadoTelecobro estTelecobro = estadoCarencia.getEstadoTelecobro();
        Long seconds = calcularPlazo(estTelecobro);
        if (!estTelecobro.getAutomatico()) {
            DtoGenerarTarea dto = new DtoGenerarTarea(clienteId, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE,
                    SubtipoTarea.CODIGO_TAREA_VERIFICAR_TELECOBRO, false, false, seconds * MILLISECONDS, null);
            Long idTareaVerificarTelecobro = notificacionManager.crearTarea(dto);

            executionContext.setVariable(TAREA_ASOCIADA_TELECOBRO, idTareaVerificarTelecobro);
        }
        String durationString = seconds + " seconds";
        BPMUtils.createTimer(executionContext, TIMER_TELECOBRO, durationString, TRANSITION_CON_TELECOBRO);

    }

    /**
     * Calcula el plazo para el verificar del telecobro en segundos.
     * @param estTelecobro EstadoTelecobro
     * @return integer
     */
    private Long calcularPlazo(EstadoTelecobro estTelecobro) {
        //La fecha de fin deberia ser menor a la fecha de inicio
        Long seconds = estTelecobro.getDiasAntelacion() * SECONDS_IN_A_DAY;
        if (seconds < estTelecobro.getPlazoInicial() / MILLISECONDS) { return seconds; }
        return estTelecobro.getPlazoInicial() / MILLISECONDS;
    }

}
