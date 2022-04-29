package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;


@Service("agrupacionPisoPiloto")
public class AgrupacionAvisoPisoPiloto implements AgrupacionAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoPisoPiloto.class);
	
	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {
		
		DtoAviso dtoAviso = new DtoAviso();
		
		if (activoAgrupacionApi.isONPisoPiloto(agrupacion)) {
			dtoAviso.setDescripcion("Piso piloto incluido en la agrupación");
			dtoAviso.setId(String.valueOf(agrupacion.getId()));
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
}