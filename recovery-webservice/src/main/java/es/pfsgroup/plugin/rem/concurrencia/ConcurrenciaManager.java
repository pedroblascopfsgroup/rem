package es.pfsgroup.plugin.rem.concurrencia;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ConcurrenciaApi;
import es.pfsgroup.plugin.rem.concurrencia.dao.ConcurrenciaDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;


@Service("concurrenciaManager")
public class ConcurrenciaManager  implements ConcurrenciaApi { 
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ConcurrenciaDao concurrenciaDao;

	
	private Concurrencia getUltimaConcurrenciaByActivo(Activo activo) {
		List<Concurrencia> concurrenciaList = genericDao.getList(Concurrencia.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
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
		Filter filtroConcurrencia = genericDao.createFilter(FilterType.EQUALS, "concurrencia", true);
		List<Oferta> ofertasList = genericDao.getList(Oferta.class, filtroConcurrencia);
		
		for (Oferta oferta : ofertasList) {
			DDEstadoOferta eof = oferta.getEstadoOferta();
			if(DDEstadoOferta.isPendiente(eof) || DDEstadoOferta.isPendienteConsentimiento(eof) || DDEstadoOferta.isTramitada(eof)) {
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
}
