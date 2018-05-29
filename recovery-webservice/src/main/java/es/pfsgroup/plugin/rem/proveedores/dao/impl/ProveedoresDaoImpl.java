package es.pfsgroup.plugin.rem.proveedores.dao.impl;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.DtoMediador;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.VProveedores;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;

@Repository("ProveedoresDao")
public class ProveedoresDaoImpl extends AbstractEntityDao<ActivoProveedor, Long> implements ProveedoresDao {

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoProveedorFilter> getProveedoresList(DtoProveedorFilter dto, Usuario usuarioLogado, Boolean esProveedor, Boolean esGestoria, Boolean esExterno) {

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
		
		// HREOS-2179: Las gestorias y proveedores tecnicos y de certificacion pueden ver todos los proveedores de tipo "entidad" y "administracion", 
		// y de los de tipo proveedor, unicamente a si mismos.
		if(esGestoria || esProveedor ){			
			hb.appendWhere(" pve.tipoProveedorCodigo in ('"+DDEntidadProveedor.TIPO_ENTIDAD_CODIGO+"','"+DDEntidadProveedor.TIPO_ADMINISTRACION_CODIGO+"') "					
							+ "or (pve.tipoProveedorCodigo = '" + DDEntidadProveedor.TIPO_PROVEEDOR_CODIGO + "' and pve.idUser = "+usuarioLogado.getId()+") ");
		}
		
		// Si es externo pero no es gestoria ni proveedor, es fsv, capa control o consulta, y hay que carterizar en función del tipo de proveedor
		if(esExterno && !esGestoria && !esProveedor) {
			
			hb.appendWhere(" (pve.tipoProveedorCodigo in ('"+DDEntidadProveedor.TIPO_ENTIDAD_CODIGO+"','"+DDEntidadProveedor.TIPO_PROVEEDOR_CODIGO+"') and pve.cartera = '"+dto.getCartera()+"' )"					
					+ "or (pve.tipoProveedorCodigo = '" + DDEntidadProveedor.TIPO_ADMINISTRACION_CODIGO + "')");
		} else {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.cartera", dto.getCartera());
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

		hb.appendWhere("v.codigoCartera = '" + codCartera + "'");
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
	public List<ActivoProveedorContacto> getActivoProveedorContactoPorIdsUsuarioYCartera(List<Long> idUsuarios, Long idCartera) {

		HQLBuilder hb = new HQLBuilder("select pvc from ActivoProveedorContacto pvc, ActivoProveedor pve, EntidadProveedor ep ");

		hb.appendWhere("pve.id = pvc.proveedor.id ");
		hb.appendWhere("pve.id = ep.proveedor.id ");

		StringBuilder builder = new StringBuilder();
		for(Long id : idUsuarios) {
			builder.append(String.valueOf(id));
			builder.append(",");
		}

		if(builder.length() > 0) {
			hb.appendWhere("pvc.usuario.id in (" + builder.toString().substring(0, builder.length()-1) + ")");
		}
		hb.appendWhere("ep.cartera.id = " + idCartera);

		List<ActivoProveedorContacto> listaProveedoresContacto = (List<ActivoProveedorContacto>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();

		return listaProveedoresContacto;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public ActivoProveedorContacto getActivoProveedorContactoPorIdsUsuario(Long idUsuario) {

		HQLBuilder hb = new HQLBuilder("from ActivoProveedorContacto pvc");
		hb.appendWhere("pvc.usuario.id = " + idUsuario);
		hb.appendWhere("pvc.fechaBaja IS NULL");
		hb.appendWhere("pvc.auditoria.borrado = 0");
		
		List<ActivoProveedorContacto> listaProveedoresContacto = (List<ActivoProveedorContacto>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		
		if(!listaProveedoresContacto.isEmpty()){
			return listaProveedoresContacto.get(0);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Long> getIdProveedoresByIdUsuario(Long idUsuario) {

		HQLBuilder hb = new HQLBuilder("select pve.id from ActivoProveedor pve, ActivoProveedorContacto pvc ");

		hb.appendWhere("pve.id = pvc.proveedor.id");
		hb.appendWhere("pvc.usuario.id = " + idUsuario);

		return (List<Long>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public  List<DDTipoProveedor> getSubtiposProveedorByCodigos(List<String> codigos) {

		HQLBuilder hb = new HQLBuilder("from DDTipoProveedor tpr ");		
		hb.appendWhereIN("tpr.codigo",  codigos.toArray(new String[codigos.size()]));


		return this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	}
	
	@Override
	public Long activosAsignadosProveedorMediador(Long idProveedor){
		
		try {

			HQLBuilder hb = new HQLBuilder(
					"select count(*) from ActivoInfoComercial where mediadorInforme.id = "+idProveedor);
			return ((Long) getHibernateTemplate().find(hb.toString()).get(0));

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	
	
	
}
