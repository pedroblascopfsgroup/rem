package es.pfsgroup.plugin.rem.factory.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.factory.TramiteAlquilerNoComercialFactory;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
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
	public TramiteAlquilerNoComercial getTramiteAlquilerNoComercialByTareaExterna(TareaExterna tareaExterna) {
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if(eco == null || eco.getOferta() == null || eco.getOferta().getSubtipoOfertaAlquiler() == null) {
			return null;
		}
		return this.getTramiteAlquilerNoComercial(eco.getOferta().getSubtipoOfertaAlquiler().getCodigo());
	}
	
	@Override
	public TramiteAlquilerNoComercial getTramiteAlquilerNoComercial(String codigo) {
		
	
		if (DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_DACION.equals(codigo))
			return tncAlquilerSocialDacion;
		else if (DDSubtipoOfertaAlquiler.CODIGO_ALQUILER_SOCIAL_EJECUCION.equals(codigo))
			return tncAlquilerSocialEjecucion;
		else if (DDSubtipoOfertaAlquiler.CODIGO_OCUPA.equals(codigo))
			return tncOcupa; 
		else if (DDSubtipoOfertaAlquiler.CODIGO_NOVACIONES.equals(codigo))
			return tncNovaciones;
		else if (DDSubtipoOfertaAlquiler.CODIGO_RENOVACIONES.equals(codigo))
			return tncRenovaciones;
		else if (DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_DACION.equals(codigo))
			return tncSubrogacionDacion;
		else if (DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_EJECUCION.equals(codigo))
			return tncSubrogacionEjecucionHipotecaria;
		
		return null;
	}

}
