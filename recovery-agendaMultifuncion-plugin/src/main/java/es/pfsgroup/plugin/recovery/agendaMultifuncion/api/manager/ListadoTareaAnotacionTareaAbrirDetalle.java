package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.core.api.registro.ClaveValor;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoMostrarAnotacion;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandler;
import es.pfsgroup.recovery.api.TareaNotificacionApi;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;

@Component
public class ListadoTareaAnotacionTareaAbrirDetalle implements
		BuzonTareasViewHandler {
	
	protected static final Log logger = LogFactory.getLog(ListadoTareaAnotacionTareaAbrirDetalle.class);

	private static class Contador {
		
		protected final Log logger_int = LogFactory.getLog("Contador");

		private long t1 = 0;
		private long t2 = 0;
		public Contador(long currentTimeMillis) {
			t1 = currentTimeMillis;
		}

		public static Contador arranca() {
			return new Contador(System.currentTimeMillis());
		}

		public Contador para() {
			t2  = System.currentTimeMillis();
			return this;
			
		}

		public void loguea(String string) {
			StringBuilder sb = new StringBuilder("Contador: ");
			if (t2 == 0){
				sb.append(" aun esta arrancado.");
			}else{
				sb.append(" " + string);
			}
			sb.append("[" + (t2 - t1) + " ms]." );
			
			logger_int.debug(sb.toString());
			
		}

		public static void printInicio() {
			logger.debug("");
			logger.debug(">>>>>>>>>>>>> Contadores abrir tarea agenda");
			
		}
		
		public static void printFinal() {
			logger.debug("<<<<<<<<<<<<<< FIN CONTADOR");
			
		}

	}

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	public String getJspName() {
		return "plugin/agendaMultifuncion/asunto/detalleAnotacion";
	}

	@Override
	public Object getModel(Long idTarea) {
		DtoMostrarAnotacion result = null;
		if (!Checks.esNulo(idTarea)) {
			logger.info("Con contadores");
			Contador.printInicio();
			SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");

			result = new DtoMostrarAnotacion();
			Contador c = Contador.arranca();
			MEJInfoRegistro infoRegistro = getTrazaParaLaTarea(idTarea);
			c.para().loguea("Obtener la traza.");
			c = Contador.arranca();
			Map<String, String> info = getInfoAdicionalTraza(infoRegistro.getRegistro().getInfoRegistro());
			c.para().loguea("Mapeando info adicional traza.");
			
			c = Contador.arranca();
			EXTTareaNotificacion tarea = (EXTTareaNotificacion) proxyFactory.proxy(
					TareaNotificacionApi.class).get(idTarea);
			c.para().loguea("Obteniendo la notificacion.");
			

			result.setFecha(format.format(tarea.getFechaInicio()));
			result.setFechaVencimiento(format.format(tarea.getFechaVenc()));
			result.setTipoAnotacion(getTipoAnotacion(info));

			result.setFlagEmail("1".equals(getInfoValue(info,
					AgendaMultifuncionTipoEventoRegistro.EventoTarea.FLAG_MAIL,
					"0")));

			Contador c1 = Contador.arranca();
			//Obtener nombre y apellidos del destinatario en lugar de mostrar el id
            Long idDestinatario=Long.parseLong(getInfoValue(
					info,
					AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESTINATARIO_TAREA,
					null));
            Usuario destinatario = proxyFactory.proxy(UsuarioApi.class).get(idDestinatario);
            c1.para().loguea("Obtener el destiantario");
            
            result.setDestinatario(destinatario.getApellidoNombre());
            //Obtener nombre y apellidos del emisor en lugar de mostrar el id
            Long idEmisor=Long.parseLong(getInfoValue(
					info,
					AgendaMultifuncionTipoEventoRegistro.EventoTarea.EMISOR_TAREA,
					null));
            Contador c2 = Contador.arranca();
            Usuario emisor = proxyFactory.proxy(UsuarioApi.class).get(idEmisor);
            c2.para().loguea("Obtener emisor");
            
            result.setEmisor(emisor.getApellidoNombre());
			
			if(tarea.getAsunto() != null){
				result.setSituacion("Asunto");
				result.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
			}else if(tarea.getExpediente()!= null){
				result.setSituacion("Expediente");
				result.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
			}else if(tarea.getCliente() != null){
				result.setSituacion("Cliente");
				result.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
			}else if(tarea.getPersona() != null){ //PERSONA QUE NO ES CLIENTE
				result.setSituacion("Persona");
				result.setCodUg("9");
			}
			result.setIdTarea(idTarea);
			// result.setDescripcion(tarea.getTarea());
			result
					.setDescripcion(getInfoValue(
							info,
							AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESCRIPCION_TAREA,
							null));
			result.setIdAsunto(infoRegistro.getRegistro().getIdEntidadInformacion());
			
                        //Todos los usuarios que han recibido la Tarea pueden responder, no solo si el logado = destinatario...
			result.setTieneResponder(true);
			Contador c3 = Contador.arranca();
			Usuario usuLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			c3.para().loguea("Obtener el usuario logado");
			
                        String usuarioDestino = new String();
                        String usuarioOrigen = new String();
			
			usuarioDestino = ((EXTTareaNotificacion)tarea).getDestinatarioTarea().getUsername();
                        usuarioOrigen = ((EXTTareaNotificacion)tarea).getEmisor();
			

                        //...a excepción de Tareas tipo "Autotarea" en las que solo hay respuesta si el logado = destinatario
			if(!Checks.esNulo(usuarioDestino) && !Checks.esNulo(usuarioOrigen))
				if(usuarioDestino.equals(usuarioOrigen) && !usuarioDestino.equals(usuLogado.getUsername()))
					result.setTieneResponder(false);
				
			
			Contador c4 = Contador.arranca();
			MEJInfoRegistro infoRegistroRespuesta = getTrazaRespuestaTarea(idTarea);
			Map<String, String> infoRespuesta = getInfoAdicionalTraza(infoRegistroRespuesta);
			c4.para().loguea("Obtener traza / info adicional traza");
			result
					.setRespuesta(getInfoValue(
							infoRespuesta,
							AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.RESPUESTA_TAREA,
							null));
			Contador.printFinal();
			
			MSVResolucion resolucion = proxyFactory.proxy(MSVResolucionApi.class).getResolucionByTareaNotificacion(idTarea);
			if(resolucion != null && resolucion.getAdjuntoFinal()!=null){
				result.setIdArchivoAdjunto(resolucion.getAdjuntoFinal().getId());
				result.setNombreAdjunto(resolucion.getNombreFichero());
				result.setIdResolucion(resolucion.getId());
			}
			if(resolucion != null){
				result.setIdTipoResolucion(resolucion.getTipoResolucion().getId());
			}
		}
		return result;
	}

	private Map<String, String> getInfoAdicionalTraza(List<? extends ClaveValor> infoRegistro) {
		HashMap<String, String> mapa =  new HashMap<String, String>();
		if (!Checks.estaVacio(infoRegistro)){
			for (ClaveValor cv : infoRegistro){
				mapa.put(cv.getClave(), cv.getValor());
			}
			
		}
		return mapa;
	}

	private MEJInfoRegistro getTrazaRespuestaTarea(Long idTarea) {
		Filter fr1 = genericDao.createFilter(FilterType.EQUALS, "clave",
				AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.ID_TAREA);
		Filter fr2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto",
				idTarea.toString());
		MEJInfoRegistro infoRegistroRespuesta = genericDao.get(
				MEJInfoRegistro.class, fr1, fr2);
		return infoRegistroRespuesta;
	}

	private String getInfoValue(Map<String, String> info, String infoKey,
			String defaultValue) {
		if (Checks.estaVacio(info)) {
			return defaultValue;
		} else {
			String v = info.get(infoKey);
			return Checks.esNulo(v) ? defaultValue : v;
		}
	}

	private String getTipoAnotacion(Map<String, String> info) {
		if (!Checks.esNulo(info)) {
			String tipoAnotacion = info
					.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.TIPO_ANOTACION);
			 DDTipoAnotacion tipoAnotacionDD = genericDao.get(DDTipoAnotacion.class, 
		        		genericDao.createFilter(FilterType.EQUALS, "codigo", tipoAnotacion),
		        		genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		       
		        if(tipoAnotacionDD !=null)
		        	return tipoAnotacionDD.getDescripcion();
//		        if ("A".equals(tipoAnotacion)) {
//		            result.setTipoAnotacion("Alerta");
//		        } else if ("R".equals(tipoAnotacion)) {
//		            result.setTipoAnotacion("Recordatorio");
//		        } else {
//		            result.setTipoAnotacion("Desconocido");
		}
		return "Desconocido";
	}

	private Map<String, String> getInfoAdicionalTraza(
			MEJInfoRegistro infoRegistro) {
		if (infoRegistro == null) {
			return null;
		}
		Map<String, String> info = proxyFactory.proxy(MEJRegistroApi.class)
				.getMapaRegistro(infoRegistro.getRegistro().getId());
		return info;
	}

	private MEJInfoRegistro getTrazaParaLaTarea(Long idTarea) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave",
				AgendaMultifuncionTipoEventoRegistro.EventoTarea.ID_TAREA);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto",
				idTarea.toString());
		MEJInfoRegistro infoRegistro = genericDao.get(MEJInfoRegistro.class,
				f1, f2);
		return infoRegistro;
	}

	@Override
	public String getValidString() {
		return EXTSubtipoTarea.CODIGO_ANOTACION_TAREA;
	}

}
