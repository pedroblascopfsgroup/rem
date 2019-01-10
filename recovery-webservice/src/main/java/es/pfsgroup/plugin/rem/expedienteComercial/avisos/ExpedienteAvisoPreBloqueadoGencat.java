package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Service("expedienteAvisoPreBloqueadoGencat")
public class ExpedienteAvisoPreBloqueadoGencat implements ExpedienteAvisadorApi{

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		
		if(!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getOferta())){
			List<ActivoOferta> actOfrList = expediente.getOferta().getActivosOferta();
			Reserva reserva = genericDao.get(Reserva.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId()));
			for (ActivoOferta actOfr : actOfrList){
				Activo activo = actOfr.getPrimaryKey().getActivo();	
				if (!Checks.esNulo(reserva)){
					if (activoDao.isActivoAfectoGENCAT(activo.getId()) && DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())) {
						dtoAviso.setId(String.valueOf(expediente.getId()));
						dtoAviso.setDescripcion("Expediente pre-bloqueado por GENCAT");
						break;
					}
				}else {
					if (activoDao.isActivoAfectoGENCAT(activo.getId()) && DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())) {
						dtoAviso.setId(String.valueOf(expediente.getId()));
						dtoAviso.setDescripcion("Expediente pre-bloqueado por GENCAT");
						break;
					}
				}
			}
		}

		return dtoAviso;
	}

}
