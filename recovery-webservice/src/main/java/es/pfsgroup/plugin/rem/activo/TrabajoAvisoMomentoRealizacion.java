package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.TrabajoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.Trabajo;


@Service("trabajoAvisoMomentoRealizacion")
public class TrabajoAvisoMomentoRealizacion implements TrabajoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(TrabajoAvisoMomentoRealizacion.class);
	
	@Override
	public DtoAviso getAviso(Trabajo trabajo, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		if (!Checks.esNulo(trabajo.getFechaHoraConcreta())) {
			
			dtoAviso.setDescripcion("A ejecutar en momento concreto");
			dtoAviso.setId(String.valueOf(trabajo.getId()));
			
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}