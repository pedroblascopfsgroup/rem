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


	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_AGENDARYFIRMAR, CODIGO_T018_DEFINICIONOFERTA, CODIGO_T018_PBCALQUILER, CODIGO_T018_PBCALQUILER,
			CODIGO_T018_SCORING, CODIGO_T018_SOLICITARGARANTIASADICIONALES, CODIGO_T018_TRASLADAROFERTACLIENTE, CODIGO_T018_PTECLROD,CODIGO_T018_ANALISISTECNICO};
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
