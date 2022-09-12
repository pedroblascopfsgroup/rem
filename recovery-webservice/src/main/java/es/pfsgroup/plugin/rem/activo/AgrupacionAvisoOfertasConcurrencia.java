package es.pfsgroup.plugin.rem.activo;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.api.ConcurrenciaApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;


@Service("agrupacionOfertasConcurrencia")
public class AgrupacionAvisoOfertasConcurrencia implements AgrupacionAvisadorApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoOfertasConcurrencia.class);

	@Autowired
	private ConcurrenciaApi concurrenciaApi;

	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {
		
		
		DtoAviso dtoAviso = new DtoAviso();
		
		if (concurrenciaApi.tieneAgrupacionOfertasDeConcurrencia(agrupacion)) {

			dtoAviso.setDescripcion("Agrupación con ofertas de concurrencia");
			dtoAviso.setId(String.valueOf(agrupacion.getId()));
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}