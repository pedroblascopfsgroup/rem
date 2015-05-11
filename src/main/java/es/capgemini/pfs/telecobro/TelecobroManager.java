package es.capgemini.pfs.telecobro;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.telecobro.dao.MotivosExclusionTelecobroDao;
import es.capgemini.pfs.telecobro.dto.DtoTelecobro;
import es.capgemini.pfs.telecobro.model.DDMotivosExclusionTelecobro;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Servicios de telecobro.
 * @author aesteban
 */
@Service
public class TelecobroManager implements ClienteBPMConstants {


	@Autowired
	private Executor executor;

    @Autowired
    private MotivosExclusionTelecobroDao motivosExclusionTelecobroDao;

    /**
     * Retorna la tarea de telecobro.
     * @param idCliente long
     * @return TareaNotificacion
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TELECOBRO_MGR_GET_TAREA_TELECOBRO)
    public TareaNotificacion getTareaTelecobro(Long idCliente) {
        //Persona persona = personaDao.get(idCliente);
        for (TareaNotificacion tareaNotificacion : getTareas()) {
            if (tareaNotificacion.getCliente().getId().equals(idCliente)
                    && (SubtipoTarea.CODIGO_TAREA_VERIFICAR_TELECOBRO.equals(tareaNotificacion.getSubtipoTarea().getCodigoSubtarea())
                     || SubtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO.equals(tareaNotificacion.getSubtipoTarea().getCodigoSubtarea()))) {

                return tareaNotificacion;
            }
        }
        return null;
    }

    /**
     * busca las tarea de telecobro para mostrar en la pantalla de decision/consulta.
     * @param idCliente el id del cliente.
     * @return la tarea.
     */
    @SuppressWarnings("unchecked")
	@BusinessOperation(PrimariaBusinessOperation.BO_TELECOBRO_MGR_GET_TAREA_TELECOBRO_DECISION)
    public TareaNotificacion getTareaTelecobroDecision(Long idCliente){
    	TareaNotificacion tarea = getTareaTelecobro(idCliente);
    	if (tarea!=null){
    		return tarea;
    	}
    	Persona persona = (Persona)executor.execute(
        		PrimariaBusinessOperation.BO_PER_MGR_GET, idCliente);
        List<TareaNotificacion> tareasNotificacion = (List<TareaNotificacion>)executor.execute(
        		ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_ASOCIADAS_A_CLIENTE,
        		persona.getClienteActivo().getId());
    	for (TareaNotificacion tn : tareasNotificacion){
         	if (SubtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO.equals(tn.getSubtipoTarea().getCodigoSubtarea())){
         		return tn;
         	}
        }
    	return null;
    }

    /**
     * Indica si el cliente tiene una tarea de telecobro segun sea gestor o supervisor.
     * @param idCliente long
     * @return string codigo del subtipo de tarea de telecobro
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TELECOBRO_MGR_GET_SUBTIPO_TAREA_TELECOBRO)
    public String getSubtipoTareaTelecobro(Long idCliente) {
    	Persona persona = (Persona)executor.execute(
        		PrimariaBusinessOperation.BO_PER_MGR_GET, idCliente);
    	if (persona.getClienteActivo()!=null){
	        TareaNotificacion tareaNotificacion = getTareaTelecobro(persona.getClienteActivo().getId());
	        if (tareaNotificacion != null) {
	            return tareaNotificacion.getSubtipoTarea().getCodigoSubtarea();
	        }
    	}
        return null;
    }

    /**
     * Devuelve la lista de motivos para la exclusión de un telecobro.
     * @return la lista de motivos de exclusión de telelcobro.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TELECOBRO_MGR_GET_MOTIVOS_TELECOBRO)
    public List<DDMotivosExclusionTelecobro> getMotivosExclusionTelecobro() {
        return motivosExclusionTelecobroDao.getList();
    }

    /**
     * Dispara el paso de solicitar exclusión del BPM.
     * @param dto DtoTelecobro
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TELECOBRO_MGR_CREAR_SOLICITUD_EXCLUSION_TELECOBRO)
    @Transactional
    public void crearSolicitudExclusionTelecobro(DtoTelecobro dto) {
        if (tieneSolicitudTelecobro(dto.getIdCliente())) {
            throw new BusinessOperationException("telecobro.error.existeSolicitud");
        }
        Cliente cliente = (Cliente)executor.execute(
        		PrimariaBusinessOperation.BO_CLI_MGR_GET,
        		dto.getIdCliente());
        Map<String, Object> variables = new HashMap<String, Object>();
        variables.put(OBSERVACION, dto.getObservacion());
        variables.put(MOTIVO_EXCLUSION_ID, dto.getIdMotivo());

        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_ADD_VARIABLES_TO_PROCESS,
        		cliente.getProcessBPM(), variables);
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS,
        		cliente.getProcessBPM(), TRANSITION_SOLICITAR_EXCLUSION_TELECOBRO);
    }

    /**
     * Dispara el paso de aceptar solicitud exclusión del BPM.
     * @param dto DtoTelecobro
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TELECOBRO_MGR_ACEPTAR_SOL_EXCLUSION_TELECOBRO)
    @Transactional
    public void aceptarSolicitudExclusionTelecobro(DtoTelecobro dto) {
        if (!tieneSolicitudTelecobro(dto.getIdCliente())) {
            throw new BusinessOperationException("telecobro.error.noExisteSolicitud");
        }
        Cliente cliente = (Cliente)executor.execute(
        		PrimariaBusinessOperation.BO_CLI_MGR_GET,
        		dto.getIdCliente());
        Map<String, Object> variables = new HashMap<String, Object>();
        variables.put(RESPUESTA, dto.getRespuesta());

        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_ADD_VARIABLES_TO_PROCESS,
        		cliente.getProcessBPM(), variables);
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS,
        		cliente.getProcessBPM(), TRANSITION_SIN_TELECOBRO);
    }

    /**
     * Dispara el paso de rechazar solicitud exclusión del BPM.
     * @param dto DtoTelecobro
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TELECOBRO_MGR_RECHAZAR_SOL_EXCLUSION_TELECOBRO)
    @Transactional
    public void rechazarSolicitudExclusionTelecobro(DtoTelecobro dto) {
        if (!tieneSolicitudTelecobro(dto.getIdCliente())) {
            throw new BusinessOperationException("telecobro.error.noExisteSolicitud");
        }
        Cliente cliente = (Cliente)executor.execute(
        		PrimariaBusinessOperation.BO_CLI_MGR_GET,
        		dto.getIdCliente());
        Map<String, Object> variables = new HashMap<String, Object>();
        variables.put(RESPUESTA, dto.getRespuesta());

        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_ADD_VARIABLES_TO_PROCESS,
        		cliente.getProcessBPM(), variables);
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS,
        		cliente.getProcessBPM(), TRANSITION_CON_TELECOBRO);
    }

    private boolean tieneSolicitudTelecobro(Long idCliente) {
        for (TareaNotificacion tareaNotificacion : getTareas()) {
            if (tareaNotificacion.getCliente().getId().equals(idCliente)
                    && SubtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO.equals(tareaNotificacion.getSubtipoTarea()
                            .getCodigoSubtarea())) {

                return true;
            }
        }
        return false;
    }

    @SuppressWarnings("unchecked")
	private List<TareaNotificacion> getTareas() {
        DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();
        List<Perfil> perfiles = ((Usuario) executor.execute(
        		ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO)).getPerfiles();
        List<DDZona> zonas = ((Usuario) executor.execute(
        		ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO)).getZonas();
        dto.setPerfiles(perfiles);
        dto.setZonas(zonas);
        dto.setCodigoTipoTarea(TipoTarea.TIPO_TAREA);
        return (List<TareaNotificacion>)executor.execute(
        		ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PENDIETE_CLIENTE_DEL_USUARIO,dto);
    }

}
