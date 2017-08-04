package es.pfsgroup.plugin.rem.adapter;

import java.util.ArrayList;
import java.util.List;

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
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
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

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Dictionary> getDiccionario(String diccionario) {
		
		Class<?> clase = DiccionarioTargetClassMap.convertToTargetClass(diccionario);
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
		lista = diccionarioApi.dameValoresDiccionario(clase);
		
		//sí el diccionario es 'tiposPeriodicidad' modificamos el orden
		if(clase.equals(DDTipoPeriocidad.class)){
			List listaPeriodicidad = new ArrayList();
			if(!Checks.esNulo(lista)){
				for(int i=1; i<=lista.size();i++){
					String cod;
					if(i<10)
						cod = "0"+i;
					else
						cod = ""+i;
					listaPeriodicidad.add(diccionarioApi.dameValorDiccionarioByCod(clase, cod));
				}
				lista = listaPeriodicidad;
			}else{
				return listaPeriodicidad;
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
	public void sendMail(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo, List<DtoAdjuntoMail> adjuntos) {
		// TODO: Para poner remitente, sustituirlo por el primer null de la
		// llamada al método enviarCorreoConAdjuntos
		try {
			// AgendaMultifuncionCorreoUtils.dameInstancia(executor).enviarCorreoConAdjuntos(null,
			// mailsPara, mailsCC, asunto, cuerpo, null);
			agendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos(null, mailsPara, mailsCC, asunto, cuerpo, adjuntos);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
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

}
