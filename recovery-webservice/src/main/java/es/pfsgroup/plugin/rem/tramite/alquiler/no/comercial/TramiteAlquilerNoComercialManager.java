package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.factory.TramiteAlquilerNoComercialFactory;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.ActivoCaixa;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoTiposAlquilerNoComercial;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Fianzas;
import es.pfsgroup.plugin.rem.model.HistoricoReagendacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoOfertaAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAdenda;

@Service("tramiteAlquilerNoComercialManager")
public class TramiteAlquilerNoComercialManager implements TramiteAlquilerNoComercialApi {
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private TramiteAlquilerNoComercialFactory tramiteNoComercialFactory;
		
	private static final String CODIGO_SI = "01";
	
	private static final String CODIGO_PTE_ANALISIS_TECNICO = "ANTEC";
	
	

	
	private enum T018_ScoringBcDecisiones{
		ANTEC, NEG;
	}
	
	private enum T018_ScoringDecision{
		requiereAnalisisTecnico, noRequiereAnalisisTecnico;
	}
		
	@Override
	public Boolean existeTareaT018Scoring(TareaExterna tareaExterna) {
		Boolean existe= false;
		
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		
		if(eco != null) {
			ActivoTramite actTramite = genericDao.get(ActivoTramite.class,genericDao.createFilter(FilterType.EQUALS,"trabajo.id",eco.getTrabajo().getId()));
			TareaExterna tareaExternaAnterior = activoTramiteApi.getTareaAnteriorByCodigoTarea(actTramite.getId(), ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_SCORING);
			if(tareaExternaAnterior != null) {
				existe = true;
			}	
		}
		
		return existe;
	}
	
	@Override
	public String avanzaScoringBC(TareaExterna tareaExterna, String codigo) {
		String avanzaBPM= null;
		
		if(CODIGO_PTE_ANALISIS_TECNICO.equals(codigo)) {
			avanzaBPM = T018_ScoringBcDecisiones.ANTEC.name();
		}else {
			avanzaBPM = T018_ScoringBcDecisiones.NEG.name();
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
		if(expedienteAnterior == null || expedienteAnterior.isEmpty()) {
			existeExpediente = true;
		}else{ 
			ExpedienteComercial expediente = expedienteComercialApi.findOneByNumExpediente(Long.parseLong(expedienteAnterior));
			if(expediente != null) {
				existeExpediente = true;
			}
		}
		return existeExpediente;
	}
	
	@Override
	public boolean isExpedienteDelMismoActivo(TareaExterna tareaExterna, String expedienteAnterior) {
		boolean isMismoActivo = false;
		if(expedienteAnterior == null || expedienteAnterior.isEmpty()) {
			isMismoActivo = true;
		}else{
			ExpedienteComercial expedienteInsertado = expedienteComercialApi.findOneByNumExpediente(Long.parseLong(expedienteAnterior));
			ExpedienteComercial expediente = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
			
			if(expediente != null && expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null 
			&& expedienteInsertado != null && expedienteInsertado.getOferta() != null && expedienteInsertado.getOferta().getActivoPrincipal() != null) {
				Long idActivoOriginal = expediente.getOferta().getActivoPrincipal().getId();
				Long idActivoInsertado = expedienteInsertado.getOferta().getActivoPrincipal().getId();
				if(idActivoInsertado == idActivoOriginal && expediente.getId() != expedienteInsertado.getId()) {
					isMismoActivo = true;
				}
			}
		}
		return isMismoActivo;
	}
	
	@Override
	public boolean isExpedienteFirmado(TareaExterna tareaExterna, String expedienteAnterior) {
		boolean isFirmado = false;
		if(expedienteAnterior == null || expedienteAnterior.isEmpty()) {
			isFirmado = true;
		}else{
			ExpedienteComercial expediente = expedienteComercialApi.findOneByNumExpediente(Long.parseLong(expedienteAnterior));
			if(expediente != null && expediente.getEstado() != null && (DDEstadosExpedienteComercial.isFirmado(expediente.getEstado()) 
				|| DDEstadosExpedienteComercial.isVendido(expediente.getEstado()) || DDEstadosExpedienteComercial.isAlquilado(expediente.getEstado()))) {
				isFirmado = true;
			}
		}
		return isFirmado;
	}
	
	@Override
	public boolean isTramiteT018Aprobado(List<String> tareasActivas){
		boolean isAprobado = false;
		String[] tareasParaAprobado = {ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_DEFINICION_OFERTA, ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_ANALISIS_BC};
		if(!CollectionUtils.containsAny(tareasActivas, Arrays.asList(tareasParaAprobado))) {
			isAprobado = true;
		}
		
		return isAprobado;
	}
	
	@Override
	public boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco){
		boolean camposRellenos = false;

		if(eco.getMotivoAnulacion() != null ) {
			camposRellenos = true;
		}
		
		return camposRellenos;
	}
	
	@Override
	public String avanzaScoring(TareaExterna tareaExterna, String comboReqAnalisisTec) {
		String avanzaBPM= null;

		if(CODIGO_SI.equals(comboReqAnalisisTec)) {
			avanzaBPM = T018_ScoringDecision.requiereAnalisisTecnico.name();
		}else{
			avanzaBPM = T018_ScoringDecision.noRequiereAnalisisTecnico.name();
		}
		
		return avanzaBPM;
	}

	@Override
	public String avanzaAprobarPbcAlquiler(TareaExterna tareaExterna) {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public boolean esAlquilerSocial(TareaExterna tareaExterna) {
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		Oferta ofr = eco.getOferta();
		if(DDSubtipoOfertaAlquiler.CODIGO_ALQUILER_SOCIAL_DACION.equals(ofr.getSubtipoOfertaAlquiler().getCodigo()) 
				|| DDSubtipoOfertaAlquiler.CODIGO_ALQUILER_SOCIAL_EJECUCION.equals(ofr.getSubtipoOfertaAlquiler().getCodigo())
				|| DDSubtipoOfertaAlquiler.CODIGO_OCUPA.equals(ofr.getSubtipoOfertaAlquiler().getCodigo())) {
			return true;
		}
		return false;
	}

	@Override
	public boolean esSubrogacionCompraVenta(TareaExterna tareaExterna) {
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		Oferta ofr = eco.getOferta();
		if(DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_DACION.equals(ofr.getSubtipoOfertaAlquiler().getCodigo())) {
			return true;
		}
		return false;
	}

	@Override
	public boolean esRenovacion(TareaExterna tareaExterna) {
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		Oferta ofr = eco.getOferta();
		if(DDSubtipoOfertaAlquiler.CODIGO_NOVACIONES.equals(ofr.getSubtipoOfertaAlquiler().getCodigo())
				|| DDSubtipoOfertaAlquiler.CODIGO_RENOVACIONES.equals(ofr.getSubtipoOfertaAlquiler().getCodigo())) {
			return true;
		}
		return false;
	}
	
	@Override
	public boolean noEsSubrogacion(TareaExterna tareaExterna) {
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		Oferta ofr = eco.getOferta();
		if(!DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_DACION.equals(ofr.getSubtipoOfertaAlquiler().getCodigo())
				&& !DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_EJECUCION.equals(ofr.getSubtipoOfertaAlquiler().getCodigo())) {
			return true;
		}
		return false;
	}

	@Override
	public boolean esSubrogacionHipoteca(TareaExterna tareaExterna) {
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		Oferta ofr = eco.getOferta();
		if(DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_EJECUCION.equals(ofr.getSubtipoOfertaAlquiler().getCodigo())) {
			return true;
		}
		return false;
	}

	@Override
	public boolean rechazaMenosDosVeces(TareaExterna tareaExterna) {
		boolean resultado = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if (eco != null && eco.getOferta() != null) {
			Filter filterEco =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", eco.getOferta().getId());
			Fianzas fia = genericDao.get(Fianzas.class, filterEco);
			if(fia != null) {
				Filter filterFia =  genericDao.createFilter(FilterType.EQUALS, "fianza.id", fia.getId());
				List <HistoricoReagendacion> histReag = genericDao.getList(HistoricoReagendacion.class, filterFia);
				if (histReag != null && !histReag.isEmpty()) {
					if (histReag.size() < 3) {
						resultado = true;
					}
				}
			}
		}
		return resultado;
	}

	@Override
	public boolean conAdenda(TareaExterna tareaExterna, String tipoAdenda) {
		boolean resultado;
		if(DDTipoAdenda.CODIGO_NO_APLICA_ADENDA.equals(tipoAdenda)) {
			resultado = false;
		}else {
			resultado = true;
		}
		return resultado;
	}

	@Override
	public boolean esCarteraConcentrada(TareaExterna tareaExterna) {
		boolean resultado = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if (eco != null && eco.getOferta() != null) {
			Oferta ofr = eco.getOferta();
			if (ofr != null) {
				Filter filterActivo =  genericDao.createFilter(FilterType.EQUALS, "activo.id", ofr.getActivoPrincipal().getId());
				ActivoCaixa activoCaixa = genericDao.get(ActivoCaixa.class, filterActivo);
				if (activoCaixa != null 
						&& (activoCaixa.getCarteraConcentrada().equals(true) || activoCaixa.getCarteraConcentrada() == true)) {
					resultado = true;
				}
			}
		}
			
		return resultado;
	}

	@Override
	public boolean isAdendaVacio(TareaExterna tareaExterna) {
		
		TramiteAlquilerNoComercial tramiteNoComercial = tramiteNoComercialFactory.getTramiteAlquilerNoComercial(tareaExterna);
		
		boolean tipoAdendaVacio = tramiteNoComercial.isAdendaVacio(tareaExterna);
		
		return tipoAdendaVacio;
	}

	@Override
	public boolean noFirmaMenosTresVeces(TareaExterna tareaExterna) {
		
		TramiteAlquilerNoComercial tramiteNoComercial = tramiteNoComercialFactory.getTramiteAlquilerNoComercial(tareaExterna);
		
		boolean noFirmaMenosTresVeces = tramiteNoComercial.noFirmaMenosTresVeces(tareaExterna);
		
		return noFirmaMenosTresVeces;
	}
	
}