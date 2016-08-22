package es.pfsgroup.plugin.rem.activo;

import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;


@Service("agrupacionAvisoRestringidaObraNueva")
public class AgrupacionAvisoRestringidaObraNueva implements AgrupacionAvisadorApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoRestringidaObraNueva.class);
	
	@Autowired
	private ActivoAgrupacionApi agrupacionApi;


	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		if (agrupacion.getTipoAgrupacion() != null && agrupacion.getTipoAgrupacion().getId() == 2) {
			
			Long tipos = agrupacionApi.haveActivoRestringidaAndObraNueva(agrupacion.getId());
			
			if (tipos > 1) {
				dtoAviso.setDescripcion("Agrupación restringida integrada en obra nueva");
				dtoAviso.setId(String.valueOf(agrupacion.getId()));
			}
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}