package es.pfsgroup.plugin.rem.activo;

import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;


@Service("agrupacionSinActivos")
public class AgrupacionAvisoSinActivos implements AgrupacionAvisadorApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoSinActivos.class);

	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {
		
		
		DtoAviso dtoAviso = new DtoAviso();
		
		if (agrupacion.getActivos() == null || agrupacion.getActivos().isEmpty()) {

			dtoAviso.setDescripcion("Agrupación sin activos");
			dtoAviso.setId(String.valueOf(agrupacion.getId()));
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}