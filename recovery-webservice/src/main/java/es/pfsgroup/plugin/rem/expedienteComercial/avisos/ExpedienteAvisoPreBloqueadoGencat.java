package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Service("expedienteAvisoPreBloqueadoGencat")
public class ExpedienteAvisoPreBloqueadoGencat implements ExpedienteAvisadorApi{

	@Autowired
	private ExpedienteComercialApi expedienteApi;	
	
	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		boolean expedientePreBloqueado = false;
		
		if (!Checks.esNulo(expediente)) {
			expedientePreBloqueado = expedienteApi.comprobarExpedientePreBloqueadoGencat(expediente);
		}
		
		if (expedientePreBloqueado) {
			dtoAviso.setId(String.valueOf(expediente.getId()));
			dtoAviso.setDescripcion("Expediente pre-bloqueado por GENCAT");	
		}

		return dtoAviso;
	}

}
