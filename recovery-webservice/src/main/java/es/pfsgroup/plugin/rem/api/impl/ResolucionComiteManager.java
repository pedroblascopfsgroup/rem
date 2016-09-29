package es.pfsgroup.plugin.rem.api.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;

@Service("resolucionComiteManager")
public class ResolucionComiteManager implements ResolucionComiteApi{

	
//	@Autowired
//	private OfertaApi ofertaApi;
//
//	@Autowired
//	private ExpedienteComercialApi expedienteComercialApi;
	
	@Override
	public void aprobada(ResolucionComiteDto resolucionComiteDto) {
		
		final Log logger = LogFactory.getLog(getClass());
		
//		Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(resolucionComiteDto.getOfertaHRE());
//		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta (oferta.getId());
		
//		DDEstadosExpedienteComercial estadoAprobado = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.APROBADO);
//		expedienteComercial.setEstado(estadoAprobado);
		
		logger.warn("RESOLUCION_APROBADA: CodigoComite="+resolucionComiteDto.getCodigoComite()+" CodigoResolucion="+resolucionComiteDto.getCodigoResolucion());
		//TODO: Falta hacer BPM de RESOLUCION_APROBADA
		
	}

	@Override
	public void denegada(ResolucionComiteDto resolucionComiteDto) {
		
		final Log logger = LogFactory.getLog(getClass());
		
//		Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(resolucionComiteDto.getOfertaHRE());
//		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta (oferta.getId());
		
//		DDEstadoOferta ofertaDenegada = ofertaApi.getDDEstadosOfertaByCodigo(DDEstadoOferta.CODIGO_RECHAZADA);
//		oferta.setEstadoOferta(ofertaDenegada);
//		DDEstadosExpedienteComercial estadoDenegado = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.DENEGADO);
//		expedienteComercial.setEstado(estadoDenegado);
		logger.warn("RESOLUCION_DENEGADA: CodigoComite="+resolucionComiteDto.getCodigoComite()+" CodigoDenegacion="+resolucionComiteDto.getCodigoDenegacion());
		//TODO: Falta hacer BPM de RESOLUCION_DENEGADA		
		
	}

	@Override
	public void contraofertada(ResolucionComiteDto resolucionComiteDto) {
		
		final Log logger = LogFactory.getLog(getClass());
		
//		Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(resolucionComiteDto.getOfertaHRE());
//		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta (oferta.getId());
		
//		DDEstadosExpedienteComercial estadoContraofertado = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.CONTRAOFERTADO);
//		expedienteComercial.setEstado(estadoContraofertado);
		logger.warn("RESOLUCION_CONTRAOFERTA: CodigoComite="+resolucionComiteDto.getCodigoComite()+" ImporteContraoferta="+resolucionComiteDto.getImporteContraoferta());
		//TODO: Falta hacer BPM de RESOLUCION_CONTRAOFERTA
		
	}

}
