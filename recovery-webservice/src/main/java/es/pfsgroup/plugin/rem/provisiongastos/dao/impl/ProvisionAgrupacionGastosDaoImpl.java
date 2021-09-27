package es.pfsgroup.plugin.rem.provisiongastos.dao.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VBusquedaProvisionAgrupacionGastos;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.provisiongastos.dao.ProvisionAgrupacionGastosDao;

@Repository("ProvisionAgrupacionGastosDao")
public class ProvisionAgrupacionGastosDaoImpl extends AbstractEntityDao<VBusquedaProvisionAgrupacionGastos, Long> implements ProvisionAgrupacionGastosDao{
	
	@Autowired
	ProveedoresDao proveedorDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	protected static final Log logger = LogFactory.getLog(ProvisionAgrupacionGastosDaoImpl.class);
	
	
	@Override
	public Page findAll(DtoProvisionGastosFilter dto, Long usuarioId) {
		List<UsuarioCartera> usuarioCartera = genericDao.getList(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioId));
		List<String> subcarteras = new ArrayList<String>();
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaProvisionAgrupacionGastos vprg");
   		
		if (usuarioCartera != null && !usuarioCartera.isEmpty()) {
			dto.setCodCartera(usuarioCartera.get(0).getCartera().getCodigo());
			
			if (dto.getCodSubCartera() == null) {
				for (UsuarioCartera usu : usuarioCartera) {
					if (usu.getSubCartera() != null) {
						subcarteras.add(usu.getSubCartera().getCodigo());
					}
				}
			}
		}
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vprg.id", dto.getId());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "vprg.numProvision", dto.getNumProvision());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vprg.codEstadoProvision", dto.getEstadoProvisionCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vprg.codCartera", dto.getCodCartera());
		if (subcarteras != null && !subcarteras.isEmpty()) {
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "vprg.codSubCartera", subcarteras);
		} else {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vprg.codSubCartera", dto.getCodSubCartera());
		}
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vprg.codREMProveedorGestoria", dto.getCodREMProveedorGestoria());
   		HQLBuilder.addFiltroBetweenSiNotNull(hb, "vprg.importeTotal", dto.getImporteDesde(), dto.getImporteHasta());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "vprg.nifPropietario", dto.getNifPropietario());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "vprg.nomPropietario", dto.getNomPropietario());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "vprg.nombreProveedor", dto.getNombreProveedor());
 
   		if(!Checks.esNulo(dto.getIsExterno()) && dto.getIsExterno()){
   			if((Checks.estaVacio(dto.getListaIdProveedor())) ||
   			   (!Checks.estaVacio(dto.getListaIdProveedor()) && !Checks.esNulo(dto.getIdGestoria()) && !dto.getListaIdProveedor().contains(dto.getIdGestoria()))){
   				
   				//Si es externo, pero NO es gestoría de administración (listaIdProveedor vacio) o no es Gestor de Administración (isGestorAdministracion vacio) 
   				//no puede ver nada
   				if(Checks.esNulo(dto.getIsGestorAdministracion())){
   					hb.appendWhere("vprg.id is null");
   				}
   				
   			}else{
   				//Si es externo y es gestoría de administración (listaIdProveedor no vacio), puede ver gastos en los que conste como gestoría
   				if(!Checks.esNulo(dto.getIdGestoria())){
   					//Si no es externo se añade el filtro de gestoría
   		   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vprg.idProveedor", dto.getIdGestoria());
   				}else{
   					HQLBuilder.addFiltroWhereInSiNotNull(hb, "vprg.idProveedor", dto.getListaIdProveedor());
   				}
   			}
   		}else{
   			//Si no es externo se añade el filtro de gestoría
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vprg.idProveedor", dto.getIdGestoria());
   		}

   		try {
			Date fechaDesde = DateFormat.toDate(dto.getFechaAltaDesde());
			Date fechaHasta = DateFormat.toDate(dto.getFechaAltaHasta());
			HQLBuilder.addFiltroBetweenSiNotNull(hb, "vprg.fechaAlta", fechaDesde, fechaHasta);
		} catch (ParseException e) {
			logger.error("Error parseando las fechas.", e);
			
		}
   		
   		return HibernateQueryUtils.page(this, hb, dto);

	}
    
}
