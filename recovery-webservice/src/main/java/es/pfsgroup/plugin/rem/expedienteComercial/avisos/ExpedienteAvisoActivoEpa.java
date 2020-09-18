package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;


@Service("expedienteAvisoActivoEpa")
public class ExpedienteAvisoActivoEpa implements ExpedienteAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(ExpedienteAvisoActivoEpa.class);
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		if (expedienteComercialApi.getActivoExpedienteEpa(expediente)) {			
			dtoAviso.setDescripcion("Esta oferta incluye activos EPA");
			dtoAviso.setId(String.valueOf(expediente.getId()));			
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}