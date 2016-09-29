package es.pfsgroup.plugin.rem.proveedores.dao.impl;

import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;

@Repository("ProveedoresDao")
public class ProveedoresDaoImpl extends AbstractEntityDao<ActivoProveedor, Long> implements ProveedoresDao {
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@SuppressWarnings("unchecked")
	@Override
	public List<DtoProveedorFilter> getProveedoresList(DtoProveedorFilter dto) {
		HQLBuilder hb = new HQLBuilder("select distinct pve.id, pve.tipoProveedorDescripcion, pve.subtipoProveedorDescripcion, pve.nifProveedor, pve.nombreProveedor, pve.nombreComercialProveedor, pve.estadoProveedorDescripcion, pve.observaciones from VBusquedaProveedor pve");

		if(!Checks.esNulo(dto.getId())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.id", Long.valueOf(dto.getId()));
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.estadoProveedorCodigo", dto.getEstadoProveedorCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.tipoProveedorCodigo", dto.getTipoProveedorCodigo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "pve.nombreComercialProveedor", dto.getNombreComercialProveedor(), true);
		try {
			if(!Checks.esNulo(dto.getFechaAlta())){
				Date fechaAlta = DateFormat.toDate(dto.getFechaAlta());
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.fechaAltaProveedor", fechaAlta);
			}
			if(!Checks.esNulo(dto.getFechaBaja())){
				Date fechaBaja = DateFormat.toDate(dto.getFechaBaja());
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.fechaBajaProveedor", fechaBaja);
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.subtipoProveedorCodigo", dto.getSubtipoProveedorCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.nifProveedor", dto.getNifProveedor());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.tipoPersonaProveedorCodigo", dto.getTipoPersonaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.cartera", dto.getCartera());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "pve.propietarioActivoVinculado", dto.getPropietario(), true);
		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.subCartera", dto.getSubCartera());// TODO: falta por definir en la vista
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.provinciaProveedor", dto.getProvinciaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.municipioProveedor", dto.getMunicipioCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.codigoPostalProveedor", dto.getCodigoPostal());
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.nifPersonaContacto", dto.getNifPersonaContacto());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "pve.nombrePersonaContacto", dto.getNombrePersonaContacto(), true);
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.homologadoProveedor", dto.getHomologadoProveedor());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.calificacionProveedor", dto.getCalificacionCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.topProveedor", dto.getTopCodigo());
   		
   		// Tiene que tratarse de la siguiente manera debido a la personalizacion de la query hql.
   		Page p = HibernateQueryUtils.page(this, hb, dto);
		List<Object[]> busquedaProveedor = (List<Object[]>) p.getResults();
   		List<DtoProveedorFilter> dtoProveedorFilter = new ArrayList<DtoProveedorFilter>();
		
		for(Object[] busqueda: busquedaProveedor) {
			DtoProveedorFilter nuevoDto = new DtoProveedorFilter();
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "id", busqueda[0]);
				beanUtilNotNull.copyProperty(nuevoDto, "tipoProveedorDescripcion", busqueda[1]);
				beanUtilNotNull.copyProperty(nuevoDto, "subtipoProveedorDescripcion", busqueda[2]);
				beanUtilNotNull.copyProperty(nuevoDto, "nifProveedor", busqueda[3]);
				beanUtilNotNull.copyProperty(nuevoDto, "nombreProveedor", busqueda[4]);
				beanUtilNotNull.copyProperty(nuevoDto, "nombreComercialProveedor", busqueda[5]);
				beanUtilNotNull.copyProperty(nuevoDto, "estadoProveedorDescripcion", busqueda[6]);
				beanUtilNotNull.copyProperty(nuevoDto, "observaciones", busqueda[7]);
				beanUtilNotNull.copyProperty(nuevoDto, "totalCount", p.getTotalCount());
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			
			if(!Checks.esNulo(nuevoDto)) {
				dtoProveedorFilter.add(nuevoDto);
			}
		}

		return dtoProveedorFilter;
	}

	@Override
	public ActivoProveedor getProveedorById(Long id) {
		HQLBuilder hb = new HQLBuilder(" from ActivoProveedor pve");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.id", id);

		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	@Override
	public ActivoProveedor getProveedorByNIF(String nifProveedor) {
		HQLBuilder hb = new HQLBuilder(" from ActivoProveedor pve");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.docIdentificativo", nifProveedor);

		return HibernateQueryUtils.uniqueResult(this, hb);
	}

}
