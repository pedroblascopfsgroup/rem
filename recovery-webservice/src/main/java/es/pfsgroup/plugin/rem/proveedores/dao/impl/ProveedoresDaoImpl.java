package es.pfsgroup.plugin.rem.proveedores.dao.impl;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.DtoMediador;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VProveedores;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;

@Repository("ProveedoresDao")
public class ProveedoresDaoImpl extends AbstractEntityDao<ActivoProveedor, Long> implements ProveedoresDao {

	@Autowired
	private GenericABMDao genericDao;
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoProveedorFilter> getProveedoresList(DtoProveedorFilter dto, Usuario usuarioLogado, Boolean esProveedor, Boolean esGestoria, Boolean esExterno) {
		List<UsuarioCartera> usuarioCartera = genericDao.getList(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));	
		String select = "select distinct pve.id, pve.codigoProveedorRem, pve.tipoProveedorDescripcion, pve.subtipoProveedorDescripcion, pve.nifProveedor, pve.nombreProveedor, pve.nombreComercialProveedor, pve.estadoProveedorDescripcion, pve.observaciones";
		String from = " from VBusquedaProveedor pve";		
		String where = "";
		Boolean haswhere = false;
		
		if(!Checks.esNulo(dto.getLineaNegocioCodigo())) {
			from += ",DDTipoComercializacion tco";
			where += " where tco.id = pve.idLineaNegocio";
			haswhere = true;
		}
		if(!Checks.esNulo(dto.getEspecialidadCodigo())) {
			from += ",ProveedorEspecialidad pveEsp, DDEspecialidad esp";
			where += (haswhere ? " and " : " where ");
			where += "pveEsp.proveedor.id = pve.id and pveEsp.especialidad.id = esp.id";
			haswhere = true;
		}
			
		HQLBuilder hb = new HQLBuilder(select + from + where);
		if (haswhere) hb.setHasWhere(true);

		if (usuarioCartera != null && !usuarioCartera.isEmpty()) {
			dto.setCartera(usuarioCartera.get(0).getCartera().getCodigo());
					
		}
		
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
							+ "or (pve.tipoProveedorCodigo = '" + DDEntidadProveedor.TIPO_PROVEEDOR_CODIGO + "' and pve.idUser = :usuarioLogadoId) ");
			hb.getParameters().put("usuarioLogadoId", usuarioLogado.getId());
		}
		
		// Si es externo pero no es gestoria ni proveedor, es fsv, capa control o consulta, y hay que carterizar en función del tipo de proveedor
		if(esExterno && !esGestoria && !esProveedor) {
			
			hb.appendWhere(" (pve.tipoProveedorCodigo in ('"+DDEntidadProveedor.TIPO_ENTIDAD_CODIGO+"','"+DDEntidadProveedor.TIPO_PROVEEDOR_CODIGO+"') and pve.cartera = :cartera )"					
					+ "or (pve.tipoProveedorCodigo = '" + DDEntidadProveedor.TIPO_ADMINISTRACION_CODIGO + "')");
			hb.getParameters().put("cartera", dto.getCartera());
		} else {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.cartera", dto.getCartera());
		}
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "pve.nombreProveedor", dto.getNombre(), true);
		
		if(!Checks.esNulo(dto.getLineaNegocioCodigo())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tco.codigo", dto.getLineaNegocioCodigo());		
		}
		if(!Checks.esNulo(dto.getEspecialidadCodigo())) {
			this.addFiltroWhereInSiNotNullConStrings(hb, "esp.codigo", Arrays.asList(dto.getEspecialidadCodigo().split(",")));
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
	
	private void addFiltroWhereInSiNotNullConStrings(HQLBuilder hb, String nombreCampo, List<String> valores) {
        if (!Checks.estaVacio(valores)) {
            final StringBuilder b = new StringBuilder();
            boolean first = true;
            for (String s : valores) {
                if (!first) {
                    b.append(", ");
                } else {
                    first = false;
                }
                b.append("'" + s + "'");
            }
            hb.appendWhere(nombreCampo.concat(" in (").concat(b.toString()).concat(")"));
        }
        
    }

	@Override
	public List<ActivoProveedor> getProveedoresByNifList(String nif) {

		HQLBuilder hb = new HQLBuilder("from ActivoProveedor pve");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.docIdentificativo", nif);
		hb.appendWhere("pve.auditoria.borrado = 0 ");
		hb.appendWhere("pve.fechaBaja IS NULL ");

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
				"territorial.provincia.codigo in (select loc.provincia.codigo from Localidad loc where loc.codigo = :activoMunicipio)");
		hb.getParameters().put("activoMunicipio",activo.getMunicipio());
		
		hb.appendWhere("proveedor.homologado = 1");

		return HibernateQueryUtils.list(this, hb);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VProveedores> getProveedoresFilteredByTiposTrabajo(String codigosTipoProveedores, String codCartera) {
		HQLBuilder hb = new HQLBuilder(" from VProveedores v");

		HQLBuilder.addFiltroIgualQue(hb, "v.codigoCartera", codCartera);
		hb.appendWhere("v.baja = 0");

		if (!Checks.esNulo(codigosTipoProveedores))
			hb.appendWhere("v.codigoTipoProveedor in ( :codigosTipoProveedores )");

		hb.orderBy("v.nombreComercial", HQLBuilder.ORDER_ASC);
		
		Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		
		if(codigosTipoProveedores != null) {
			q.setParameterList("codigosTipoProveedores", Arrays.asList(codigosTipoProveedores.split(",")));
		}
		
		return (List<VProveedores>) q.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> getNombreProveedorByIdUsuario(Long idUsuario) {

		HQLBuilder hb = new HQLBuilder("select pve.nombre from ActivoProveedor pve, ActivoProveedorContacto pvc ");

		hb.appendWhere("pve.id = pvc.proveedor.id");
		hb.appendWhere("pvc.usuario.id = :usuarioId");

		List<String> listaProveedores = (List<String>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).setParameter("usuarioId", idUsuario).list();
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

	/*	StringBuilder builder = new StringBuilder();
		for(Long id : idUsuarios) {
			builder.append(String.valueOf(id));
			builder.append(",");
		}

	 */
		if(idUsuarios.size() > 0) {
			hb.appendWhere("pvc.usuario.id in ( :usuarioIds )");
		}
		hb.appendWhere("ep.cartera.id = :idCartera");
				
		if(idUsuarios.size() > 0) {
			hb.appendWhere("pvc.usuario.id in ( :usuarioIds )");
		}
		

		List<ActivoProveedorContacto> listaProveedoresContacto = (List<ActivoProveedorContacto>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).setParameterList("usuarioIds", idUsuarios).setParameter("idCartera", idCartera).list();

		return listaProveedoresContacto;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public ActivoProveedorContacto getActivoProveedorContactoPorIdsUsuario(Long idUsuario) {

		HQLBuilder hb = new HQLBuilder("select pvc from ActivoProveedorContacto pvc, ActivoProveedor pve ");
		hb.appendWhere("pve.id = pvc.proveedor.id ");
		hb.appendWhere("pvc.usuario.id = :idUsuario");
		hb.appendWhere("pve.fechaBaja IS NULL ");
		hb.appendWhere("pvc.fechaBaja IS NULL ");
		hb.appendWhere("pvc.auditoria.borrado = 0 ");
		
		List<ActivoProveedorContacto> listaProveedoresContacto = (List<ActivoProveedorContacto>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).setParameter("idUsuario", idUsuario).list();
		
		if(!listaProveedoresContacto.isEmpty()){
			return listaProveedoresContacto.get(0);
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public ActivoProveedorContacto getActivoProveedorContactoPorUsernameUsuario(String username) {

		HQLBuilder hb = new HQLBuilder("from ActivoProveedorContacto pvc");
		hb.appendWhere("pvc.usuario.username = :userName");
		hb.appendWhere("pvc.fechaBaja IS NULL");
		hb.appendWhere("pvc.auditoria.borrado = 0");
		
		List<ActivoProveedorContacto> listaProveedoresContacto = (List<ActivoProveedorContacto>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).setParameter("userName", username).list();
		
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
		hb.appendWhere("pvc.usuario.id = :idUsuario");

		return (List<Long>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).setParameter("idUsuario", idUsuario).list();
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
					"select count(*) from ActivoInfoComercial ico, PerimetroActivo pac ");
			hb.appendWhere("ico.activo.id = pac.activo.id");
			hb.appendWhere("ico.activo.situacionComercial.codigo not in ('05','06')");
			hb.appendWhere("pac.incluidoEnPerimetro = 1");
			hb.appendWhere("ico.mediadorInforme.id = :idProveedor");
			
			
			return (Long) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).setParameter("idProveedor", idProveedor).uniqueResult();

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public BigDecimal activosAsignadosNoVendidosNoTraspasadoProveedorTecnico(Long idProveedor) {
		
		BigDecimal count = new BigDecimal("0");
		
		String queryString = "SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR PVE "
				+ " INNER JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.PVE_ID_EMISOR = PVE.PVE_ID "
                + " INNER JOIN GLD_GASTOS_LINEA_DETALLE GLD ON GPV.GPV_ID = GLD.GPV_ID "
                + " INNER JOIN GLD_TBJ TBJ ON TBJ.GLD_ID = GLD.GLD_ID "
                + " INNER JOIN GLD_ENT ENT ON ENT.GLD_ID = TBJ.GLD_ID "               
                + " INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = ENT.ENT_ID AND ACT.BORRADO = 0 " 
				+ " INNER JOIN DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO NOT IN ('05', '06') "
				+ " WHERE PVE.PVE_ID = :idProveedor"
				+ " AND ENT.DD_ENT_ID = (SELECT DD_ENT_ID FROM DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO ='ACT')";
		
		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory()
				.getCurrentSession().createSQLQuery(queryString);
		sqlQuery.setParameter("idProveedor", idProveedor);
		
		final Object obj = sqlQuery.uniqueResult();
        if (obj != null) {
            count = (BigDecimal) obj;
        }
		
								
		return count;
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Long> getIdsProveedorByIdUsuario(Long idUsuario) {
		HQLBuilder hb = new HQLBuilder("select pve.id from ActivoProveedor pve, ActivoProveedorContacto pvc ");

		hb.appendWhere("pve.id = pvc.proveedor.id");
		hb.appendWhere("pvc.usuario.id = :idUsuario");

		List<Long> listaProveedores = (List<Long>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).setParameter("idUsuario", idUsuario).list();
		return listaProveedores;
	}
	
	@Override
	public List<ActivoProveedor> getMediadoresActivos() {
		HQLBuilder hb = new HQLBuilder(
				"select proveedor.id, proveedor.codigoProveedorRem, proveedor.nombre from ActivoProveedor proveedor");
		hb.appendWhere("(proveedor.tipoProveedor.codigo =" + DDTipoProveedor.COD_MEDIADOR +" and proveedor.homologado = 1) "
				+ "or (proveedor.tipoProveedor.codigo =" + DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA + " and proveedor.estadoProveedor.codigo = " + DDEstadoProveedor.ESTADO_BIGENTE + ") "
				+ "and proveedor.fechaBaja != null");
		
		return HibernateQueryUtils.list(this, hb);
	}
	
	@Override
	public Boolean cambiaMediador(Long nActivo, String pveCodRem, String userName) {
		String procedureHQL = "BEGIN CAMBIO_MEDIADOR(:idActivoParam, :pveCodRemParam, :userNameParam, :outputParam);  END;";
		String output="";
		Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
		callProcedureSql.setParameter("idActivoParam", nActivo);
		callProcedureSql.setParameter("pveCodRemParam", pveCodRem);
		callProcedureSql.setParameter("userNameParam", userName);
		callProcedureSql.setParameter("outputParam", output);
		int resultado = callProcedureSql.executeUpdate();

		return resultado == 1;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<VProveedores> getProveedoresCarterizados(String codCartera) {
		HQLBuilder hb = new HQLBuilder(" from VProveedores v");

		hb.appendWhere("v.codigoCartera = :codCartera");
		hb.appendWhere("v.baja = 0");

		hb.orderBy("v.nombreComercial", HQLBuilder.ORDER_ASC);

		return (List<VProveedores>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).setParameter("codCartera", codCartera).list();
	}
}
