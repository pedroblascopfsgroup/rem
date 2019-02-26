package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.TrabajoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;


@Service("trabajoAvisoOcupado")
public class TrabajoAvisoOcupado implements TrabajoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(TrabajoAvisoOcupado.class);
	
	@Override
	public DtoAviso getAviso(Trabajo trabajo, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		if (trabajo.getActivosTrabajo().size() <= 1) {
			
			if (trabajo.getActivo().getSituacionPosesoria().getOcupado() == 1) {
				
				if (trabajo.getActivo().getSituacionPosesoria().getConTitulo().equals(DDTipoTituloActivoTPA.tipoTituloSi)) {

					dtoAviso.setDescripcion("Activo ocupado con título");
					dtoAviso.setId(String.valueOf(trabajo.getId()));

				} else {

					dtoAviso.setDescripcion("Activo ocupado sin título");
					dtoAviso.setId(String.valueOf(trabajo.getId()));
					
				}
				
			}
			
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}