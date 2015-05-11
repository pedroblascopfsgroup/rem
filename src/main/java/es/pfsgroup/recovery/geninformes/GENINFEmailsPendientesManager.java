package es.pfsgroup.recovery.geninformes;

import java.util.List;

import javax.mail.MessagingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.geninformes.api.GENINFEmailsPendientesApi;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;
import es.pfsgroup.recovery.geninformes.dao.GENINFCorreoPendienteDao;
import es.pfsgroup.recovery.geninformes.dto.GENINFCorreoPendienteDto;
import es.pfsgroup.recovery.geninformes.model.GENINFCorreoPendiente;

/**
 * Manager que gestiona los emails pendientes de enviar
 * 
 * @author pedro
 * 
 */
@Component
public class GENINFEmailsPendientesManager implements GENINFEmailsPendientesApi {

	@Autowired
	private transient ApiProxyFactory proxyFactory;

	@Autowired
	private transient GenericABMDao genericDao;

	@Autowired
	private transient GENINFCorreoPendienteDao correoPendienteDao;
	
	@Override
	@BusinessOperation(PLUGIN_GENINFORMES_BO_PROCESAR_EMAILS_PENDIENTES)
	@Transactional(readOnly = false)
	public void procesarEmailsPendientes() {
		
		GENINFInformesApi informesManager = proxyFactory.proxy(GENINFInformesApi.class);
		
		List<GENINFCorreoPendiente> listaCorreosPendientes = correoPendienteDao.getCorreosPendientes();
		
		// Recorrer la lista y procesarla
		for (GENINFCorreoPendiente geninfCorreoPendiente : listaCorreosPendientes) {
			Filter filtroAdjunto = genericDao.createFilter(FilterType.EQUALS, "id", geninfCorreoPendiente.getIdAdjunto());
			EXTAdjuntoAsunto adjunto = genericDao.get(EXTAdjuntoAsunto.class, filtroAdjunto);
			boolean enviado = false;
			if (!Checks.esNulo(adjunto)) {
				try {
					GENINFCorreoPendienteDto dto = new GENINFCorreoPendienteDto();
					dto.populateDto(geninfCorreoPendiente);
					//adjunto.setContentType("application/pdf");
					//TDOD: Revisar cómo obtener el contenttype, que está en la tabla
					// y ver si los nombres ya llevan extensión.
					//adjunto.setContentType("application/rtf");
					dto.setAdjunto(adjunto.getAdjunto().getFileItem());
					//dto.setNombreAdjunto(adjunto.getNombre() + ".pdf");
					dto.setNombreAdjunto(adjunto.getNombre());
					informesManager.enviarMailConEscritoAdjunto(dto);
					enviado = true;
				} catch (MessagingException e) {
					System.out.println("[GENINFEmailsPendientesManager]: Error al enviar email: " + e.getMessage());
					//e.printStackTrace();
				}
			} else {
				enviado = true;
			}
			if (enviado) {
				geninfCorreoPendiente.setProcesado(true);
				genericDao.save(GENINFCorreoPendiente.class, geninfCorreoPendiente);
			}
		}
		
	}

}
