package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Service("expedienteAvisoVentaSobrePlano")
public class ExpedienteAvisoVentaSobrePlano implements ExpedienteAvisadorApi{
	
	@Autowired
	private OfertaApi ofertaApi;

	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		
		DtoAviso dtoAviso = new DtoAviso();
		
		Long numAgrupacionONVentaSobrePlano = ofertaApi.numAgrupacionONVentaSobrePlano(expediente.getOferta());
		if(!Checks.esNulo(numAgrupacionONVentaSobrePlano)){
			dtoAviso.setDescripcion("Venta sobre plano (".concat(numAgrupacionONVentaSobrePlano.toString()).concat(")"));
			dtoAviso.setId(String.valueOf(expediente.getId()));
		}

		return dtoAviso;
	}
}