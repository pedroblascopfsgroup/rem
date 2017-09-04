package es.pfsgroup.plugin.rem.gasto.avisos;

import java.text.DecimalFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;


@Service("gastoAvisoParticipacion")
public class GastoAvisoParticipacion implements GastoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoAvisoParticipacion.class);
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {

		DtoAviso dtoAviso = new DtoAviso();	
		Double participacionTotal= new Double(0);
		Double participacionCien= new Double(100);
				
		if(!Checks.esNulo(gasto)){
			
			List<VBusquedaGastoActivo> activosGasto= gastoProveedorApi.getListActivosGastos(gasto.getId());
			DecimalFormat df = new DecimalFormat("#.00");
			for(VBusquedaGastoActivo ag: activosGasto){
				participacionTotal +=  ag.getParticipacion();
				participacionTotal = Double.valueOf(df.format(participacionTotal));
			}
			
			if(!participacionCien.equals(participacionTotal)){
				dtoAviso.setDescripcion("% participación de activos incorrecto");
				dtoAviso.setId(String.valueOf(gasto.getId()));	
			}
			
		}
		
		return dtoAviso;
		
	}
	
}