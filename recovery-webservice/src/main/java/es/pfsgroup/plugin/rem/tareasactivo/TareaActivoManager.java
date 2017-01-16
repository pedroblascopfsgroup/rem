package es.pfsgroup.plugin.rem.tareasactivo;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.ActivoBaseActionHandler;
import es.pfsgroup.plugin.rem.jbpm.handler.listener.ActivoGenerarSaltoImpl;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.VTareaActivoCount;
import es.pfsgroup.plugin.rem.tareasactivo.dao.TareaActivoDao;
import es.pfsgroup.plugin.rem.tareasactivo.dao.VTareaActivoCountDao;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;


@Service("tareaActivoManager")
public class TareaActivoManager implements TareaActivoApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(TareaActivoManager.class);
	
    @Autowired
    private ActivoTareaExternaApi activoTareaExternaManagerApi;	
	
	@Autowired
	private TareaActivoDao tareaActivoDao;

    @Autowired
	private Executor executor;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
    @Autowired
    private JBPMProcessManagerApi jbpmManager;
    
    @Autowired
    private MEJRegistroApi mejRegistroApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private VTareaActivoCountDao vTareaActivoCountDao;
	
	@Override
	public TareaActivo get(Long id) {
		return tareaActivoDao.get(id);
	}

	@Override
	public TareaActivo getByIdTareaExterna(Long idTareaExterna) {
		TareaExterna tareaExterna = activoTareaExternaManagerApi.get(idTareaExterna);
		if (tareaExterna != null){
			TareaNotificacion tarea=tareaExterna.getTareaPadre();
			if (tarea != null){
				TareaActivo tareaActivo = (TareaActivo) tarea;
				if (tarea != null)
					return tareaActivo;
			}
		}
		
		
		return null;
	}
	
	@Override
	@Transactional(readOnly=false)
	public void generarAutoprorroga(DtoSolicitarProrroga dto) throws BusinessOperationException{
		EventFactory.onMethodStart(this.getClass());
		
		TareaActivo tareaAsociada = null;
		if (DDTipoEntidad.CODIGO_ENTIDAD_ACTIVO.equals(dto.getIdTipoEntidadInformacion())) {
			TareaExterna tareaExterna = proxyFactory.proxy(TareaExternaApi.class).get(dto.getIdTareaAsociada());
			if (!Checks.esNulo(tareaExterna)) {
				tareaAsociada = (TareaActivo) tareaExterna.getTareaPadre();
			}
			TareaProcedimiento tareaProcedimiento =tareaExterna.getTareaProcedimiento();
			if ((tareaProcedimiento instanceof EXTTareaProcedimiento)&& (tareaExterna instanceof EXTTareaExterna)){
				EXTTareaProcedimiento tar = (EXTTareaProcedimiento) tareaProcedimiento;
				EXTTareaExterna tex = (EXTTareaExterna) tareaExterna;
				if (tar.getMaximoAutoprorrogas()> tex.getNumeroAutoprorrogas()){
					tex.setNumeroAutoprorrogas(tex.getNumeroAutoprorrogas()+1);
				}else {
					throw new BusinessOperationException("Se han excedido el número máximo de autoprórrogas solicitadas");
				}
			}
			
		} else {
			tareaAsociada = get(dto.getIdTareaAsociada());
		}
		if (tareaAsociada != null) {
			tareaAsociada.setAlerta(false);
			Date fechaVencOriginal = tareaAsociada.getFechaVenc();
			tareaAsociada.setVencimiento(VencimientoUtils.getFecha(dto.getFechaPropuesta(), TipoCalculo.PRORROGA));
//			if (tareaAsociada instanceof TareaActivo){
//				TareaActivo tarea = (TareaActivo) tareaAsociada;
//				tareaAsociada.setVencimiento(VencimientoUtils.getFecha(dto.getFechaPropuesta(), TipoCalculo.PRORROGA));
//			} else{
//				tareaAsociada.setFechaVenc(dto.getFechaPropuesta());
//			}
			if (!Checks.esNulo(tareaAsociada.getTareaExterna())){
				jbpmManager.signalToken(tareaAsociada.getTareaExterna().getTokenIdBpm(), BPMContants.TRANSICION_PRORROGA);
			}
			
			TareaActivo tarea = createTareaProrroga(tareaAsociada);
			
			MEJTrazaDto trazaAutoProrroga = generaTrazaAutoProrroga(dto,fechaVencOriginal, tarea.getId());
			mejRegistroApi.guardatTrazaEvento(trazaAutoProrroga);
		
		}
		
		EventFactory.onMethodStop(this.getClass());
	}
	
	//	@Override
	//	@Transactional(readOnly=false)
	//	public void saltoCierreEconomico(Long idTareaExterna) throws BusinessOperationException{
	//		TareaActivo tareaAsociada = null;
	//		TareaExterna tareaExterna = proxyFactory.proxy(TareaExternaApi.class).get(idTareaExterna);
	//		if (!Checks.esNulo(tareaExterna)) {
	//			tareaAsociada = (TareaActivo) tareaExterna.getTareaPadre();
	//		}
	//		if (!Checks.esNulo(tareaAsociada.getTareaExterna())){
	//			jbpmManager.generaTransicionesSalto(tareaAsociada.getTareaExterna().getTokenIdBpm(), ActivoGenerarSaltoImpl.CODIGO_SALTO_CIERRE);
	//			jbpmManager.signalToken(tareaAsociada.getTareaExterna().getTokenIdBpm(), ActivoGenerarSaltoImpl.SALTO_CIERRE_ECONOMICO);
	//		}
	//	}
	
	@Override
	@Transactional(readOnly=false)
	public void saltoCierreEconomico(Long idTareaExterna){
			saltoTarea(idTareaExterna,ActivoGenerarSaltoImpl.CODIGO_SALTO_CIERRE);
	}
	
	@Override
	@Transactional(readOnly=false)
	public void saltoResolucionExpediente(Long idTareaExterna){
		saltoTarea(idTareaExterna,ActivoGenerarSaltoImpl.CODIGO_SALTO_RESOLUCION);
	}
		
	@Override
	@Transactional(readOnly=false)
	public void saltoFin(Long idTareaExterna){
		saltoTarea(idTareaExterna,ActivoGenerarSaltoImpl.CODIGO_FIN);
	}
			
	@Override
	@Transactional(readOnly=false)
	public void saltoTarea(Long idTareaExterna, String tareaDestino){
		TareaActivo tareaAsociada = null;
		TareaExterna tareaExterna = proxyFactory.proxy(TareaExternaApi.class).get(idTareaExterna);
		if (!Checks.esNulo(tareaExterna)) {
			tareaAsociada = (TareaActivo) tareaExterna.getTareaPadre();
		}
		if(!Checks.esNulo(tareaAsociada.getTareaExterna())){
			jbpmManager.generaTransicionesSalto(tareaAsociada.getTareaExterna().getTokenIdBpm(), tareaDestino);
			jbpmManager.signalToken(tareaAsociada.getTareaExterna().getTokenIdBpm(), "salto"+tareaDestino);
		}
	}
		
	
	private MEJTrazaDto generaTrazaAutoProrroga(DtoSolicitarProrroga dto, Date fechaVencimientoOriginal, Long idTareaActivo) {

		Map<String, Object> informacion = new HashMap<String, Object>();
		informacion.put(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_FECHA_VENCIMIENTO_ORIGINAL,fechaVencimientoOriginal);
		informacion.put(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_FECHA_VENCIMIENTO_PROPUESTA,dto.getFechaPropuesta());
		informacion.put(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_ID_TAREA_NOTIFICACION,dto.getIdTareaAsociada());
		informacion.put("tareaActivo",idTareaActivo);
		informacion.put(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_MOTIVO,dto.getCodigoCausa());
		informacion.put(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_DETALLE,dto.getDescripcionCausa());

		Map<String, Object> datosTraza = new HashMap<String, Object>();
		datosTraza.put(MEJTrazaDto.ID_UNIDAD_GESTION, dto.getIdEntidadInformacion());
		datosTraza.put(MEJTrazaDto.TIPO_EVENTO,MEJDDTipoRegistro.CODIGO_AUTO_PRORROGA);
		datosTraza.put(MEJTrazaDto.TIPO_UNIDAD_GESTION, dto.getIdTipoEntidadInformacion());
		datosTraza.put(MEJTrazaDto.USUARIO, proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getId());
		datosTraza.put(MEJTrazaDto.INFORMACION_ADICIONAL, informacion);

		MEJTrazaDto traza = DynamicDtoUtils.create(MEJTrazaDto.class, datosTraza);
		return traza;
	}
	
	@Transactional(readOnly=false)
	private TareaActivo createTareaProrroga(TareaActivo tareaAsociada){
		TareaActivo tareaProrroga = new TareaActivo();
		tareaProrroga.setActivo(tareaAsociada.getActivo());
		tareaProrroga.setTramite(tareaAsociada.getTramite());
		tareaProrroga.setAlerta(false);
		tareaProrroga.setEspera(false);
		//tareaProrroga.setBorrado(false);
		tareaProrroga.setCodigoTarea(TipoTarea.TIPO_PRORROGA);
		
		Filter filtroSubtipotarea = genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", EXTSubtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO);
		SubtipoTarea subtipoTarea = (SubtipoTarea) genericDao.get(SubtipoTarea.class, filtroSubtipotarea);
		tareaProrroga.setSubtipoTarea(subtipoTarea);
		tareaProrroga.setTarea("Autoprórroga");
		tareaProrroga.setDescripcionTarea("Autoprórroga");
		
		Filter filtroEntidad = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoEntidad.CODIGO_ENTIDAD_ACTIVO);
		DDTipoEntidad tipoEntidad = (DDTipoEntidad) genericDao.get(DDTipoEntidad.class, filtroEntidad);
		
		tareaProrroga.setTipoEntidad(tipoEntidad);
		
		tareaActivoDao.saveOrUpdate(tareaProrroga);
		
		return tareaProrroga;
	}
	
	@Override
	public List<TareaActivo> getTareasActivoByIdTramite(Long idTramite) {
		return tareaActivoDao.getTareasActivoTramiteHistorico(idTramite);
	}

	@Override
	public Long getTareasPendientes(Usuario usuario) {
		EXTGrupoUsuarios grupoUsuario  = genericDao.get(EXTGrupoUsuarios.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId()));		
		
		List<VTareaActivoCount> contadores = vTareaActivoCountDao.getContador(usuario, grupoUsuario);
		
		//Si hay usuario y grupo de usuario se suman los contadores.
		
		if(Checks.estaVacio(contadores))
			return 0L;
		else
			if(contadores.size()==2)
				return contadores.get(0).getTareas()+contadores.get(1).getTareas();
			else
				return contadores.get(0).getTareas();
	}

	@Override
	public Long getAlertasPendientes(Usuario usuario) {
		EXTGrupoUsuarios grupoUsuario  = genericDao.get(EXTGrupoUsuarios.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId()));		
		
		List<VTareaActivoCount> contadores = vTareaActivoCountDao.getContador(usuario, grupoUsuario);
		
		//Si hay usuario y grupo de usuario se suman los contadores.
		
		if(Checks.estaVacio(contadores))
			return 0L;
		else
			if(contadores.size()==2)
				return contadores.get(0).getAlertas()+contadores.get(1).getAlertas();
			else
				return contadores.get(0).getAlertas();
	}

	@Override
	public Long getAvisosPendientes(Usuario usuario) {
		EXTGrupoUsuarios grupoUsuario  = genericDao.get(EXTGrupoUsuarios.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId()));		
		
		List<VTareaActivoCount> contadores = vTareaActivoCountDao.getContador(usuario, grupoUsuario);
		
		//Si hay usuario y grupo de usuario se suman los contadores.
		if(Checks.estaVacio(contadores))
			return 0L;
		else
			if(contadores.size()==2)
				return contadores.get(0).getAvisos()+contadores.get(1).getAvisos();
			else
				return contadores.get(0).getAvisos();
	}

}
















