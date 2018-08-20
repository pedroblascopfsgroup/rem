package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.AgrupacionesVigencias;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.model.DtoVigenciaAgrupacion;

@Repository("ActivoAgrupacionDao")
public class ActivoAgrupacionDaoImpl extends AbstractEntityDao<ActivoAgrupacion, Long> implements ActivoAgrupacionDao {

	@Resource
	private PaginationManager paginationManager;

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
	public Page getListActivosAgrupacionById(DtoAgrupacionFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(" from VActivosAgrupacion agr");

		if (dto.getAgrupacionId() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.agrId", Long.valueOf(dto.getAgrupacionId()));
		}

		if (dto.getSort() == null || dto.getSort().isEmpty()) {
			hb.orderBy("activoPrincipal", HQLBuilder.ORDER_DESC);
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
					"select agr.id from ActivoAgrupacion agr where agr.numAgrupRem = " + numAgrupRem + " ");
			return ((Long) getHibernateTemplate().find(hb.toString()).get(0));

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public Long haveActivoPrincipal(Long id) {

		try {
			HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act where act.agrupacion.id = "
					+ id + " and act.principal = " + 1);
			return ((Long) getHibernateTemplate().find(hb.toString()).get(0));

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	@Override
	public Long haveActivoRestringidaAndObraNueva(Long id) {

		try {

			HQLBuilder hb = new HQLBuilder(
					"select count( distinct act.agrupacion.tipoAgrupacion.id ) from ActivoAgrupacionActivo act where act.activo.id in "
							+ " ( select distinct (agru.activo.id) from ActivoAgrupacionActivo agru where agru.agrupacion.id = "
							+ id + ")");
			return ((Long) getHibernateTemplate().find(hb.toString()).get(0));

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	/*
	 * @Override public void
	 * deleteActivoPrincipalByIdActivoAgrupacionActivo(Long id) {
	 * 
	 * try {
	 * 
	 * HQLBuilder hb = new HQLBuilder(
	 * "update ActivoAgrupacion set activoPrincipal = null where activoPrincipal = (select activo from ActivoAgrupacionActivo where id = "
	 * + id + ")");
	 * 
	 * Query queryUpdate = this.getSession().createQuery(hb.toString());
	 * 
	 * queryUpdate.executeUpdate(); //HQLBuilder hb = new HQLBuilder(
	 * "update ActivoAgrupacion set activoPrincipal = null where activoPrincipal = (select activo from ActivoAgrupacionActivo where id = "
	 * + id + ")"); //return ((List<ActivoFoto>)
	 * getHibernateTemplate().find(hb.toString()));
	 * 
	 * } catch (Exception e) { e.printStackTrace(); //return null; }
	 * 
	 * //update ACT_AGR_AGRUPACION AGR set AGR_ACT_PRINCIPAL = NULL WHERE
	 * AGR.AGR_ACT_PRINCIPAL = (SELECT ACT_ID FROM ACT_AGA_AGRUPACION_ACTIVO
	 * WHERE AGA_ID = 42)
	 * 
	 * }
	 */

	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoFoto> getFotosActivosAgrupacionById(Long id) {

		try {

			HQLBuilder hb = new HQLBuilder(
					"from ActivoFoto foto where foto.tipoFoto.codigo = '01' AND foto.activo.id in "
							+ " ( select distinct(agru.agrupacion.activoPrincipal) from ActivoAgrupacionActivo agru where agru.agrupacion.id = "
							+ id + ") order by foto.activo.id desc ");

			List<ActivoFoto> listaPrincipal = (List<ActivoFoto>) getHibernateTemplate().find(hb.toString());

			HQLBuilder hbDos = new HQLBuilder(
					"from ActivoFoto foto where foto.tipoFoto.codigo = '01' AND  foto.activo.id in "
							+ " ( select distinct(agru.activo.id) from ActivoAgrupacionActivo agru where agru.agrupacion.id = "
							+ id
							+ " and agru.agrupacion.activoPrincipal != foto.activo.id) order by foto.activo.id desc ");

			List<ActivoFoto> listaResto = (List<ActivoFoto>) getHibernateTemplate().find(hbDos.toString());

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
	public List<ActivoFoto> getFotosSubdivision(DtoSubdivisiones subdivision) {

		List<ActivoFoto> lista = null;

		try {

			HQLBuilder hb = new HQLBuilder("from ActivoFoto foto where foto.subdivision = " + subdivision.getId()
					+ " and foto.agrupacion.id = " + subdivision.getAgrId() + " order by foto.orden");

			lista = (List<ActivoFoto>) getHibernateTemplate().find(hb.toString());

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

			HQLBuilder hb = new HQLBuilder(
					"from ActivoFoto foto where foto.agrupacion.id = " + id + " and foto.subdivision is null");

			lista = (List<ActivoFoto>) getHibernateTemplate().find(hb.toString());

		} catch (Exception e) {
			e.printStackTrace();
		}

		return lista;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<AgrupacionesVigencias> getHistoricoVigenciasAgrupacionById(DtoVigenciaAgrupacion agrupacionFilter) {
		HQLBuilder hb = new HQLBuilder(
				" from AgrupacionesVigencias vigencia where vigencia.agrupacion.id = " + agrupacionFilter.getAgrId());
		hb.orderBy("vigencia.auditoria.fechaCrear", HQLBuilder.ORDER_DESC);

		return (List<AgrupacionesVigencias>) getHibernateTemplate().find(hb.toString());

	}

	@SuppressWarnings("unchecked")
	@Override
	public Boolean estaActivoEnOtraAgrupacionVigente(ActivoAgrupacion agrupacion, Activo activo) {
		String activos = "(";
		Boolean resultado = false;
		int contActivos = 0;
		// si pasamos el parametro activo buscamos solo en ese
		if (activo != null) {
			activos = activos.concat(activo.getId().toString());
			contActivos++;
		} else {
			if (agrupacion.getActivos() != null && agrupacion.getActivos().size() > 0) {
				for (int i = 0; i < agrupacion.getActivos().size(); i++) {
					Activo aux = agrupacion.getActivos().get(i).getActivo();
					if (i > 0) {
						activos = activos.concat(",");
					}
					activos = activos.concat(aux.getId().toString());
					contActivos++;
				}
			}
		}
		activos = activos.concat(")");

		if (contActivos > 0) {
			HQLBuilder hb = new HQLBuilder(
					"from ActivoAgrupacionActivo agrActivo where agrActivo.auditoria.borrado != 1 and agrActivo.activo.id in "
							+ activos + " and agrActivo.agrupacion.id != " + agrupacion.getId()
							+ " and agrActivo.agrupacion.fechaFinVigencia >= sysdate and agrActivo.agrupacion.fechaBaja is null");

			List<ActivoAgrupacionActivo> agrActivoList = (List<ActivoAgrupacionActivo>) getHibernateTemplate()
					.find(hb.toString());

			if (agrActivoList != null && agrActivoList.size() > 0) {
				resultado = true;
			}
		}

		return resultado;
	}

}
