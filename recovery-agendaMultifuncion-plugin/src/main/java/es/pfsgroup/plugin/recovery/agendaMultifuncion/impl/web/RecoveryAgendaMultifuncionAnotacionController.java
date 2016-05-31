package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.plazoTareasDefault.PlazoTareasDefaultApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.parametrizacion.ParametrizacionManager;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionRespuestaTarea;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.RecoveryAnotacionApi;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacion;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacionUsuario;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacionWeb;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.manager.RecoveryAnotacionManager;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web.dto.GestorWebDto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.recovery.api.AsuntoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTUsuarioRelacionadoInfo;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;

@Controller
public class RecoveryAgendaMultifuncionAnotacionController {
	
	public static final String ADJUNTOS_ASUNTO = "plugin/agendaMultifuncion/window/adjuntosAsunto";

	@Resource
	private Properties appProperties;

    @Autowired
    private ApiProxyFactory proxyFactory;
    
    @Autowired
    private GenericABMDao genericDao;
    
    
    protected final Log logger = LogFactory.getLog(getClass());

    /**
     * Metodo que devuelve la vista de la pantalla de anotacion
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String anotacionWindow(@RequestParam(value = "id", required = true) Long id,@RequestParam(value = "codUg", required = true) String codUg, ModelMap model) {
    	 List<GestorWebDto> listaGestoresWeb = new ArrayList<GestorWebDto>();
    	if(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equalsIgnoreCase(codUg)){
    		Set<EXTUsuarioRelacionadoInfo> listaGestores = proxyFactory.proxy(EXTAsuntoApi.class).getUsuariosRelacionados(id);
           
            for (EXTUsuarioRelacionadoInfo g : listaGestores) {
                GestorWebDto dto = new GestorWebDto();
                dto.setNombre(g.getUsuario().getApellidoNombre());
                dto.setUsername(g.getUsuario().getUsername());
                dto.setId(g.getUsuario().getId());
                if(g.getUsuario().getEmail() != null && g.getUsuario().getEmail()!="")
           		 dto.setTieneEmail(true);
           	 	else
           		 dto.setTieneEmail(false);
                listaGestoresWeb.add(dto);
                
            }
        }
        if(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equalsIgnoreCase(codUg) || DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equalsIgnoreCase(codUg)){
        	//PONEMOS DE MOMENTO SOLO EL USUARIO LOGADO
        	
        	Usuario usuLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
        	 GestorWebDto dto = new GestorWebDto();
        	 dto.setNombre(usuLogado.getApellidoNombre());
        	 dto.setUsername(usuLogado.getUsername());
        	 dto.setId(usuLogado.getId());
        	 if(usuLogado.getEmail() != null && usuLogado.getEmail()!="")
        		 dto.setTieneEmail(true);
        	 else
        		 dto.setTieneEmail(false);
        	 listaGestoresWeb.add(dto);
        }
        
        PlazoTareasDefault plazo = proxyFactory.proxy(PlazoTareasDefaultApi.class).buscarPlazoPorDescripcion("Plazo minimo autotarea");
        Long plazoMinimoAutotarea = 0L;
        if(!Checks.esNulo(plazo)){
        	plazoMinimoAutotarea = plazo.getPlazo();
        }
        
        Boolean valorParametro= false;
        valorParametro= proxyFactory.proxy(RecoveryAnotacionApi.class).getConfiVentanaAnotaciones();

       
        model.put("parametroCreacionTareaUnicaAnotacion", valorParametro);
        model.put("id", id);
        model.put("codUg", codUg);
        model.put("listaGestores", listaGestoresWeb);
        model.put("plazoMinimoAutotarea", plazoMinimoAutotarea);
        model.put("tamanyoMaximoAdjustos", appProperties.getProperty("agendaMultifuncion.mail.tamanyoMaximoAdjustos"));
        return "plugin/agendaMultifuncion/window/anotacion";
    }

    /**
     * Metodo que devuelve los usuarios para el instant de usuarios
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getUsuariosInstant(String query, ModelMap model) {
        model.put("data", proxyFactory.proxy(RecoveryAnotacionApi.class).getUsuarios(query));
        return "plugin/agendaMultifuncion/json/listaUsuariosJSON";
    }

    /**
     * Metodo que crea una nueva anotacion
     * @param dto
     * @param model
     * @return
     */
    @RequestMapping
    public String createAnotacion(DtoCrearAnotacionWeb dto, ModelMap model) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        DtoCrearAnotacion serviceDto = new DtoCrearAnotacion();
        List<DtoCrearAnotacionUsuario> listaUsuarios = new ArrayList<DtoCrearAnotacionUsuario>();

        for (String us : dto.getUsuarios()) {
            if (StringUtils.hasText(us)) {
                DtoCrearAnotacionUsuario du = new DtoCrearAnotacionUsuario();
                String datosU[] = us.split("#");
                du.setId(Long.parseLong(datosU[0]));
                du.setIncorporar("1".equals(datosU[1]));
                try {
                    du.setFecha(StringUtils.hasText(datosU[2]) ? dateFormat.parse(datosU[2]) : null);
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                du.setEmail("1".equals(datosU[3]));
                listaUsuarios.add(du);
            }
        }

        serviceDto.setUsuarios(listaUsuarios);
        serviceDto.setAsuntoMail(dto.getAsuntoMail());
        serviceDto.setCuerpoEmail(dto.getCuerpoEmail());
        if (!Checks.esNulo(dto.getAdjuntosList())){
        	List<String> listaAdjuntos= Arrays.asList(dto.getAdjuntosList().split(","));
        	List<DtoAdjuntoMail> lista = new ArrayList<DtoAdjuntoMail>();
        	for (String adj : listaAdjuntos){
        		String adjuntoNombre[]=adj.split("#");
        		Long idAdjunto=Long.parseLong(adjuntoNombre[0]);
        		Adjunto adjunto= genericDao.get(Adjunto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAdjunto));
        		DtoAdjuntoMail dtoAdjunto=new DtoAdjuntoMail();
        		dtoAdjunto.setAdjunto(adjunto);
        		dtoAdjunto.setNombre(construirNombreAdjunto(adjuntoNombre));
        		lista.add(dtoAdjunto);
        	}
        	serviceDto.setAdjuntosList(lista);
        }

        try {
            serviceDto.setFechaTodas(StringUtils.hasText(dto.getFechaTodas()) ? dateFormat.parse(dto.getFechaTodas()) : null);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        serviceDto.setIdUg(dto.getIdUg());
        serviceDto.setCodUg(dto.getCodUg());
        serviceDto.setTipoAnotacion(dto.getTipoAnotacion());

        List<String> listaDireccionesCc = new ArrayList<String>();
        if (StringUtils.hasText(dto.getCc())) {
            String direcciones[] = dto.getCc().replace(" ", "").split(",");
            if (direcciones.length > 1) {
                listaDireccionesCc.addAll(Arrays.asList(direcciones));
            } else {
                listaDireccionesCc.add(dto.getCc());
            }
        }
        serviceDto.setDireccionesMailCc(listaDireccionesCc);

        List<String> listaDireccionesPara = new ArrayList<String>();
        if (StringUtils.hasText(dto.getPara())) {
            String direcciones[] = dto.getPara().replace(" ", "").split(",");
            if (direcciones.length > 1) {
                listaDireccionesPara.addAll(Arrays.asList(direcciones));
            } else {
                listaDireccionesPara.add(dto.getPara());
            }
        }
        serviceDto.setDireccionesMailPara(listaDireccionesPara);

        proxyFactory.proxy(RecoveryAnotacionApi.class).createAnotacion(serviceDto);

        return "default";
    }
    
    private String construirNombreAdjunto(String[] adjuntoNombre) {
		String nombreAdjunto=adjuntoNombre[1];
		String nombreAdjuntoSinEspacios=nombreAdjunto.replace(" ", "");
		if(!nombreAdjuntoSinEspacios.contains(".")){
			String dtype=adjuntoNombre[2];
			String[] tipoAdjunto=dtype.split("/");
			String extension=tipoAdjunto[1];
			nombreAdjunto=nombreAdjunto+"."+extension;
		}	
		return nombreAdjunto;
	}

	@RequestMapping
    public String responderTarea(Long idTarea,Long idUg,String codUg, String respuesta, ModelMap model){
    	
    	if(anotacionYaRespondida(idTarea)) {
    		throw new UserException("plugin.agendaMultifuncion.error.anotacionYaRespondida");
    	}
    	
    	TareaNotificacion tarea = proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea);
    	
    	tarea.setFechaFin(new Date());
    	tarea.setTareaFinalizada(true);
    	
    	proxyFactory.proxy(TareaNotificacionApi.class).saveOrUpdate(tarea);
    	
    	DtoCrearAnotacionRespuestaTarea dto = new DtoCrearAnotacionRespuestaTarea();
    	dto.setIdTarea(idTarea);
    	dto.setIdUg(idUg);
    	dto.setCodUg(codUg);
    	dto.setRespuesta(respuesta);
    	
    	String emisorTarea = tarea.getEmisor();
    	
    	Usuario emisor = genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS,"username", emisorTarea),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
    	Long idEmisor=emisor.getId();
    	dto.setIdUsuarioEmisor(idEmisor);
    	
		proxyFactory.proxy(RecoveryAnotacionApi.class).createRespuesta(dto);
    	
    	return "default";
    }
    
    @RequestMapping
    public String marcarTareaLeida(Long idTarea, boolean leida, ModelMap model){
    	
    	if(leida){
    		TareaNotificacion tarea = proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea);
    	
    		tarea.setFechaFin(new Date());
    		tarea.setTareaFinalizada(true);
    		proxyFactory.proxy(TareaNotificacionApi.class).saveOrUpdate(tarea);
    	}
    	
    	
    	
    	
    	return "default";
    }
    
    @SuppressWarnings("unchecked")
	@RequestMapping
    public String obtenerTiposAnotaciones( ModelMap model){
    	
    	List<DDTipoAnotacion> lista = proxyFactory.proxy(RecoveryAnotacionApi.class).getListaTiposAnotacion();
    	model.put("data",lista);
    	return "plugin/agendaMultifuncion/json/listaTiposAnotacionJSON";
    }
    
    @RequestMapping
    public String getAdjuntosEntidad(Long id,String codUg,ModelMap model){
    	Asunto asunto;
    	if (!Checks.esNulo(codUg)){
    		if("3".equals(codUg)){
    			asunto=proxyFactory.proxy(AsuntoApi.class).get(id);
    			model.put("asunto", asunto);
    		}
    	}
    	return "plugin/agendaMultifuncion/window/adjuntosAsunto";
    }
    
    /**
     * Metodo que comprueba si ya existe una respuesta para la anotacion indicada
     * @param idTarea
     * @return true si ya existe respuesta
     */
    
    private Boolean anotacionYaRespondida(Long idTarea){
    	
    	 Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave", AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.ID_TAREA_ORIGINAL);
         Filter f2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
         Filter f3 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
         MEJInfoRegistro infoRegistro = genericDao.get(MEJInfoRegistro.class, f1, f2, f3);
         
         if(infoRegistro!=null)
        	 return true;
         
         return false;
         
    }

}
