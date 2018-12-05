package es.pfsgroup.plugin.rem.activo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Service("agrupacionAvisoRestringidaVendida")
public class AgrupacionAvisoRestringidaVendida implements AgrupacionAvisadorApi {
	
	@Autowired
	public OfertaApi ofertaApi;
	
	@Autowired
	public ExpedienteComercialApi expedienteComercialApi;
	
	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {
	
		DtoAviso dtoAviso = new DtoAviso();
		
		if (!Checks.esNulo(agrupacion.getActivoPrincipal())) {
			
			Activo activo = agrupacion.getActivoPrincipal();
	    	
	    	Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(activo);
	    	
	    	if(!Checks.esNulo(ofertaAceptada)) {
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				if(DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo()) || !Checks.esNulo(activo.getFechaVentaExterna())) {
					dtoAviso.setDescripcion("Agrupación restringida vendida");
					dtoAviso.setId(String.valueOf(agrupacion.getId()));
				}
			}
		}
		
		return dtoAviso;
		
	}
}
