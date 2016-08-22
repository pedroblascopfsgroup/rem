package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.TrabajoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.Trabajo;


@Service("trabajoAvisoEstadoComercial")
public class TrabajoAvisoEstadoComercial implements TrabajoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(TrabajoAvisoEstadoComercial.class);
	
	@Override
	public DtoAviso getAviso(Trabajo trabajo, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		//TODO No tenemos aún el estado comercial del activo
		/*if (trabajo.getActivosTrabajo().size() > 1) {
			
			dtoAviso.setDescripcion("Estado activo: " + trabajo.getEstado().getDescripcion());
			dtoAviso.setId(String.valueOf(trabajo.getId()));
			
		}*/

		return dtoAviso;
		
	}
	
	
}