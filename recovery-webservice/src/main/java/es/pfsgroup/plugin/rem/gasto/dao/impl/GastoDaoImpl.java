package es.pfsgroup.plugin.rem.gasto.dao.impl;


import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VGastosProveedor;

@Repository("GastoDao")
public class GastoDaoImpl extends AbstractEntityDao<GastoProveedor, Long> implements GastoDao{
	
	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter) {
		
		HQLBuilder hb = new HQLBuilder(" from VGastosProveedor vgasto");

   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.idProvision", dtoGastosFilter.getIdProvision());
   		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.codigoProveedorRem", dtoGastosFilter.getCodigoProveedorRem());   		
   		
   		////////////////////////Por situación del gasto
   		
   		if(!Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionHayaCodigo())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.estadoAutorizacionHayaCodigo",dtoGastosFilter.getEstadoAutorizacionHayaCodigo());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionPropietarioCodigo())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.estadoAutorizacionPropietarioCodigo",dtoGastosFilter.getEstadoAutorizacionPropietarioCodigo());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getEstadoGastoCodigo())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.estadoGastoCodigo",dtoGastosFilter.getEstadoGastoCodigo());
   		}
   		
   		
   		//////////////////////// Por gasto
   		
   		if(!Checks.esNulo(dtoGastosFilter.getNumGastoHaya())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.numGastoHaya",dtoGastosFilter.getNumGastoHaya());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getTipoGastoCodigo())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.tipoCodigo",dtoGastosFilter.getTipoGastoCodigo());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getSubtipoGastoCodigo())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.subtipoCodigo",dtoGastosFilter.getSubtipoGastoCodigo());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getImporteDesde()) || !Checks.esNulo(dtoGastosFilter.getImporteHasta())){
   			Double importeHasta= null;
   			Double importeDesde= null;
   			
   			if(Checks.esNulo(dtoGastosFilter.getImporteDesde())){
   				importeHasta= Double.parseDouble(dtoGastosFilter.getImporteHasta());
   			}
   			else if(Checks.esNulo(dtoGastosFilter.getImporteHasta())){
   				importeDesde= Double.parseDouble(dtoGastosFilter.getImporteDesde());
   			}
   			else{
   				importeHasta= Double.parseDouble(dtoGastosFilter.getImporteHasta());
   				importeDesde= Double.parseDouble(dtoGastosFilter.getImporteDesde());
   			}
   			
   			HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgasto.importeTotal", importeDesde, importeHasta);
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getNumGastoGestoria())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.numGastoGestoria",Long.parseLong(dtoGastosFilter.getNumGastoGestoria()));
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getNifGestoria())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.nifGestoria", dtoGastosFilter.getNifGestoria());
   		}   		
   		if(!Checks.esNulo(dtoGastosFilter.getReferenciaEmisor())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.numFactura",dtoGastosFilter.getReferenciaEmisor());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getNecesitaAutorizacionPropietario())){
   			
   			if("1".equals(dtoGastosFilter.getNecesitaAutorizacionPropietario())){
   				HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.autorizacionPropietario",true);
   			}
   			else if("0".equals(dtoGastosFilter.getNecesitaAutorizacionPropietario())){
   				HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.autorizacionPropietario",false);
   			}
//   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.autorizacionPropietario",dtoGastosFilter.getNecesitaAutorizacionPropietario());
   		}
   		
   		try {
			Date fechaTopePagoDesde = DateFormat.toDate(dtoGastosFilter.getFechaTopePagoDesde());
			Date fechaTopePagoHasta = DateFormat.toDate(dtoGastosFilter.getFechaTopePagoHasta());
			HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgasto.fechaTopePago", fechaTopePagoDesde, fechaTopePagoHasta);
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
   		if(!Checks.esNulo(dtoGastosFilter.getDestinatario())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.destinatarioCodigo",dtoGastosFilter.getDestinatario());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getCubreSeguro())){
   			if("1".equals(dtoGastosFilter.getCubreSeguro())){
   				HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.cubreSeguro",true);
   			}
   			else if("0".equals(dtoGastosFilter.getCubreSeguro())){
   				HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.cubreSeguro",false);
   			}
//   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.cubreSeguro",dtoGastosFilter.getCubreSeguro());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getPeriodicidad())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.periodicidadCodigo",dtoGastosFilter.getPeriodicidad());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getNumProvision())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.numProvision",Long.parseLong(dtoGastosFilter.getNumProvision()));
   		}
   		//////////////////////// Por Proveedor
   		
   		if(!Checks.esNulo(dtoGastosFilter.getNifProveedor())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.documentoProveedor",dtoGastosFilter.getNifProveedor());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getCodigoSubtipoProveedor())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.tipoProveedorCodigo",dtoGastosFilter.getCodigoSubtipoProveedor());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getCodigoTipoProveedor())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.tipoEntidadCodigo",dtoGastosFilter.getCodigoTipoProveedor());
   		}
   		if(!Checks.esNulo(dtoGastosFilter.getNombreProveedor())){
   			HQLBuilder.addFiltroLikeSiNotNull(hb,"vgasto.nombreProveedor",dtoGastosFilter.getNombreProveedor(), true);
   		}
   		
   		if(Checks.esNulo(dtoGastosFilter.getNumActivo())) {
   			HQLBuilder.addFiltroIgualQue(hb, "vgasto.rango", 1);
   		} else {
   			HQLBuilder.addFiltroIgualQue(hb, "vgasto.numActivo", dtoGastosFilter.getNumActivo());
   		}
   		
   		////////////////////// Por activo / agrupación
   		
   		if(!Checks.esNulo(dtoGastosFilter.getEntidadPropietariaCodigo())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.entidadPropietariaCodigo",dtoGastosFilter.getEntidadPropietariaCodigo());
   		}
   		
   		if(!Checks.esNulo(dtoGastosFilter.getSubentidadPropietariaCodigo())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.entidadPropietariaCodigo",dtoGastosFilter.getSubentidadPropietariaCodigo());
   		}

	
		Page pageVisitas = HibernateQueryUtils.page(this, hb, dtoGastosFilter);
		
		List<VGastosProveedor> ofertas = (List<VGastosProveedor>) pageVisitas.getResults();
		
		return new DtoPage(ofertas, pageVisitas.getTotalCount());
		
	}

	@Override
	public Long getNextNumGasto() {

		String sql = "SELECT S_GPV_NUM_GASTO_HAYA.NEXTVAL FROM DUAL ";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
		
	}
	
    @Override
	public void deleteGastoTrabajoById(Long id) {
		
		StringBuilder sb = new StringBuilder("delete from GastoProveedorTrabajo gpt where gpt.id = "+id);		
		getSession().createQuery(sb.toString()).executeUpdate();
		
	}
	
	


	


}
