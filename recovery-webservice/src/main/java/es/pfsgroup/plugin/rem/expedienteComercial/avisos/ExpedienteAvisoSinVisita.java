package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;


@Service("expedienteAvisoSinVisita")
public class ExpedienteAvisoSinVisita implements ExpedienteAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(ExpedienteAvisoSinVisita.class);
	

	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		if (!Checks.esNulo(expediente.getOferta()) && Checks.esNulo(expediente.getOferta().getVisita())) {			
			dtoAviso.setDescripcion("No hay visita asignada");
			dtoAviso.setId(String.valueOf(expediente.getId()));			
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}