package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Service("expedienteAvisoBloqueado")
public class ExpedienteAvisoBloqueado implements ExpedienteAvisadorApi{

	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		if(!Checks.esNulo(expediente.getBloqueado())){
			if(expediente.getBloqueado().equals(Integer.valueOf(1))){
				dtoAviso.setId(String.valueOf(expediente.getId()));
				dtoAviso.setDescripcion("Expediente bloqueado");
			}
		}

		return dtoAviso;
	}

}
