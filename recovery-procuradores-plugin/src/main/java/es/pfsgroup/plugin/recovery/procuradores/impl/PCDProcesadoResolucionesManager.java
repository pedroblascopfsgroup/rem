package es.pfsgroup.plugin.recovery.procuradores.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.multigestor.api.GestorAdicionalAsuntoApi;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.RecoveryAnotacionApi;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacion;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacionUsuario;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.tareaNotificacion.MEJTareaNoficacionApi;
import es.pfsgroup.plugin.recovery.procuradores.api.PCDProcesadoResolucionesApi;
//import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;
//import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;
//import es.pfsgroup.recovery.ext.impl.tareas.EXTDtoGenerarTareaIdividualizadaImpl;

@Service
@Transactional(readOnly = false)
public class PCDProcesadoResolucionesManager implements PCDProcesadoResolucionesApi{
	

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	//private static final String ESTADO_GUARDAR = MSVDDEstadoProceso.CODIGO_PTE_VALIDAR;
	//private static final String ESTADO_PROCESADO = MSVDDEstadoProceso.CODIGO_PROCESADO;
	private static final String ESTADO_RECHAZADO = MSVDDEstadoProceso.CODIGO_RECHAZADO;
	
	private static final String COD_ENTIDAD = "3";
//	private static final long ID_GESTOR = 25053;
//	private static final long ID_PROCURADOR = 25054;
//	private static final String SUBTIPO_TAREA_TAREA = "700";
//	private static final boolean FLAG_EN_ESPERA = false;
	private static final String TIPO_ANOTACION_TAREA = "T";
	private static final int CODIGO_TIPO_RESOLUCION_TAREA = 1003;
	private static final int CODIGO_TIPO_RESOLUCION_NOTIFICACION = 1005;
	private static final int CODIGO_TIPO_RESOLUCION_SUBIDA = 1000;
	private static final String CODIGO_TIPO_LETRADO = "LETR";
	
	@Override
	@BusinessOperation(PCD_BO_GENERAR_AUTOPRORROGA)
	public void generarAutoprorroga(MSVResolucionesDto dtoResolucion) throws ParseException{
	    SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
	    String strFecha = dtoResolucion.getCamposDinamicos().get("d_fechaProrroga");
	    Date fecha = null;
	    fecha = formato.parse(strFecha);
		    
		DtoSolicitarProrroga dtoSolicitarProrroga = new DtoSolicitarProrroga();

		
		dtoSolicitarProrroga.setCodigoCausa(dtoResolucion.getCamposDinamicos().get("d_motivoProrroga"));
		
		dtoSolicitarProrroga.setIdTareaAsociada(dtoResolucion.getIdTarea());
		dtoSolicitarProrroga.setFechaPropuesta(fecha);
		dtoSolicitarProrroga.setIdTipoEntidadInformacion(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
		dtoSolicitarProrroga.setIdEntidadInformacion(dtoResolucion.getIdProcedimiento());
		dtoSolicitarProrroga.setDescripcionCausa(dtoResolucion.getCamposDinamicos().get("d_observaciones"));
		proxyFactory.proxy(MEJTareaNoficacionApi.class).generarAutoprorroga(dtoSolicitarProrroga);
				
		dtoResolucion.setEstadoResolucion(PCDProcesadoResolucionesManager.ESTADO_RECHAZADO);
	}

	@Override
	@BusinessOperation(PCD_BO_GENERAR_COMUNICACION)
	public void generarComunicacion(MSVResolucionesDto dtoResolucion) throws ParseException {
		SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
	    String strFecha = dtoResolucion.getCamposDinamicos().get("d_fecha");
	    Date fecha = null;
	    fecha = formato.parse(strFecha);
	    					
		DtoGenerarTarea dtoGenerarTarea = new DtoGenerarTarea();
		dtoGenerarTarea.setCodigoTipoEntidad(DDTipoEntidad.CODIGO_ENTIDAD_TAREA);
		dtoGenerarTarea.setFecha(fecha);
		dtoGenerarTarea.setSubtipoTarea(SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR);

		if(dtoResolucion.getCamposDinamicos().get("d_requiererespuesta").equals("01"))
		{
			dtoGenerarTarea.setEnEspera(false);
			dtoGenerarTarea.setEsAlerta(false);
		}
		dtoGenerarTarea.setDescripcion(dtoResolucion.getCamposDinamicos().get("d_texto"));
		proxyFactory.proxy(TareaNotificacionApi.class).crearTareaComunicacion(dtoGenerarTarea);
	}
	
	@Override
	@BusinessOperation(PCD_BO_GENERAR_COMUNICACION_SUBIDA_FICHERO)
	public void generarComunicacionSubidaFichero(MSVResolucionesDto dtoResolucion) throws ParseException {

	    Date fecha = new Date();
	    					
		DtoGenerarTarea dtoGenerarTarea = new DtoGenerarTarea();
		dtoGenerarTarea.setCodigoTipoEntidad(DDTipoEntidad.CODIGO_ENTIDAD_TAREA);
		dtoGenerarTarea.setFecha(fecha);
		dtoGenerarTarea.setSubtipoTarea(SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR);
		dtoGenerarTarea.setEnEspera(false);
		dtoGenerarTarea.setEsAlerta(false);
		dtoGenerarTarea.setDescripcion(dtoResolucion.getCamposDinamicos().get("d_observaciones"));

		proxyFactory.proxy(TareaNotificacionApi.class).crearTareaComunicacion(dtoGenerarTarea);
	}
	
	
	@Override
	@BusinessOperation(PCD_BO_GENERAR_TAREA)
	public void generarTarea(MSVResolucionesDto dtoResolucion) throws Exception
	{
		MSVResolucion resolucion = proxyFactory.proxy(MSVResolucionApi.class).getResolucion(dtoResolucion.getIdResolucion());
		SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
		Date fecha = null;
		if(!Checks.esNulo(dtoResolucion.getCamposDinamicos().get("d_fecha")))
		{
			String strFecha = dtoResolucion.getCamposDinamicos().get("d_fecha");
			fecha = formato.parse(strFecha);
		}
		
		DtoCrearAnotacion serviceDto = new DtoCrearAnotacion();
		List<String> listaDireccionesCc = new ArrayList<String>();
        List<String> listaDireccionesPara = new ArrayList<String>();

		
		
		//Introducimos el usuario en un listado de usuarios para almacenar el dto en el formato correcto.
		List<DtoCrearAnotacionUsuario> listaUsuarios = new ArrayList<DtoCrearAnotacionUsuario>();
		Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(dtoResolucion.getIdAsunto());
		DtoCrearAnotacionUsuario du = new DtoCrearAnotacionUsuario();
		if (dtoResolucion.getComboTipoResolucionNew() == PCDProcesadoResolucionesManager.CODIGO_TIPO_RESOLUCION_TAREA ||
				dtoResolucion.getComboTipoResolucionNew() == PCDProcesadoResolucionesManager.CODIGO_TIPO_RESOLUCION_NOTIFICACION ||
				dtoResolucion.getComboTipoResolucionNew() == PCDProcesadoResolucionesManager.CODIGO_TIPO_RESOLUCION_SUBIDA){ //Tarea
			List<Usuario> usuarios = (List<Usuario>) proxyFactory.proxy(GestorAdicionalAsuntoApi.class).findGestoresByAsunto(asu.getId(), CODIGO_TIPO_LETRADO);
			if(usuarios.size()>0){
				///Asignamos el letrado de momento para HAYA, se creara una configuración donde se sleccione el destinatario
				du.setId(usuarios.get(0).getId());
			}else{
				///Si no tiene letrado, asignamos al gestor
				du.setId(asu.getGestor().getUsuario().getId());
			}
			///du.setId(asu.getGestor().getUsuario().getId());
		
		}else{ //Autotarea
			du.setId(asu.getProcurador().getUsuario().getId());
		}
		
		du.setIncorporar(true);
		if(!Checks.esNulo(fecha)) 
			du.setFecha(fecha);
		listaUsuarios.add(du);
		serviceDto.setUsuarios(listaUsuarios);
		
		//Si hubiese que mandar e-mail habría que rellenar setAsuntoMail setCuerpoEmail setDireccionesMailCc listaDireccionesPara
		//serviceDto.setIdUg(PCDProcesadoResolucionesManager.ID_GESTOR);
		serviceDto.setIdUg(dtoResolucion.getIdAsunto());
		serviceDto.setCodUg(PCDProcesadoResolucionesManager.COD_ENTIDAD);
		serviceDto.setTipoAnotacion(PCDProcesadoResolucionesManager.TIPO_ANOTACION_TAREA);
		if(dtoResolucion.getComboTipoResolucionNew() == PCDProcesadoResolucionesManager.CODIGO_TIPO_RESOLUCION_SUBIDA)
		{
			serviceDto.setCuerpoEmail("Se ha realizado la subida del fichero "+resolucion.getAdjuntoFinal().getNombre()+"["+resolucion.getAdjuntoFinal().getTipoFichero().getDescripcion()+"]"+ " al asunto "+dtoResolucion.getAsunto());
			serviceDto.setAsuntoMail("Subida de fichero");
		}else{
			serviceDto.setCuerpoEmail(dtoResolucion.getCamposDinamicos().get("d_mensaje"));
			serviceDto.setAsuntoMail(dtoResolucion.getCamposDinamicos().get("d_asunto"));
		}
		serviceDto.setDireccionesMailCc(listaDireccionesCc);
		serviceDto.setDireccionesMailPara(listaDireccionesPara);
		
		
		Long idTarea = proxyFactory.proxy(RecoveryAnotacionApi.class).createAnotacion(serviceDto).get(0);
		//proxyFactory.proxy(RecoveryAnotacionApi.class).createAnotacion(serviceDto);
		//Almacenamos la tarea en la tabla de resoluciones.
		TareaNotificacion tarea = proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea);
		proxyFactory.proxy(MSVResolucionApi.class).getResolucion(dtoResolucion.getIdResolucion()).setTareaNotificacion(tarea);
	}
	
}
