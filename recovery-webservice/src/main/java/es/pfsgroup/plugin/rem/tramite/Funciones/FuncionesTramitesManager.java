package es.pfsgroup.plugin.rem.tramite.Funciones;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteVentaApi;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;

@Service("funcionesTramitesManager")
public class FuncionesTramitesManager implements FuncionesTramitesApi {
	
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private TramiteVentaApi tramiteVentaApi;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;
		
	@Autowired
	private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Override
	public boolean tieneRellenosCamposAnulacion(TareaExterna tareaExterna){
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		
		return tieneRellenosCamposAnulacion(eco);
	}
	
	@Override
	public boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco){
		boolean camposRellenos = false;
		Oferta oferta = eco.getOferta();
		if(oferta != null) {
			if(DDTipoOferta.isTipoVenta(oferta.getTipoOferta())){
				camposRellenos = tramiteVentaApi.tieneRellenosCamposAnulacion(eco);
			}else if(DDTipoOferta.isTipoAlquiler(oferta.getTipoOferta())){
				camposRellenos = tramiteAlquilerApi.tieneRellenosCamposAnulacion(eco);
			}else if(DDTipoOferta.isTipoAlquilerNoComercial(oferta.getTipoOferta())){
				camposRellenos = tramiteAlquilerNoComercialApi.tieneRellenosCamposAnulacion(eco);
			}	
		}	
				
		return camposRellenos;
	}

	@Override
	public boolean isTramiteAprobado(ExpedienteComercial eco) {
		Set<TareaExterna> tareasActivas = activoTramiteApi.getTareasActivasByExpediente(eco);
		List<String> codigoTareasActivas = new ArrayList<String>();
		boolean isAprobado = false;
		
		
		for (TareaExterna tareaExterna : tareasActivas) {
			codigoTareasActivas.add(tareaExterna.getTareaProcedimiento().getCodigo());
		}
		TipoProcedimiento tp = activoTramiteApi.getTipoTramiteByExpediente(eco);
		if(tp != null) {
			String codigoTp = tp.getCodigo();
			if(ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA_APPLE.equals(codigoTp)) {
				isAprobado = tramiteVentaApi.isTramiteT017Aprobado(codigoTareasActivas);
			}else if(ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_ALQUILER.equals(codigoTp)){
				isAprobado = tramiteAlquilerApi.isTramiteT015Aprobado(codigoTareasActivas);
			}else if(ActivoTramiteApi.CODIGO_TRAMITE_ALQUILER_NO_COMERCIAL.equals(codigoTp)){
				isAprobado = tramiteAlquilerNoComercialApi.isTramiteT018Aprobado(codigoTareasActivas);
			}
		}
		
		return isAprobado;
	}
	
	@Override
	public boolean tieneCampoClasificacionRelleno(TareaExterna tareaExterna) {
		boolean isRelleno = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		
		if(eco != null && eco.getOferta() != null && eco.getOferta().getClasificacion() != null) {
			isRelleno = true;
		}
		return isRelleno;
	}
	
}