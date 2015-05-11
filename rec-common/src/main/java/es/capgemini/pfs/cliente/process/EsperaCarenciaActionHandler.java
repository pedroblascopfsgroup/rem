package es.capgemini.pfs.cliente.process;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.def.ActionHandler;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.cliente.ClienteManager;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.itinerario.EstadoProcesoManager;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * Clase que maneja el estado EsperarCarencia.
 * @author jbosnjak
 *
 */
@Component
public class EsperaCarenciaActionHandler implements ActionHandler, ClienteBPMConstants {

    private static final long serialVersionUID = 1L;
    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ClienteManager clienteManager;
    @Autowired
    private EstadoProcesoManager estadoProcesoManager;

    /**
     * Espera una determinada cantidad de tiempo.
     * @param executionContext Contexto JBPM
     * @throws Exception e
     */
    public void execute(ExecutionContext executionContext) throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("EsperaCarenciaActionHandler......");
        }
        Long tiempoVencido = (Long) executionContext.getVariable(TIEMPO_VENCIDO_CLIENTE);
        Long clienteId = (Long) executionContext.getVariable(CLIENTE_ID);

        Cliente cliente = clienteManager.getWithEstado(clienteId);

        Estado estadoCarencia = cliente.getArquetipo().getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA);

        cliente.setFechaEstado(new Date());

        estadoProcesoManager.pasarDeEstado(clienteId, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE, estadoCarencia, executionContext
                .getProcessInstance().getId());
        clienteManager.saveOrUpdate(cliente);

        Long plazo = 0L;
        if (tiempoVencido > 0) {
            plazo = estadoCarencia.getPlazo() - tiempoVencido;
        } else {
            plazo = estadoCarencia.getPlazo();
        }
        if (plazo < 0L) {
            plazo = UN_SEGUNDO;
        }

        executionContext.setVariable(TIEMPO_VENCIDO_CLIENTE, tiempoVencido - estadoCarencia.getPlazo());

        String durationString = (plazo / MILLISECONDS) + " seconds";
        BPMUtils.createTimer(executionContext, TIMER_CARENCIA_CLIENTE, durationString, TRANSTION_ENVIAR_GESTION_VENCIDOS);
    }
}
