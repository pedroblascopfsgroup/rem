package es.pfsgroup.plugin.recobro.bpm.handlers;

import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.controlcalidad.manager.api.ControlCalidadManager;
import es.pfsgroup.plugin.controlcalidad.model.ControlCalidadProcedimientoDto;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroMetaVolante;

/**
 * Handler específico para controlar los timers del procedimiento de Recobro
 * @author Guillem
 *
 */
@Component
public class RecobroTimerDelayActionHandler extends RecobroGenericActionHandler {
	
    private static final long serialVersionUID = 1L;
    
    private static final Log logger = LogFactory.getLog(RecobroTimerDelayActionHandler.class);
    
	@Autowired
	protected ApiProxyFactory proxyFactory;
	
	@Autowired
	private ControlCalidadManager controlCalidadManager;
    
    private String name = "Calculo del Timer de la meta volante";
    
    private String duration = "1 days";
    
    private String transicion = "avanzaBPM";

    /**
     * Calcula el nuevo timer del procedimiento de Recobro
     */
	@Override
	public void execute(ExecutionContext executionContext) throws Exception {
		ExpedienteRecobro expediente = null;
		try{
			// Recalculamos los días que faltan para la siguiente meta volante
			// Obtener la configuración de metas volantes para este expediente - subcartera - cartera - esquema
			expediente = getExpedienteRecobro(executionContext);		
			List<RecobroMetaVolante> listaMetasVolantes = expediente.getCicloRecobroActivo().getSubcartera().getItinerarioMetasVolantes().getMetasItinerario();
			// Calcular la siguiente meta volante a partir de la fecha de inicio del ciclo de vida activo	
			Date fechaAltaCicloRecobroActivo = expediente.getCicloRecobroActivo().getFechaAlta();
			RecobroMetaVolante recobroMetaVolante = obtenerProximaMetaVolante(listaMetasVolantes, fechaAltaCicloRecobroActivo);
			if(!Checks.esNulo(recobroMetaVolante)){
				// Calcular los días que faltan para la fecha de la siguiente meta volante y añdirlos a la variable duration	
				Long diasDiferencia = getDateDiff(new Date(System.currentTimeMillis()), 
						sumarRestarDiasFecha(fechaAltaCicloRecobroActivo, recobroMetaVolante.getDiasDesdeEntrega()), TimeUnit.DAYS);
				duration = String.valueOf(diasDiferencia) + "days";
				if (logger.isDebugEnabled()) {
		            logger.debug("RecobroTimerDelayActionHandler......");
		            logger.debug("[name=" + name + ", duration=" + duration + ", transition=" + transicion + "]");
		            logger.debug("Creando timer");
		        }		
				BPMUtils.createTimer(executionContext, name, duration, transicion);
			}else{
				// Si no hay próxima meta volante ya sea porque sea ha cumplido la última meta o hay error o es expedientes manuales? logamos y lanzamos excepción
				// Pensando en validaciones podríamos comprobar cuantos expedientes con ciclos activos de recobro tienen procedimientos sin timers
				logger.error("No se ha encontrado la siguiente meta volante, no se puede calcular el timer para el expediente " + expediente.getId());
				logger.error("Se configura un timer de 1 día para el expediente " + expediente.getId());
				if (logger.isDebugEnabled()) {
		            logger.debug("RecobroTimerDelayActionHandler......");
		            logger.debug("[name=" + name + ", duration=" + duration + ", transition=" + transicion + "]");
		            logger.debug("Creando timer");
		        }		
				BPMUtils.createTimer(executionContext, name, duration, transicion);
			}
		}catch(Throwable e){
			logger.error("Se ha producido un error en el método execute de la clase RecobroTimerDelayActionHandler", e);
			if(Checks.esNulo(expediente)) expediente = getExpedienteRecobro(executionContext);
			ControlCalidadProcedimientoDto controlCalidadProcedimientoDto = new ControlCalidadProcedimientoDto();
			controlCalidadProcedimientoDto.setDescripcion("Se ha producido un error calculando el timer para el expediente: " + expediente.getId());
			controlCalidadProcedimientoDto.setIdBPM(expediente.getProcessBpm());		
			controlCalidadProcedimientoDto.setIdEntidad(expediente.getId());	
			controlCalidadManager.registrarIncidenciaProcedimientoRecobro(controlCalidadProcedimientoDto);
		}
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDuration() {
		return duration;
	}

	public void setDuration(String duration) {
		this.duration = duration;
	}

	public String getTransicion() {
		return transicion;
	}

	public void setTransicion(String transicion) {
		this.transicion = transicion;
	}

	@Override
	protected void process(Object arg0, Object arg1, ExecutionContext arg2)
			throws Exception {
		
	}
		
}

