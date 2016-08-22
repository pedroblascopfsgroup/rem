package es.pfsgroup.plugin.rem.adapter;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.api.controlAcceso.EXTControlAccesoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.direccion.api.DireccionApi;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.factory.DTOFactory;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils.AgendaMultifuncionCorreoUtils;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;

@Service
public class GenericAdapter {
	
    @Autowired
    private DTOFactory dtoFactory;
    
    @Autowired
    private UsuarioApi usuarioApi;
    
    @Autowired
    private UtilDiccionarioApi diccionarioApi;
    
    @Autowired
    private DictionaryManager diccionarioManager;
    
    @Autowired
    private DireccionApi direccionApi;
    
    @Autowired
    private ActivoApi activoApi;
    
	@Autowired
	private Executor executor;

	@Autowired
	private AgendaMultifuncionCorreoUtils agendaMultifuncionCorreoUtils;
	
	@Autowired
	EXTControlAccesoApi controlAccesoApi;
	
    @Autowired
    private GenericABMDao genericDao;
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
    
	@SuppressWarnings("unchecked")
	public List<Dictionary> getDiccionario(String diccionario) {
		
		Class<?> clase = DiccionarioTargetClassMap.convertToTargetClass(diccionario);
		
		try {
			if(!Checks.esNulo(clase.getField("auditoria"))) {
				return diccionarioApi.dameValoresDiccionario(clase);
			}
		} catch (Exception e) {			
		}
		
		return diccionarioApi.dameValoresDiccionarioSinBorrado(clase);
		
		
		
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
	 * Manda un correo electrónico sin adjunto al listado de emails indicado en mailsPara y mailsCC
	 */
	public void sendMail(List<String> mailsPara, List<String> mailsCC, String asunto, String cuerpo)
	{
	// TODO: Para poner remitente, sustituirlo por el primer null de la llamada al método enviarCorreoConAdjuntos
		try {
			//AgendaMultifuncionCorreoUtils.dameInstancia(executor).enviarCorreoConAdjuntos(null, mailsPara, mailsCC, asunto, cuerpo, null);
			agendaMultifuncionCorreoUtils.enviarCorreoConAdjuntos(null, mailsPara, mailsCC, asunto, cuerpo, null);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * LLama a la api de control de acceso para registrar al usuario identificado
	 */
	public void registerUser() {		
		controlAccesoApi.registrarAccesoDeUsuario();		
	}
	
	public Boolean isSuper(Usuario usuario){
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYASUPER");
		Perfil perfilSuper = genericDao.get(Perfil.class, filtro);
				
		return usuario.getPerfiles().contains(perfilSuper);
	}

}
