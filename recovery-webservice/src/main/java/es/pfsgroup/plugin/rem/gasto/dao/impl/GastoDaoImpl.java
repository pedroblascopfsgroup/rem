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
		
		
		String from = "select vgasto from VGastosProveedor vgasto";
		HQLBuilder hb = null;
				
		
   		if(!Checks.esNulo(dtoGastosFilter.getNumActivo()) || !Checks.esNulo(dtoGastosFilter.getEntidadPropietariaCodigo()) || !Checks.esNulo(dtoGastosFilter.getSubentidadPropietariaCodigo()) ) {

   			from = from + ",GastoProveedorActivo gastoActivo where vgasto.id = gastoActivo.gastoProveedor.id ";
   			hb = new HQLBuilder(from);
   			hb.setHasWhere(true);   			

   		} else {   			
   			hb = new HQLBuilder(from);
   		}
   		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gastoActivo.activo.numActivo", dtoGastosFilter.getNumActivo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gastoActivo.activo.cartera.codigo", dtoGastosFilter.getEntidadPropietariaCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gastoActivo.activo.subcartera.codigo", dtoGastosFilter.getSubentidadPropietariaCodigo());
		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.idProvision", dtoGastosFilter.getIdProvision());   		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.codigoProveedorRem", dtoGastosFilter.getCodigoProveedorRem()); 
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.nifProveedor", dtoGastosFilter.getNifProveedor());
   		
   		////////////////////////Por situación del gasto
   		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.estadoAutorizacionHayaCodigo",dtoGastosFilter.getEstadoAutorizacionHayaCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.estadoAutorizacionPropietarioCodigo",dtoGastosFilter.getEstadoAutorizacionPropietarioCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.estadoGastoCodigo",dtoGastosFilter.getEstadoGastoCodigo());   		
   		
   		//////////////////////// Por gasto   		

   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.numGastoHaya",dtoGastosFilter.getNumGastoHaya());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.tipoCodigo",dtoGastosFilter.getTipoGastoCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.subtipoCodigo",dtoGastosFilter.getSubtipoGastoCodigo());
   	
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
   		

   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.idGestoria", dtoGastosFilter.getIdGestoria());
  
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.numFactura",dtoGastosFilter.getReferenciaEmisor());   		
   		
   		try {
			Date fechaTopePagoDesde = DateFormat.toDate(dtoGastosFilter.getFechaTopePagoDesde());
			Date fechaTopePagoHasta = DateFormat.toDate(dtoGastosFilter.getFechaTopePagoHasta());
			HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgasto.fechaTopePago", fechaTopePagoDesde, fechaTopePagoHasta);
			
			Date fechaEmisionDesde = DateFormat.toDate(dtoGastosFilter.getFechaEmisionDesde());
			Date fechaEmisionHasta = DateFormat.toDate(dtoGastosFilter.getFechaEmisionHasta());
			HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgasto.fechaEmision", fechaEmisionDesde, fechaEmisionHasta);
			
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

   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.periodicidadCodigo",dtoGastosFilter.getPeriodicidad());
   		
   		if(!Checks.esNulo(dtoGastosFilter.getNumProvision())){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.numProvision",Long.parseLong(dtoGastosFilter.getNumProvision()));
   		}
   		
   		HQLBuilder.addFiltroLikeSiNotNull(hb,"vgasto.nombrePropietario", dtoGastosFilter.getNombrePropietario(), true);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.docIdentifPropietario", dtoGastosFilter.getDocIdentifPropietario());
   		
   		
   		//////////////////////// Por Proveedor
   		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.tipoProveedorCodigo",dtoGastosFilter.getCodigoSubtipoProveedor());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"vgasto.tipoEntidadCodigo",dtoGastosFilter.getCodigoTipoProveedor());
   		HQLBuilder.addFiltroLikeSiNotNull(hb,"vgasto.nombreProveedor",dtoGastosFilter.getNombreProveedor(), true);
   		
		HQLBuilder.addFiltroIgualQue(hb, "vgasto.rango", 1);

		
		Page pageGastos = HibernateQueryUtils.page(this, hb, dtoGastosFilter);
		
		List<VGastosProveedor> gastos = (List<VGastosProveedor>) pageGastos.getResults();
		
		return new DtoPage(gastos, pageGastos.getTotalCount());
		
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
