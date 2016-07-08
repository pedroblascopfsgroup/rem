package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.TrabajoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.Trabajo;


@Service("trabajoAvisoAccesibilidad")
public class TrabajoAvisoAccesibilidad implements TrabajoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(TrabajoAvisoAccesibilidad.class);
	
	@Override
	public DtoAviso getAviso(Trabajo trabajo, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		if (trabajo.getActivosTrabajo().size() <= 1) {
			
			if (BooleanUtils.toBoolean(trabajo.getActivo().getSituacionPosesoria().getAccesoTapiado())){
				dtoAviso.setDescripcion("Situación de acceso tapiado");
				dtoAviso.setId(String.valueOf(trabajo.getId()));
				
			// Aviso 6: Acceso antiocupa	
			} else if (BooleanUtils.toBoolean(trabajo.getActivo().getSituacionPosesoria().getAccesoAntiocupa())) {
				
				dtoAviso.setDescripcion("Situación de acceso con puerta antiocupa");
				dtoAviso.setId(String.valueOf(trabajo.getId()));
				
			}
		
			
		}

		return dtoAviso;
		
	}
	
}