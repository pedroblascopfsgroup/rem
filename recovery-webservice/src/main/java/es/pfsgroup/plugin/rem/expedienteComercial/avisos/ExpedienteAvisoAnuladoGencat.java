package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Service("expedienteAvisoAnuladoGencat")
public class ExpedienteAvisoAnuladoGencat implements ExpedienteAvisadorApi{
	
	@Autowired
	private ExpedienteComercialApi expedienteApi;
	
	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		boolean expedienteAnulado = false;
		
		if (!Checks.esNulo(expediente)) {
			expedienteAnulado = expedienteApi.comprobarExpedienteAnuladoGencat(expediente);
		}
		
		if (expedienteAnulado) {
			dtoAviso.setId(String.valueOf(expediente.getId()));
			dtoAviso.setDescripcion("Expediente anulado por GENCAT");
		}
		
		return dtoAviso;
	}

}
