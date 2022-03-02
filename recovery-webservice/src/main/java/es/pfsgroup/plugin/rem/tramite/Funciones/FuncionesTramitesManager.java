package es.pfsgroup.plugin.rem.tramite.Funciones;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteVentaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService.TramiteAlquilerT015;
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
	public boolean tieneMasUnaTareaBloqueo(ExpedienteComercial eco, String codigoTarea) {
		boolean tieneMasUnaTareaBloqueoActiva = false;
		Set<TareaExterna> tareasActivas = activoTramiteApi.getTareasActivasByExpediente(eco);
		List<String> codigoTareasActivas = new ArrayList<String>();
		List<String> tareasBloqueo = new ArrayList<String>();
		
		tareasBloqueo.addAll(this.devolverTareasBloqueoScreening());
		tareasBloqueo.addAll(this.devolverTareasBloqueoScoring());

		for (TareaExterna tareaExterna : tareasActivas) {
			if(!codigoTarea.equals(tareaExterna.getTareaProcedimiento().getCodigo())) {
				codigoTareasActivas.add(tareaExterna.getTareaProcedimiento().getCodigo());
			}
		}

		if(CollectionUtils.containsAny(codigoTareasActivas, tareasBloqueo)) {
			tieneMasUnaTareaBloqueoActiva = true;
		} 
		
		return tieneMasUnaTareaBloqueoActiva;
	}

	@SuppressWarnings("unchecked")
	private List<String> devolverTareasBloqueoScreening(){
		String[] tareasBloqueoScreening = {
				ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_BLOQUEOSCREENING, 
				ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_BLOQUEOSCREENING,
				ComercialUserAssigantionService.CODIGO_T017_BLOQUEOSCREENING};
		
		return Arrays.asList(tareasBloqueoScreening);
	}
	
	@SuppressWarnings("unchecked")
	private List<String> devolverTareasBloqueoScoring(){
		String[] tareasBloqueoScoring = {
				ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_BLOQUEOSCORING, 
				ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_BLOQUEOSCORING,
				ComercialUserAssigantionService.CODIGO_T017_BLOQUEOSCORING};
		return Arrays.asList(tareasBloqueoScoring);
	}
}