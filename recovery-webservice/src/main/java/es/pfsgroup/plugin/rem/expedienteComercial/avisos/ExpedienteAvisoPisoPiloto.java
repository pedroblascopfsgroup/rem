package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

@Service("expedienteAvisoPisoPiloto")
public class ExpedienteAvisoPisoPiloto implements ExpedienteAvisadorApi{
	
	@Autowired
	private OfertaApi ofertaApi;

	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		
		DtoAviso dtoAviso = new DtoAviso();
		
		if(ofertaApi.isOfertaONPisoPiloto(expediente.getOferta())){
			dtoAviso.setDescripcion("Piso piloto incluido en la oferta");
			dtoAviso.setId(String.valueOf(expediente.getId()));
		}

		return dtoAviso;
	}

}
