package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoTiposAlquilerNoComercial;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOfertaAlquiler;

@Service("tramiteAlquilerNoComercialManager")
public class TramiteAlquilerNoComercialManager implements TramiteAlquilerNoComercialApi {
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;


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
				ExpedienteComercial ecoAnt = eco.getExpedienteAnterior();
				if(ecoAnt != null && ecoAnt.getOferta() != null) {
					if(DDTipoOfertaAlquiler.isSubrogacion(ecoAnt.getOferta().getTipoOfertaAlquiler())) {
						avanzaBPM = T018_PbcAlquilerDecisiones.renovacionNovacionOrigenSubrogacion.name();
					}else {
						avanzaBPM = T018_PbcAlquilerDecisiones.renovacionNovacionOrigenNoSubrogacion.name();
					}
				}
			}
		}
		
		return avanzaBPM;
	}
	
	@Override
	public String avanzaScoringBC(TareaExterna tareaExterna) {
		String avanzaBPM= null;
		
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if(eco != null) {
			ExpedienteComercial ecoAnt = eco.getExpedienteAnterior();
			if(ecoAnt != null && ecoAnt.getOferta() != null) {
				if(DDTipoOfertaAlquiler.isSubrogacion(ecoAnt.getOferta().getTipoOfertaAlquiler())) {
					avanzaBPM = T018_ScoringBcDecisiones.origenSubrogacion.name();
				}else {
					avanzaBPM = T018_ScoringBcDecisiones.origenNoSubrogacion.name();
				}
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
	
	@Override
	public boolean existeExpedienteComercialByNumExpediente(TareaExterna tareaExterna, String expedienteAnterior)  {
		boolean existeExpediente = false;
		ExpedienteComercial expediente = expedienteComercialApi.findOneByNumExpediente(Long.parseLong(expedienteAnterior));
		if(expediente != null) {
			existeExpediente = true;
		}
		
		return existeExpediente;
	}
	
	@Override
	public boolean isExpedienteTipoAlquilerNoComercial(TareaExterna tareaExterna, String expedienteAnterior) {
		boolean is = false;
		ExpedienteComercial expediente = expedienteComercialApi.findOneByNumExpediente(Long.parseLong(expedienteAnterior));
		if(expediente != null && expediente.getOferta() != null && DDTipoOferta.isTipoAlquilerNoComercial(expediente.getOferta().getTipoOferta())) {
			is = true;
		}
		return is;
	}
	
	@Override
	public boolean isExpedienteFirmado(TareaExterna tareaExterna, String expedienteAnterior) {
		boolean isFirmado = false;
		ExpedienteComercial expediente = expedienteComercialApi.findOneByNumExpediente(Long.parseLong(expedienteAnterior));
		if(expediente != null && expediente.getEstado() != null && DDEstadosExpedienteComercial.isFirmado(expediente.getEstado())) {
			isFirmado = true;
		}
		return isFirmado;
	}
	

	
}