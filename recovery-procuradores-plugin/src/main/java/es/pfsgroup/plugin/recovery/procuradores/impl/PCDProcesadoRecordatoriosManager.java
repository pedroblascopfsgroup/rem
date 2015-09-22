package es.pfsgroup.plugin.recovery.procuradores.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacion;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacionUsuario;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.procuradores.api.PCDProcesadoRecordatoriosApi;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.dao.RECRecordatorioDao;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.model.RECRecordatorio;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;
import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;
import es.pfsgroup.recovery.ext.impl.tareas.EXTDtoGenerarTareaIdividualizadaImpl;


@Service
@Transactional(readOnly = false)
public class PCDProcesadoRecordatoriosManager implements PCDProcesadoRecordatoriosApi{
	

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private RECRecordatorioDao recRecordatorioDao;
	
	private static final String COD_ENTIDAD = "4";
	private static final String TIPO_ANOTACION_TAREA = "T";
	private static final String SUBTIPO_ANOTACION_AUTOTAREA = "TAREA_RECORDATORIO";
	
	
	@Override
	@BusinessOperation(PCD_BO_CREAR_TAREAS_DE_RECORDATORIO)
	public void crearTareaRecordatorios(long idRecordatorio, String[] dias) {
		
		RECRecordatorio recRecordatorio = recRecordatorioDao.getRecRecordatorio(idRecordatorio);
		
		Usuario user = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		List<String> diasList = Arrays.asList(dias);
		Collections.sort(diasList);
		Collections.reverse(diasList);
		
		///Creamos las tareas
		Calendar calendar = new GregorianCalendar();
		
		int clavAj = 0;
		
		for(String dia : diasList){
			
			if(!Checks.esNulo(dia) &&  !dia.equals("")){
				
				clavAj ++;
				
				calendar.setTime(recRecordatorio.getFecha());
				int dias_habiles_encontrados = 1;
				
				while(dias_habiles_encontrados <= Integer.parseInt(dia)){
					
					calendar.add(Calendar.DAY_OF_MONTH, -1);
					
					if(calendar.get(Calendar.DAY_OF_WEEK)!= Calendar.SATURDAY && calendar.get(Calendar.DAY_OF_WEEK)!= Calendar.SUNDAY){
						///Incrementamos días habiles encontrados
						dias_habiles_encontrados ++;
					}
				}
				
				///El calendario esta situado en la fecha indicada, creamos la tarea
				Date d = calendar.getTime();
				
				
				DtoCrearAnotacionUsuario du = new DtoCrearAnotacionUsuario();
				du.setId(user.getId());
				du.setIncorporar(true);
				du.setFecha(d);
				
				List<DtoCrearAnotacionUsuario> listaUsuarios = new ArrayList<DtoCrearAnotacionUsuario>();
				listaUsuarios.add(du);
				
				DtoCrearAnotacion serviceDto = new DtoCrearAnotacion();
				serviceDto.setIdUg(recRecordatorio.getId());
				serviceDto.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_TAREA);
				serviceDto.setUsuarios(listaUsuarios);
				serviceDto.setCodUg(COD_ENTIDAD);
				serviceDto.setTipoAnotacion(TIPO_ANOTACION_TAREA);
				serviceDto.setAsuntoMail("Recordatorio "+" "+clavAj+" - "+ recRecordatorio.getTitulo());

				
				try {
					Long idTarea = crearTarea(serviceDto.getIdUg(), serviceDto.getCodUg(),
							serviceDto.getAsuntoMail(), user.getId(),
							false, SUBTIPO_ANOTACION_AUTOTAREA,
							du.getFecha());
					
					///Guardamos las claves ajenas
					switch (clavAj) {
					case 1:
						recRecordatorio.setTareaUno(proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea));
						break;
					case 2:
						recRecordatorio.setTareaDos(proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea));
						break;
					case 3:
						recRecordatorio.setTareaTres(proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea));
						break;

					default:
						break;
					}
					
					dejarTraza(
							user.getId(),
							AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_TAREA,
							serviceDto.getIdUg(),
							serviceDto.getCodUg(),
							createInfoEventoTarea(idTarea,
									user.getId(), new Date(),
									du.getFecha(), user.getId(),
									serviceDto.getAsuntoMail(),
									HtmlUtils.htmlUnescape(serviceDto.getCuerpoEmail()),
									du.isEmail(),
									serviceDto.getTipoAnotacion()));
				} catch (EXTCrearTareaException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

		}
		
	}


	private void dejarTraza(final long idUsuario, final String tipoEvento, final long idUg,
			final String codUg, final Map<String, Object> infoEvento) {

		MEJTrazaDto evento = new MEJTrazaDto() {

			@Override
			public long getUsuario() {
				return idUsuario;
			}

			@Override
			public String getTipoUnidadGestion() {
				return codUg;
			}

			@Override
			public String getTipoEvento() {
				return tipoEvento;
			}

			@Override
			public Map<String, Object> getInformacionAdicional() {
				return infoEvento;
			}

			@Override
			public long getIdUnidadGestion() {
				return idUg;
			}
		};
		proxyFactory.proxy(MEJRegistroApi.class).guardatTrazaEvento(evento);
		
	}


	private Map<String, Object> createInfoEventoTarea(Long idTarea,
			Long emisor, Date fecha_creacion, Date fecha_vencimiento,
			Long destinatario, String asunto, String descripcion, boolean mail,
			String tipoAnotacion) {

		HashMap<String, Object> info = new HashMap<String, Object>();
		info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.ID_TAREA,
				idTarea);
		info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.EMISOR_TAREA,
				emisor);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.FECHA_CREACION_TAREA,
				fecha_creacion);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.FECHA_VENCIMIENTO_TAREA,
				fecha_vencimiento);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESTINATARIO_TAREA,
				destinatario);
		info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.ASUNTO_TAREA,
				asunto);
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESCRIPCION_TAREA,
				descripcion);
		if (mail) {
			info.put(
					AgendaMultifuncionTipoEventoRegistro.EventoTarea.FLAG_MAIL,
					1);
		}
		info.put(
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.TIPO_ANOTACION,
				tipoAnotacion);
		return info;
	}


	protected Long crearTarea(Long idUg, String codUg, String asuntoMail,
			Long idUsuarioDestinatarioTarea, boolean enEspera,
			String codigoSubtarea, Date fechaVencimiento)throws EXTCrearTareaException {
		
		EXTDtoGenerarTareaIdividualizadaImpl tareaIndDto = new EXTDtoGenerarTareaIdividualizadaImpl();
		DtoGenerarTarea tareaDto = new DtoGenerarTarea();

		tareaDto.setSubtipoTarea(codigoSubtarea);
		tareaDto.setEnEspera(enEspera);
		tareaDto.setFecha(fechaVencimiento);
		tareaDto.setDescripcion(asuntoMail);
		tareaDto.setIdEntidad(idUg);
		tareaDto.setCodigoTipoEntidad(codUg);
		tareaIndDto.setTarea(tareaDto);
		tareaIndDto.setDestinatario(idUsuarioDestinatarioTarea);
		return proxyFactory.proxy(EXTTareasApi.class).crearTareaNotificacionIndividualizada(tareaIndDto);
	}	

	
}
