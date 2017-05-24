package es.pfsgroup.plugin.rem.proveedores.dao.impl;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoMediador;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.VProveedores;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;

@Repository("ProveedoresDao")
public class ProveedoresDaoImpl extends AbstractEntityDao<ActivoProveedor, Long> implements ProveedoresDao {

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private GenericAdapter adapter;

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoProveedorFilter> getProveedoresList(DtoProveedorFilter dto) {

		// Es proveedor o gestoria
		Usuario usuarioLogado = adapter.getUsuarioLogado();
		Boolean esProveedor = adapter.isProveedorHayaOrCee(usuarioLogado);
		Boolean esGestoria = false;
		if(!esProveedor){
			esGestoria = adapter.isGestoria(usuarioLogado);
		}

		HQLBuilder hb = new HQLBuilder(
				"select distinct pve.id, pve.codigoProveedorRem, pve.tipoProveedorDescripcion, pve.subtipoProveedorDescripcion, pve.nifProveedor, pve.nombreProveedor, pve.nombreComercialProveedor, pve.estadoProveedorDescripcion, pve.observaciones from VBusquedaProveedor pve");

		if (!Checks.esNulo(dto.getCodigo())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.codigoProveedorRem", Long.valueOf(dto.getCodigo()));
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.estadoProveedorCodigo", dto.getEstadoProveedorCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.tipoProveedorCodigo", dto.getTipoProveedorCodigo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "pve.nombreComercialProveedor", dto.getNombreComercialProveedor(), true);
		try {
			if (!Checks.esNulo(dto.getFechaAlta())) {
				Date fechaAlta = DateFormat.toDate(dto.getFechaAlta());
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.fechaAltaProveedor", fechaAlta);
			}
			if (!Checks.esNulo(dto.getFechaBaja())) {
				Date fechaBaja = DateFormat.toDate(dto.getFechaBaja());
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.fechaBajaProveedor", fechaBaja);
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.subtipoProveedorCodigo", dto.getSubtipoProveedorCodigo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "pve.nifProveedor", dto.getNifProveedor(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.tipoPersonaProveedorCodigo", dto.getTipoPersonaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.cartera", dto.getCartera());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "pve.propietarioActivoVinculado", dto.getPropietario(), true);
		// HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.subCartera",
		// dto.getSubCartera());// TODO: falta por definir en la vista

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.provinciaProveedor", dto.getProvinciaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.municipioProveedor", dto.getMunicipioCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.codigoPostalProveedor", dto.getCodigoPostal());

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.nifPersonaContacto", dto.getNifPersonaContacto());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "pve.nombrePersonaContacto", dto.getNombrePersonaContacto(), true);

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.homologadoProveedor", dto.getHomologadoProveedor());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.calificacionProveedor", dto.getCalificacionCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.topProveedor", dto.getTopCodigo());
		
		//HREOS-1964: Los proveedores solo se pueden ver a si mismo en el listado de proveedores
		if(esProveedor){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.idUser", usuarioLogado.getId());
		}
		
		//HREOS-1964: Las gestorias se pueden ver a si misma y a todos los de tipo "entidad" y "administracion"
		if(esGestoria){
			ArrayList<String> codigos = new ArrayList<String>();
			codigos.add("01");
			codigos.add("02");
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "pve.tipoProveedorCodigo", codigos);
		}

		// Tiene que tratarse de la siguiente manera debido a la personalizacion
		// de la query hql.
		Page p = HibernateQueryUtils.page(this, hb, dto);
		List<Object[]> busquedaProveedor = (List<Object[]>) p.getResults();
		List<DtoProveedorFilter> dtoProveedorFilter = new ArrayList<DtoProveedorFilter>();

		for (Object[] busqueda : busquedaProveedor) {
			DtoProveedorFilter nuevoDto = new DtoProveedorFilter();
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "id", busqueda[0]);
				beanUtilNotNull.copyProperty(nuevoDto, "codigo", busqueda[1]);
				beanUtilNotNull.copyProperty(nuevoDto, "tipoProveedorDescripcion", busqueda[2]);
				beanUtilNotNull.copyProperty(nuevoDto, "subtipoProveedorDescripcion", busqueda[3]);
				beanUtilNotNull.copyProperty(nuevoDto, "nifProveedor", busqueda[4]);
				beanUtilNotNull.copyProperty(nuevoDto, "nombreProveedor", busqueda[5]);
				beanUtilNotNull.copyProperty(nuevoDto, "nombreComercialProveedor", busqueda[6]);
				beanUtilNotNull.copyProperty(nuevoDto, "estadoProveedorDescripcion", busqueda[7]);
				beanUtilNotNull.copyProperty(nuevoDto, "observaciones", busqueda[8]);
				beanUtilNotNull.copyProperty(nuevoDto, "totalCount", p.getTotalCount());
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}

			if (!Checks.esNulo(nuevoDto)) {
				dtoProveedorFilter.add(nuevoDto);
			}
		}

		return dtoProveedorFilter;
	}

	@Override
	public List<ActivoProveedor> getProveedoresByNifList(String nif) {

		HQLBuilder hb = new HQLBuilder("from ActivoProveedor pve");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.docIdentificativo", nif);

		List<ActivoProveedor> lista = HibernateQueryUtils.list(this, hb);

		return lista;
	}

	@Override
	public ActivoProveedor getProveedorById(Long id) {
		HQLBuilder hb = new HQLBuilder(" from ActivoProveedor pve");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.id", id);

		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	@Override
	public ActivoProveedor getProveedorByNIFTipoSubtipo(DtoProveedorFilter dtoProveedorFilter) {
		HQLBuilder hb = new HQLBuilder(" from ActivoProveedor pve");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.docIdentificativo", dtoProveedorFilter.getNifProveedor());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.tipoProveedor.tipoEntidadProveedor.codigo",
				dtoProveedorFilter.getTipoProveedorDescripcion());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.tipoProveedor.codigo",
				dtoProveedorFilter.getSubtipoProveedorDescripcion());

		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	@Override
	public Long getNextNumCodigoProveedor() {
		String sql = "SELECT S_PVE_COD_REM.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())
				.longValue();
	}

	@Override
	public List<ActivoProveedor> getMediadorListFiltered(Activo activo, DtoMediador dto) {
		HQLBuilder hb = new HQLBuilder(
				"select proveedor from ActivoProveedor proveedor, EntidadProveedor entidad, ProveedorTerritorial territorial");
		hb.appendWhere("proveedor.id = entidad.proveedor.id and proveedor.id = territorial.proveedor.id");
		if (!Checks.esNulo(activo.getCartera())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "entidad.cartera.codigo", activo.getCartera().getCodigo());
		}
		hb.appendWhere("proveedor.tipoProveedor.codigo = " + DDTipoProveedor.COD_MEDIADOR);
		hb.appendWhere(
				"territorial.provincia.codigo in (select loc.provincia.codigo from Localidad loc where loc.codigo = '"
						+ activo.getMunicipio() + "')");
		hb.appendWhere("proveedor.homologado = 1");

		return HibernateQueryUtils.list(this, hb);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VProveedores> getProveedoresFilteredByTiposTrabajo(String codigosTipoProveedores, String codCartera) {
		HQLBuilder hb = new HQLBuilder(" from VProveedores v");

		hb.appendWhere("v.codigoCartera = " + codCartera);
		hb.appendWhere("v.baja = 0");

		if (!Checks.esNulo(codigosTipoProveedores))
			hb.appendWhere("v.codigoTipoProveedor in (" + codigosTipoProveedores + ")");

		hb.orderBy("v.nombreComercial", HQLBuilder.ORDER_ASC);

		return (List<VProveedores>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> getNombreProveedorByIdUsuario(Long idUsuario) {

		HQLBuilder hb = new HQLBuilder("select pve.nombre from ActivoProveedor pve, ActivoProveedorContacto pvc ");

		hb.appendWhere("pve.id = pvc.proveedor.id");
		hb.appendWhere("pvc.usuario.id = " + idUsuario);

		List<String> listaProveedores = (List<String>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();
		List<String> listaNombres = new ArrayList<String>();
		for (String proveedor : listaProveedores) {
			listaNombres.add("'" + proveedor + "'");
		}

		return listaNombres;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Long> getIdProveedoresByIdUsuario(Long idUsuario) {

		HQLBuilder hb = new HQLBuilder("select pve.id from ActivoProveedor pve, ActivoProveedorContacto pvc ");

		hb.appendWhere("pve.id = pvc.proveedor.id");
		hb.appendWhere("pvc.usuario.id = " + idUsuario);

		return (List<Long>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	}
}
