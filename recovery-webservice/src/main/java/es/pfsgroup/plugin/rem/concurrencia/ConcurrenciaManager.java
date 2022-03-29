package es.pfsgroup.plugin.rem.concurrencia;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import es.pfsgroup.plugin.rem.model.*;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ConcurrenciaApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.concurrencia.dao.ConcurrenciaDao;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import org.springframework.transaction.annotation.Transactional;


@Service("concurrenciaManager")
public class ConcurrenciaManager  implements ConcurrenciaApi { 
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ConcurrenciaDao concurrenciaDao;
	
	@Autowired
	private OfertaApi ofertaApi;

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
	public List<VGridOfertasActivosAgrupacionConcurrencia> getListOfertasVivasConcurrentes(Long idActivo) {
		return concurrenciaDao.getListOfertasVivasConcurrentes(idActivo);
	}
	
	@Override
	public boolean isConcurrenciaOfertasEnProgresoActivo(Activo activo) {
		return this.isActivoEnConcurrencia(activo) || this.tieneActivoOfertasDeConcurrencia(activo);
	}
	
	@Override
	public boolean isConcurrenciaOfertasEnProgresoAgrupacion(ActivoAgrupacion agrupacion) {
		return this.isAgrupacionEnConcurrencia(agrupacion) || this.tieneAgrupacionOfertasDeConcurrencia(agrupacion);
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
						OfertaConcurrencia ofc = genericDao.get(OfertaConcurrencia.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", actOfr.getOferta()));
						if(ofc != null && (ofc.getFechaDeposito() != null || !ofc.entraEnTiempoDeposito())){
							noEntraDeposito.put(actOfr.getOferta(), rellenaMapOfertaCorreos(ofc));
						}
						if(ofc != null && (ofc.getFechaDocumentacion() != null || !ofc.entraEnTiempoDocumentacion())){
							noEntraDocumentacion.put(actOfr.getOferta(), rellenaMapOfertaCorreos(ofc));
						}
						Oferta ofr = actOfr.getPrimaryKey().getOferta();
						ofr.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_RECHAZADA)));
						genericDao.save(Oferta.class, ofr);
					}
				}
			}
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
}
