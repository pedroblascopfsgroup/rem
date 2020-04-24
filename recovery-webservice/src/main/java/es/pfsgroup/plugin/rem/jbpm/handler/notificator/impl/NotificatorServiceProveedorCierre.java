package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.mail.MailManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

@Component
public class NotificatorServiceProveedorCierre extends AbstractNotificatorService implements NotificatorService {

	private static final String CODIGO_T004_CIERRE_ECONOMICO = "T004_CierreEconomico";
	private static final String BUZON_ELECNOR = "buzonelecnor";
	private static final String ELECNOR ="---------.29";
	private static final String BUZON_BANKIA_ASISTA	= "BUZON BANKIA ASISTA";
	private static final String BANKIA_ASISTA = "---------.5";
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T004_CIERRE_ECONOMICO};
	}
	
	@Resource(name = "mailManager")
	private MailManager mailManager;

	@Override
	public void notificator(ActivoTramite tramite) {
		
		//Comprobamos que el proveedor no sea null para el caso de que salte a la tarea de Cierre
		if(!Checks.esNulo(tramite.getTrabajo().getProveedorContacto())){
			DtoSendNotificator dtoSendNotificator = this.rellenaDtoSendNotificator(tramite);
			
			List<String> mailsPara = new ArrayList<String>();
			List<String> mailsCC = new ArrayList<String>();
			String correos = null;
					    	
		    if(!Checks.esNulo(tramite.getTrabajo().getProveedorContacto())){
		    	correos = tramite.getTrabajo().getProveedorContacto().getEmail();
			    if(!Checks.esNulo(tramite.getTrabajo().getProveedorContacto().getUsuario()) 
			    		&& ELECNOR.equals(tramite.getTrabajo().getProveedorContacto().getUsuario().getUsername())) {
			    	Usuario buzonElecnor = usuarioManager.getByUsername(BUZON_ELECNOR);			    	
					correos += !Checks.esNulo(buzonElecnor) ? ";" + buzonElecnor.getEmail() : "";
				}else if(tramite.getActivos() != null && !tramite.getActivos().isEmpty() && tramite.getActivos().get(0).getCartera() != null &&
	    				DDCartera.CODIGO_CARTERA_BANKIA.equals(tramite.getActivos().get(0).getCartera().getCodigo()) 
	    				&& BANKIA_ASISTA.equals(tramite.getTrabajo().getProveedorContacto().getUsuario().getUsername())) {
					Usuario buzonBankiaAsista = usuarioManager.getByUsername(BUZON_BANKIA_ASISTA);
	    	    	correos = !Checks.esNulo(buzonBankiaAsista) ? buzonBankiaAsista.getEmail() : "";
				}
		    }
			
			if(correos != null && !correos.equals("")) {
				Collections.addAll(mailsPara, correos.split(";"));
			}
				
			mailsCC.add(this.getCorreoFrom());
			
			String contenido = "";
			String titulo = "";		
			String descripcionTrabajo = !Checks.esNulo(tramite.getTrabajo().getDescripcion())? (tramite.getTrabajo().getDescripcion() + "-") : "";
			
			contenido = "<p>Desde HAYA RE le informamos de que el gestor del activo "+dtoSendNotificator.getNumActivo()+" ha validado positivamente su ejecución del trabajo "+dtoSendNotificator.getTipoContrato()+" "
						 + "(Número REM "+tramite.getActivo().getNumActivoRem()+"), relativo al activo nº "+dtoSendNotificator.getNumActivo()+", situado en "+dtoSendNotificator.getDireccion()+" "
						 + ", por lo que se ha procedido a su cierre económico."
				  		 + "<p>Un saludo.</p>";
			
			titulo = "Notificación de aceptación de ejecución de trabajo en REM (" + descripcionTrabajo + " Nº Trabajo "+dtoSendNotificator.getNumTrabajo()+")";
			 
			genericAdapter.sendMail(mailsPara, mailsCC, titulo, this.generateCuerpo(dtoSendNotificator, contenido));
		}
		

	}
	
	@Override
	public void notificatorFinTareaConValores(ActivoTramite tramite, List<TareaExternaValor> valores) {
		//empty
	}

}