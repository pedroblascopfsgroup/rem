package es.pfsgroup.procedimientos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.core.api.cliente.ClienteApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.telecobro.dao.SolicitudExclusionTelecobroDao;
import es.capgemini.pfs.telecobro.model.EstadoTelecobro;
import es.capgemini.pfs.telecobro.model.SolicitudExclusionTelecobro;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

public class PROConTelecobroActionHandler extends PROBaseActionHandler implements ClienteBPMConstants{

	private static final long serialVersionUID = -7048651613858360107L;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
    private SolicitudExclusionTelecobroDao solicitudExclusionTelecobroDao;
	
	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		logger.debug("ConTelecobroActionHandler......");

        Long clienteId = (Long) executionContext.getVariable(CLIENTE_ID);

        // Borro el timer de solicitarExclusi�nTelecobro o verificarTelecobro
        BPMUtils.deleteTimer(executionContext, TIMER_TELECOBRO);

        Cliente cliente = proxyFactory.proxy(ClienteApi.class).getWithEstado(clienteId);

        Estado estadoCarencia = cliente.getArquetipo().getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        EstadoTelecobro estTelecobro = estadoCarencia.getEstadoTelecobro();

        cliente.setTelecobro(true);
        cliente.setProveedorTelecobro(estTelecobro.getProveedor());
        if (!estTelecobro.getAutomatico()) {
            // Obtengo la tarea de verificarTelecobro o solicitatExclusionTelecobro y la elimino
            Long idTareaTelecobro = new Long(executionContext.getVariable(TAREA_ASOCIADA_TELECOBRO).toString());
            proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(idTareaTelecobro);

            // Si la solicitud es rechazada
            Long solicitudId = (Long) executionContext.getVariable(SOLICITUD_ASOCIADA_TELECOBRO_ID);
            if (solicitudId != null) {
                SolicitudExclusionTelecobro solicitud = solicitudExclusionTelecobroDao.get(solicitudId);
                solicitud.setRespuesta((String) executionContext.getVariable(RESPUESTA));
                solicitud.setAceptada(false);
                solicitudExclusionTelecobroDao.saveOrUpdate(solicitud);

                Long notificacionId = proxyFactory.proxy(TareaNotificacionApi.class).crearNotificacion(clienteId, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE,
                        SubtipoTarea.CODIGO_TAREA_RESPUESTA_SOLICITUD_EXCLUSION_TELECOBRO, null);

                TareaNotificacion notificacion = proxyFactory.proxy(TareaNotificacionApi.class).get(notificacionId);
                notificacion.setTareaId(proxyFactory.proxy(TareaNotificacionApi.class).get(idTareaTelecobro));
                notificacion.setSolicitudExclusionTelecobro(solicitud);
                proxyFactory.proxy(TareaNotificacionApi.class).saveOrUpdate(notificacion);
            }
        }
        executionContext.setVariable(TAREA_ASOCIADA_TELECOBRO, null);

        proxyFactory.proxy(ClienteApi.class).saveOrUpdate(cliente);
		
	}
}
