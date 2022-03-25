package es.pfsgroup.plugin.rem.concurrencia;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ConcurrenciaApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.concurrencia.dao.ConcurrenciaDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaConcurrencia;
import es.pfsgroup.plugin.rem.model.Puja;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionConcurrencia;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;


@Service("concurrenciaManager")
public class ConcurrenciaManager  implements ConcurrenciaApi { 
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ConcurrenciaDao concurrenciaDao;

	@Autowired
	private OfertaApi ofertaApi;
		
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
}
