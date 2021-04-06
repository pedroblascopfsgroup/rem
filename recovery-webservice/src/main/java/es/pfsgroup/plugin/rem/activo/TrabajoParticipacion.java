package es.pfsgroup.plugin.rem.activo;

import java.text.DecimalFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.activotrabajo.dao.ActivoTrabajoDao;
import es.pfsgroup.plugin.rem.api.TrabajoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.Trabajo;


@Service("trabajoParticipacion")
public class TrabajoParticipacion implements TrabajoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(TrabajoParticipacion.class);
	
	@Autowired
	private ActivoTrabajoDao activoTrabajoDao;
	
	@Override
	public DtoAviso getAviso(Trabajo trabajo, Usuario usuarioLogado) {

		DtoAviso dtoAviso = new DtoAviso();
		
		Float participacion = activoTrabajoDao.getImporteParticipacionTotal(trabajo.getNumTrabajo());
		if (participacion != null && participacion.doubleValue() != 100.00) {
			dtoAviso.setDescripcion("Participacion activos no suma 100%");
			dtoAviso.setId(String.valueOf(trabajo.getId()));
		}
		
		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}