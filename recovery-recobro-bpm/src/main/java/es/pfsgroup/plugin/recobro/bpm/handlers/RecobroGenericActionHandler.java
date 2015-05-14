package es.pfsgroup.plugin.recobro.bpm.handlers;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recobro.bpm.constants.RecobroConstantsBPM.Genericas;
import es.pfsgroup.procedimientos.PROGenericActionHandler;
import es.pfsgroup.procedimientos.recoveryapi.TareaProcedimientoApi;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpedienteTareaNotificacion;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroMetaVolante;

/**
 * Clase abstracta generica para los handlers de Recobro
 * @author Guillem
 *
 */
public abstract class RecobroGenericActionHandler extends PROGenericActionHandler{

	private static final long serialVersionUID = 6523512050200173060L;
	
	@Autowired
	private JBPMProcessManager jbpmUtils;
	
	@Autowired
	private EXTTareaNotificacionManager tareaNotificacionManager;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	protected ApiProxyFactory proxyFactory;
	
	/**
	 * Obtiene el id del expediente desde el mapa de variables del contexto de ejeccción
	 * @param executionContext
	 * @return
	 */
	protected ExpedienteRecobro getExpedienteRecobro(ExecutionContext executionContext) {
		try{
			ExpedienteRecobro expediente = genericDao.get(ExpedienteRecobro.class, genericDao.createFilter(FilterType.EQUALS, "id",
					(Long) getVariable(Genericas.IDEXPEDIENTE_VARIABLE_NAME_INSTANCE, executionContext)));					
			if(Checks.esNulo(expediente)){
				String nombreProcedimiento = getNombreProceso(executionContext);
				// Destruimos el proceso BPM porque no podemos averiguar a que
				// procedimiento pertenece
				jbpmUtils.destroyProcess(executionContext.getProcessInstance().getId());
				//proxyFactory.proxy(JBPMProcessApi.class).destroyProcess(executionContext.getProcessInstance().getId());
				// Mostramos un mensaje de error
				String mensajeError = "El BPM en ejecuciï¿½n para el procedimiento " + nombreProcedimiento +
						" no tiene asociado un PRC_PROCEDIMIENTO y por tanto no puede continuar su ejecuciï¿½n";
				logger.error(mensajeError);
				throw new UserException("No se ha encontrado ningún expediente con ese id");
			}
			return expediente;
		}catch(Throwable e){
			logger.error("Se ha producido un error en el método getExpedienteRecobro de la clase RecobroGenericActionHandler", e);
			throw new UserException("bpm.error.script");
		}
	}
	
	/**
	 * Obtiene el script de validación para el nodo actual del procedimiento de recobro
	 * @param executionContext
	 * @return
	 */
	protected String getScriptValidaciónRecobro(ExecutionContext executionContext) {
		try{
			String name = executionContext.getNode().getName();
			TipoProcedimiento tipoProcedimiento =  genericDao.get(TipoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "P100"));
			TareaProcedimiento tp = proxyFactory.proxy(TareaProcedimientoApi.class).getByCodigoTareaIdTipoProcedimiento(tipoProcedimiento.getId(), name);
	    	String script = tp.getScriptDecision();
			if(Checks.esNulo(script)){
				String nombreProcedimiento = getNombreProceso(executionContext);
				// Destruimos el proceso BPM porque no podemos averiguar a que
				// procedimiento pertenece
				jbpmUtils.destroyProcess(executionContext.getProcessInstance().getId());
				//proxyFactory.proxy(JBPMProcessApi.class).destroyProcess(executionContext.getProcessInstance().getId());
				// Mostramos un mensaje de error
				String mensajeError = "El BPM en ejecuciï¿½n para el procedimiento " + nombreProcedimiento + 
						" no tiene asociado un PRC_PROCEDIMIENTO y por tanto no puede continuar su ejecuciï¿½n";
				logger.error(mensajeError);
				throw new UserException("No se ha encontrado ningún expediente con ese id");
			}
			return script;
		}catch(Throwable e){
			logger.error("Se ha producido un error en el método getScriptValidaciónRecobro de la clase RecobroGenericActionHandler", e);
			throw new UserException("bpm.error.script");
		}
	}
	
	/**
	 * Obtiene el valor resultante de la decisión
	 * @param executionContext
	 * @return
	 */
    protected String getDecision(ExecutionContext executionContext) {    	
    	String result = null;
    	ExpedienteRecobro expediente = getExpedienteRecobro(executionContext);       	
    	String script = getScriptValidaciónRecobro(executionContext);       
        Map<String, Object> context = new HashMap<String, Object>();
        context.put("idExpediente", expediente.getId());
        try {
        	result = jbpmUtils.evaluaScriptRecobro(expediente.getId(), context, script).toString();
            //result = proxyFactory.proxy(JBPMProcessApi.class).evaluaScript(expediente.getId(), null, null, context, script).toString();
        } catch (Throwable e) {
            logger.error("Error en el script de decisi�n [" + script + "]. Expediente [" + expediente.getId() + "], nodo ["
                    + executionContext.getNode().getName() + "].", e);
            throw new UserException("bpm.error.script");
        }
        return result;
    }
    
	/**
	 * Método que marca un expediente para rearquetipado por parte del Batch de Recobro
	 * @param executionContext
	 */
    protected void marcarExpedienteRecobro(ExecutionContext executionContext) {
        try {
        	ExpedienteRecobro expediente = genericDao.get(ExpedienteRecobro.class, genericDao.createFilter(FilterType.EQUALS, "id",
    				(Long) getVariable(Genericas.IDEXPEDIENTE_VARIABLE_NAME_INSTANCE, executionContext)));	
        	expediente.getCicloRecobroActivo().setMarcadoBpm(true);
        	expediente.getCicloRecobroActivo().setMarcadoBpmFecha(new Date(System.currentTimeMillis()));
        	genericDao.update(ExpedienteRecobro.class, expediente);
        	Long idNotificacion = tareaNotificacionManager.crearNotificacion(expediente.getId(), 
					DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, Genericas.REC_MARCADO_EXP, Genericas.MARCADO_EXPEDIENTE);
			CicloRecobroExpedienteTareaNotificacion cicloRecobroExpedienteTareaNotificacion = new CicloRecobroExpedienteTareaNotificacion();
			cicloRecobroExpedienteTareaNotificacion.setCicloRecobroExpediente(expediente.getCicloRecobroActivo());
			cicloRecobroExpedienteTareaNotificacion.setTareaNotificacion(genericDao.get(EXTTareaNotificacion.class, genericDao.createFilter(FilterType.EQUALS, Genericas.ID, idNotificacion)));
			genericDao.save(CicloRecobroExpedienteTareaNotificacion.class, cicloRecobroExpedienteTareaNotificacion);			
        } catch (Throwable e) {
            logger.error("Se ha producido un error en el método marcarExpedienteRecobro de la clase RecobroGenericActionHandle", e);
            throw new UserException("bpm.error.script");
        }
    }
    
	/**
	 * Obtiene la próxima meta volante configurada según su fecha de alta del ciclo activo de recobro
	 * @param listaMetasVolantes
	 * @param fechaAltaCicloRecobroActivo
	 * @return
	 */
	protected RecobroMetaVolante obtenerProximaMetaVolante(List<RecobroMetaVolante> listaMetasVolantes, Date fechaAltaCicloRecobroActivo){
		RecobroMetaVolante resultado = null;
		Long aux = new Long(1000);
		try{
			Long diasDiferencia = getDateDiff(fechaAltaCicloRecobroActivo, new Date(System.currentTimeMillis()), TimeUnit.DAYS); 
			// Esto se puede mejorar si donde calculamos si ha cumplido la meta insertamos una variable con el orden de la meta volante en la que estamos
			// también se podría meter en esta clase cuando obtenemos la siguiente meta volante			
			for (RecobroMetaVolante recobroMetaVolante : listaMetasVolantes) {
				if(diasDiferencia < recobroMetaVolante.getDiasDesdeEntrega()){
					if(diasDiferencia < aux){
						aux = diasDiferencia;
						resultado = recobroMetaVolante;
					}
				}
			}
		}catch(Throwable e){
			logger.error("Se ha producido un error en el método obtenerProximaMetaVolante de la clase RecobroTimerDelayActionHandler", e);
			throw new UserException("bpm.error.script");			
		}
		return resultado;
	}
	
	/**
	 * Get a diff between two dates
	 * @param date1 the oldest date
	 * @param date2 the newest date
	 * @param timeUnit the unit in which you want the diff
	 * @return the diff value, in the provided unit
	 */
	protected static long getDateDiff(Date date1, Date date2, TimeUnit timeUnit) {
	    long diffInMillies = date2.getTime() - date1.getTime();
	    return timeUnit.convert(diffInMillies,TimeUnit.MILLISECONDS);
	}
	
	/**
	 * Suma o resta días a una fecha ya sea el int positivo o negativo
	 * @param fecha
	 * @param dias
	 * @return
	 */
	protected Date sumarRestarDiasFecha(Date fecha, int dias){
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(fecha); // Configuramos la fecha que se recibe
		calendar.add(Calendar.DAY_OF_YEAR, dias);  // numero de días a añadir, o restar en caso de días<0
		return calendar.getTime(); // Devuelve el objeto Date con los nuevos días añadidos
	}
	
}
