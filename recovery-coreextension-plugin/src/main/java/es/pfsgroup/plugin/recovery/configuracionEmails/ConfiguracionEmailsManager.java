package es.pfsgroup.plugin.recovery.configuracionEmails;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.util.GenericMailUtils;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.configuracionEmails.api.ConfiguracionEmailsApi;
import es.pfsgroup.plugin.recovery.configuracionEmails.model.ConfiguracionEmails;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoAdjuntoMail;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Service
public class ConfiguracionEmailsManager implements ConfiguracionEmailsApi {
	
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private TareaExternaManager tareaExternaManager;
	
	@BusinessOperation(BO_CONFIGURACION_EMAILS_ENVIO_EMAILS)
    @Transactional(readOnly = false)
    public void enviarEmailsTarea(TareaExterna tarea) {
	
		// Se recupera el listado de emails configurados para la tarea
		List<ConfiguracionEmails> listConfiguracionEmails = getConfiguracionEmailsByTarea(tarea.getTareaProcedimiento().getId());
		
		// Si existe alguna configuración se preparan los datos y hace el envío 
		for(ConfiguracionEmails configuracionEmails : listConfiguracionEmails) {
			
			List<String> destinatarios = Arrays.asList(StringUtils.split(configuracionEmails.getDestinatarios(), ","));
			String asuntoMail = configuracionEmails.getSubject();
			String cuerpoEmail = configuracionEmails.getCuerpo();
			
			// Se añaden al cuerpo los campos de la tarea y su valor
			List<TareaExternaValor> vValores = tareaExternaManager.obtenerValoresTarea(tarea.getId());
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", tarea.getTareaProcedimiento().getId()); 
			List<GenericFormItem> items = genericDao.getList(GenericFormItem.class, filtro);

			for(GenericFormItem item : items) {
				
				if(!item.getNombre().equals("titulo")) {
				
					String sValor = "";
					for(TareaExternaValor valor : vValores) {
					
						if(item.getNombre().equals(valor.getNombre())) {
							
							sValor = valor.getValor();
							if(sValor == null) {
								sValor = "";
							}
							else {
								if(item.getType().equals("date")) {
									sValor = DateFormat.toString(FormatUtils.strADate(sValor, "yyyy-MM-dd"));
								}
							}
							
							break;
						}				
					}
					
					cuerpoEmail += "<p>" + item.getLabel() + ": " + sValor + "</p>";
				}
			}
			
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
			
			try {
				// Se envía el correo
				GenericMailUtils.dameInstancia().enviarCorreoConAdjuntos(null, destinatarios, new LinkedList<String>(), asuntoMail, cuerpoEmail, listaAdjuntos);
			} 
			catch (Exception e) {
				logger.error("Error enviando los mails asociados a la tarea.");
				e.printStackTrace();
				throw new FrameworkException("Error enviando los mails asociados a la tarea.");
			}
		}
	}

	private List<ConfiguracionEmails> getConfiguracionEmailsByTarea(Long idTarea) {
		return genericDao.getList(ConfiguracionEmails.class, genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", idTarea));
	}
}
