package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacion;

@Service("expedienteAvisoPisoPiloto")
public class ExpedienteAvisoPisoPiloto implements ExpedienteAvisadorApi{

	@Autowired
    private GenericABMDao genericDao;
	
	
	
	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		
		if (!Checks.esNulo(expediente.getOferta())){
			Oferta oferta = expediente.getOferta();
			if (!Checks.esNulo(oferta.getActivosOferta())) {
				List<ActivoOferta> listaActivosOferta = oferta.getActivosOferta();
				for (ActivoOferta listaActivoOferta : listaActivosOferta) {				
					if (!Checks.esNulo(listaActivoOferta.getActivoId())) {
						Long activoOfertaId = listaActivoOferta.getActivoId();
						ActivoAgrupacion agrupacionOferta = oferta.getAgrupacion();
						VActivosAgrupacion activoPisoPiloto;
						List<VActivosAgrupacion> activosAgrupaciones;
						boolean pisoPiloto = false;
						if(!Checks.esNulo(agrupacionOferta)) {
							Long agrupacionOfertaId = oferta.getAgrupacion().getId();
							activoPisoPiloto = genericDao.get(VActivosAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "activoId", activoOfertaId),
								genericDao.createFilter(FilterType.EQUALS, "agrId", agrupacionOfertaId));
							if (!Checks.esNulo(activoPisoPiloto) && !Checks.esNulo(activoPisoPiloto.getEsPisoPiloto()) && activoPisoPiloto.getEsPisoPiloto()) {
								pisoPiloto = true;
							}
						}
						else {
							activosAgrupaciones = genericDao.getList(VActivosAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "activoId", activoOfertaId));
							if(!Checks.estaVacio(activosAgrupaciones)) {
								for(VActivosAgrupacion activoAgrupacion : activosAgrupaciones) {
									if (!Checks.esNulo(activoAgrupacion) && !Checks.esNulo(activoAgrupacion.getEsPisoPiloto()) && activoAgrupacion.getEsPisoPiloto()) {
										pisoPiloto = true;
									}
								}
							}
						}
						if (pisoPiloto) {
							dtoAviso.setId(String.valueOf(expediente.getId()));
							dtoAviso.setDescripcion("Piso Piloto");
						}
					}
				}
			}
		}				
				
		return dtoAviso;
	}

}
