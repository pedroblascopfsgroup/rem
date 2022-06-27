package es.pfsgroup.plugin.rem.concurrencia;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ConcurrenciaApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.concurrencia.dao.ConcurrenciaDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.DtoHistoricoConcurrencia;
import es.pfsgroup.plugin.rem.model.DtoPujaDetalle;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaConcurrencia;
import es.pfsgroup.plugin.rem.model.Puja;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionConcurrencia;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosConcurrencia;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.oferta.OfertaManager;


@Service("concurrenciaManager")
public class ConcurrenciaManager  implements ConcurrenciaApi { 
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ConcurrenciaDao concurrenciaDao;

	@Autowired
	private OfertaManager ofertaManager;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
		
	public boolean bloquearEditarOfertasPorConcurrenciaActivo(Activo activo) {
		boolean bloquear = false;
		if(activo != null) {
			if(isActivoEnConcurrencia(activo)) {
				return true;
			}else {
				List<Oferta> listOfr = ofertaApi.getListaOfertasByActivo(activo);
				bloquear = isOfertaEnPlazoDoc(bloquear, listOfr);
			}	
		}
		
		return bloquear;
	}
	
	public boolean bloquearEditarOfertasPorConcurrenciaAgrupacion(ActivoAgrupacion agr) {
		boolean bloquear = false;
		if(agr != null) {
			if(isAgrupacionEnConcurrencia(agr)) {
				bloquear = true;
			}else {
				List<Oferta> listOfertas = genericDao.getList(Oferta.class,
						genericDao.createFilter(FilterType.EQUALS,"agrupacion.id",agr.getId())
						,genericDao.createFilter(FilterType.EQUALS,"concurrencia",true));
				bloquear = isOfertaEnPlazoDoc(bloquear, listOfertas);
			}
		}
		return bloquear;
	}

	private boolean isOfertaEnPlazoDoc(boolean bloquear, List<Oferta> listOfertas) {
		OfertaConcurrencia ofrConcurrencia = null;
		if(listOfertas != null && !listOfertas.isEmpty()) {
			for (Oferta oferta : listOfertas) {
				ofrConcurrencia = genericDao.get(OfertaConcurrencia.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
				if(ofrConcurrencia != null && ofrConcurrencia.entraEnTiempoDocumentacion() && ofrConcurrencia.entraEnTiempoDeposito()) {
					bloquear =  true;
					break;
				}
			}
		}
		return bloquear;
	}

	@Override
	public Concurrencia getUltimaConcurrenciaByActivo(Activo activo) {
		List<Concurrencia> concurrenciaList = genericDao.getList(Concurrencia.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		Concurrencia concurrencia = null;
		if(concurrenciaList != null && !concurrenciaList.isEmpty()) {
			concurrencia = concurrenciaList.get(0);
		}
		
		return concurrencia;
	}
	
	@Override
	public Concurrencia getUltimaConcurrenciaByAgrupacion(ActivoAgrupacion agrupacion) {
		List<Concurrencia> concurrenciaList = genericDao.getList(Concurrencia.class, genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", agrupacion.getId()));
		Concurrencia concurrencia = null;
		if(concurrenciaList != null && !concurrenciaList.isEmpty()) {
			concurrencia = concurrenciaList.get(0);
		}
		
		return concurrencia;
	}
	
	@Override
	public boolean isActivoEnConcurrencia(Activo activo) {
		boolean isEnConcurrencia = false;
		Concurrencia concurrencia = this.getUltimaConcurrenciaByActivo(activo);
		
		if(concurrencia != null && concurrencia.getFechaInicio() != null && concurrencia.getFechaFin() != null) {
			Date hoy = new Date();
			if( hoy.after(concurrencia.getFechaInicio()) && hoy.before(concurrencia.getFechaFin())) {
				isEnConcurrencia = true;
			}
		}
		
		return isEnConcurrencia;
	}
	
	@Override
	public boolean tieneActivoOfertasDeConcurrencia(Activo activo) {
		boolean tieneOfertasDeConcurrencia = false;
		
		List<Oferta> ofertasList = ofertaApi.getListaOfertasByActivo(activo);
		
		for (Oferta oferta : ofertasList) {
			DDEstadoOferta eof = oferta.getEstadoOferta();
			if(oferta.getConcurrencia() != null && oferta.getConcurrencia() && DDEstadoOferta.isOfertaActiva(eof)) {
				tieneOfertasDeConcurrencia = true;
				break;
			}
		}
		
		return tieneOfertasDeConcurrencia;
	}
	
	@Override
	public boolean isAgrupacionEnConcurrencia(ActivoAgrupacion agr) {
		boolean isEnConcurrencia = false;
		
		if(agr != null) {
			isEnConcurrencia = concurrenciaDao.isAgrupacionEnConcurrencia(agr.getId());
		}
		
		return isEnConcurrencia;
	}
	
	@Override
	public boolean tieneAgrupacionOfertasDeConcurrencia(ActivoAgrupacion agr) {
		boolean isEnConcurrencia = false;
		
		if(agr != null) {
			isEnConcurrencia = concurrenciaDao.isAgrupacionConOfertasDeConcurrencia(agr.getId());
		}
		
		return isEnConcurrencia;
	}

	@Override
	public boolean isOfertaEnConcurrencia(Oferta ofr){

		if(ofr != null && ofr.getConcurrencia()){
			return true;
		}

		return false;
	}
	
	@Override
	public boolean createPuja(Concurrencia concurrencia, Oferta oferta, Double importe) {
		try {
			Puja puja = new Puja();
			if(concurrencia != null) {
				puja.setConcurrencia(concurrencia);	
			}
			puja.setOferta(oferta);
			puja.setImporte(importe);
			genericDao.save(Puja.class, puja);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}		
		return true;
	}

	@Override
	public Oferta getOfertaGanadora(Activo activo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
		List<VGridOfertasActivosAgrupacionConcurrencia> ofertasConcurrencia = genericDao.getList(VGridOfertasActivosAgrupacionConcurrencia.class, filtro);
		Oferta ofertaGanadora = null;
		if(ofertasConcurrencia != null && !ofertasConcurrencia.isEmpty()) {
			ofertaGanadora = ofertaApi.getOfertaById(ofertasConcurrencia.get(0).getId());
		}
		
		return ofertaGanadora;
	}
	
	@Override
	public List<VGridOfertasActivosConcurrencia> getListOfertasVivasConcurrentes(Long idActivo, Long idConcurrencia) {
		return concurrenciaDao.getListOfertasVivasConcurrentes(idActivo,idConcurrencia);
	}
	
	@Override
	public boolean isConcurrenciaOfertasEnProgresoActivo(Activo activo) {
		return this.isActivoEnConcurrencia(activo) || this.tieneActivoOfertasDeConcurrencia(activo);
	}
	
	@Override
	public boolean isConcurrenciaTerminadaOfertasEnProgresoActivo(Activo activo) {
		return !this.isActivoEnConcurrencia(activo) && this.tieneActivoOfertasDeConcurrencia(activo);
	}
	
	@Override
	public boolean isConcurrenciaOfertasEnProgresoAgrupacion(ActivoAgrupacion agrupacion) {
		return this.isAgrupacionEnConcurrencia(agrupacion) || this.tieneAgrupacionOfertasDeConcurrencia(agrupacion);
	}
	
	@Override
	public boolean isConcurrenciaTerminadaOfertasEnProgresoAgrupacion(ActivoAgrupacion agrupacion) {
		return !this.isAgrupacionEnConcurrencia(agrupacion) && this.tieneAgrupacionOfertasDeConcurrencia(agrupacion);
	}

	@Override
	@Transactional
	public void caducaOfertasRelacionadasConcurrencia(Long idActivo, Long idOferta){
		Activo act = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", idActivo));
		if(act != null){
			List<ActivoOferta> ofertas = act.getOfertas();
			HashMap<Long, String> noEntraDocumentacion = new HashMap<Long, String>();
			HashMap<Long, String> noEntraDeposito = new HashMap<Long, String>();

			if(ofertas != null && !ofertas.isEmpty()) {
				for(ActivoOferta actOfr: ofertas){
					if(actOfr != null && actOfr.getOferta() != null && !idOferta.toString().equals(actOfr.getOferta().toString())
							&& !actOfr.getPrimaryKey().getOferta().esOfertaAnulada()){
						Oferta ofr = actOfr.getPrimaryKey().getOferta();
						OfertaConcurrencia ofc = genericDao.get(OfertaConcurrencia.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", actOfr.getOferta()));
						if(ofc != null && (ofc.getFechaDeposito() != null || !ofc.entraEnTiempoDeposito())){
							noEntraDeposito.put(actOfr.getOferta(), rellenaMapOfertaCorreos(ofc));
							ofr.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA)));

						}
						if(ofc != null && (ofc.getFechaDocumentacion() != null || !ofc.entraEnTiempoDocumentacion())){
							noEntraDocumentacion.put(actOfr.getOferta(), rellenaMapOfertaCorreos(ofc));
							ofr.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA)));

						}
						genericDao.save(Oferta.class, ofr);
					}
				}
			}
		}
	}

	@Override
	@Transactional
	public void caducaOfertaConcurrencia(Long idActivo, Long idOferta){
		Oferta ofr = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id", idOferta));
		HashMap<Long, String> noEntraDocumentacion = new HashMap<Long, String>();
		HashMap<Long, String> noEntraDeposito = new HashMap<Long, String>();

		if(ofr != null && !ofr.esOfertaAnulada()){
			OfertaConcurrencia ofc = genericDao.get(OfertaConcurrencia.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofr.getId()));
			if(ofc != null && (ofc.getFechaDeposito() != null || !ofc.entraEnTiempoDeposito())){
				noEntraDeposito.put(ofr.getId(), rellenaMapOfertaCorreos(ofc));
				ofr.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA)));

			}
			if(ofc != null && (ofc.getFechaDocumentacion() != null || !ofc.entraEnTiempoDocumentacion())){
				noEntraDocumentacion.put(ofr.getId(), rellenaMapOfertaCorreos(ofc));
				ofr.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA)));

			}
			genericDao.save(Oferta.class, ofr);
		}

	}

	private String rellenaMapOfertaCorreos(OfertaConcurrencia ofc) {
		String correos = null;

		if(ofc.getOferta() != null){
			if(ofc.getOferta().getCliente() != null && ofc.getOferta().getCliente().getEmail() != null){
				correos = ofc.getOferta().getCliente().getEmail();
			}

			List<TitularesAdicionalesOferta> titularesAdicionales = genericDao.getList(TitularesAdicionalesOferta.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofc.getOferta().getId()));

			if(titularesAdicionales != null && !titularesAdicionales.isEmpty()){
				for(TitularesAdicionalesOferta tit: titularesAdicionales){
					if(correos == null){
						correos = tit.getEmail();
					}else{
						correos = correos + "," + tit.getEmail();
					}
				}
			}

		}
		return correos;
	}
	
	@Override
	@Transactional
	public List<DtoPujaDetalle> getPujasDetalleByIdOferta(Long idActivo, Long idOferta) {
		//String importeOculto = "*****";
		List<DtoPujaDetalle> dtoLista = new ArrayList<DtoPujaDetalle>();
		List<Puja> listaPujas = new ArrayList<Puja>();		
		Activo activo = activoAdapter.getActivoById(idActivo);

		Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "oferta.id", idOferta);
		Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
		listaPujas = genericDao.getListOrdered(Puja.class, order, filtroOferta);
	
		if (listaPujas != null && !listaPujas.isEmpty()) {					
			
			for (Puja puja : listaPujas) {
				DtoPujaDetalle dto = new DtoPujaDetalle();
				if (puja.getId() != null) {
					dto.setId(puja.getId());
				}
				if (puja.getOferta() != null) {
					dto.setIdOferta(puja.getOferta().getId());
				}
				if (!Checks.isFechaNula(puja.getAuditoria().getFechaCrear())) {
					dto.setFechaCrear(puja.getAuditoria().getFechaCrear());
				}
				if (this.isActivoEnConcurrencia(activo) == true && ofertaManager.isHayaSuper() == true) {
					if (puja.getImporte() != null) {
						dto.setImportePuja(puja.getImporte());
					} else {
						dto.setImportePuja(null);
					}
				} else {
					dto.setImportePuja(null);
				}
				
				dtoLista.add(dto);
			}
		}
		return dtoLista;
	}
	
	@Override
	public List<DtoHistoricoConcurrencia> getHistoricoConcurrencia(Long idActivo) {
		List<DtoHistoricoConcurrencia> listaHistorico = new ArrayList<DtoHistoricoConcurrencia>();
		List<Concurrencia> listaConcurrencia = new ArrayList<Concurrencia>();
		if (idActivo != null) {
			Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			listaConcurrencia = genericDao.getList(Concurrencia.class, filtroIdActivo);
			if(!listaConcurrencia.isEmpty()) {
				for (Concurrencia concurrencia : listaConcurrencia) {
					DtoHistoricoConcurrencia dto = new DtoHistoricoConcurrencia();
					dto.setId(concurrencia.getId());
					dto.setIdActivo(concurrencia.getActivo() != null ? concurrencia.getActivo().getId() : null);
					dto.setNumActivo(concurrencia.getActivo() != null ? concurrencia.getActivo().getNumActivo() : null);
					dto.setIdAgrupacion(concurrencia.getAgrupacion() != null ? concurrencia.getAgrupacion().getId() : null);
					dto.setNumAgrupacion(concurrencia.getAgrupacion() != null ? concurrencia.getAgrupacion().getNumAgrupRem() : null);
					dto.setImporteMinOferta(concurrencia.getImporteMinOferta());
					dto.setImporteDeposito(concurrencia.getImporteDeposito());
					dto.setFechaInicio(concurrencia.getFechaInicio());
					dto.setFechaFin(concurrencia.getFechaFin());
					listaHistorico.add(dto);
				}
			}
		}
		return listaHistorico;
	}
}
