package es.pfsgroup.plugin.rem.jbpm.activo;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.jbpm.handler.BaseActionHandler;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;

@Service
@Scope(BeanDefinition.SCOPE_SINGLETON)
public class JBPMActivoTramiteManager implements JBPMActivoTramiteManagerApi {

    public static final String ESTADO_PROCEDIMIENTO_EN_TRAMITE = "10";
    public static final String ESTADO_PROCEDIMIENTO_FINALIZADO = "11";
    
    public static final String CODIGO_TAREA_CHECKING_ADMISION = "T001_CheckingDocumentacionAdmision";
    public static final String CODIGO_TAREA_CHECKING_GESTION = "T001_CheckingDocumentacionGestion";
    
    @Autowired
    private ActivoTareaExternaApi tareaExternaManagerApi;
    
    @Autowired
    private ActivoTramiteApi activoTramiteManagerApi;
    
    @Autowired
    private ActivoTareaExternaApi activoTareaExternaManagerApi;
    
    @Autowired
    JBPMProcessManagerApi jbpmProcessManagerApi;
    
    @Autowired
    UtilDiccionarioApi utilDiccionarioApi;
	
	@Override
	public Long lanzaBPMAsociadoATramite(Long idTramite) {
		return this.lanzaBPMAsociadoATramite(idTramite, null);
	}

	@Override
	public ActivoTramite creaActivoTramiteHijo(TipoProcedimiento tipoProcedimiento, ActivoTramite activoTramitePadre) {
		
		ActivoTramite activoTramiteHijo = new ActivoTramite();
		
		activoTramiteHijo.setActivo(activoTramitePadre.getActivo());
		activoTramiteHijo.setTramitePadre(activoTramitePadre);
		activoTramiteHijo.setTipoActuacion(activoTramitePadre.getTipoActuacion());
		activoTramiteHijo.setTipoTramite(tipoProcedimiento);

        DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento)utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoProcedimiento.class
        		,DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
        
        activoTramiteHijo.setEstadoTramite(estadoProcedimiento);

        Long idTramite = activoTramiteManagerApi.saveOrUpdateActivoTramite(activoTramiteHijo);

        return activoTramiteManagerApi.get(idTramite);
	}
	
	
	public ActivoTramite creaActivoTramite(TipoProcedimiento tipoProcedimiento, Activo activo) {
		
		ActivoTramite activoTramite = new ActivoTramite();
		
		activoTramite.setActivo(activo);
		activoTramite.setTramitePadre(null);
		activoTramite.setTipoActuacion(tipoProcedimiento.getTipoActuacion());
		activoTramite.setTipoTramite(tipoProcedimiento);
		activoTramite.setFechaInicio(new Date());

        DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento)utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoProcedimiento.class
        		,ESTADO_PROCEDIMIENTO_EN_TRAMITE);
        
        activoTramite.setEstadoTramite(estadoProcedimiento);

        Long idTramite = activoTramiteManagerApi.saveOrUpdateActivoTramite(activoTramite);

        return activoTramiteManagerApi.get(idTramite);
	}

	public ActivoTramite createActivoTramiteTrabajo(TipoProcedimiento tipoProcedimiento, /*Activo activo, */Trabajo trabajo) {
		
		ActivoTramite activoTramite = new ActivoTramite();
		
		//Cuando es un trámite que se crea a partir de un trabajo, no se rellenaría el activo, sino que se cogería del trabajo
		/*activoTramite.setActivo(activo);*/
		activoTramite.setTramitePadre(null);
		activoTramite.setTipoActuacion(tipoProcedimiento.getTipoActuacion());
		activoTramite.setTipoTramite(tipoProcedimiento);
		activoTramite.setFechaInicio(new Date());
		activoTramite.setTrabajo(trabajo);

        DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento)utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoProcedimiento.class
        		,ESTADO_PROCEDIMIENTO_EN_TRAMITE);
        
        activoTramite.setEstadoTramite(estadoProcedimiento);

        Long idTramite = activoTramiteManagerApi.saveOrUpdateActivoTramite(activoTramite);

        return activoTramiteManagerApi.get(idTramite);
	}
	
	@Override
	public Long lanzaBPMAsociadoATramite(Long idTramite, Long idTokenAviso) {
		
        ActivoTramite activoTramite = activoTramiteManagerApi.get(idTramite);

        //Lanzamos el BPM nuevo asociandolo al nuevo procedimiento
        String procesoJBPM = activoTramite.getTipoTramite().getXmlJbpm();
        Map<String, Object> params = new HashMap<String, Object>();
        
        params.put(BaseActionHandler.ACTIVO_TRAMITE_TAREA_EXTERNA, idTramite);
        if (idTokenAviso != null) {
            params.put(BPMContants.TOKEN_JBPM_PADRE, idTokenAviso);
        }

        long idProcessBPM = jbpmProcessManagerApi.crearNewProcess(procesoJBPM, params);

        //Escribimos el id de proceso BPM en el objeto ActivoTramite
        activoTramite.setProcessBPM(idProcessBPM);
        activoTramiteManagerApi.saveOrUpdateActivoTramite(activoTramite);

        return idProcessBPM;
	}

	@Override
	public void finalizarTramite(Long idTramite) throws Exception {
		
        ActivoTramite activoTramite = activoTramiteManagerApi.get(idTramite);

        if (activoTramite == null) { throw new UserException("El trámite [" + idTramite + "] no existe en la BD"); }

        Long idProcess = activoTramite.getProcessBPM();
        if (idProcess != null) {

            //Destruimos el proceso
        	jbpmProcessManagerApi.destroyProcess(idProcess);

            //Eliminamos las tareas Externas del trámite que aún están activas
            List<TareaExterna> vTareas = activoTareaExternaManagerApi.getActivasByIdTramite(idTramite,null);
            Iterator<TareaExterna> it = vTareas.iterator();

            while (it.hasNext()) {
                TareaExterna tareaExterna = it.next();
                activoTareaExternaManagerApi.borrar(tareaExterna);
            }

        }

	}

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcedimientoContextScriptManagerApi#creaMapValores(java.lang.Long)
	 */
	public Map<String, Map<String, String>> creaMapValores(Long idTramite) {
        List<TareaExterna> tareas = tareaExternaManagerApi.getTareasByIdTramite(idTramite);
        Map<String, Map<String, String>> valores = new HashMap<String, Map<String, String>>();

        if (tareas != null) {
            for (TareaExterna tarea : tareas) {
                String codigo = tarea.getTareaProcedimiento().getCodigo();

                //Queremos meter todas las tareas aunque sean repetitivas. A las repetitivas le iremos incrementando un contador
                String temp = codigo;
                int contador = 0;

                // TODO: Simplificación funcional:
                // comentamos esta parte para que cuando se encuentre con varias tareas que se llaman igual (bucles) se quede con los datos de la última tarea.
                // sino almacenaría los valores:  tarea[P11_Leer], tarea[P11_Leer_1], etc. y al ir a por el valor de la tarea siempre cogerá el de la primera
                // que introducimos.
                
//                //Mientras el nombre ya esté en el map, vamos incrementando el contador
//                while (valores.containsKey(temp)) {
//                    contador++;
//                    temp = codigo + "_" + contador;
//                }

                /*
                 * Ya tenemos el nombre de la tarea único en el map, con esto tendremos:
                 *
                 * tarea[P11_Leer] = xxx <-- Esta es la última vez que se ejecutó la tarea
                 * tarea[P11_Leer_1] = yyy <-- Esta es la segunda vez que se ejecutó la tarea
                 * tarea[P11_Leer_2] = zzz <-- Esta es la primera vez que se ejecutó esta tarea
                 * tarea[P11_Escribir] = xxx
                 *
                */
                // codigo = temp; // TODO: Comentado para la simplificación funcional.

                //Si el código no está en el Map lo introducimos (esto es para evitar que se pase dos veces por la misma tarea)
//                if (!valores.containsKey(codigo)) { // TODO: Comentado para la simplificación funcional.
                    Map<String, String> valoresTarea = new HashMap<String, String>();

                    List<TareaExternaValor> vValores = tareaExternaManagerApi.obtenerValoresTarea(tarea.getId());
                    //List<TareaExternaValor> vValores = tarea.getValores();

                    if (vValores != null) {
                        for (TareaExternaValor valor : vValores) {
                            valoresTarea.put(valor.getNombre(), valor.getValor());
                        }
                    }
                    valores.put(codigo, valoresTarea);
//                } // TODO: Comentado para la simplificación funcional.
            }
        }

        return valores;
    }
	
	@Transactional
	public void paralizarTareasChecking(ActivoTramite tramite){
		// En caso de que la fecha esté rellena no tenemos que paralizar las tareas
		
		//if(Checks.esNulo(tramite.getActivo().getBien().getAdjudicacion().getFechaRealizacionPosesion()))
		if(Checks.esNulo(tramite.getActivo().getSituacionPosesoria().getFechaTomaPosesion()))
		{
			List<TareaExterna> listaTareas = activoTareaExternaManagerApi.getTareasByIdTramite(tramite.getId());
			
			for(TareaExterna tarea : listaTareas){
				if(CODIGO_TAREA_CHECKING_ADMISION.equals(tarea.getTareaProcedimiento().getCodigo()) || 
						CODIGO_TAREA_CHECKING_GESTION.equals(tarea.getTareaProcedimiento().getCodigo())){
					((TareaActivo)tarea.getTareaPadre()).setBorrado(true);
					tarea.setDetenida(true);
				}
			}
		}
	}

}
