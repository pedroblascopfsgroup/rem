package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoEmailReserva;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Component
public class NotificatorServiceContabilidadBbva extends AbstractNotificatorService {
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	public void notificatorFinTareaConValores(ExpedienteComercial expediente) {
		
			DtoEmailReserva dtoEmailReserva = rellenarDtoEmailReserva(expediente);
			
			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
			String correos = null;
			
//			correos = tramite.getTrabajo().getSolicitante().getEmail();
//		    Collections.addAll(mailsPara, correos.split(";"));
//			mailsCC.add(this.getCorreoFrom());
//			
//			String contenido = "";
//			String titulo = "";
//			String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + " - ") : "";
//	
//				contenido = "<p>El gestor responsable de tramitar su petición la ha aceptado, por lo que se ha procedido a actualizar la información solicitada en los activos correspondientes.</p>";
//			
//				titulo = "Notificación de aceptación de petición en REM (" + descripcionTrabajo + " Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
//				
//			
//			genericAdapter.sendMail(mailsPara, mailsCC, titulo, generateBodyMailVenta(dtoEmailReserva, contenido));
		}
	
	public DtoEmailReserva rellenarDtoEmailReserva(ExpedienteComercial expediente) {
		DtoEmailReserva dtoEmailReserva = new DtoEmailReserva();
		dtoEmailReserva.setNumeroOferta(expediente.getOferta().getNumOferta());
		dtoEmailReserva.setImporteOferta(expediente.getOferta().getImporteOferta());
		dtoEmailReserva.setImporteReserva(expediente.getReserva().getImporteDevuelto());
		return null;
		
	}
	
}

	
	

