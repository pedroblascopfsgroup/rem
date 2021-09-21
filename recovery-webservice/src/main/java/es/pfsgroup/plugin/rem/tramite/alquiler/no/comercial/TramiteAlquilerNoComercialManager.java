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
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
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
	public String aprobarAnalisisBc(Long idTramite) {
		 // Valor de prueba, poner null cuando se implemente el calculo.
		String valorAprobacionAnalisisBc = T018_AnalisisBcDecisiones.renovacionNovacion.name(); // Valor de prueba, poner null cuando se implemente el calculo.
		TareaExterna tareaAnalisisBc = null;
		List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaByIdTramite(idTramite);
		for (TareaExterna tarea : listaTareas) {
			if(T018_ANALISIS_BC.equals(tarea.getTareaProcedimiento().getCodigo())) {
				tareaAnalisisBc = tarea;
				break;
			}
		}
		if(tareaAnalisisBc != null) {
			/*
			ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaAnalisisBc);
						
			if(eco != null) {
				CondicionanteExpediente coe = eco.getCondicionante();
				if(coe != null) {
					DDTipoOfertaAlquiler tipoOfertaAlquiler = new DDTipoOfertaAlquiler(); // aqui hay que recoger el valor de la oferta 
					
					if(tipoOfertaAlquiler != null) {
						switch (tipoOfertaAlquiler.getCodigo()) {
						case DDTipoOfertaAlquiler.CODIGO_RENOVACION:
							return T018_AnalisisBcDecisiones.renovacionNovacion.name();
						case DDTipoOfertaAlquiler.CODIGO_SUBROGACION:
							return T018_AnalisisBcDecisiones.subrogacion.name();
						case DDTipoOfertaAlquiler.CODIGO_ALQUILER_SOCIAL:
							if(coe.getVulnerabilidadDetectada() == null || !coe.getVulnerabilidadDetectada()) {
								return T018_AnalisisBcDecisiones.alquilerSocialNoVulnerable.name();								
							} else {
								if(!analisisTecnico) {
									return T018_AnalisisBcDecisiones.alquilerSocialSiVulnerableNoAnalisis.name();								
								}else {
									return T018_AnalisisBcDecisiones.alquilerSocialSiVulnerableSiAnalisis.name();								
								}
							}
						}
						
					}					
				}
			}
			*/
		}
		return valorAprobacionAnalisisBc;
	}

	@Override
	public String aprobarPbcAlquiler(Long idTramite) {
		 // Valor de prueba, poner null cuando se implemente el calculo.
		String valorAprobacionPbcAlquiler = T018_PbcAlquilerDecisiones.renovacionNovacionOrigenSubrogacion.name(); // Valor de prueba, poner null cuando se implemente el calculo.
		TareaExterna tareaPbcAlquiler = null;
		List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaByIdTramite(idTramite);
		for (TareaExterna tarea : listaTareas) {
			if(T018_PBC_ALQUILER.equals(tarea.getTareaProcedimiento().getCodigo())) {
				tareaPbcAlquiler = tarea;
				break;
			}
		}
		if(tareaPbcAlquiler != null) {
			/*
			ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaPbcAlquiler);
						
			if(eco != null) {
				
				CondicionanteExpediente coe = eco.getCondicionante();
				if(coe != null) {
					DDTipoOfertaAlquiler tipoOfertaAlquiler = new DDTipoOfertaAlquiler(); // aqui hay que recoger el valor de la oferta 
					
					if(tipoOfertaAlquiler != null) {
						switch (tipoOfertaAlquiler.getCodigo()) {
						case DDTipoOfertaAlquiler.CODIGO_SUBROGACION:
							return T018_PbcAlquilerDecisiones.subrogacionAcepta.name();
						case DDTipoOfertaAlquiler.CODIGO_RENOVACION:
							if(!origenSubrogacion) {
								return T018_PbcAlquilerDecisiones.renovacionNovacionOrigenNoSubrogacion.name();
							}else {
								return T018_PbcAlquilerDecisiones.renovacionNovacionOrigenSubrogacion.name();
							}
						}						
					}					
				}
			}	
			*/
		}
		return valorAprobacionPbcAlquiler;
	}

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
	public String aprobarRevisionBcYCondiciones(Long idTramite) {
		String valorAprobacionRevisionBcYCondiciones = null;
		TareaExterna tareaRevisionBcYCondiciones = null;
		List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaByIdTramite(idTramite);
		for (TareaExterna tarea : listaTareas) {
			if(T018_REVISION_BC_Y_CONDICIONES.equals(tarea.getTareaProcedimiento().getCodigo())) {
				tareaRevisionBcYCondiciones = tarea;
				break;
			}
		}
		if(tareaRevisionBcYCondiciones != null) {
			
			ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaRevisionBcYCondiciones);
						
			if(eco != null) {
				
				CondicionanteExpediente coe = eco.getCondicionante();
				if(coe != null) {
					if(coe.getVulnerabilidadDetectada() == null || !coe.getVulnerabilidadDetectada()) {
						return T018_RevisionBcYCondicionesDecisiones.apruebaNoVulnerable.name();
					}else {
						return T018_RevisionBcYCondicionesDecisiones.apruebaSiVulnerable.name();
					}
				}
			}	
			
		}
		return valorAprobacionRevisionBcYCondiciones;
	}
		
	private enum T018_AnalisisBcDecisiones{
		renovacionNovacion, subrogacion, alquilerSocialNoVulnerable, alquilerSocialSiVulnerableNoAnalisis, alquilerSocialSiVulnerableSiAnalisis;
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
	
}