package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

@Service("expedienteAvisoPisoPiloto")
public class ExpedienteAvisoPisoPiloto implements ExpedienteAvisadorApi{
	
	@Autowired
	private ActivoDao activoDao;
	
	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();

		//No se puede crear una oferta con una agrupacion de tipo Obra Nueva, 
		//por lo tanto la oferta nunca va a tener mas de un activo asociado
		Activo activo = expediente.getOferta().getActivoPrincipal();
		if (DDSubcartera.CODIGO_YUBAI.equals(activo.getSubcartera().getCodigo())) {
			//Un activo solo puede pertenecer a una agrupación de tipo Obra Nueva
			ActivoAgrupacionActivo AgaObraNueva = activoDao.getActivoAgrupacionActivoObraNuevaPorActivoID(activo.getId());
			if(!Checks.esNulo(AgaObraNueva) && !Checks.esNulo(AgaObraNueva.getPisoPiloto()) && AgaObraNueva.getPisoPiloto()) {
				dtoAviso.setId(String.valueOf(expediente.getId()));
				dtoAviso.setDescripcion("Piso Piloto");
			}
		}				
				
		return dtoAviso;
	}

}
