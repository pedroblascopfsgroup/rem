package es.pfsgroup.plugin.rem.tareasactivo;

import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.politica.model.Objetivo;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.registro.AceptarProrrogaListener;
import es.capgemini.pfs.tareaNotificacion.EXTAbstractTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.EXTDtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.EXTModelClassFactory;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.tareasactivo.dao.ActivoTareaExternaDao;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.VTARBusquedaOptimizadaTareasDao;

@Component
public class EXTActivoTareaNotificacionManager extends EXTAbstractTareaNotificacionManager{

	private static final TipoCalculo TIPO_CALCULO_FECHA_POR_DEFECTO = TipoCalculo.TODO;
	private final int maxlength = 49;
	
    @Autowired
    Executor executor;

    @Autowired
    GenericABMDao genericDao;

    @Autowired
    private VTARBusquedaOptimizadaTareasDao vtarBusquedaOptimizadaTareasDao;

    @Resource
    Properties appProperties;

    @Autowired(required = false)
    private List<AceptarProrrogaListener> listeners;
    
    @Autowired
    private EXTModelClassFactory modelClassFactory;

    @Autowired
    private ActivoTareaExternaDao extActivoTareaNotificacionDao;
    
    @Autowired
    private UsuarioManager usuarioManager;

    @Override
    public String managerName() {
        return "tareaNotificacionManager";
    }

 

    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA)
    @Transactional(readOnly = false)
    public Long crearTarea(DtoGenerarTarea dto) {
    	
    	EXTTareaNotificacion tarea;
    	if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(dto.getCodigoTipoEntidad())){
    		tarea = new TareaActivo();
    		dto.setCodigoTipoEntidad(DDTipoEntidad.CODIGO_ENTIDAD_ACTIVO);
    	}
    	else{
	        tarea = new EXTTareaNotificacion();
    	}
	        String codigoSubtarea = dto.getSubtipoTarea();
	        SubtipoTarea subtipoTarea = getSubtipoTarea(codigoSubtarea);
	        TipoCalculo tipoCalculo = null;
	        if (dto instanceof EXTDtoGenerarTarea) {
	            EXTDtoGenerarTarea sandto = (EXTDtoGenerarTarea) dto;
	            tipoCalculo = sandto.getTipoCalculo();
	        }
	        if (subtipoTarea == null) {
	            throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", dto.getSubtipoTarea());
	        }
	        if (!TipoTarea.TIPO_TAREA.equals(subtipoTarea.getTipoTarea().getCodigoTarea())) {
	            throw new GenericRollbackException("tareaNotificacion.subtipoTarea.notificacionIncorrecta", dto.getSubtipoTarea());
	        }
	
	        tarea.setEspera(dto.isEnEspera());
	        tarea.setAlerta(dto.isEsAlerta());
	        return saveNotificacionTarea(tarea, subtipoTarea, dto.getIdEntidad(), dto.getCodigoTipoEntidad(), dto.getPlazo(), dto.getDescripcion(), tipoCalculo);
       
    }
    
    private SubtipoTarea getSubtipoTarea(String codigoSubtarea) {
        return genericDao.get(SubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", codigoSubtarea));
    }    
    
    private Long saveNotificacionTarea(EXTTareaNotificacion notificacionTarea, SubtipoTarea subtipoTarea, Long idEntidad, String codigoTipoEntidad, Long plazo, String descripcion,
            TipoCalculo tipoCalculo) {
    	
        notificacionTarea.setTarea(subtipoTarea.getDescripcion());
        if (descripcion == null || descripcion.length() == 0) {
            notificacionTarea.setDescripcionTarea(subtipoTarea.getDescripcionLarga());
        } else {
            notificacionTarea.setDescripcionTarea(descripcion);
        }
        notificacionTarea.setCodigoTarea(subtipoTarea.getTipoTarea().getCodigoTarea());
        notificacionTarea.setSubtipoTarea(subtipoTarea);
        DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, codigoTipoEntidad);
        notificacionTarea.setTipoEntidad(tipoEntidad);
        Date ahora = new Date(System.currentTimeMillis());
        notificacionTarea.setFechaInicio(ahora);
        notificacionTarea.setTareaFinalizada(false);
        if (plazo != null) {
            // Date aux = new Date(ahora.getTime());
            // Calendar c = new GregorianCalendar();
            // c.setTime(aux);
            // Long plazoSegundos = plazo/1000;
            // c.add(Calendar.SECOND, plazoSegundos.intValue());
            Date fin = new Date(System.currentTimeMillis() + plazo);
            if (tipoCalculo == null) {
                tipoCalculo = TIPO_CALCULO_FECHA_POR_DEFECTO;
            }
            notificacionTarea.setVencimiento(VencimientoUtils.getFecha(fin, tipoCalculo));
        }
        // Seteo la entidad en el campo que corresponda
        decodificarEntidadInformacion(idEntidad, codigoTipoEntidad, notificacionTarea);
        
        return guardarTareaBBDD(notificacionTarea);

    }   

 


    private Long guardarTareaBBDD(EXTTareaNotificacion notificacionTarea) {
    	if (notificacionTarea instanceof TareaActivo){
    		
    		TareaActivo tareaActivo = (TareaActivo) notificacionTarea;
    		tareaActivo.setUsuario(usuarioManager.getUsuarioLogado());
    		// TODO: cambiarlo de sitio.
    		
    		return genericDao.save(TareaActivo.class, tareaActivo).getId();
    	}else{
    		return genericDao.save(EXTTareaNotificacion.class, notificacionTarea).getId();
    	}
    	
    		
    }



	private void decodificarEntidadInformacion(Long idEntidad, String codigoTipoEntidad, TareaNotificacion tareaNotificacion) {
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(codigoTipoEntidad)) {

            Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idEntidad);

            tareaNotificacion.setExpediente(exp);
            tareaNotificacion.setEstadoItinerario(exp.getEstadoItinerario());
            setearEmisorExpediente(tareaNotificacion, exp);
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(codigoTipoEntidad)) {

            Cliente cli = (Cliente) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_GET, idEntidad);

            tareaNotificacion.setCliente(cli);
            tareaNotificacion.setEstadoItinerario(cli.getEstadoItinerario());
            setearEmisorCliente(tareaNotificacion);
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(codigoTipoEntidad)) {
            Asunto asu = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idEntidad);

            tareaNotificacion.setAsunto(asu);
            tareaNotificacion.setEstadoItinerario(asu.getEstadoItinerario());
            tareaNotificacion.setEmisor(asu.getGestor().getUsuario().getApellidoNombre());
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(codigoTipoEntidad)) {
            Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idEntidad);
            tareaNotificacion.setProcedimiento(proc);
            tareaNotificacion.setAsunto(proc.getAsunto());
            tareaNotificacion.setEstadoItinerario(proc.getAsunto().getEstadoItinerario());
            if (proc.getAsunto().getGestor() != null) {
                tareaNotificacion.setEmisor(proc.getAsunto().getGestor().getUsuario().getApellidoNombre());
            }
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ACTIVO.equals(codigoTipoEntidad)) {
        	ActivoTramite actT = genericDao.get(ActivoTramite.class, genericDao.createFilter(FilterType.EQUALS, "id",idEntidad));
        	if (tareaNotificacion instanceof TareaActivo){
        		
        		TareaActivo tareaActivo = (TareaActivo) tareaNotificacion;
        		tareaActivo.setActivo(actT.getActivo());
        		tareaActivo.setTramite(actT);
        	}
        }        
        if (DDTipoEntidad.CODIGO_ENTIDAD_NOTIFICACION.equals(codigoTipoEntidad)) {
            Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idEntidad);
            tareaNotificacion.setProcedimiento(proc);
            tareaNotificacion.setAsunto(proc.getAsunto());
            tareaNotificacion.setEstadoItinerario(proc.getAsunto().getEstadoItinerario());
            if (proc.getAsunto().getGestor() != null) {
                tareaNotificacion.setEmisor(proc.getAsunto().getGestor().getUsuario().getApellidoNombre());
            }
            tareaNotificacion.setEmisor("Automatico");
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO.equals(codigoTipoEntidad)) {
            Objetivo objetivo = (Objetivo) executor.execute(InternaBusinessOperation.BO_OBJ_MGR_GET_OBJETIVO, idEntidad);

            tareaNotificacion.setObjetivo(objetivo);
            // Si el obj. es del estado vigente, el mismo tiene que tener la
            // asociacion que se asigna cuando entra en vigencia
            tareaNotificacion.setEstadoItinerario(objetivo.getPolitica().getEstadoItinerarioPolitica().getEstadoItinerario());
            setearEmisorObjetivo(tareaNotificacion, objetivo);
        }
    }

    /**
     * setea el emisor de la tarea.
     * 
     * @param tareaNotificacion
     *            tarea
     * @param exp
     *            expediente
     */
    private void setearEmisorExpediente(TareaNotificacion tareaNotificacion, Expediente exp) {
        String descZona = exp.getOficina().getZona().getDescripcion();
        Perfil gestor = exp.getArquetipo().getItinerario().getEstado(exp.getEstadoItinerario().getCodigo()).getGestorPerfil();
        String descPerfil = "";
        if (gestor != null) {
            descPerfil = gestor.getDescripcion();
        }
        String emisor = (descPerfil + " - " + descZona);
        if (emisor.length() > maxlength) {
            emisor = emisor.substring(0, maxlength);
        }
        tareaNotificacion.setEmisor(emisor);
    }

    /**
     * setea el emisor de la tarea.
     * 
     * @param tareaNotificacion
     *            tarea
     */
    private void setearEmisorCliente(TareaNotificacion tareaNotificacion) {
        try {
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

            Perfil perfil = usuario.getZonaPerfil().iterator().next().getPerfil();
            String descPerfil = perfil.getDescripcion();
            String descZona = "";
            for (ZonaUsuarioPerfil zp : usuario.getZonaPerfil()) {
                if (perfil.getId().longValue() == zp.getPerfil().getId().longValue()) {
                    descZona = zp.getZona().getDescripcion();
                    break;
                }
            }
            String emisor = (descPerfil + " - " + descZona);
            if (emisor.length() > maxlength) {
                emisor = emisor.substring(0, maxlength);
            }
            tareaNotificacion.setEmisor(emisor);
        } catch (Exception e) {
            // Por si no estoy logueado y es un proceso del sistema
            tareaNotificacion.setEmisor("Automático");
        }
    }

    /**
     * setea el emisor de la tarea.
     * 
     * @param tareaNotificacion
     *            tarea
     * @param Objetivo
     *            obj
     */
    private void setearEmisorObjetivo(TareaNotificacion tareaNotificacion, Objetivo obj) {
        String emisor;
        if (tareaNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO)
                || tareaNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO)
                || tareaNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO)) {
            emisor = obj.getPolitica().getPerfilGestor().getDescripcion();
        } else {
            emisor = obj.getPolitica().getPerfilSupervisor().getDescripcion();
        }
        tareaNotificacion.setEmisor(emisor);
    }
    
}
