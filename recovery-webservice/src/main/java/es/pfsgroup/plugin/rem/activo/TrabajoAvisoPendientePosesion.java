package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.TrabajoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.Trabajo;


@Service("trabajoAvisoPendientePosesion")
public class TrabajoAvisoPendientePosesion implements TrabajoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(TrabajoAvisoPendientePosesion.class);
	
	@Override
	public DtoAviso getAviso(Trabajo trabajo, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		if (trabajo.getActivosTrabajo().size() <= 1) {
			
			if (trabajo.getActivo().getAdjJudicial() != null && trabajo.getActivo().getAdjJudicial().getAdjudicacionBien() != null 
					&&  trabajo.getActivo().getAdjJudicial().getAdjudicacionBien().getFechaSenalamientoPosesion() == null) {
				
				dtoAviso.setDescripcion("Activo pendiente toma de posesión");
				dtoAviso.setId(String.valueOf(trabajo.getId()));				
			}
			
		}

		return dtoAviso;
		
	}
	
}