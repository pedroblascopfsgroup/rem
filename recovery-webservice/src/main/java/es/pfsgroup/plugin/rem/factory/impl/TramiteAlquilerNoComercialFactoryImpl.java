package es.pfsgroup.plugin.rem.factory.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.factory.TramiteAlquilerNoComercialFactory;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoOfertaAlquiler;
import es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial.TramiteAlquilerNoComercial;
import es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial.TramiteAlquilerNoComercialAlquilerSocialDacion;
import es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial.TramiteAlquilerNoComercialAlquilerSocialEjecucion;
import es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial.TramiteAlquilerNoComercialNovaciones;
import es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial.TramiteAlquilerNoComercialOcupa;
import es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial.TramiteAlquilerNoComercialRenovaciones;
import es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial.TramiteAlquilerNoComercialSubrogacionDacion;
import es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial.TramiteAlquilerNoComercialSubrogacionEjecucionHipotecaria;

@Component
public class TramiteAlquilerNoComercialFactoryImpl implements TramiteAlquilerNoComercialFactory {
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private TramiteAlquilerNoComercialAlquilerSocialDacion tncAlquilerSocialDacion;
	
	@Autowired
	private TramiteAlquilerNoComercialAlquilerSocialEjecucion tncAlquilerSocialEjecucion;
	
	@Autowired
	private TramiteAlquilerNoComercialOcupa tncOcupa;
	
	@Autowired
	private TramiteAlquilerNoComercialNovaciones tncNovaciones;
	
	@Autowired
	private TramiteAlquilerNoComercialRenovaciones tncRenovaciones;
	
	@Autowired
	private TramiteAlquilerNoComercialSubrogacionDacion tncSubrogacionDacion;
	
	@Autowired
	private TramiteAlquilerNoComercialSubrogacionEjecucionHipotecaria tncSubrogacionEjecucionHipotecaria;
	
	@Override
	public TramiteAlquilerNoComercial getTramiteAlquilerNoComercial(TareaExterna tareaExterna) {
		
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if(eco == null)
			return null;
		
		Oferta ofr = eco.getOferta();
		if(ofr == null)
			return null;
		else if(ofr != null && ofr.getSubtipoOfertaAlquiler() == null)
			return null;
		
		if (DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_DACION.equals(ofr.getSubtipoOfertaAlquiler().getCodigo()))
			return tncAlquilerSocialDacion;
		else if (DDSubtipoOfertaAlquiler.CODIGO_ALQUILER_SOCIAL_EJECUCION.equals(ofr.getSubtipoOfertaAlquiler().getCodigo()))
			return tncAlquilerSocialEjecucion;
		else if (DDSubtipoOfertaAlquiler.CODIGO_OCUPA.equals(ofr.getSubtipoOfertaAlquiler().getCodigo()))
			return tncOcupa; 
		else if (DDSubtipoOfertaAlquiler.CODIGO_NOVACIONES.equals(ofr.getSubtipoOfertaAlquiler().getCodigo()))
			return tncNovaciones;
		else if (DDSubtipoOfertaAlquiler.CODIGO_RENOVACIONES.equals(ofr.getSubtipoOfertaAlquiler().getCodigo()))
			return tncRenovaciones;
		else if (DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_DACION.equals(ofr.getSubtipoOfertaAlquiler().getCodigo()))
			return tncSubrogacionDacion;
		else if (DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_DACION.equals(ofr.getSubtipoOfertaAlquiler().getCodigo()))
			return tncSubrogacionEjecucionHipotecaria;
		
		return null;
	}

}
