package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoTiposAlquilerNoComercial;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOfertaAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTratamiento;

@Service("tramiteAlquilerNoComercialManager")
public class TramiteAlquilerNoComercialManager implements TramiteAlquilerNoComercialApi {
	
	private static final String CAMPO_DEF_OFERTA_TIPOTRATAMIENTO = "tipoTratamiento";
	private static final String T018_ANALISIS_BC = "T018_AnalisisBc";
	private static final String T018_PBC_ALQUILER = "T018_PbcAlquiler";
	private static final String T018_SCORING_BC = "T018_ScoringBc";
	private static final String T018_REVISION_BC_Y_CONDICIONES = "T018_RevisionBcYCondiciones";
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired 
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	

	@Override
	public String aprobarScoringBc(Long idTramite) {
		 // Valor de prueba, poner null cuando se implemente el calculo.
		String valorAprobacionScoringBc = T018_ScoringBcDecisiones.origenSubrogacion.name(); // Valor de prueba, poner null cuando se implemente el calculo.
		TareaExterna tareaScoringBc = null;
		List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaByIdTramite(idTramite);
		for (TareaExterna tarea : listaTareas) {
			if(T018_SCORING_BC.equals(tarea.getTareaProcedimiento().getCodigo())) {
				tareaScoringBc = tarea;
				break;
			}
		}
		if(tareaScoringBc != null) {
			/*
			ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaScoringBc);
						
			if(eco != null) {
				
				CondicionanteExpediente coe = eco.getCondicionante();
				if(coe != null) {
					DDTipoOfertaAlquiler tipoOfertaAlquiler = new DDTipoOfertaAlquiler(); // aqui hay que recoger el valor de la oferta 
					
					if(tipoOfertaAlquiler != null && !origenSubrogacion) {
						return T018_ScoringBcDecisiones.origenNoSubrogacion.name();
					}else {
						return T018_ScoringBcDecisiones.origenSubrogacion.name();
					}
				}
			}	
			*/
		}
		return valorAprobacionScoringBc;
	}

	@Override
	public String aprobarRevisionBcYCondiciones(TareaExterna tareaExterna) {
		String valorAprobacionRevisionBcYCondiciones = null;
		
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
							
		if(eco != null) {
			Oferta ofr = eco.getOferta();
			CondicionanteExpediente coe = eco.getCondicionante();
			if(ofr != null) {
				if(DDTipoOfertaAlquiler.isAlquilerSocial(ofr.getTipoOfertaAlquiler())) {
					if(coe != null) {
						if(coe.getVulnerabilidadDetectada() != null && coe.getVulnerabilidadDetectada()) {
							return T018_RevisionBcYCondicionesDecisiones.apruebaSiVulnerable.name();
						}else {
							return T018_RevisionBcYCondicionesDecisiones.apruebaNoVulnerable.name();
						}
					}
				}else{
					return T018_RevisionBcYCondicionesDecisiones.apruebaSiVulnerable.name();
				}
			}
			
		}	
			
		
		return valorAprobacionRevisionBcYCondiciones;
	}
		
	@Override
	public String avanzaAprobarPbcAlquiler(TareaExterna tareaExterna) {
		String avanzaBPM= null;
		
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if(eco != null) {
			Oferta ofr = eco.getOferta();
			if(DDTipoOfertaAlquiler.isSubrogacion(ofr.getTipoOfertaAlquiler())) {
				avanzaBPM = T018_PbcAlquilerDecisiones.subrogacionAcepta.name();
			}else {
				//sacar la ofr origen
			}
		}
		
		return avanzaBPM;
	}
	
	@Override
	public String getCodigoSubtipoOfertaByIdExpediente(Long idExpediente) {
		String codigoTipoOfertaAlquiler = null; 
		ExpedienteComercial eco = expedienteComercialApi.findOne(idExpediente);
		if(eco != null && eco.getOferta() != null && eco.getOferta().getTipoOfertaAlquiler() != null) {
			codigoTipoOfertaAlquiler = eco.getOferta().getTipoOfertaAlquiler().getCodigo();
		}
		
		return codigoTipoOfertaAlquiler;
	}
	

	
	
	@Override
	public DtoTiposAlquilerNoComercial getInfoCaminosAlquilerNoComercial(Long idExpediente) {
		DtoTiposAlquilerNoComercial dto = new DtoTiposAlquilerNoComercial();
		ExpedienteComercial eco = expedienteComercialApi.findOne(idExpediente);
		CondicionanteExpediente coe = eco.getCondicionante();
		
		dto.setCodigoTipoAlquiler(this.getCodigoSubtipoOfertaByIdExpediente(idExpediente));
		dto.setIsVulnerable(DDSinSiNo.cambioBooleanToCodigoDiccionario(coe.getVulnerabilidadDetectada()));
			
		return dto;
	}

	private enum T018_PbcAlquilerDecisiones{
		subrogacionAcepta, renovacionNovacionOrigenSubrogacion, renovacionNovacionOrigenNoSubrogacion;
	}
	
	private enum T018_ScoringBcDecisiones{
		origenSubrogacion, origenNoSubrogacion;
	}
	
	private enum T018_RevisionBcYCondicionesDecisiones{
		apruebaNoVulnerable, apruebaSiVulnerable;
	}


	@Override
	public String aprobarPbcAlquiler(Long idTramite) {
		// TODO Auto-generated method stub
		return null;
	}
	
}