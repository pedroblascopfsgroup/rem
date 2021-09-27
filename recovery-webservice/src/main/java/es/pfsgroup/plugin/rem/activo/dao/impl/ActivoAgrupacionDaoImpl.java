package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.AgrupacionesVigencias;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionGridFilter;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.model.DtoVigenciaAgrupacion;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Repository("ActivoAgrupacionDao")
public class ActivoAgrupacionDaoImpl extends AbstractEntityDao<ActivoAgrupacion, Long> implements ActivoAgrupacionDao {

	@Resource
	private PaginationManager paginationManager;
	
	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionDao;
	
	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public Page getListAgrupaciones(DtoAgrupacionFilter dto, Usuario usuLogado) {
		String from = " select distinct agr from VBusquedaAgrupaciones agr";
		boolean activos = dto.getNif() != null || dto.getSubcarteraCodigo() != null || dto.getNumActHaya() != null
				|| dto.getNumActPrinex() != null || dto.getNumActReco() != null || dto.getNumActSareb() != null
				|| dto.getNumActUVEM() != null;
		
		
		
		if (activos) {
			from = from + ActivoAgrupacionHqlHelper.getFromActivos();
		}

		if (dto.getNif() != null) {
			from = from + ActivoAgrupacionHqlHelper.getFromPropietarios();
		}

		HQLBuilder hb = new HQLBuilder(from);
		if (activos) {
			hb.appendWhere("agr.id = aaa.agrupacion.id");
			hb.appendWhere("ac.id = aaa.activo.id");

		}

		if (dto.getNif() != null) {
			hb.appendWhere("ap.id = apa.propietario.id");
			hb.appendWhere("ac.id = apa.activo.id");
		}

		HQLBuilder.addFiltroLikeSiNotNull(hb, "agr.nombre", dto.getNombre(), true);
		// HQLBuilder.addFiltroLikeSiNotNull(hb, "agr.publicado",
		// dto.getPublicado(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.tipoAgrupacion.codigo", dto.getTipoAgrupacion());

		if(dto.getTipoAlquiler() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.codTipoAlquiler", dto.getTipoAlquiler());
		}

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.numAgrupacionRem", dto.getNumAgrupacionRem());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.cartera", dto.getCodCartera());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.provincia.codigo", dto.getCodProvincia());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "agr.localidad.descripcion", dto.getLocalidadDescripcion(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.numAgrupacionUvem", dto.getNumAgrUVEM());
		if (dto.getAgrupacionId() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.id", Long.valueOf(dto.getAgrupacionId()));
		}

		try {

			if (dto.getFechaCreacionDesde() != null) {
				Date fechaDesde = DateFormat.toDate(dto.getFechaCreacionDesde());
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "agr.fechaAlta", fechaDesde, null);
			}

			if (dto.getFechaCreacionHasta() != null) {
				Date fechaHasta = DateFormat.toDate(dto.getFechaCreacionHasta());

				// Se le añade un día para que encuentre las fechas del día
				// anterior hasta las 23:59
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(fechaHasta); // Configuramos la fecha que se
												// recibe
				calendar.add(Calendar.DAY_OF_YEAR, 1); // numero de días a
														// añadir, o restar en
														// caso de días<0

				HQLBuilder.addFiltroBetweenSiNotNull(hb, "agr.fechaAlta", null, calendar.getTime());
			}

		} catch (ParseException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {

			if (dto.getFechaInicioVigenciaDesde() != null) {
				Date fechaInicioVigenciaDesde = DateFormat.toDate(dto.getFechaInicioVigenciaDesde()); // aqui
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "agr.fechaInicioVigencia", fechaInicioVigenciaDesde, null);
			}

			if (dto.getFechaInicioVigenciaHasta() != null) {
				Date fechaInicioVigenciaHasta = DateFormat.toDate(dto.getFechaInicioVigenciaHasta());

				// Se le añade un día para que encuentre las fechas del día
				// anterior hasta las 23:59
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(fechaInicioVigenciaHasta); // Configuramos la
															// fecha que se
															// recibe
				calendar.add(Calendar.DAY_OF_YEAR, 1); // numero de días a
														// añadir, o restar en
														// caso de días<0

				HQLBuilder.addFiltroBetweenSiNotNull(hb, "agr.fechaInicioVigencia", null, calendar.getTime());
			}

		} catch (ParseException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {

			if (dto.getFechaFinVigenciaDesde() != null) {
				Date fechaFinVigenciaDesde = DateFormat.toDate(dto.getFechaFinVigenciaDesde()); // aqui
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "agr.fechaFinVigencia", fechaFinVigenciaDesde, null);
			}

			if (dto.getFechaFinVigenciaHasta() != null) {
				Date fechaFinVigenciaHasta = DateFormat.toDate(dto.getFechaFinVigenciaHasta());

				// Se le añade un día para que encuentre las fechas del día
				// anterior hasta las 23:59
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(fechaFinVigenciaHasta); // Configuramos la
															// fecha que se
															// recibe
				calendar.add(Calendar.DAY_OF_YEAR, 1); // numero de días a
														// añadir, o restar en
														// caso de días<0

				HQLBuilder.addFiltroBetweenSiNotNull(hb, "agr.fechaFinVigencia", null, calendar.getTime());
			}

		} catch (ParseException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (dto.getNumActHaya() != null) {
			hb.appendWhere(ActivoAgrupacionHqlHelper.getWhereAndNumActHaya(dto.getNumActHaya()));
		}

		if (dto.getNumActUVEM() != null) {
			hb.appendWhere(ActivoAgrupacionHqlHelper.getWhereAndNumActUvem(dto.getNumActUVEM()));
		}

		if (dto.getNumActSareb() != null) {
			hb.appendWhere(ActivoAgrupacionHqlHelper.getWhereAndNumActSareb(dto.getNumActSareb()));
		}

		if (dto.getNumActPrinex() != null) {
			hb.appendWhere(ActivoAgrupacionHqlHelper.getWhereAndNumActPrinex(dto.getNumActPrinex()));
		}

		if (dto.getNumActReco() != null) {
			hb.appendWhere(ActivoAgrupacionHqlHelper.getWhereAndNumActRecovery(dto.getNumActReco()));
		}

		if (dto.getSubcarteraCodigo() != null) {
			hb.appendWhere(ActivoAgrupacionHqlHelper.getWhereAndSubcarteraCodigo(dto.getSubcarteraCodigo()));
		}

		if (dto.getNif() != null) {
			hb.appendWhere(ActivoAgrupacionHqlHelper.getWhereAndNif(dto.getNif()));
		}

		return HibernateQueryUtils.page(this, hb, dto);

	}

	@Override
	public Page getListActivosAgrupacionById(DtoAgrupacionFilter dto, Usuario usuLogado,Boolean little) {

		HQLBuilder hb = new HQLBuilder(" from VActivosAgrupacion aga");
		
		if(little){
			hb = new HQLBuilder(" from VActivosAgrupacionLil aga");
		}
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(Long.valueOf(dto.getAgrupacionId()));
		

		if (dto.getAgrupacionId() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aga.agrId", Long.valueOf(dto.getAgrupacionId()));

		} 
		
		
		if(DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aga.activoMatriz", 0);
		}
		

		if(!little){
			if (dto.getSort() == null || dto.getSort().isEmpty()) {
				hb.orderBy("activoPrincipal", HQLBuilder.ORDER_DESC);
			}
		}else{
			hb.orderBy("numActivo", HQLBuilder.ORDER_DESC);
		}

		return HibernateQueryUtils.page(this, hb, dto);

	}

	public Long getNextNumAgrupacionRemManual() {
		String sql = "SELECT S_AGR_NUM_AGRUP_REM.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())
				.longValue();
	}

	@Override
	public Long getAgrupacionIdByNumAgrupRem(Long numAgrupRem) {
		try {
			HQLBuilder hb = new HQLBuilder(
					"select agr.id from ActivoAgrupacion agr where agr.numAgrupRem = :numAgrupRem");
			return (Long) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).setParameter("numAgrupRem", numAgrupRem).uniqueResult();

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public Long haveActivoPrincipal(Long id) {

		try {
			HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act");
			hb.appendWhere("act.principal = 1");
			hb.appendWhere("act.agrupacion.id = :agrupacionId");
			
			return (Long) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).setParameter("agrupacionId", id).uniqueResult();

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	;
	
	@Override
	public Long haveActivoRestringidaAndObraNueva(Long id) {

		try {

			HQLBuilder hb = new HQLBuilder("select count( distinct act.agrupacion.tipoAgrupacion.id ) from ActivoAgrupacionActivo act");
			hb.appendWhere("act.activo.id in ( select distinct (agru.activo.id) from ActivoAgrupacionActivo agru where agru.agrupacion.id = :agrupacionId)");
			Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
			q.setParameter("agrupacionId", id);
			return (Long) q.uniqueResult();

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoFoto> getFotosActivosAgrupacionById(Long id) {

		Query q = null;
		
		try {

			HQLBuilder hb = new HQLBuilder(
					"from ActivoFoto foto where foto.tipoFoto.codigo = '01' AND foto.activo.id in "
							+ " ( select distinct(agru.agrupacion.activoPrincipal) from ActivoAgrupacionActivo agru where agru.agrupacion.id = :agrupacionId) order by foto.activo.id desc ");

			q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
			q.setParameter("agrupacionId", id);
			List<ActivoFoto> listaPrincipal = (List<ActivoFoto>) q.list();
			
			

			HQLBuilder hbDos = new HQLBuilder(
					"from ActivoFoto foto where foto.tipoFoto.codigo = '01' AND  foto.activo.id in "
							+ " ( select distinct(agru.activo.id) from ActivoAgrupacionActivo agru where agru.agrupacion.id = :agrupacionId"
							+ " and agru.agrupacion.activoPrincipal != foto.activo.id) order by foto.activo.id desc ");

			q = this.getSessionFactory().getCurrentSession().createQuery(hbDos.toString());
			q.setParameter("agrupacionId", id);
			List<ActivoFoto> listaResto = (List<ActivoFoto>) q.list();

			if (listaPrincipal != null && !listaPrincipal.isEmpty()) {
				listaPrincipal.addAll(listaResto);
				return listaPrincipal;
			} else {
				return listaResto;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	@Override
	public Page getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter) {

		HQLBuilder hb = new HQLBuilder(" from VSubdivisionesAgrupacion subagr");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "subagr.agrupacionId", agrupacionFilter.getAgrId());

		return HibernateQueryUtils.page(this, hb, agrupacionFilter);
	}

	@Override
	public Page getListActivosSubdivisionById(DtoSubdivisiones subdivision) {

		HQLBuilder hb = new HQLBuilder(" from VActivosSubdivision actsub");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "actsub.idSubdivision", subdivision.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "actsub.agrupacionId", subdivision.getAgrId());

		return HibernateQueryUtils.page(this, hb, subdivision);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Long getIdSubdivisionByIdActivo(Long idActivo) {
		
		Long idSubdivision = null;
		
		try {
			HQLBuilder hb = new HQLBuilder("select distinct actsub.idSubdivision from VActivosSubdivision actsub where actsub.activoId = :idActivo");
			
			Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
			q.setParameter("idActivo", idActivo);

			List<Long> lista = (List<Long>) q.list();
			
			if (!Checks.estaVacio(lista)) {
				idSubdivision = lista.get(0);
			}
			
			return idSubdivision;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<Long> getListIdActivoByIdSubdivisionAndIdsAgrupacion(Long idSubdivision, String idsAgrupacion) {

		List<Long> idsAgrupacionList = new ArrayList<Long>();
		
		try {

			HQLBuilder hb = new HQLBuilder("select actsub.activoId from VActivosSubdivision actsub where actsub.idSubdivision = :idSubdivision" +
											" and actsub.agrupacionId in (:idsAgr)");
			
			Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
			
			for (String s : (List<String>)Arrays.asList(idsAgrupacion.split(","))) {
				try {
					idsAgrupacionList.add(Long.parseLong(s));
				} catch (Exception e) {
					logger.error(e);
				}
				
			}
			q.setParameter("idSubdivision", idSubdivision);
			q.setParameterList("idsAgr",idsAgrupacionList);
	
			return (List<Long>) q.list();
		
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoFoto> getFotosSubdivision(DtoSubdivisiones subdivision) {

		List<ActivoFoto> lista = null;

		try {

			HQLBuilder hb = new HQLBuilder("from ActivoFoto foto where foto.subdivision = :subdivisionId and foto.agrupacion.id = :agrupacionId order by foto.orden");

			Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
			q.setParameter("subdivisionId", subdivision.getId());
			q.setParameter("agrupacionId", subdivision.getAgrId());
			
			lista = (List<ActivoFoto>) q.list();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return lista;

	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoFoto> getFotosAgrupacionById(Long id) {

		List<ActivoFoto> lista = null;

		try {
			
			ActivoAgrupacion agr = this.get(id);
			if(!Checks.esNulo(agr.getTipoAgrupacion()) && DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER.equals(agr.getTipoAgrupacion().getCodigo())) {
				Activo am = activoAgrupacionDao.getActivoMatrizByIdAgrupacion(id);
				lista = am.getFotos();
			} else {
				HQLBuilder hb = new HQLBuilder(
						"from ActivoFoto foto where foto.agrupacion.id = :fotoAgrId and foto.subdivision is null");

				
				Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
				q.setParameter("fotoAgrId", id);
				
				lista = (List<ActivoFoto>) q.list();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return lista;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<AgrupacionesVigencias> getHistoricoVigenciasAgrupacionById(DtoVigenciaAgrupacion agrupacionFilter) {
		HQLBuilder hb = new HQLBuilder(
				" from AgrupacionesVigencias vigencia where vigencia.agrupacion.id = :agrId");
		hb.orderBy("vigencia.auditoria.fechaCrear", HQLBuilder.ORDER_DESC);

		Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		q.setParameter("agrId", agrupacionFilter.getAgrId());
		
		return (List<AgrupacionesVigencias>) q.list();

	}

	@SuppressWarnings("unchecked")
	@Override
	public Boolean estaActivoEnOtraAgrupacionVigente(ActivoAgrupacion agrupacion, Activo activo) {
		String activos = "(";
		Boolean resultado = false;
		List<Long> activosList = new ArrayList<Long>();
		int contActivos = 0;
		// si pasamos el parametro activo buscamos solo en ese
		if (activo != null) {
			activosList.add(activo.getId());
		} else {
			if (agrupacion.getActivos() != null && agrupacion.getActivos().size() > 0) {
				for (int i = 0; i < agrupacion.getActivos().size(); i++) {
					Activo aux = agrupacion.getActivos().get(i).getActivo();
					activosList.add(aux.getId());
				}
			}
		}

		if (activosList.size() > 0) {
			HQLBuilder hb = new HQLBuilder(
					"from ActivoAgrupacionActivo agrActivo where agrActivo.auditoria.borrado != 1 and agrActivo.activo.id in (:activoList)"
					+ " and agrActivo.agrupacion.id != :agrId"
					+ " and agrActivo.agrupacion.fechaFinVigencia >= sysdate and agrActivo.agrupacion.fechaBaja is null");
			
			Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
			q.setParameterList("activoList", activosList);
			q.setLong("agrId", agrupacion.getId());

			List<ActivoAgrupacionActivo> agrActivoList = (List<ActivoAgrupacionActivo>) q.list();

			if (agrActivoList != null && agrActivoList.size() > 0) {
				resultado = true;
			}
		}

		return resultado;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Double getPorcentajeParticipacionUATotalDeUnAMById(Long id) {
		Double porcentajeUAs = 0.00;
		try {
			HQLBuilder hb = new HQLBuilder("SELECT SUM(participacionUA) FROM ActivoAgrupacionActivo AGA WHERE AGA.agrupacion.id = :agrId AND AGA.principal = 0");
			
			Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
			q.setLong("agrId", id);

			List<Double> listPorcentajeUAs = (List<Double>) q.list();
			
			if (!Checks.estaVacio(listPorcentajeUAs)) {
				porcentajeUAs = listPorcentajeUAs.get(0);
			}
			
			return porcentajeUAs;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public ActivoAgrupacion getAgrupacionById(Long idAgrupacion) {
		if(!Checks.esNulo(idAgrupacion)) {
			HQLBuilder hb = new HQLBuilder("from ActivoAgrupacion agr");
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "id", idAgrupacion);
	
			return HibernateQueryUtils.uniqueResult(this, hb);
		}
		return null;
	}
	
	@Override
	public Page getBusquedaAgrupacionesGrid(DtoAgrupacionGridFilter dto, Long usuarioId) {		
		List<UsuarioCartera> usuarioCartera = genericDao.getList(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioId));
		List<String> subcarteras = new ArrayList<String>();
		
		HQLBuilder hb = new HQLBuilder("select vgrid from VGridBusquedaAgrupaciones vgrid ");
		
		if (usuarioCartera != null && !usuarioCartera.isEmpty()) {
			dto.setCarteraCodigo(usuarioCartera.get(0).getCartera().getCodigo());
			
			if (dto.getSubcarteraCodigo() == null) {
				for (UsuarioCartera usu : usuarioCartera) {
					if (usu.getSubCartera() != null) {
						subcarteras.add(usu.getSubCartera().getCodigo());
					}
				}
			}
		}
		
		if (dto.getNumAgrupacionRem() != null && StringUtils.isNumeric(dto.getNumAgrupacionRem()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numAgrupacionRem", Long.valueOf(dto.getNumAgrupacionRem()));
		if (dto.getNumAgrupacionUvem() != null && StringUtils.isNumeric(dto.getNumAgrupacionUvem()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numAgrupacionUvem", Long.valueOf(dto.getNumAgrupacionUvem()));
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.carteraCodigo", dto.getCarteraCodigo());	
		if (subcarteras != null && !subcarteras.isEmpty()) {
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "vgrid.subcarteraCodigo", subcarteras);
		} else {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.subcarteraCodigo", dto.getSubcarteraCodigo());
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoAgrupacionCodigo", dto.getTipoAgrupacionCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoAlquilerCodigo", dto.getTipoAlquilerCodigo());
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.nombre", dto.getNombre(), true);		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.publicado", dto.getPublicado());		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.provinciaCodigo", dto.getProvinciaCodigo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.localidadDescripcion", dto.getLocalidadDescripcion(), true);
		
		if(dto.getNumActHaya() != null || dto.getNumActPrinex() != null || dto.getNumActSareb() != null 
				|| dto.getNumActUVEM() != null || dto.getNumActReco() != null) {			
			StringBuilder sb = new StringBuilder(" exists (select 1 from ActivoAgrupacionActivo aga "
					+ " where vgrid.id = aga.agrupacion.id ");
			if(dto.getNumActHaya() != null && StringUtils.isNumeric(dto.getNumActHaya())) {
				sb.append(" and aga.activo.numActivo = :numActHaya");
			    hb.getParameters().put("numActHaya", dto.getNumActHaya());
			}
			if(dto.getNumActPrinex() != null && StringUtils.isNumeric(dto.getNumActPrinex())) {
				sb.append(" and aga.activo.idProp = :numActPrinex");
				hb.getParameters().put("numActPrinex", dto.getNumActPrinex());
			}
			if(dto.getNumActSareb() != null) {
				sb.append(" and aga.activo.idSareb = :numActSareb");
				hb.getParameters().put("numActSareb", dto.getNumActSareb());
			}
			if(dto.getNumActUVEM() != null && StringUtils.isNumeric(dto.getNumActUVEM())) {
				sb.append(" and aga.activo.numActivoUvem = :numActUVEM");
				hb.getParameters().put("numActUVEM", dto.getNumActUVEM());
			}
			if(dto.getNumActReco() != null && StringUtils.isNumeric(dto.getNumActReco())) {
				sb.append(" and aga.activo.idRecovery = :numActReco");
				hb.getParameters().put("numActReco", dto.getNumActReco());
			}
			sb.append("  ) ");
			hb.appendWhere(sb.toString());
   		}
		
		if(dto.getNif() != null) {
			hb.appendWhere(" exists (select 1 from ActivoPropietarioActivo apa where apa.propietario.docIdentificativo = :nif "
					+ " and apa.activo.id IN (select actag.activo.id from ActivoAgrupacionActivo actag where vgrid.id = actag.agrupacion.id) ) ");
			hb.getParameters().put("nif", dto.getNif());
		}

			
		
		try {				
				Date fechaCreacionDesde = dto.getFechaCreacionDesde() != null ? DateFormat.toDate(dto.getFechaCreacionDesde()) : null;
				Date fechaCreacionHasta = dto.getFechaCreacionHasta() != null ? DateFormat.toDate(dto.getFechaCreacionHasta()) : null;			
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaAlta", fechaCreacionDesde, fechaCreacionHasta);
				
				Date fechaInicioVigenciaDesde = dto.getFechaInicioVigenciaDesde() != null ? DateFormat.toDate(dto.getFechaInicioVigenciaDesde()) : null;
				Date fechaInicioVigenciaHasta = dto.getFechaInicioVigenciaHasta() != null ? DateFormat.toDate(dto.getFechaInicioVigenciaHasta()) : null;			
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaInicioVigencia", fechaInicioVigenciaDesde, fechaInicioVigenciaHasta);
				
				Date fechaFinVigenciaDesde = dto.getFechaFinVigenciaDesde() != null ? DateFormat.toDate(dto.getFechaFinVigenciaDesde()) : null;
				Date fechaFinVigenciaHasta = dto.getFechaFinVigenciaHasta() != null ? DateFormat.toDate(dto.getFechaFinVigenciaHasta()) : null;			
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaFinVigencia", fechaFinVigenciaDesde, fechaFinVigenciaHasta);				

		} catch (ParseException e) {
			logger.error(e.getMessage());
			}
		
		return HibernateQueryUtils.page(this, hb, dto);		
	}
	
	public Long getIdByNumAgrupacion(Long numAgrupacion) {
				
			Long idAgrupacion = null;
				
			try {
			idAgrupacion = Long.parseLong(rawDao.getExecuteSQL("SELECT AGR_ID FROM ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM = " + numAgrupacion + " AND BORRADO = 0"));
			} catch (Exception e) {
				return null;
			}
			return idAgrupacion;
		}

}
