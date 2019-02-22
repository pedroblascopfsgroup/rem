package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDSancionGencat;

@Service("expedienteAvisoAnuladoGencat")
public class ExpedienteAvisoAnuladoGencat implements ExpedienteAvisadorApi{

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		Boolean expBloqueado = false;
		if(!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getOferta())){
			
			Oferta oferta = expediente.getOferta();	
			OfertaGencat ofertaGencat = genericDao.get(OfertaGencat.class,genericDao.createFilter(FilterType.EQUALS,"oferta", oferta));

			if((Checks.esNulo(ofertaGencat)) || (!Checks.esNulo(ofertaGencat) && Checks.esNulo(ofertaGencat.getIdOfertaAnterior()) && !ofertaGencat.getAuditoria().isBorrado())) {
					List<ActivoOferta> actOfrList = expediente.getOferta().getActivosOferta();
					for (ActivoOferta actOfr : actOfrList){
						Activo activo = actOfr.getPrimaryKey().getActivo();
						Order order = new Order(OrderType.DESC,"id");
						List<ComunicacionGencat> comGenLista = genericDao.getListOrdered(ComunicacionGencat.class, order ,genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
						if(!Checks.estaVacio(comGenLista)) {
							ComunicacionGencat comGen = comGenLista.get(0);
						
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
							}
							
							if (!Checks.esNulo(comGen) && expBloqueado && !Checks.esNulo(comGen.getSancion()) &&
									DDSancionGencat.COD_EJERCE.equals(comGen.getSancion().getCodigo()) && activoApi.isAfectoGencat(activo)) {
								dtoAviso.setId(String.valueOf(expediente.getId()));
								dtoAviso.setDescripcion("Expediente anulado por GENCAT");
								break;
							}
						}
					}
			}
			
		}
		return dtoAviso;
	}

}
