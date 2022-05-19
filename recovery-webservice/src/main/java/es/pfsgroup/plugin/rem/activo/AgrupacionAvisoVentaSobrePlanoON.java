package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoObraNueva;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;


@Service("agrupacionAvisoVentaSobrePlanoON")
public class AgrupacionAvisoVentaSobrePlanoON implements AgrupacionAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoVentaSobrePlanoON.class);

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {
		
		DtoAviso dtoAviso = new DtoAviso();
		
		if (DDSinSiNo.cambioDiccionarioaBooleanoNativo(agrupacion.getVentaPlano())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", agrupacion.getId());
			ActivoObraNueva on = genericDao.get(ActivoObraNueva.class, filtro);
			if(!Checks.esNulo(on) && !Checks.esNulo(on.getIdOnvDnd())) {
				dtoAviso.setDescripcion("Venta sobre plano");
				dtoAviso.setId(String.valueOf(agrupacion.getId()));
			}
		}

		return dtoAviso;
		
	}	
}