package es.pfsgroup.plugin.rem.tramite.Funciones;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.*;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.CuentasVirtualesAlquiler;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesExpediente;
import es.pfsgroup.plugin.rem.model.DtoTabFianza;
import es.pfsgroup.plugin.rem.model.DtoTipoAlquiler;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Fianzas;
import es.pfsgroup.plugin.rem.model.HistoricoTareaPbc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VGridDescuentoColectivos;
import es.pfsgroup.plugin.rem.model.VGridHistoricoReagendaciones;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoOfertaAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTareaPbc;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.validator.routines.checkdigit.IBANCheckDigit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service("funcionesTramitesManager")
public class FuncionesTramitesManager implements FuncionesTramitesApi {
	
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	
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
	
	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Override
	public boolean tieneRellenosCamposAnulacion(TareaExterna tareaExterna){
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		
		return tieneRellenosCamposAnulacion(eco);
	}

	@Override
	public boolean isTramiteAprobado(ExpedienteComercial eco) {
		Set<TareaExterna> tareasActivas = activoTramiteApi.getTareasActivasByExpediente(eco);
		TareaExterna resolucionComite = null;
		List<String> codigoTareasActivas = new ArrayList<String>();
		boolean isAprobado = false;

		DDSubcartera subcartera = eco.getOferta().getActivoPrincipal().getSubcartera();

		for (TareaExterna tareaExterna : tareasActivas) {
			if(ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_CES.equals(tareaExterna.getTareaProcedimiento().getCodigo())){
				resolucionComite = tareaExterna;
			}
			codigoTareasActivas.add(tareaExterna.getTareaProcedimiento().getCodigo());
		}
		TipoProcedimiento tp = activoTramiteApi.getTipoTramiteByExpediente(eco);
		if(tp != null) {
			String codigoTp = tp.getCodigo();
			if(ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA_APPLE.equals(codigoTp)) {
				isAprobado = tramiteVentaApi.isTramiteT017Aprobado(eco);
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
	
	@Override
	public boolean checkIBANValido(TareaExterna tareaExterna, String numIban) {
		boolean resultado = false;
		IBANCheckDigit iban = new IBANCheckDigit();
		
		try {
			if (numIban != null) {
				resultado = iban.isValid(numIban);
			}
		} catch (Exception e) {
			logger.error("error en TramiteAlquilerManager", e);
		}
			
		return resultado;
	}
	
	@Override
	public boolean checkCuentasVirtualesAlquilerLibres(TareaExterna tareaExterna) {
		boolean resultado = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if (eco != null && eco.getOferta() != null) {
			Oferta ofr = eco.getOferta();
			if (ofr != null) {
				Filter filterCva =  genericDao.createFilter(FilterType.EQUALS, "subcartera", ofr.getActivoPrincipal().getSubcartera());
				List <CuentasVirtualesAlquiler> cva = genericDao.getList(CuentasVirtualesAlquiler.class, filterCva);
				if (cva != null && cva.size() >= 1 && !cva.isEmpty()) {
					for (CuentasVirtualesAlquiler cuentasVirtualesAlquiler : cva) {
						if (Checks.isFechaNula(cuentasVirtualesAlquiler.getFechaInicio())) {
							resultado = true;
							break;
						}
					}
				}
			}
		}
			
		return resultado;
	}
	
	@Override
	public boolean checkFechaAgendacionRelleno(Long idExpediente){
		boolean resultado = false;
		ExpedienteComercial eco = expedienteComercialDao.get(idExpediente);
		if (eco != null && eco.getOferta() != null) {
			Filter filterEco =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", eco.getOferta().getId());
			Fianzas fia = genericDao.get(Fianzas.class, filterEco);
			if(fia != null && !Checks.isFechaNula(fia.getFechaAgendacionIngreso())) {
				resultado = true;
			}
		}
		
		return resultado;
	}
	
	@Override
	public DtoCondicionantesExpediente getFianzaExonerada(Long idExpediente) {
		DtoCondicionantesExpediente dto = new DtoCondicionantesExpediente();
		ExpedienteComercial eco = expedienteComercialApi.findOne(idExpediente);
		CondicionanteExpediente coe = eco.getCondicionante();
		if (coe != null) {
			dto.setFianzaExonerada(coe.getFianzaExonerada());
		}		
		
		return dto;
	}
	
	@Override
	public DtoTabFianza getDtoFianza(Long idExpediente) {
		DtoTabFianza dto = new DtoTabFianza();
		ExpedienteComercial eco = expedienteComercialApi.findOne(idExpediente);
		Oferta ofr = eco.getOferta();
		if (ofr != null) {
			dto.setFianzaExonerada(eco.getCondicionante().getFianzaExonerada());
			
			Fianzas fia = genericDao.get(Fianzas.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofr.getId()));
			
			if (fia != null) {
				dto.setAgendacionIngreso(fia.getFechaAgendacionIngreso());
				dto.setImporteFianza(fia.getImporte());
				dto.setIbanDevolucion(fia.getIbanDevolucion());
			}	
		}
		
		return dto;
	}

	@Override
	public List<VGridHistoricoReagendaciones> getHistoricoReagendaciones(Long idExpediente) {
		List<VGridHistoricoReagendaciones> historicoReagendaciones = new ArrayList<VGridHistoricoReagendaciones>();
		if (idExpediente != null) {
			historicoReagendaciones = genericDao.getList(VGridHistoricoReagendaciones.class, genericDao.createFilter(FilterType.EQUALS, "idExpedienteComercial", idExpediente));
		}		
		return historicoReagendaciones;
	}
	
	@Override
	public DtoTipoAlquiler getDtoTipoAlquiler(Long idExpediente) {
		DtoTipoAlquiler dto = new DtoTipoAlquiler();
		ExpedienteComercial eco = expedienteComercialApi.findOne(idExpediente);
		Oferta ofr = eco.getOferta();
		if (ofr != null) {
			dto.setCodTipoAlquiler(ofr.getTipoOfertaAlquiler().getCodigo());
			dto.setCodSubtipoAlquiler(ofr.getSubtipoOfertaAlquiler().getCodigo());
		}
		
		return dto;
	}

}