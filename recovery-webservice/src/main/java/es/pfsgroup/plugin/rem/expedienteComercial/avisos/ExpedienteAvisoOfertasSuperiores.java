package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;


@Service("expedienteAvisoOfertasSuperiores")
public class ExpedienteAvisoOfertasSuperiores implements ExpedienteAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(ExpedienteAvisoOfertasSuperiores.class);
	

	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		boolean existeOfertaSuperior = false;
		
		Oferta ofertaActiva = expediente.getOferta();
		
		if(!Checks.esNulo(ofertaActiva.getAgrupacion())) {
			
			for(Oferta oferta: ofertaActiva.getAgrupacion().getOfertas()) {	
				
				if(DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta())) {
					if (oferta.getImporteOferta().compareTo(oferta.getImporteOferta()) > 0) {
						existeOfertaSuperior = true;
					}
				}
			}
		} else if(!Checks.esNulo(ofertaActiva.getActivosOferta())) {
			
			if(!ofertaActiva.getActivosOferta().isEmpty()) {
				Activo activo = ofertaActiva.getActivosOferta().get(0).getPrimaryKey().getActivo();
				
				for(ActivoOferta activoOferta: activo.getOfertas()) {
					Oferta oferta = activoOferta.getPrimaryKey().getOferta();
					if(DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta())) {
						if (oferta.getImporteOferta().compareTo(ofertaActiva.getImporteOferta()) > 0) {
							existeOfertaSuperior = true;
						}
					}
				}
			}

		}

		if (existeOfertaSuperior) {
			dtoAviso.setDescripcion("Existen oferta/s de importe superior");
			dtoAviso.setId(String.valueOf(expediente.getId()));	
		}

		return dtoAviso;
		
	}
	
}