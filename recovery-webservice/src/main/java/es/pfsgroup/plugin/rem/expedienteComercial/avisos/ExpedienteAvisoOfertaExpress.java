package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Service("expedienteAvisoOfertaExpress")
public class ExpedienteAvisoOfertaExpress implements ExpedienteAvisadorApi{

	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		
		if(!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getOferta())){
			if(expediente.getOferta().getOfertaExpress()){
				dtoAviso.setId(String.valueOf(expediente.getId()));
				dtoAviso.setDescripcion("Expediente Oferta Express");
			}
		}

		return dtoAviso;
	}

}
