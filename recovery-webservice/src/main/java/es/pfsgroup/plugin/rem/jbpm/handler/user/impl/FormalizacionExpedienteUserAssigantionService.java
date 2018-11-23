package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TareaActivo;

@Component
public class FormalizacionExpedienteUserAssigantionService implements UserAssigantionService {
	
	private static final String CODIGO_T013_CIERRE_ECONOMICO = "T013_CierreEconomico";
	private static final String CODIGO_T013_INFORME_JURIDICO = "T013_InformeJuridico";
	private static final String CODIGO_T013_RESOLUCION_TANTEO = "T013_ResolucionTanteo";
	private static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";
	private static final String CODIGO_T013_POSICIONAMIENTO_FIRMA = "T013_PosicionamientoYFirma";
	private static final String CODIGO_T013_DEVOLUCION_LLAVES = "T013_DevolucionLlaves";
	private static final String CODIGO_T013_DOCUMENTOS_POSTVENTA = "T013_DocumentosPostVenta";
	
	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		//return new String[]{CODIGO_T013_CIERRE_ECONOMICO, CODIGO_T013_INFORME_JURIDICO, CODIGO_T013_RESOLUCION_TANTEO, CODIGO_T013_RESULTADO_PBC,
		//		CODIGO_T013_POSICIONAMIENTO_FIRMA, CODIGO_T013_DEVOLUCION_LLAVES, CODIGO_T013_DOCUMENTOS_POSTVENTA};
		
		// TODO: Tira del asignador ComercialUserAssignationService. Revisar.
		return new String[]{};
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		
		return this.getGestorOrSupervisorByCodigo(tareaExterna, GestorExpedienteComercialApi.CODIGO_GESTOR_FORMALIZACION);
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		
		return this.getGestorOrSupervisorByCodigo(tareaExterna, GestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION);
	}
	
	private Usuario getGestorOrSupervisorByCodigo(TareaExterna tareaExterna, String codigo) {
		
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		if(!Checks.esNulo(tareaActivo.getTramite().getTrabajo())) {
			
			ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(tareaActivo.getTramite().getTrabajo().getId());
			return gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, codigo);
		}
		
		return null;
	}
}
