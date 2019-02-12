package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Service("expedienteAvisoBloqueadoGencat")
public class ExpedienteAvisoBloqueadoGencat implements ExpedienteAvisadorApi{

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		Boolean expBloqueado = false;
		if(!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getOferta())){
			List<ActivoOferta> actOfrList = expediente.getOferta().getActivosOferta();
			ComunicacionGencat comGen = null;
			for (ActivoOferta actOfr : actOfrList){
				Activo activo = actOfr.getPrimaryKey().getActivo();
				comGen = genericDao.get(ComunicacionGencat.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
				if (!Checks.esNulo(comGen) && !Checks.esNulo(comGen.getEstadoComunicacion()) && !DDEstadoComunicacionGencat.COD_RECHAZADO.equals(comGen.getEstadoComunicacion().getCodigo())
						&& !DDEstadoComunicacionGencat.COD_ANULADO.equals(comGen.getEstadoComunicacion().getCodigo())
						&& !DDEstadoComunicacionGencat.COD_SANCIONADO.equals(comGen.getEstadoComunicacion().getCodigo()) && activoDao.isActivoAfectoGENCAT(activo.getId()) &&
						!DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo()) && !DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())) {
					dtoAviso.setId(String.valueOf(expediente.getId()));
					dtoAviso.setDescripcion("Expediente bloqueado por GENCAT");
					return dtoAviso;
				}
				List<ActivoTramite> actTraList = genericDao.getList(ActivoTramite.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
				if(!Checks.estaVacio(actTraList)){
					for (ActivoTramite activoTramite : actTraList) {
						if(ActivoTramiteApi.CODIGO_TRAMITE_COMUNICACION_GENCAT.equals(activoTramite.getTipoTramite().getCodigo())){
							if(!Checks.esNulo(activoTramite.getEstadoTramite()) && (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(activoTramite.getEstadoTramite().getCodigo()) || DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO.equals(activoTramite.getEstadoTramite().getCodigo()))){
								expBloqueado = true;
							}else{
								expBloqueado = false;
								break;
							}
						}
					}
					if(expBloqueado && !Checks.esNulo(comGen) && Checks.esNulo(comGen.getSancion())
							&& !Checks.esNulo(comGen.getEstadoComunicacion()) && !DDEstadoComunicacionGencat.COD_ANULADO.equals(comGen.getEstadoComunicacion().getCodigo()))
					{
						dtoAviso.setId(String.valueOf(expediente.getId()));
						dtoAviso.setDescripcion("Expediente bloqueado por GENCAT");
						return dtoAviso;
					}
				}
			}
		}

		return dtoAviso;
	}

}
