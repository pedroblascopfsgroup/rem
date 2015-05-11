package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.asunto;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.ReportAsuntoManager;
import es.capgemini.pfs.asunto.dto.DtoReportComunicacion;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.AnotacionAgendaDto;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.RecoveryAnotacionApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.MEJAsuntoDao;
import es.pfsgroup.plugin.recovery.mejoras.expediente.dao.MEJEventoDao;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.recovery.api.AsuntoApi;

@Component
public class ReportAsuntoAgendaManager {

	private static final String PROPERTY_REPORT_FICHA_GLOBAL_LITIGIOS_FILTRO_HTML_ANOTACIONES = "report.ficha.global.litigios.filtro.html.anotaciones";
	private static final String MEJ_BO_GETMAPA_REGISTRO = "plugin.mejoras.registro.getMapa";
	
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private MEJEventoDao eventoDao;
	
	@Autowired
	private MEJAsuntoDao mejAsuntoDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private UsuarioDao usuarioDao;

	@Resource
	Properties appProperties;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private Executor executor;
	
	@BusinessOperation(overrides = ReportAsuntoManager.GET_COMUNICACIONES_FICHA_GLOBAL_REPORT)
	public List<DtoReportComunicacion> getListComunicacionesFichaGlobal(Long idAsunto) {
		 
		 List<DtoReportComunicacion> listTotal = new ArrayList<DtoReportComunicacion>();
		 
		 // Anotaciones
		 List<DtoReportComunicacion> listAnot = obtenerAnotacionesAsunto(idAsunto);
		 for (DtoReportComunicacion dtoAnot : listAnot){
			 dtoAnot.setTipoComunicacion("1");
			 listTotal.add(dtoAnot);
		 }
		 
		 // Comunicaciones
		 List<DtoReportComunicacion> listCom = getListComunicacionesAsunto(idAsunto);
		 for (DtoReportComunicacion dtoCom : listCom){
			 dtoCom.setTipoComunicacion("2");
			 listTotal.add(dtoCom);
		 }
		 
		// Correos
		List<DtoReportComunicacion> listCorreo = obtenerCorreosAsuntoLitigio(idAsunto);
		
		// Comprobamos que no haya correos repetidos con las anotaciones
		for (DtoReportComunicacion dtoCorreo : listCorreo){
			Boolean repetido = false;
			for (DtoReportComunicacion dtoCom : listCom){
				if (!Checks.esNulo(dtoCom.getFecha()) && !Checks.esNulo(dtoCorreo.getFecha())
						&& dtoCom.getFecha().equals(dtoCorreo.getFecha())){
					repetido = true;
				}
			}
			if (!repetido){
				for (DtoReportComunicacion dtoAnot : listAnot){
					if (!Checks.esNulo(dtoAnot.getFecha()) && !Checks.esNulo(dtoCorreo.getFecha())
							&& dtoAnot.getFecha().equals(dtoCorreo.getFecha())){
						repetido = true;
					}
				}
				if (!repetido){
					dtoCorreo.setTipoComunicacion("3");
					listTotal.add(dtoCorreo);
				}
			}
		}
		
		listTotal = ordenaComFichaGlobal(listTotal);
		
		return listTotal;
		 
	 }

	
	private List<DtoReportComunicacion> ordenaComFichaGlobal(List<DtoReportComunicacion> list) {
		if (!Checks.estaVacio(list)) {
			Collections.sort(list, new Comparator<DtoReportComunicacion>() {

				@Override
				public int compare(DtoReportComunicacion o1, DtoReportComunicacion o2) {
					if ((o1 == null) && (o2 == null))
						return 0;
					else if ((o1 == null) && (o2 != null))
						return 1;
					else if ((o1 != null) && (o2 == null))
						return -1;
					else {
						Date f1 = o1.getFecha();
						Date f2 = o2.getFecha();
						if ((f1 == null) && (f2 == null))
							return 0;
						else if ((f1 == null) && (f2 != null))
							return 1;
						else if ((f1 != null) && (f2 == null))
							return -1;
						else {
							return f1.compareTo(f2);
						}
					}
				}
			});
		}
		return list;
	}
	
	private List<? extends HistoricoAsuntoInfo> ordenaLista(ArrayList<HistoricoAsuntoInfo> lista) {
		
		if (!Checks.estaVacio(lista)) {
			Collections.sort(lista, new Comparator<HistoricoAsuntoInfo>() {

				@Override
				public int compare(HistoricoAsuntoInfo o1, HistoricoAsuntoInfo o2) {
					if ((o1 == null) && (o2 == null))
						return 0;
					else if ((o1 == null) && (o2 != null))
						return 1;
					else if ((o1 != null) && (o2 == null))
						return -1;
					else {
						Date f1 = o1.getTarea().getFechaIni();
						Date f2 = o2.getTarea().getFechaIni();
						if ((f1 == null) && (f2 == null))
							return 0;
						else if ((f1 == null) && (f2 != null))
							return 1;
						else if ((f1 != null) && (f2 == null))
							return -1;
						else {
							return f1.compareTo(f2);
						}
					}
				}
			});
		}
		return lista;
	}

	/**
	 * Obtiene las anotaciones relacionadas de un asunto.
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de anotaciones
	 */
	private List<DtoReportComunicacion> obtenerAnotacionesAsunto(Long idAsunto) {

		List<DtoReportComunicacion> anotaciones = new ArrayList<DtoReportComunicacion>();

		//if (extras != null) {
			List<DtoInfoAnotacionAgenda> list = getAnotacionesAgenda(idAsunto);//extras.getAnotaciones();
			if (!Checks.estaVacio(list)) {
				for (DtoInfoAnotacionAgenda an : list) {
					DtoReportComunicacion d = new DtoReportComunicacion();
					d.setUsuario(an.getUsuarioCrear());
					d.setAsunto(an.getAsuntoAnotacion());
					String textAnot = an.getTextoAnotacion();
					String texto = "";
					
					int start = textAnot.indexOf("<IMG"); 
					
					if (start > 0){
						
						int numRepeticiones = cuentaTagImg(textAnot);
						for (int i = 0; i < numRepeticiones; i ++){
							start = textAnot.indexOf("<IMG");
							int end = textAnot.substring(start, textAnot.length()).indexOf(">");
							texto = textAnot.substring(0,start) + textAnot.substring(start+end, textAnot.length());
							textAnot = texto;
						}
					} else {
						texto = textAnot;
					}
					
					if (Boolean.parseBoolean(appProperties.getProperty(PROPERTY_REPORT_FICHA_GLOBAL_LITIGIOS_FILTRO_HTML_ANOTACIONES))) {
						d.setTexto(formateaTextoHtml(texto));
					} else {
						d.setTexto(texto);
					}
					d.setFecha(an.getFechaAnotacion());
					anotaciones.add(d);
				}
			}
		//}
		return anotaciones;
	}

	private List<DtoInfoAnotacionAgenda> getAnotacionesAgenda(Long asuId) {
		List<AnotacionAgendaDto> anotaciones = proxyFactory.proxy(RecoveryAnotacionApi.class).getAnotacionesAgenda(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, asuId,
				new String[] { AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_COMENTARIO });

		if (Checks.estaVacio(anotaciones)) {
			return null;
		}

		ArrayList<DtoInfoAnotacionAgenda> result = new ArrayList<DtoInfoAnotacionAgenda>();
		for (AnotacionAgendaDto a : anotaciones) {
			Map<String, String> detalles = a.getDetalleTraza();
			if (!Checks.esNulo(detalles)) {
				String textoAnotacion = detalles.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.DESCRIPCION_COMENTARIO);
				String asuntoAnotacion = detalles.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.ASUNTO_COMENTARIO);
				String usuarioCrear = detalles.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.EMISOR_COMENTARIO);
				String strFechaAnotacion = detalles.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.FECHA_CREACION_COMENTARIO);
				Date fechaAnotacion = null;
				if (!Checks.esNulo(strFechaAnotacion)) {
					try {
						fechaAnotacion = new Date(Long.parseLong(strFechaAnotacion));
					} catch (Exception e) {
						fechaAnotacion = null;
					}
				}
				// Ahora procedemos a averiguar el nombre y apellido
				if (!Checks.esNulo(usuarioCrear)) {
					Usuario usu = proxyFactory.proxy(UsuarioApi.class).get(Long.parseLong(usuarioCrear));
					if (!Checks.esNulo(usu)) {
						usuarioCrear = usu.getApellidoNombre();
					}
				}
				result.add(new DtoInfoAnotacionAgenda(usuarioCrear, asuntoAnotacion, textoAnotacion, fechaAnotacion));
			}
		}
		return result;
	}

	private String formateaTextoHtml(String textoAnotacion) {
		StringBuffer sb = new StringBuffer();
		char[] caracteres = textoAnotacion.toCharArray();
		boolean estoyBorrando = false;
		for (int i = 0; i < caracteres.length; i++) {
			if (caracteres[i] == '<' && !estoyBorrando) {
				if (caracteres[i + 1] == 'o' || caracteres[i + 1] == 'P' || caracteres[i + 1] == 'B' || caracteres[i + 1] == 'F' || caracteres[i + 1] == 'b' || caracteres[i + 1] == 'D'
						|| caracteres[i + 1] == 'S' || caracteres[i + 1] == '?' || (caracteres[i + 1] == '/' && caracteres[i + 2] == 'o') || (caracteres[i + 1] == '/' && caracteres[i + 2] == 'P')
						|| (caracteres[i + 1] == '/' && caracteres[i + 2] == 'S')) {
					estoyBorrando = true;
				} else {
					sb.append(caracteres[i]);
				}
			} else if (caracteres[i] == '>' && estoyBorrando) {
				estoyBorrando = false;
				try {
					if (sb.substring(sb.length() - 30).indexOf("<br>") < 0) {
						sb.append("<br>");
					}
				} catch (Throwable e) {

				}
			} else if (!estoyBorrando) {
				sb.append(caracteres[i]);
			}
		}
		return sb.toString();
	}

	private int cuentaTagImg (String texto){
		
		int i = 0;
		int count = 0;
		while (i != -1){
			i = texto.indexOf("<IMG", i);
			if (i != -1){
				i++;
				count++;
			}
		}
		return count;
	}

	public List<DtoReportComunicacion> getListComunicacionesAsunto(Long idAsunto) {
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
		
		List<DtoReportComunicacion> result = new ArrayList<DtoReportComunicacion>();
		
		for (TareaNotificacion com : comunicaciones){
			
			DtoReportComunicacion dto = new DtoReportComunicacion();
			boolean anyadirNotificacion = true;
			boolean isAnotacion = false;
			
			if (com.getSubtipoTarea().getCodigoSubtarea().equals("700") || com.getSubtipoTarea().getCodigoSubtarea().equals("701")){
				isAnotacion = true;
				if (com.getCodigoTarea().equals(TipoTarea.TIPO_TAREA)){
					// Texto de la comunicaci�n
					MEJInfoRegistro infoRegistro = getTrazaParaLaTarea(com.getId());
					
					if (infoRegistro != null){
						Map<String, String> info = getInfoAdicionalTraza(infoRegistro); 
					
						if(getInfoValue(info, "DESCRIPCION_TAREA", null) != null){
							dto.setTextoComunicacion(getInfoValue(info, "DESCRIPCION_TAREA", null));
						} else {
							dto.setTextoComunicacion("");
						}
						
						// Emisor
						if(getInfoValue(info, "EMISOR_TAREA", null) != null){
							String idEmisor = getInfoValue(info, "EMISOR_TAREA", null); 
							Usuario emisor = proxyFactory.proxy(UsuarioApi.class).get(Long.valueOf(idEmisor));
							dto.setEmisor(emisor.getApellidoNombre());
						} else {
							dto.setEmisor("");
						}
						
						// Destinatario
						if(getInfoValue(info, "DESTINATARIO_TAREA", null) != null){
							String idDestinatario = getInfoValue(info, "DESTINATARIO_TAREA", null);
							Usuario destinatario = proxyFactory.proxy(UsuarioApi.class).get(Long.valueOf(idDestinatario));
							dto.setDestinatario(destinatario.getApellidoNombre());
						} else {
							dto.setDestinatario("");
						}
						
						// Respuesta
						MEJInfoRegistro infoRegistroRespuesta = getTrazaRespuestaTarea(com.getId());
			            Map<String, String> infoRespuesta = getInfoAdicionalTraza(infoRegistroRespuesta);
			            
			            if(getInfoValue(infoRespuesta, "RESP_TAREA", null) != null){
			            	dto.setRespuestaComunicacion(getInfoValue(infoRespuesta, "RESP_TAREA", null));
			            } else {
			            	dto.setRespuestaComunicacion("");
			            }
			            
					} else {
						anyadirNotificacion = false;
					}	
		            
				} else if (com.getCodigoTarea().equals(TipoTarea.TIPO_NOTIFICACION)){
					// Texto de la comunicaci�n
					MEJInfoRegistro infoRegistro = getTrazaParaLaNotificacion(com.getId());
					
					if (infoRegistro != null){
						Map<String, String> info = getInfoAdicionalTraza(infoRegistro); 
					
						// Emisor
						if(getInfoValue(info, "EMISOR_NOTIF", null) != null){
							String idEmisor = getInfoValue(info, "EMISOR_NOTIF", null); 
							Usuario emisor = proxyFactory.proxy(UsuarioApi.class).get(Long.valueOf(idEmisor));
							dto.setEmisor(emisor.getApellidoNombre());
						} else {
							dto.setEmisor("");
						}
					
						// Destinatario
						if(getInfoValue(info, "DESTINATARIO_NOTIF", null) != null){
							String idDestinatario = getInfoValue(info, "DESTINATARIO_NOTIF", null);
							Usuario destinatario = proxyFactory.proxy(UsuarioApi.class).get(Long.valueOf(idDestinatario));
							dto.setDestinatario(destinatario.getApellidoNombre());
						} else {
							dto.setDestinatario("");
						}
					
						if(getInfoValue(info, "DESCRIPCION_NOTIF", null) != null){
							dto.setTextoComunicacion(getInfoValue(info, "DESCRIPCION_NOTIF", null));
						} else {
							dto.setTextoComunicacion("");
						}
					} else {
						anyadirNotificacion = false;
					}
				}
			} else if (com.getSubtipoTarea().getCodigoSubtarea().equals("26") || com.getSubtipoTarea().getCodigoSubtarea().equals("24")
					|| com.getSubtipoTarea().getCodigoSubtarea().equals("16") || com.getSubtipoTarea().getCodigoSubtarea().equals("28")){
				
				if (!Checks.esNulo(com.getAuditoria()) && !Checks.esNulo(com.getAuditoria().getUsuarioCrear())){
					
					Usuario usuEmisor = usuarioDao.getByUsername(com.getAuditoria().getUsuarioCrear());
					
					if (!Checks.esNulo(usuEmisor)){
						dto.setEmisor(usuEmisor.getApellidoNombre());
				
						if(com.getGestor().equals(usuEmisor.getId())){
							dto.setDestinatario(com.getDescSupervisor());
						} else {
							dto.setDestinatario(com.getDescGestor());
						}
					}
				}
			}
            
            if(anyadirNotificacion){
            	
            	Boolean isRepetido = false;
            	
            	// Antes de a�adir comprobar que no sea una comunicacion repetida
            	for (DtoReportComunicacion incluido : result){
            		if(!Checks.esNulo(incluido.getTarea().getDescripcionTarea()) && incluido.getTarea().getDescripcionTarea().equals(com.getDescripcionTarea())
            				&& !Checks.esNulo(incluido.getFecha()) && !Checks.esNulo(com.getFechaInicio())
            				&& incluido.getFecha().toString().substring(0, 16).equals(com.getFechaInicio().toString().substring(0, 16))
            				&& incluido.getTarea().getEmisor().equals(com.getEmisor())){
            			isRepetido = true;
            		}
            	}
            	
            	// Tarea
            	if(!isRepetido){
            		dto.setTarea(com); 
            		dto.setAnotacion(isAnotacion);
            		dto.setFecha(com.getFechaInicio());
            		result.add(dto);
            	}
            }
            
		}	
		return result;
	}

	 private List<TareaNotificacion> getComunicacionesProcedimientos(Asunto asunto) {
		 
		 ArrayList<TareaNotificacion> tareas = new ArrayList<TareaNotificacion>();
			
		 if ((asunto != null) && (!Checks.estaVacio(asunto.getProcedimientos()))){
			for (Procedimiento p : asunto.getProcedimientos()){
				tareas.addAll(eventoDao.getComunicacionesProcedimiento(p.getId()));
			}
		}
			
		return tareas;
	}
	 
	 private void addNuevasComunicaciones(List<TareaNotificacion> comunicaciones, List<TareaNotificacion> nuevas) {

		comunicaciones.addAll(nuevas);
		for (TareaNotificacion tn : nuevas){
			if (!Checks.esNulo(tn.getTareaId())){
				if (comunicaciones.contains(tn.getTareaId())){
					comunicaciones.remove(tn.getTareaId());
				}
			}
		}
	 }
	 
	 private MEJInfoRegistro getTrazaParaLaNotificacion(Long idTarea) {
	     Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave", "ID_NOTIF");
	     Filter f2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
	     MEJInfoRegistro infoRegistro = new MEJInfoRegistro();
	     try {
	    	 infoRegistro = genericDao.get(MEJInfoRegistro.class, f1, f2);
	     } catch (Exception e) {
				return null;
	     }
	     
	     return infoRegistro;
	 }
	 
	 private MEJInfoRegistro getTrazaParaLaTarea(Long idTarea) {
	     Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave", "ID_TAREA");
	     Filter f2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
	     MEJInfoRegistro infoRegistro = new MEJInfoRegistro();
	     try {
	    	 infoRegistro = genericDao.get(MEJInfoRegistro.class, f1, f2);
	     } catch (Exception e) {
				return null;
	     }
	     return infoRegistro;
	 }
	 
	 private MEJInfoRegistro getTrazaRespuestaTarea(Long idTarea) {
	    Filter fr1 = genericDao.createFilter(FilterType.EQUALS, "clave", "ID_TAREA_ORIGINAL");
	    Filter fr2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
	    MEJInfoRegistro infoRegistroRespuesta = new MEJInfoRegistro();
	    try{
	    	infoRegistroRespuesta = genericDao.get(MEJInfoRegistro.class, fr1, fr2);
	    } catch (Exception e) {
			return null;
	    }    
	    return infoRegistroRespuesta;
	 }
	 
	 private MEJInfoRegistro getTrazaRespuestaProrroga(Long idTarea) {
		    Filter fr1 = genericDao.createFilter(FilterType.EQUALS, "clave", "tarId");
		    Filter fr2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
		    MEJInfoRegistro infoRegistroRespuesta = new MEJInfoRegistro();
		    try{
		    	infoRegistroRespuesta = genericDao.get(MEJInfoRegistro.class, fr1, fr2);
		    } catch (Exception e) {
				return null;
		    }    
		    return infoRegistroRespuesta;
		 }

	 private String getInfoValue(Map<String, String> info, String infoKey, String defaultValue) {
		 
	     if (Checks.estaVacio(info)) {
	    	 return defaultValue;
	     } else {
	         String v = info.get(infoKey);
	         return Checks.esNulo(v) ? defaultValue : v;
	     }
	 }

	 @SuppressWarnings("unchecked")
	private Map<String, String> getInfoAdicionalTraza(MEJInfoRegistro infoRegistro) {
		 
	     if (infoRegistro == null) 
	    	 return null;  
	     
	     Map<String, String> info = new HashMap<String, String>();
	     
	     try {
	    	 info = (Map<String, String>) executor.execute(MEJ_BO_GETMAPA_REGISTRO, infoRegistro.getRegistro().getId());
	     } catch (Exception e) {
				return null;
	     }
	     
	     return info;
	 }

		private List<DtoReportComunicacion> obtenerCorreosAsuntoLitigio(Long idAsunto) {

			List<DtoReportComunicacion> correos = new ArrayList<DtoReportComunicacion>();
			
			//UGASDatosExtraAsuntoFacade extras = proxyFactory.proxy(UGASAsuntoApi.class).getDatosExtraAsuntoLitigios(idAsunto);
			
			//if (!Checks.esNulo(extras)){
				List<DtoInfoCorreos> listado = getCorreos(idAsunto);//extras.getCorreos();

				for (DtoInfoCorreos b : listado) {
					DtoReportComunicacion correo = new DtoReportComunicacion();
					correo.setEmisor(b.getEmisor());
					correo.setDestinatario(b.getDestinatario());
					correo.setAsunto(b.getAsunto());
					correo.setTexto(formateaTextoHtml(b.getTexto()));
					correo.setFecha(b.getFechaEnvio());

					correos.add(correo);
				}

			//}
			
			return correos;
		}

		private List<DtoInfoCorreos> getCorreos(Long asuId) {

			List<DtoInfoCorreos> correos = new ArrayList<DtoInfoCorreos>();
			List<Long> listadoTrazas = mejAsuntoDao.getListTrazasConCorreo(asuId);

			if (!Checks.estaVacio(listadoTrazas)) {
				for (Long idTraza : listadoTrazas) {
					Map<String, String> info = proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(idTraza);
					if (!Checks.esNulo(info)) {
						String body = info.get(AgendaMultifuncionTipoEventoRegistro.EventoCorreo.CORREO_BODY);
						String to = info.get(AgendaMultifuncionTipoEventoRegistro.EventoCorreo.CORREO_TO);
						String from = info.get(AgendaMultifuncionTipoEventoRegistro.EventoCorreo.CORREO_FROM);
						String asunto = info.get(AgendaMultifuncionTipoEventoRegistro.EventoCorreo.CORREO_ASUNTO);
						MEJRegistroInfo infoFecha = proxyFactory.proxy(MEJRegistroApi.class).get(idTraza);
						Date fechaEnvio = null;
						if (!Checks.esNulo(infoFecha)) {
							fechaEnvio = infoFecha.getFecha();
						}
						DtoInfoCorreos sb = new DtoInfoCorreos(from, to, asunto, fechaEnvio, body);
						correos.add(sb);
					}
				}
			}

			return correos;
		}
	 
}
