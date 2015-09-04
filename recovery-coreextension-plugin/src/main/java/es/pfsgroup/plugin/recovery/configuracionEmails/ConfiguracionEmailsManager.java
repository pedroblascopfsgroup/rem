package es.pfsgroup.plugin.recovery.configuracionEmails;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.mail.MailManager;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.util.GenericMailUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.configuracionEmails.api.ConfiguracionEmailsApi;
import es.pfsgroup.plugin.recovery.configuracionEmails.model.ConfiguracionEmails;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Service
public class ConfiguracionEmailsManager implements ConfiguracionEmailsApi {
	
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private TareaExternaManager tareaExternaManager;
	
	@Autowired
    private UtilDiccionarioApi utilDiccionario;
	
	@Autowired
	private GenericMailUtils genericMailUtils;
	
	@Autowired
    private DictionaryManager dictionaryManager;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Resource(name = "mailManager")
	private MailManager mailManager;
	
	@Autowired
	private MEJRegistroApi mejRegistro;
		
	public void enviarEmailsTarea(TareaExterna tarea) {
	
		// Se recupera el listado de emails configurados para la tarea
		List<ConfiguracionEmails> listConfiguracionEmails = getConfiguracionEmailsByTarea(tarea.getTareaProcedimiento().getId());
		
		// Si existe alguna configuración se preparan los datos, se deja una traza y hace el envío 
		for(ConfiguracionEmails configuracionEmails : listConfiguracionEmails) {
			
			List<String> destinatarios = Arrays.asList(StringUtils.split(configuracionEmails.getDestinatarios(), ","));
			String asuntoMail = configuracionEmails.getSubject();
			String cuerpoEmail = generaCuerpo(configuracionEmails.getCuerpo(), tarea);
			
			// Se añaden los adjuntos al mensaje
			List<DtoAdjuntoMail> listaAdjuntos = new LinkedList<DtoAdjuntoMail>();
			if(configuracionEmails.getDocumentosAdjuntos() != null) {
				
				Procedimiento prc = tarea.getTareaPadre().getProcedimiento();
				List<String> documentos = Arrays.asList(StringUtils.split(configuracionEmails.getDocumentosAdjuntos(), ","));
				for(String codigoDocumento : documentos) {
					
					Set<AdjuntoAsunto> adjuntos = prc.getAdjuntos();
					for (AdjuntoAsunto adjunto : adjuntos) {
						if (!Checks.esNulo(adjunto.getProcedimiento())) {
							if (adjunto instanceof EXTAdjuntoAsunto) {
								EXTAdjuntoAsunto extAdjunto = (EXTAdjuntoAsunto) adjunto;
								DDTipoFicheroAdjunto tipoAdjunto = extAdjunto.getTipoFichero();
								if (tipoAdjunto == null) {
									continue;
								}
								if (codigoDocumento.equals(tipoAdjunto.getCodigo())) {
									
									DtoAdjuntoMail adjuntoMail = new DtoAdjuntoMail();
									adjuntoMail.setAdjunto(adjunto.getAdjunto());
									adjuntoMail.setNombre(adjunto.getNombre());
									
									listaAdjuntos.add(adjuntoMail);
								}
							}
						}
					}					
				}
			}
			
			// Se guarda la traza del envío
			Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			dejarTraza(
					usuarioLogado.getId(),
					MEJDDTipoRegistro.CODIGO_ENVIO_EMAILS,
					Long.parseLong(DDTipoEntidad.CODIGO_ENTIDAD_TAREA),
					"T",
					createInfoEventoMailConAdjunto(
							asuntoMail,
							mailManager.getUsername(),
							configuracionEmails.getDestinatarios(),
							null,
							HtmlUtils.htmlUnescape(cuerpoEmail),
							listaAdjuntos));
			
			try {
				// Se envía el correo
				genericMailUtils.enviarCorreoConAdjuntos(null, destinatarios, new LinkedList<String>(), asuntoMail, cuerpoEmail, listaAdjuntos);
			} 
			catch (Exception e) {
				logger.error("Error enviando los mails asociados a la tarea: " + e.getMessage());
				e.printStackTrace();
			}
		}
	}

	private List<ConfiguracionEmails> getConfiguracionEmailsByTarea(Long idTarea) {
		return genericDao.getList(ConfiguracionEmails.class, genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", idTarea));
	}
	
	private String generaCuerpo(String cuerpo, TareaExterna tarea) {
		
		try {			
			String cuerpoConFormato = ""; 
			List<TareaExternaValor> vValores = tareaExternaManager.obtenerValoresTarea(tarea.getId());
			Map<String, String> model = new HashMap<String, String>();
			
			// Se añaden los valores al mapa
			for(TareaExternaValor valor : vValores) {
				model.put(valor.getNombre(), valor.getValor());
			}
			
			// Se recorren los ítems asociados a la tarea para obtener la descripción de los combos en lugar de su código.
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", tarea.getTareaProcedimiento().getId()); 
			List<GenericFormItem> items = genericDao.getList(GenericFormItem.class, filtro);

			for(GenericFormItem item : items) {
			
				if(item.getType().equals("combo")) {
					
					List<Dictionary> values = dictionaryManager.getList(item.getValuesBusinessOperation());
					for(Dictionary dictionary : values) {
						
						if(dictionary.getCodigo().equals(model.get(item.getNombre()))) {
							model.put(item.getNombre(), dictionary.getDescripcion());
							
							break;
						}
					}
				}
			}
			
			// Se genera el cuerpo con sustituyendo las variables de Velocity
			cuerpoConFormato = genericMailUtils.createContentWithVelocityFromString(cuerpo, model);
			
			return cuerpoConFormato;
		} 
		catch (Exception e) {
			logger.error("Error enviando los mails asociados a la tarea.");
			e.printStackTrace();
			throw new FrameworkException("Error enviando los mails asociados a la tarea.");
		}
	}
	
	private void dejarTraza(final long idUsuario, final String tipoEvento,
			final long idUg, final String codUg,
			final Map<String, Object> infoEvento) {
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
		
		mejRegistro.guardatTrazaEvento(evento);
	}
	
	private Map<String, Object> createInfoEventoMailConAdjunto(
			String asunto, String from,
			String destino,
			String cc, String cuerpo,
			List<DtoAdjuntoMail> adjuntosList) {
		HashMap<String, Object> info = new HashMap<String, Object>();

		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_ORIGEN, from);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_ASUNTO, asunto);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_DESTINO, destino);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_CC, cc);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_CUERPO, cuerpo);
		if(!Checks.esNulo(adjuntosList) && !Checks.estaVacio(adjuntosList)){
			String adjuntos="";
			for (DtoAdjuntoMail adjunto : adjuntosList){
				if ("".equals(adjuntos)){ adjuntos = adjuntos + adjunto.getAdjunto().getId();}
				else { adjuntos=adjuntos+","+adjunto.getAdjunto().getId();}
			}
			info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_ADJUNTOS,adjuntos );
		}

		return info;
	}
}
