package es.pfsgroup.plugin.recovery.mejoras.tareaNotificacion;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
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
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.expediente.dao.MEJEventoDao;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.MEJTipoProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;
import es.pfsgroup.recovery.api.AsuntoApi;

@Component
public class MEJTareaNotificacionManager implements MEJTareaNoficacionApi{

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private MEJEventoDao eventoDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GENERAR_AUTOPRORROGA)
	@Transactional(readOnly=false)
	public void generarAutoprorroga(DtoSolicitarProrroga dto) {
		EventFactory.onMethodStart(this.getClass());
		
		TareaNotificacion tareaAsociada = null;
		if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(dto
				.getIdTipoEntidadInformacion())) {
			TareaExterna tareaExterna = proxyFactory.proxy(
					TareaExternaApi.class).get(dto.getIdTareaAsociada());
			if (!Checks.esNulo(tareaExterna)) {
				tareaAsociada = tareaExterna.getTareaPadre();
			}
			TareaProcedimiento tareaProcedimiento =tareaExterna.getTareaProcedimiento();
			if ((tareaProcedimiento instanceof EXTTareaProcedimiento)&& (tareaExterna instanceof EXTTareaExterna)){
				EXTTareaProcedimiento tar = (EXTTareaProcedimiento) tareaProcedimiento;
				EXTTareaExterna tex = (EXTTareaExterna) tareaExterna;
				if (tar.getMaximoAutoprorrogas()> tex.getNumeroAutoprorrogas()){
					tex.setNumeroAutoprorrogas(tex.getNumeroAutoprorrogas()+1);
				}else {
					throw new BusinessOperationException("**Se han excedido el n�mero m�ximo de autopr�rrogas solicitadas");
				}
			}
			
		} else {
			tareaAsociada = proxyFactory.proxy(TareaNotificacionApi.class).get(
					dto.getIdTareaAsociada());
		}
		if (tareaAsociada != null) {
			tareaAsociada.setAlerta(false);
			Date fechaVencOriginal = tareaAsociada.getFechaVenc();
			if (tareaAsociada instanceof EXTTareaNotificacion) {
				EXTTareaNotificacion tarea = (EXTTareaNotificacion) tareaAsociada;
				tarea.setVencimiento(VencimientoUtils.getFecha(dto
						.getFechaPropuesta(), TipoCalculo.PRORROGA));
			} else {
				tareaAsociada.setFechaVenc(dto.getFechaPropuesta());
			}
			if (!Checks.esNulo(tareaAsociada.getTareaExterna())){
				executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN, tareaAsociada.getTareaExterna().getTokenIdBpm(),
                    BPMContants.TRANSICION_PRORROGA);
			}
			MEJTrazaDto trazaAutoProrroga = generaTrazaAutoProrroga(dto,
					fechaVencOriginal);
			proxyFactory.proxy(MEJRegistroApi.class).guardatTrazaEvento(
					trazaAutoProrroga);
		
		}
		
		EventFactory.onMethodStop(this.getClass());
	}
	
	private MEJTrazaDto generaTrazaAutoProrroga(
			DtoSolicitarProrroga dto, Date fechaVencimientoOriginal) {

		Map<String, Object> informacion = new HashMap<String, Object>();
		informacion
				.put(
						MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_FECHA_VENCIMIENTO_ORIGINAL,
						fechaVencimientoOriginal);
		informacion
				.put(
						MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_FECHA_VENCIMIENTO_PROPUESTA,
						dto.getFechaPropuesta());
		informacion
				.put(
						MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_ID_TAREA_NOTIFICACION,
						dto.getIdTareaAsociada());
		informacion
		.put(
				MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_MOTIVO,
				dto.getCodigoCausa());
		informacion
		.put(
				MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_DETALLE,
				dto.getDescripcionCausa());

		Map<String, Object> datosTraza = new HashMap<String, Object>();
		datosTraza.put(MEJTrazaDto.ID_UNIDAD_GESTION, dto
				.getIdEntidadInformacion());
		datosTraza.put(MEJTrazaDto.TIPO_EVENTO,
				MEJDDTipoRegistro.CODIGO_AUTO_PRORROGA);
		datosTraza.put(MEJTrazaDto.TIPO_UNIDAD_GESTION, dto
				.getIdTipoEntidadInformacion());
		datosTraza.put(MEJTrazaDto.USUARIO, proxyFactory.proxy(
				UsuarioApi.class).getUsuarioLogado().getId());
		datosTraza.put(MEJTrazaDto.INFORMACION_ADICIONAL, informacion);

		MEJTrazaDto traza = DynamicDtoUtils.create(
				MEJTrazaDto.class, datosTraza);
		return traza;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_LISTA_COMUNICACIONES_ASU)
	public List<TareaNotificacion> getListComunicacionesAsunto(Long idAsunto) {
		EventFactory.onMethodStart(this.getClass());
		
		List<TareaNotificacion> comunicaciones = new ArrayList<TareaNotificacion>();
		List<TareaNotificacion> tareas = eventoDao.getComunicacionesAsunto(idAsunto);
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		List<TareaNotificacion> tareasProcedimientos = getComunicacionesProcedimientos(asunto);
		
		addNuevasComunicaciones(comunicaciones, tareas);
		addNuevasComunicaciones(comunicaciones, tareasProcedimientos);
		
		Collections.sort(comunicaciones, new Comparator<TareaNotificacion>() {

			@Override
			public int compare(TareaNotificacion o1, TareaNotificacion o2) {
				return o1.getFechaInicio().compareTo(o2.getFechaInicio());
			}
		});
		
		EventFactory.onMethodStop(this.getClass());
		return comunicaciones;
	}

	private void addNuevasComunicaciones(
			List<TareaNotificacion> comunicaciones,
			List<TareaNotificacion> nuevas) {
		comunicaciones.addAll(nuevas);
		for (TareaNotificacion tn : nuevas){
			if (!Checks.esNulo(tn.getTareaId())){
				if (comunicaciones.contains(tn.getTareaId())){
					comunicaciones.remove(tn.getTareaId());
				}
			}
		}
	}

	private List<TareaNotificacion> getComunicacionesProcedimientos(
			Asunto asunto) {
		ArrayList<TareaNotificacion> tareas = new ArrayList<TareaNotificacion>();
		
		if ((asunto != null) && (!Checks.estaVacio(asunto.getProcedimientos()))){
			for (Procedimiento p : asunto.getProcedimientos()){
				tareas.addAll(eventoDao.getComunicacionesProcedimiento(p.getId()));
			}
		}
		
		return tareas;
	}
	
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_PERMITE_PRORROGAS)
	public boolean permiteProrrogas(Long idProcedimiento){
		
		boolean permiteProrrogas = false;
		
		Procedimiento proc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
		
		Filter filtroTipoProc = genericDao.createFilter(FilterType.EQUALS, "id", proc.getTipoProcedimiento().getId());
		MEJTipoProcedimiento tipo = genericDao.get(MEJTipoProcedimiento.class,filtroTipoProc);
		
		if (!Checks.esNulo(tipo)){
			permiteProrrogas = tipo.isFlagProrroga();
		}
		
		return permiteProrrogas;
	}

}
