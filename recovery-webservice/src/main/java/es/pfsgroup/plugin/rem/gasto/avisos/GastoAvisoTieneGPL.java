package es.pfsgroup.plugin.rem.gasto.avisos;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoPrinex;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

@Service("gastoAvisoTieneGPL")
public class GastoAvisoTieneGPL implements GastoAvisadorApi{
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {

		DtoAviso dtoAviso = new DtoAviso();
		
		GastoPrinex gastoPrinex = genericDao.get(GastoPrinex.class,genericDao.createFilter(FilterType.EQUALS, "idGasto", gasto.getId()));
		
		if(!Checks.esNulo(gastoPrinex) ) {

			dtoAviso.setDescripcion("El gasto tiene información detalle PRINEX LBK");
			dtoAviso.setId(String.valueOf(gasto.getId()));
			
		}
		
		return dtoAviso;
	}

}
