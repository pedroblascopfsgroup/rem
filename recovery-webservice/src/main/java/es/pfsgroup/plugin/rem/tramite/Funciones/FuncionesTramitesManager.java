package es.pfsgroup.plugin.rem.tramite.Funciones;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteVentaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService.TramiteAlquilerT015;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoTareaPbc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTareaPbc;

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
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Override
	public boolean tieneRellenosCamposAnulacion(TareaExterna tareaExterna){
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		
		return tieneRellenosCamposAnulacion(eco);
	}

	@Override
	public boolean isTramiteAprobado(ExpedienteComercial eco) {
		Set<TareaExterna> tareasActivas = activoTramiteApi.getTareasActivasByExpediente(eco);
		List<String> codigoTareasActivas = new ArrayList<String>();
		boolean isAprobado = false;

		DDSubcartera subcartera = eco.getOferta().getActivoPrincipal().getSubcartera();

		for (TareaExterna tareaExterna : tareasActivas) {
			codigoTareasActivas.add(tareaExterna.getTareaProcedimiento().getCodigo());
		}
		TipoProcedimiento tp = activoTramiteApi.getTipoTramiteByExpediente(eco);
		if(tp != null) {
			String codigoTp = tp.getCodigo();
			if(ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA_APPLE.equals(codigoTp)) {
				if (subcartera != null && (DDSubcartera.isSubcarteraDivarianRemainingInmob(subcartera) || DDSubcartera.isSubcarteraDivarianArrowInmob(subcartera))){
					isAprobado = tramiteVentaApi.isTramiteT017DivarianAprobado(eco);
				}else{
					isAprobado = tramiteVentaApi.isTramiteT017Aprobado(codigoTareasActivas);
				}

			}else if(ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_ALQUILER.equals(codigoTp)){
				isAprobado = tramiteAlquilerApi.isTramiteT015Aprobado(codigoTareasActivas);
			}else if(ActivoTramiteApi.CODIGO_TRAMITE_ALQUILER_NO_COMERCIAL.equals(codigoTp)){
				isAprobado = tramiteAlquilerNoComercialApi.isTramiteT018Aprobado(codigoTareasActivas);
			}
		}
		
		return isAprobado;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void desactivarHistoricoPbc(Long idOferta, String codigoTipoTarea) {
		Filter filterOferta =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", idOferta);
		Filter filterTipoPbc =  genericDao.createFilter(FilterType.EQUALS, "tipoTareaPbc.codigo", codigoTipoTarea);
		Filter filterActiva =  genericDao.createFilter(FilterType.EQUALS, "activa", true);
		HistoricoTareaPbc historico = genericDao.get(HistoricoTareaPbc.class, filterOferta, filterTipoPbc, filterActiva);
		
		if (historico != null) {
			historico.setActiva(false);
			genericDao.save(HistoricoTareaPbc.class, historico);
		}
	}
	
	@Override
	public HistoricoTareaPbc createHistoricoPbc(Long idOferta, String codigoTipoTarea) {
		Filter filterOferta =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", idOferta);
		Filter filterTipoPbc =  genericDao.createFilter(FilterType.EQUALS, "tipoTareaPbc.codigo", codigoTipoTarea);
		Filter filterActiva =  genericDao.createFilter(FilterType.EQUALS, "activa", true);
		HistoricoTareaPbc htp = genericDao.get(HistoricoTareaPbc.class, filterOferta, filterTipoPbc, filterActiva);
		
		if (htp == null) {
			htp = new HistoricoTareaPbc();
			Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoTarea);
			DDTipoTareaPbc tpb = genericDao.get(DDTipoTareaPbc.class, filtroTipo);
			htp.setOferta(ofertaApi.getOfertaById(idOferta));
			htp.setTipoTareaPbc(!Checks.esNulo(tpb) ? tpb : null);
		}

		return htp;
	}
	
	@Override
	public boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco){
		boolean camposRellenos = false;
		
		if(!Checks.isFechaNula(eco.getFechaAnulacion()) && eco.getMotivoAnulacion() != null) {
			camposRellenos = true;
		}
		
		return camposRellenos;
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

	public boolean tieneCampoClasificacionRelleno(TareaExterna tareaExterna) {
		boolean isRelleno = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		
		if(eco != null && eco.getOferta() != null && eco.getOferta().getClasificacion() != null) {
			isRelleno = true;
		}
		return isRelleno;

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