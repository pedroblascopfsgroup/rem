package es.pfsgroup.plugin.rem.expedienteComercial.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Repository("ExpedienteComercialDao")
public  class ExpedienteComercialDaoImpl extends AbstractEntityDao<ExpedienteComercial, Long> implements ExpedienteComercialDao {

	@Override
	public Page getCompradoresByExpediente(Long idExpediente, WebDto webDto) {

		HQLBuilder hql = new HQLBuilder("from VBusquedaCompradoresExpediente");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idExpediente", idExpediente.toString());

		return HibernateQueryUtils.page(this, hql, webDto);
	}

	@Override
	public Page getObservacionesByExpediente(Long idExpediente, WebDto dto) {

		HQLBuilder hql = new HQLBuilder(" from ObservacionesExpedienteComercial obs");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "obs.expediente.id", idExpediente);

   		return HibernateQueryUtils.page(this, hql, dto);
	}

	@Override
	public Page getComboProveedoresExpediente(String codigoTipoProveedor, String nombreBusqueda, String codigoProvinciaActivo, List<Long> proveedoresIDporCartera, WebDto webDto) {

		HQLBuilder hql = new HQLBuilder("from ActivoProveedor");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "tipoProveedor.codigo", codigoTipoProveedor); // Filtro por tipo de proveedor.

		if (!Checks.esNulo(nombreBusqueda)) {
   			HQLBuilder.addFiltroLikeSiNotNull(hql, "nombre", nombreBusqueda, true); // Filtro por nombre de proveedor.
   		}

		if(!Checks.esNulo(codigoProvinciaActivo)) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "provincia.codigo", codigoProvinciaActivo); // Filtro por provincia del activo.
		}

		if(!Checks.estaVacio(proveedoresIDporCartera)) {
			HQLBuilder.addFiltroWhereInSiNotNull(hql, "id", proveedoresIDporCartera); // Filtro por IDs de proveedor pre-filtrado por cartera del activo.
		}

		return HibernateQueryUtils.page(this, hql, webDto);
	}

	@Override
	public void deleteCompradorExpediente(Long idExpediente, Long idComprador) {

		StringBuilder sb = new StringBuilder("delete from CompradorExpediente ce where ce.primaryKey.comprador = "+idComprador+" and ce.primaryKey.expediente= "+idExpediente);		
		getSession().createQuery(sb.toString()).executeUpdate();
	}
	
	@Override
	public ExpedienteComercial getExpedienteComercialByTrabajo(Long idTrabajo) {
		
		HQLBuilder hql = new HQLBuilder("from ExpedienteComercial exp");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "exp.trabajo.id", idTrabajo);
		
		List<ExpedienteComercial> listaExpedientes = HibernateQueryUtils.list(this, hql);

		if(!Checks.estaVacio(listaExpedientes))
			return listaExpedientes.get(0);
		else
			return null;
	}
}