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
public class NoComercialAlquilerUserAssignationService implements UserAssigantionService {

	private static final 	String	CODIGO_T018_AGENDARYFIRMAR = "T018_AgendarYFirmar	";
	private static final 	String	CODIGO_T018_ANALISISBC	= 	"T018_AnalisisBc";
	private static final 	String	CODIGO_T018_ANALISISTECNICO	 = "T018_AnalisisTecnico";
	private static final 	String	CODIGO_T018_BLOQUEOSCREENING = "T018_BloqueoScreening";
	private static final 	String	CODIGO_T018_DEFINICIONOFERTA = "T018_DefinicionOferta";
	private static final 	String	CODIGO_T018_PBCALQUILER	 = "T018_PbcAlquiler";
	private static final 	String	CODIGO_T018_PTECLROD= "T018_PteClRod";
	private static final 	String	CODIGO_T018_RESOLUCIONCOMITE = "T018_ResolucionComite";
	private static final 	String	CODIGO_T018_REVISIONBCYCONDICIONES = "T018_RevisionBcYCondiciones";
	private static final 	String	CODIGO_T018_SCORING	= "T018_Scoring";
	private static final 	String	CODIGO_T018_SCORINGBC= "T018_ScoringBc";
	private static final 	String	CODIGO_T018_SOLICITARGARANTIASADICIONALES = "T018_SolicitarGarantiasAdicionales";
	private static final 	String	CODIGO_T018_TRASLADAROFERTACLIENTE = "T018_TrasladarOfertaCliente";
	private static final 	String	CODIGO_TO18_CIERRE = "T018_CierreContrato";
	private static final 	String 	CODIGO_T018_BLOQUEOSCORING = "T018_BloqueoScoring";
	private static final 	String 	CODIGO_T018_APROBACION_ALQUILER_SOCIAL = "T018_AprobacionAlquilerSocial";
	private static final 	String 	CODIGO_T018_RESPUESTA_CONTRAOFERTA_BC = "T018_RespuestaContraofertaBC";
	private static final 	String 	CODIGO_T018_ENTREGA_FIANZAS = "T018_EntregaFianzas";
	private static final 	String 	CODIGO_T018_APROBACION_OFERTA = "T018_AprobacionOferta";
	private static final 	String 	CODIGO_T018_COMUNICAR_SUBROGACION = "T018_ComunicarSubrogacion";
	private static final 	String 	CODIGO_T018_ALTA_CONTRATO_ALQUILER = "T018_AltaContratoAlquiler";
	private static final 	String 	CODIGO_T018_APROBACION_CONTRATO = "T018_AprobacionContrato";
	private static final 	String 	CODIGO_T018_AGENDAR_FIRMA_ADENDA = "T018_AgendarFirmaAdenda";
	private static final 	String 	CODIGO_T018_FIRMA_ADENDA = "T018_FirmaAdenda";
	private static final 	String 	CODIGO_T018_ALTA_CONTRATO_ALQUILER_ADENDA = "T018_AltaContratoAlquilerAdenda";
	private static final 	String 	CODIGO_T018_PROPONER_RECESION_CLIENTE = "T018_ProponerRescisionCliente";
	private static final 	String 	CODIGO_T018_FIRMA_RECESION_CONTRATO = "T018_FirmaRescisionContrato";
	private static final 	String 	CODIGO_T018_RESPUESTA_REAGENDACION_BC = "T018_RespuestaReagendacionBC";
	private static final 	String 	CODIGO_T018_FIRMA_CONTRATO = "T018_FirmaContrato";
	private static final 	String 	CODIGO_T018_AGENDAR_FIRMA = "T018_AgendarFirma";
	private static final 	String 	CODIGO_T018_RESPUESTA_OFERTA_BC = "T018_RespuestaOfertaBC";
	private static final 	String 	CODIGO_T018_DECISION_COMITE = "T018_DecisionComite";
	private static final 	String 	CODIGO_T018_DECISION_CONTINUIDAD_OFERTA = "T018_DecisionContinuidadOferta";

	

	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_AGENDARYFIRMAR, CODIGO_T018_DEFINICIONOFERTA, CODIGO_T018_PBCALQUILER, CODIGO_T018_BLOQUEOSCREENING,
			CODIGO_T018_SCORING, CODIGO_T018_SOLICITARGARANTIASADICIONALES, CODIGO_T018_TRASLADAROFERTACLIENTE, CODIGO_T018_PTECLROD,
			CODIGO_T018_ANALISISTECNICO,CODIGO_TO18_CIERRE,CODIGO_T018_BLOQUEOSCORING,CODIGO_T018_SCORINGBC,CODIGO_T018_REVISIONBCYCONDICIONES,
			CODIGO_T018_RESOLUCIONCOMITE,CODIGO_T018_ANALISISBC,CODIGO_T018_ALTA_CONTRATO_ALQUILER,CODIGO_T018_ALTA_CONTRATO_ALQUILER_ADENDA,
			CODIGO_T018_DECISION_COMITE, CODIGO_T018_DECISION_CONTINUIDAD_OFERTA};
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		//GCOMALQ o GCOM por defecto CODIGO_GESTOR_COMERCIAL_ALQUILERES
		Usuario gestor = this.getGestorOrSupervisorByCodigo(tareaExterna, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES);
		if(gestor == null) {
			EXTTareaProcedimiento tareaProcedimiento = (EXTTareaProcedimiento)tareaExterna.getTareaProcedimiento();
			gestor = this.getGestorOrSupervisorByCodigo(tareaExterna, tareaProcedimiento.getTipoGestor().getCodigo());
		}
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
