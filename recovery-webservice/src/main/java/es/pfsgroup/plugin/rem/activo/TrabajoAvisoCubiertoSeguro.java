package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.TrabajoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.Trabajo;


@Service("trabajoAvisoCubiertoSeguro")
public class TrabajoAvisoCubiertoSeguro implements TrabajoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(TrabajoAvisoCubiertoSeguro.class);
	

	@Override
	public DtoAviso getAviso(Trabajo trabajo, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		if (trabajo.getCubreSeguro()) {
			
			dtoAviso.setDescripcion("Trabajo cubierto por seguro");
			dtoAviso.setId(String.valueOf(trabajo.getId()));
			
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}