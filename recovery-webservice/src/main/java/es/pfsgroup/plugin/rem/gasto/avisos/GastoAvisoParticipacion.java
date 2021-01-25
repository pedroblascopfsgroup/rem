package es.pfsgroup.plugin.rem.gasto.avisos;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VElementosLineaDetalle;
import es.pfsgroup.plugin.rem.model.VParticipacionLineaDetalle;


@Service("gastoAvisoParticipacion")
public class GastoAvisoParticipacion implements GastoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoAvisoParticipacion.class);
		
	@Autowired
	private GenericABMDao genericDao;
	

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {

		DtoAviso dtoAviso = new DtoAviso();	
	

		if(gasto != null){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", gasto.getId());
			List<VParticipacionLineaDetalle> participacionesLinea = genericDao.getList(VParticipacionLineaDetalle.class, filtro);
			if(participacionesLinea != null && !participacionesLinea.isEmpty()) {
				for (VParticipacionLineaDetalle vParticipacionLineaDetalle : participacionesLinea) {
					if((new BigDecimal(100).compareTo(vParticipacionLineaDetalle.getParticipacion())) != 0){
						dtoAviso.setDescripcion("Líneas con % de participación incorrecto");
						dtoAviso.setId(String.valueOf(gasto.getId()));	
						break;
					}
				}
			}
		}
		
		return dtoAviso;
		
	}
	
}