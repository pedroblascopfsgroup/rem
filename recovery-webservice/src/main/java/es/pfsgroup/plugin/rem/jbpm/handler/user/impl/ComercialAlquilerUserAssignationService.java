package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.TareaActivo;

@Component
public class ComercialAlquilerUserAssignationService implements UserAssigantionService {

	private static final String CODIGO_T015_ACEPTACION_CLIENTE = "T015_AceptacionCliente";
	private static final String CODIGO_T015_CIERRE_CONTRATO = "T015_CierreContrato";
	private static final String CODIGO_T015_DEFINICION_OFERTA = "T015_DefinicionOferta";
	private static final String CODIGO_T015_ELEVAR_A_SANCION = "T015_ElevarASancion";
	private static final String CODIGO_T015_FIRMA = "T015_Firma";
	private static final String CODIGO_T015_POSICIONAMIENTO = "T015_Posicionamiento";
	private static final String CODIGO_T015_RESOLUCION_EXPEDIENTE = "T015_ResolucionExpediente";
	private static final String CODIGO_T015_RESOLUCION_PBC = "T015_ResolucionPBC";
	private static final String CODIGO_T015_VERIFICAR_SCORING = "T015_VerificarScoring";
	private static final String CODIGO_T015_VERIFICAR_SEGURO_RENTAS = "T015_VerificarSeguroRentas";

	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_ACEPTACION_CLIENTE, CODIGO_T015_CIERRE_CONTRATO, 
				CODIGO_T015_DEFINICION_OFERTA, CODIGO_T015_ELEVAR_A_SANCION, CODIGO_T015_FIRMA,
				CODIGO_T015_POSICIONAMIENTO, CODIGO_T015_RESOLUCION_EXPEDIENTE, CODIGO_T015_RESOLUCION_PBC,
				CODIGO_T015_VERIFICAR_SCORING, CODIGO_T015_VERIFICAR_SEGURO_RENTAS};
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		
		EXTTareaProcedimiento tareaProcedimiento = (EXTTareaProcedimiento)tareaExterna.getTareaProcedimiento();
		Usuario gestor = this.getGestorOrSupervisorByCodigo(tareaExterna, tareaProcedimiento.getTipoGestor().getCodigo());
		return gestor;
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		
		return this.getGestorOrSupervisorByCodigo(tareaExterna, GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES);
	}
	
	private Usuario getGestorOrSupervisorByCodigo(TareaExterna tareaExterna, String codigo) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		Usuario gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), codigo);
		
		return gestor;
	}
}
