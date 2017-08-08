package es.pfsgroup.plugin.rem.gasto.avisos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.gasto.dao.impl.MotivosAvisoHqlHelper;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoProveedorAvisos;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosAvisoGasto;


@Service("gastoAvisoAlertas")
public class GastoAvisoAlertas implements GastoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoAvisoAlertas.class);
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();		
						
		if(!Checks.estaVacio(gasto.getGastoProveedorAvisos())) {
			String id = String.valueOf(gasto.getId());
			dtoAviso.setId(id);
			for (GastoProveedorAvisos aviso : gasto.getGastoProveedorAvisos()) {
				String[] campos = aviso.camposAlerta();
				if (campos != null) {
					for (String c : campos) {
						String codigoMotivo = MotivosAvisoHqlHelper.codigoMotivo(c);
						if (!Checks.esNulo(codigoMotivo)) {
							String descripcionMotivo = ((Dictionary) diccionarioApi.dameValorDiccionarioByCod(DDMotivosAvisoGasto.class, codigoMotivo)).getDescripcion();
							dtoAviso.addDescripcion(descripcionMotivo);
						}
					}
				}
			}
		}
		
		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}