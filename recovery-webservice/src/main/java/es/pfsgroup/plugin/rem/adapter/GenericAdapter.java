package es.pfsgroup.plugin.rem.adapter;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.api.controlAcceso.EXTControlAccesoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.AgendaMultifuncionCorreoUtils;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.thread.EnvioCorreoAsync;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;

@Service
public class GenericAdapter {

	@Autowired
	private UsuarioApi usuarioApi;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private DictionaryManager diccionarioManager;

	@Autowired
	private AgendaMultifuncionCorreoUtils agendaMultifuncionCorreoUtils;

	@Autowired
	EXTControlAccesoApi controlAccesoApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Resource
	private Properties appProperties;

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	private static final String SERVIDOR_CORREO = "agendaMultifuncion.mail.server";
	private static final String PUERTO_CORREO = "agendaMultifuncion.mail.port";

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Dictionary> getDiccionario(String diccionario) {
		
		Class<?> clase = null;
		List lista = null;
		
		//TODO: Código bueno:
//		try {
//			if(!Checks.esNulo(clase.getMethod("getAuditoria"))){
//				lista = diccionarioApi.dameValoresDiccionario(clase);
//			}
//		} catch (SecurityException e) {
//			lista = diccionarioApi.dameValoresDiccionarioSinBorrado(clase);
//		} catch (NoSuchMethodException e) {
//			lista = diccionarioApi.dameValoresDiccionarioSinBorrado(clase);
//		}
		
		//TODO: Para ver que diccionarios no tienen auditoria.
		if("gestorCommiteLiberbank".equals(diccionario)) {
			lista = new ArrayList();
			lista.add(diccionarioApi.dameValorDiccionarioByCod(DiccionarioTargetClassMap.convertToTargetClass("entidadesPropietarias")
					, DDCartera.CODIGO_CARTERA_LIBERBANK));
		}else {
			clase = DiccionarioTargetClassMap.convertToTargetClass(diccionario);
			lista = diccionarioApi.dameValoresDiccionario(clase);

			List listaPeriodicidad = new ArrayList();
			//sí el diccionario es 'tiposPeriodicidad' modificamos el orden
			if(clase.equals(DDTipoPeriocidad.class)){
				if(!Checks.esNulo(lista)){
					for(int i=1; i<=lista.size();i++){
						String cod;
						if(i<10)
							cod = "0"+i;
						else
							cod = ""+i;
						listaPeriodicidad.add(diccionarioApi.dameValorDiccionarioByCod(clase, cod));
					}
				}
			} else if (clase.equals(DDCartera.class)) {
				Usuario usuarioLogado = getUsuarioLogado();
				UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
						genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
				if (!Checks.esNulo(usuarioCartera)) {
					listaPeriodicidad.add(diccionarioApi.dameValorDiccionarioByCod(clase, usuarioCartera.getCartera().getCodigo()));
					lista = listaPeriodicidad;
				}
			}
		}	
		return lista;
	}

	public List<Dictionary> getDiccionarioTareas(String diccionario) {

		return diccionarioManager.getList(diccionario);

	}

	public Usuario getUsuarioLogado() {

		Usuario usuario = usuarioApi.getUsuarioLogado();
		return usuario;
	}

	/**
	 * 
	 * @param mailsPara
	 * @param mailsCC
	 * @param asunto
	 * @param cuerpo
	 *            Manda un correo electrónico sin adjunto al listado de emails
	 *            indicado en mailsPara y mailsCC
	 * @param adjuntos Archivos adjuntos a manar por correo
	 */
	public void sendMailSinc(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo, List<DtoAdjuntoMail> adjuntos) {
		// TODO: Para poner remitente, sustituirlo por el primer null de la
		// llamada al método enviarCorreoConAdjuntos
		try {
			// AgendaMultifuncionCorreoUtils.dameInstancia(executor).enviarCorreoConAdjuntos(null,
			// mailsPara, mailsCC, asunto, cuerpo, null);
			//añado comprobacion para que no falle en local
			for(int i = 0; i < mailsPara.size(); i++) {
				if(Checks.esNulo(mailsPara.get(i)) || "null".equals(mailsPara.get(i).toLowerCase())) {
					mailsPara.remove(i);
				}
			}
			
			if (mailsPara.isEmpty()) {
				logger.warn(
						"El correo de " + asunto + " no se va a enviar");
				return;
			}
			String servidorCorreo = appProperties.getProperty(SERVIDOR_CORREO);
			logger.info(servidorCorreo);
			String puertoCorreo =appProperties.getProperty(PUERTO_CORREO);
			logger.info(puertoCorreo);
			if(!Checks.esNulo(servidorCorreo) && !Checks.esNulo(puertoCorreo)){
				agendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos(null, mailsPara, mailsCC, asunto, cuerpo, adjuntos);
			}
		} catch (Exception e) {
			//Sacamos log de los receptores y el asunto del mail para trazar los errores
			logger.error("mailsPara: " + mailsPara + ", mailsCC: " + mailsCC + ", asunto: " + asunto);
			logger.error("error enviando correo",e);			
		}
	}
	
	public void sendMail(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo, List<DtoAdjuntoMail> adjuntos) {
		Thread hiloCorreo = new Thread(new EnvioCorreoAsync(mailsPara, mailsCC, asunto, cuerpo, adjuntos));
		hiloCorreo.start();	
	}
	
	/**
	 * 
	 * @param mailsPara
	 * @param mailsCC
	 * @param asunto
	 * @param cuerpo
	 *            Manda un correo electrónico sin adjunto al listado de emails
	 *            indicado en mailsPara y mailsCC
	 */
	public void sendMail(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo) {
		this.sendMail(mailsPara, mailsCC, asunto, cuerpo, null);
	}

	/**
	 * LLama a la api de control de acceso para registrar al usuario
	 * identificado
	 */
	public void registerUser() {
		controlAccesoApi.registrarAccesoDeUsuario();
	}

	public Boolean isSuper(Usuario usuario) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYASUPER");
		Perfil perfilSuper = genericDao.get(Perfil.class, filtro);

		return usuario.getPerfiles().contains(perfilSuper);
	}

	public Boolean isProveedor(Usuario usuario) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYAPROV");
		Perfil perfilProveedor = genericDao.get(Perfil.class, filtro);

		return usuario.getPerfiles().contains(perfilProveedor);
	}
	
	

	
	
	

	/**
	 * Es proveedor HAYA o CEE?
	 * 
	 * @param usuario
	 * @return
	 */
	public Boolean isProveedorHayaOrCee(Usuario usuario) {
		Perfil perfilProveedorHaya = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYAPROV"));

		Perfil perfilProveedorCEE = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYACERTI"));

		return usuario.getPerfiles().contains(perfilProveedorHaya)
				|| usuario.getPerfiles().contains(perfilProveedorCEE);
	}

	/**
	 * Es gestoria?
	 * 
	 * @param usuario
	 * @return
	 */
	public Boolean isGestoria(Usuario usuario) {
		Perfil GESTOADM = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GESTOADM"));

		Perfil GESTIAFORM = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GESTIAFORM"));

		Perfil HAYAGESTADMT = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYAGESTADMT"));

		Perfil GESTOCED = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GESTOCED"));

		Perfil GESTOPLUS = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GESTOPLUS"));

		Perfil GESTOPDV = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "GESTOPDV"));

		return usuario.getPerfiles().contains(GESTOADM) || usuario.getPerfiles().contains(GESTIAFORM)
				|| usuario.getPerfiles().contains(HAYAGESTADMT) || usuario.getPerfiles().contains(GESTOCED)
				|| usuario.getPerfiles().contains(GESTOPLUS) || usuario.getPerfiles().contains(GESTOPDV);
	}

	/**
	 * Comprueba si el usuario tiene el perfil pasado por parametro
	 */
	public Boolean tienePerfil(String codPerfil, Usuario u) {

		if (Checks.esNulo(u) || Checks.esNulo(codPerfil)) {
			return false;
		}
		for (Perfil p : u.getPerfiles()) {
			if (codPerfil.equals(p.getCodigo()))
				return true;
		}

		return false;
	}
	
	/**
	 * Comprueba si un usuario es gestor Haya a través de su perfil.
	 * @param usuario
	 * @return Boolean
	 */
	public Boolean isGestorHaya(Usuario usuario) {
		
		
		
		Perfil HAYAGESTCOM = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYAGESTCOM"));

		Perfil FVDBACKOFERTA = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "FVDBACKOFERTA"));

		Perfil FVDBACKVENTA = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "FVDBACKVENTA"));

		Perfil HAYABACKOFFICE = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYABACKOFFICE"));

		Perfil FVDNEGOCIO = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", "FVDNEGOCIO"));
		

		return usuario.getPerfiles().contains(HAYAGESTCOM) || usuario.getPerfiles().contains(FVDBACKOFERTA)
				|| usuario.getPerfiles().contains(FVDBACKVENTA) || usuario.getPerfiles().contains(HAYABACKOFFICE)
				|| usuario.getPerfiles().contains(FVDNEGOCIO);		
	}

}
