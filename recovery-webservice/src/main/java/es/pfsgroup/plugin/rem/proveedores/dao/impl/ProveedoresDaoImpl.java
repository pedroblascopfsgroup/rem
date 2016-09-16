package es.pfsgroup.plugin.rem.proveedores.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaProveedor;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;

@Repository("ProveedoresDao")
public class ProveedoresDaoImpl extends AbstractEntityDao<ActivoProveedor, Long> implements ProveedoresDao {

	@Override
	public Page getProveedoresList(DtoProveedorFilter dto) {
		HQLBuilder hb = new HQLBuilder(" from VBusquedaProveedor pve");

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
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.tipoPersonaProveedorCodigo", dto.getTipoPersonaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.cartera", dto.getCartera());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.propietario", dto.getPropietario());// TODO: falta por definir en la vista
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.subCartera", dto.getSubCartera());// TODO: falta por definir en la vista
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.provinciaProveedor", dto.getProvinciaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.municipioProveedor", dto.getMunicipioCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.codigoPostalProveedor", dto.getCodigoPostal());
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.nifProveedor", dto.getNifProveedor());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.nombreProveedor", dto.getNombreProveedor());
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.homologadoProveedor", dto.getHomologadoProveedor());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.calificacionProveedor", dto.getCalificacionCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.topProveedor", dto.getTopCodigo());
   		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public ActivoProveedor getProveedorById(Long id) {
		HQLBuilder hb = new HQLBuilder(" from ActivoProveedor pve");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.id", id);

		return HibernateQueryUtils.uniqueResult(this, hb);
	}

}
