package es.pfsgroup.plugin.recovery.coreextension.subasta.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dao.SubastaDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.AcuerdoCierreDeudaDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarLotesSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchAcuerdoCierreDeuda;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchCDDResultadoNuse;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;
import es.pfsgroup.recovery.ext.impl.utils.StringUtils;

@Repository("SubastaDao")
public class SubastaDaoImpl extends AbstractEntityDao<Subasta, Long> implements
		SubastaDao {

	@Resource
	private PaginationManager paginationManager;
	
	@Autowired
	private EXTGrupoUsuariosDao extGrupoUsuariosDao;

	private void setSortSubastas(NMBDtoBuscarSubastas dto) {
		if (dto.getSort() != null) {
			if (dto.getSort().equals("numAutos")) {
				dto.setSort("s.procedimiento.codigoProcedimientoEnJuzgado");
			} else if (dto.getSort().equals("fechaSolicitud")) {
				dto.setSort("s.fechaSolicitud");
			} else if (dto.getSort().equals("fechaAnuncio")) {
				dto.setSort("s.fechaAnuncio");
			} else if (dto.getSort().equals("fechaSenyalamiento")) {
				dto.setSort("s.fechaSenyalamiento");
			} else if (dto.getSort().equals("estadoSubasta")) {
				dto.setSort("s.estadoSubasta.codigo");
			} else if (dto.getSort().equals("tasacion")) {
				dto.setSort("s.tasacion");
			} else if (dto.getSort().equals("embargo")) {
				dto.setSort("s.embargo");
			} else if (dto.getSort().equals("infLetrado")) {
				dto.setSort("s.infoLetrado");
			} else if (dto.getSort().equals("instrucciones")) {
				dto.setSort("s.instrucciones");
			} else if (dto.getSort().equals("subastaRevisada")) {
				dto.setSort("s.subastaRevisada");
			} else if (dto.getSort().equals("cargasAnteriores")) {
				dto.setSort("s.cargasAnteriores");
			} else if (dto.getSort().equals("totalImporteAdjudicado")) {
				dto.setSort("s.totalImporteAdjudicado");
			}
		} else {
			dto.setSort("s.id");
		}
	}

	/**
	 * Busqueda de subastas por filtro. (solo se trae lo necesario para la exportacion)
	 * 
	 * Optimizada para exportacion excel
	 */
	public List<HashMap<String, Object>> buscarSubastasExcel(NMBDtoBuscarSubastas filtro, Usuario usuLogado, Boolean isCount) {
		Criteria query = getSession().createCriteria(Subasta.class, "subasta");

		// Select
		query.setProjection(selectSubastasExcel(isCount));

		// From
		query.createAlias("asunto", "asunto", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("asunto.propiedadAsunto", "propiedadAsunto", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("asunto.gestionAsunto", "gestionAsunto", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("estadoSubasta", "estadoSubasta", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("procedimiento", "procedimiento", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("procedimiento.juzgado", "juzgado", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("procedimiento.juzgado.plaza", "plaza", CriteriaSpecification.LEFT_JOIN);

		// Where
		List<Criterion> where = new ArrayList<Criterion>();

		where.add(Restrictions.eq("auditoria.borrado", false));
		where.add(Restrictions.eq("asunto.auditoria.borrado", false));

		// Filtros Pesta�as
		where.addAll(restriccionesPorUsuarioExterno(usuLogado, query));
		where.addAll(restriccionesDatosSubasta(filtro));
		where.addAll(restriccionesCliente(filtro, query));
		where.addAll(restriccionesContrato(filtro, usuLogado, query));
		where.addAll(restriccionesJerarquia(filtro, query));
		where.addAll(restriccionesAsunto(filtro));

		// A�adir filtros a la consulta
		for (Criterion condicion : where) {
			query.add(condicion);
		}

		query.addOrder(Order.asc("id"));
		query.setResultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP);

		return query.list();
	}

	/**
	 * Metodo de ayuda (buscarSubastasExcel)
	 * @return devuelve un listado de proyecciones para la exportacion a excel de subastas.
	 */
	private ProjectionList selectSubastasExcel(Boolean isCount) {
		ProjectionList select = Projections.projectionList();

		// Realizar solo un count
		if(isCount){
			select.add(Projections.count("id").as("count"));
			return select;
		}

		select.add(Projections.property("fechaSolicitud").as("fechaSolicitud"));
		select.add(Projections.property("fechaAnuncio").as("fechaAnuncio"));
		select.add(Projections.property("fechaSenyalamiento").as("fechaSenyalamiento"));
		select.add(Projections.property("estadoSubasta.descripcion").as("estadoSubastaDescripcion"));
		select.add(Projections.property("tasacion").as("tasacion"));
		select.add(Projections.property("embargo").as("embargo"));
		select.add(Projections.property("infoLetrado").as("infoLetrado"));
		select.add(Projections.property("instrucciones").as("instrucciones"));
		select.add(Projections.property("subastaRevisada").as("subastaRevisada"));
		select.add(Projections.property("cargasAnteriores").as("cargasAnteriores"));
		select.add(Projections.property("totalImporteAdjudicado").as("totalImporteAdjudicado"));
		select.add(Projections.property("asunto.codigoExterno").as("codigoExterno"));
		select.add(Projections.property("asunto.nombre").as("nombre"));
		select.add(Projections.property("propiedadAsunto.descripcion").as("propiedadAsunto"));
		select.add(Projections.property("gestionAsunto.descripcion").as("gestionAsunto"));
		select.add(Projections.property("procedimiento.codigoProcedimientoEnJuzgado").as("nAutos"));
		select.add(Projections.property("juzgado.descripcion").as("juzgado"));
		select.add(Projections.property("plaza.descripcion").as("plaza"));
		select.add(Projections.property("asunto").as("asunto"));
		return select;
	}

	/**
	 * Metodo de ayuda (buscarSubastasExcel)
	 * @param filtro datos que vienen de la web
	 * @return devuelve las restricciones aplicar a la consutla
	 */
	private List<Criterion> restriccionesAsunto(NMBDtoBuscarSubastas filtro) {
		List<Criterion> where = new ArrayList<Criterion>();

		if (!StringUtils.emtpyString(filtro.getGestion())) {
			where.add(Restrictions.eq("gestionAsunto.codigo", filtro.getGestion()));
		}

		if (!StringUtils.emtpyString(filtro.getPropiedad())) {
			where.add(Restrictions.eq("propiedadAsunto.codigo", filtro.getPropiedad()));
		}

		return where;
	}

	/**
	 * Metodo de ayuda (buscarSubastasExcel)
	 * @param filtro datos que vienen de la web
	 * @param query objeto que contiene la consulta, se utiliza para a�adir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consutla
	 */
	private List<Criterion> restriccionesJerarquia(NMBDtoBuscarSubastas filtro, Criteria query) {
		List<Criterion> where = new ArrayList<Criterion>();

		if (!StringUtils.emtpyString(filtro.getCodigoZona())) {
			query.createAlias("contrato.oficinaContable", "oficinaContable");
			query.createAlias("oficinaContable.zona", "oficinaContableZona");

			where.add(Restrictions.in("oficinaContableZona.codigo", filtro.getCodigoZona().split(",")));
		}

		if (!StringUtils.emtpyString(filtro.getCodigoZonaAdm())) {
			query.createAlias("contrato.oficinaAdministrativa", "oficinaAdministrativa");
			query.createAlias("oficinaAdministrativa.zona", "oficinaAdministrativaZona");

			where.add(Restrictions.in("oficinaAdministrativaZona.codigo", filtro.getCodigoZonaAdm().split(",")));
		}

		return where;
	}

	/**
	 * Metodo de ayuda (buscarSubastasExcel)
	 * @param filtro datos que vienen de la web
	 * @param query objeto que contiene la consulta, se utiliza para a�adir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consutla
	 */
	private List<Criterion> restriccionesContrato(NMBDtoBuscarSubastas filtro, Usuario usuLogado, Criteria query) {
		List<Criterion> where = new ArrayList<Criterion>();

		if (necesitaContratos(filtro, usuLogado)) {
			query.createAlias("asunto.expediente", "expediente", CriteriaSpecification.LEFT_JOIN);
			query.createAlias("expediente.contratos", "expcontrato");
			query.createAlias("expcontrato.contrato", "contrato");

			where.add(Restrictions.eq("expcontrato.auditoria.borrado", false));
			where.add(Restrictions.eq("expcontrato.sinActuacion", false));

			if (!StringUtils.emtpyString(filtro.getNroContrato())) {
				where.add(Restrictions.like("contrato.nroContrato", filtro.getNroContrato(), MatchMode.ANYWHERE));
			}

			if (!StringUtils.emtpyString(filtro.getStringEstadosContrato())) {
				query.createAlias("contrato.estadoContrato", "estadoContrato");
				where.add(Restrictions.in("estadoContrato.codigo", filtro.getStringEstadosContrato().split(",")));
			}

			if (!StringUtils.emtpyString(filtro.getTiposProductoEntidad())) {
				query.createAlias("contrato.tipoProductoEntidad", "tipoProductoEntidad");
				where.add(Restrictions.in("tipoProductoEntidad.codigo", filtro.getTiposProductoEntidad().split(",")));
			}
		}

		return where;
	}

	/**
	 * Metodo de ayuda (buscarSubastasExcel)
	 * @param filtro datos que vienen de la web
	 * @param query objeto que contiene la consulta, se utiliza para a�adir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consutla
	 */
	private List<Criterion> restriccionesCliente(NMBDtoBuscarSubastas filtro, Criteria query) {
		List<Criterion> where = new ArrayList<Criterion>();

		Boolean filtroClienteInformado = Boolean.valueOf((!StringUtils.emtpyString(filtro.getCodigoCliente()) 
										|| !StringUtils.emtpyString(filtro.getNombre()) 
										|| !StringUtils.emtpyString(filtro.getApellidos())
										|| !StringUtils.emtpyString(filtro.getNif()) 
										|| !StringUtils.emtpyString(filtro.getTipoPersona())));

		if (filtroClienteInformado) {

			query.createAlias("procedimiento.personasAfectadas", "persona", CriteriaSpecification.LEFT_JOIN);

			if (!StringUtils.emtpyString(filtro.getCodigoCliente())) {
				where.add(Restrictions.like("persona.codClienteEntidad", filtro.getCodigoCliente(), MatchMode.ANYWHERE));
			}

			if (!StringUtils.emtpyString(filtro.getNombre())) {
				where.add(Restrictions.like("persona.nombre", filtro.getNombre(), MatchMode.ANYWHERE).ignoreCase());
			}

			if (!StringUtils.emtpyString(filtro.getApellidos())) {
				String[] apellidos = filtro.getApellidos().split(" ");

				// Distingue entre apellido1 espacio apellido2 y solo un apellido, el cual podria ser el primero o el segundo.
				if (apellidos.length >= 2) {
					query.add(Restrictions.like("persona.apellido1", apellidos[0], MatchMode.ANYWHERE).ignoreCase());
					query.add(Restrictions.like("persona.apellido2", apellidos[1], MatchMode.ANYWHERE).ignoreCase());
				} else if (apellidos.length == 1) {
					query.add(
							Restrictions.or(
									Restrictions.like("persona.apellido1", apellidos[0], MatchMode.ANYWHERE).ignoreCase(), 
									Restrictions.like("persona.apellido2", apellidos[0], MatchMode.ANYWHERE).ignoreCase()));
				}
			}

			if (!StringUtils.emtpyString(filtro.getNif())) {
				where.add(Restrictions.like("persona.docId", filtro.getNif(), MatchMode.ANYWHERE).ignoreCase());
			}

			if (!StringUtils.emtpyString(filtro.getTipoPersona())) {
				query.createAlias("persona.tipoPersona", "tipoPersona");
				where.add(Restrictions.eq("tipoPersona.codigo", filtro.getTipoPersona()));
			}
		}

		return where;
	}

	/**
	 * Metodo de ayuda (buscarSubastasExcel)
	 * @param filtro datos que vienen de la web
	 * @param query objeto que contiene la consulta, se utiliza para a�adir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consutla
	 */
	private List<Criterion> restriccionesPorUsuarioExterno(Usuario usuLogado, Criteria query) {
		List<Criterion> where = new ArrayList<Criterion>();

		if (usuLogado.getUsuarioExterno()) {

			// es MonoGestor
			Query monogestorSubQuery = getSession().createQuery("SELECT a.id FROM Asunto a WHERE a.gestor.usuario.id = " + usuLogado.getId());
			List<Object> asuntoIds = monogestorSubQuery.list();

			Criterion monoGestor = null;

			if (asuntoIds != null && !asuntoIds.isEmpty()) {
				monoGestor = Restrictions.in("asunto.id", asuntoIds);
			}

			// es Multigestor
			Criterion multiGestor = null;
			List<Long> idGrpsUsuario = extGrupoUsuariosDao.buscaGruposUsuario(usuLogado);

			if (idGrpsUsuario.size() > 0) {
				StringBuilder listIds = new StringBuilder();

				for (Long id : idGrpsUsuario) {
					listIds.append(",").append(id);
				}

				if (listIds.length() > 0) {
					Query multiGestorQuery = getSession().createQuery("SELECT gaa.asunto.id FROM EXTGestorAdicionalAsunto gaa WHERE gaa.gestor.usuario.id IN (" + listIds.deleteCharAt(0).toString() + ")");
					multiGestor = Restrictions.in("asunto.id", multiGestorQuery.list());
				}
			}

			if (multiGestor != null) {
				if (monoGestor != null) {
					where.add(Restrictions.or(monoGestor, multiGestor));
				} else {
					where.add(multiGestor);
				}

			} else {
				// Gestor propio
				Query propioGestorQuery = getSession().createQuery("SELECT gaa.asunto.id FROM EXTGestorAdicionalAsunto gaa WHERE gaa.gestor.usuario.id = " + usuLogado.getId());
				Criterion propioGestor = Restrictions.in("asunto.id", propioGestorQuery.list());

				if (monoGestor != null) {
					where.add(Restrictions.or(monoGestor, propioGestor));
				} else {
					where.add(propioGestor);
				}
			}

			query.createAlias("asunto.estadoAsunto", "estadoAsunto", CriteriaSpecification.LEFT_JOIN);
			where.add(
					Restrictions.not(
							Restrictions.in("estadoAsunto.codigo", new String[] { DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO, DDEstadoAsunto.ESTADO_ASUNTO_CERRADO })));
		}

		return where;
	}

	/**
	 * Metodo de ayuda (buscarSubastasExcel)
	 * @param filtro datos que vienen de la web
	 * @param query objeto que contiene la consulta, se utiliza para a�adir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consutla
	 */
	private List<Criterion> restriccionesDatosSubasta(NMBDtoBuscarSubastas filtro) {

		List<Criterion> where = new ArrayList<Criterion>();

		if (filtro.getId() != null) {
			where.add(Restrictions.eq("id", filtro.getId()));
		}

		if (!StringUtils.emtpyString(filtro.getNumAutos())) {
			where.add(Restrictions.like("procedimiento.codigoProcedimientoEnJuzgado", filtro.getNumAutos(), MatchMode.ANYWHERE));
		}

		try {

			SimpleDateFormat formatoFechaFiltroWeb = new SimpleDateFormat("MM/dd/yyyy");
			
			if (!StringUtils.emtpyString(filtro.getFechaSolicitudDesde())) {
				where.add(Restrictions.ge("subasta.fechaSolicitud", formatoFechaFiltroWeb.parse(filtro.getFechaSolicitudDesde())));
			}

			if (!StringUtils.emtpyString(filtro.getFechaSolicitudHasta())) {
				where.add(Restrictions.le("subasta.fechaSolicitud", formatoFechaFiltroWeb.parse(filtro.getFechaSolicitudHasta())));
			}

			if (!StringUtils.emtpyString(filtro.getFechaAnuncioDesde())) {
				where.add(Restrictions.ge("subasta.fechaAnuncio", formatoFechaFiltroWeb.parse(filtro.getFechaAnuncioDesde())));
			}

			if (!StringUtils.emtpyString(filtro.getFechaAnuncioHasta())) {
				where.add(Restrictions.le("subasta.fechaAnuncio", formatoFechaFiltroWeb.parse(filtro.getFechaAnuncioHasta())));
			}

			if (!StringUtils.emtpyString(filtro.getFechaSenyalamientoDesde())) {
				where.add(Restrictions.ge("subasta.fechaSenyalamiento", formatoFechaFiltroWeb.parse(filtro.getFechaSenyalamientoDesde())));
			}

			if (!StringUtils.emtpyString(filtro.getFechaSenyalamientoHasta())) {
				where.add(Restrictions.le("subasta.fechaSenyalamiento", formatoFechaFiltroWeb.parse(filtro.getFechaSenyalamientoHasta())));
			}

		} catch (ParseException e) {
			logger.error(e.getLocalizedMessage());
		}

		if (!StringUtils.emtpyString(filtro.getIdComboInfLetradoCompleto())) {
			where.add(Restrictions.eq("subasta.infoLetrado", "1".equals(filtro.getIdComboInfLetradoCompleto())));
		}

		if (!StringUtils.emtpyString(filtro.getIdComboInstruccionesCompletadas())) {
			where.add(Restrictions.eq("subasta.instrucciones", "1".equals(filtro.getIdComboInstruccionesCompletadas())));
		}

		if (!StringUtils.emtpyString(filtro.getIdComboSubastaRevisada())) {
			where.add(Restrictions.eq("subasta.subastaRevisada", "1".equals(filtro.getIdComboSubastaRevisada())));
		}

		if (!StringUtils.emtpyString(filtro.getComboFiltroEstadoDeGestion())) {
			where.add(Restrictions.in("estadoSubasta.codigo", filtro.getComboFiltroEstadoDeGestion().split(",")));
		}

		if (!StringUtils.emtpyString(filtro.getTotalCargasAnterioresDesde())) {
			where.add(Restrictions.ge("subasta.cargasAnteriores", filtro.getTotalCargasAnterioresDesde()));
		}

		if (!StringUtils.emtpyString(filtro.getTotalCargasAnterioresHasta())) {
			where.add(Restrictions.le("subasta.cargasAnteriores", filtro.getTotalCargasAnterioresHasta()));
		}

		if (!StringUtils.emtpyString(filtro.getTotalImporteAdjudicadoDesde())) {
			where.add(Restrictions.ge("subasta.totalImporteAdjudicado", filtro.getTotalImporteAdjudicadoDesde()));
		}

		if (!StringUtils.emtpyString(filtro.getTotalImporteAdjudicadoHasta())) {
			where.add(Restrictions.le("subasta.totalImporteAdjudicado", filtro.getTotalImporteAdjudicadoHasta()));
		}

		if (!StringUtils.emtpyString(filtro.getIdComboTasacionCompletada())) {
			where.add(Restrictions.eq("subasta.tasacion", "1".equals(filtro.getIdComboTasacionCompletada())));
		}

		if (!StringUtils.emtpyString(filtro.getIdComboEmbargo())) {
			where.add(Restrictions.eq("subasta.embargo", "1".equals(filtro.getIdComboEmbargo())));
		}

		return where;
	}
	
	public Page buscarSubastasPaginados(NMBDtoBuscarSubastas dto,
			Usuario usuLogado) {
		// Establece el orden de la b�squeda
		setSortSubastas(dto);
		final HashMap<String, Object> params = new HashMap<String, Object>();
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				generarHQLBuscarSubastasPaginados(dto, usuLogado, params), dto, params);
	}

	private String anyadirApostrofesParaSql(String cadena) {
		String resultado = cadena.replace(",", "','");
		resultado = "'" + resultado + "'";
		return resultado;
	}

	private String sqlFechaMayorOIgual(String fecha, String nombreCampoYTabla) {
		String mes = fecha.substring(0, 2);
		String dia = fecha.substring(3, 5);
		String anyo = fecha.substring(6, 10);
		String fechaEnNumero = anyo.concat(mes).concat(dia);
		return (" and to_number(to_char(".concat(nombreCampoYTabla).concat(
				",'yyyyMMdd')) >= ").concat(fechaEnNumero));
	}

	private String sqlFechaMenorOIgual(String fecha, String nombreCampoYTabla) {
		String mes = fecha.substring(0, 2);
		String dia = fecha.substring(3, 5);
		String anyo = fecha.substring(6, 10);
		String fechaEnNumero = anyo.concat(mes).concat(dia);
		return (" and to_number(to_char(".concat(nombreCampoYTabla).concat(
				",'yyyyMMdd')) <= ").concat(fechaEnNumero));

	}
	
	private String generarHQLBuscarSubastasPaginados(NMBDtoBuscarSubastas dto,
			Usuario usuLogado, HashMap<String, Object> params) {
		
		
		StringBuffer hqlSelect = new StringBuffer();
		StringBuffer hqlFrom = new StringBuffer();
		StringBuffer hqlWhere = new StringBuffer();

		// Consulta inicial b?sica
		hqlSelect.append(" select distinct s ");

		hqlFrom.append("  from Subasta s ");
		hqlFrom.append(" , Asunto asu ");
		hqlFrom.append(" , Expediente e ");
		if (necesitaContratos(dto, usuLogado)) {
			hqlFrom.append(" , Contrato c ");
			hqlFrom.append(" , ExpedienteContrato cex ");
		}
		hqlFrom.append(" , Procedimiento p ");
		hqlFrom.append(" , TipoJuzgado j  ");
		hqlFrom.append(" , TipoPlaza pla ");

		hqlWhere.append(" where s.auditoria.borrado = 0");

		hqlWhere.append(" and (asu=s.asunto or s.asunto is null) ");
		hqlWhere.append(" and asu.auditoria.borrado = 0 ");
		hqlWhere.append(" and (asu.expediente = e or asu.expediente is null)  ");
		if (necesitaContratos(dto, usuLogado)) {
			hqlWhere.append(" and (cex.expediente = e or cex.expediente is null) ");
			hqlWhere.append(" and (cex.contrato = c or cex.contrato is null) ");
			hqlWhere.append(" and cex.auditoria.borrado = 0 ");
		}
		hqlWhere.append(" and (s.procedimiento = p or s.procedimiento is null) ");
		hqlWhere.append(" and (p.juzgado = j or p.juzgado is null) ");
		hqlWhere.append(" and (j.plaza = pla or j.plaza is null) ");

		if (usuLogado.getUsuarioExterno()) {
			hqlWhere.append(hqlFiltroEsGestorAsunto(usuLogado));
			if (necesitaContratos(dto, usuLogado)) {
				hqlWhere.append(" and cex.sinActuacion = 0 ");
			}
			hqlWhere.append(" and asu.estadoAsunto.codigo NOT IN ("
					+ DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO + ", "
					+ DDEstadoAsunto.ESTADO_ASUNTO_CERRADO + ")");
		}

		// Filtros de pesta?a de Subasta
		if (dto.getId() != null) {
			hqlWhere.append(" and s.id = ".concat(dto.getId().toString()));
		}

		if (!StringUtils.emtpyString(dto.getNumAutos())) {
			
			hqlWhere.append(" and s.procedimiento.codigoProcedimientoEnJuzgado like '%'|| :numAut ||'%'");
			params.put("numAut", dto.getNumAutos());
			
			
//			hqlWhere.append(" and s.procedimiento.codigoProcedimientoEnJuzgado like ('%"
//					.concat(dto.getNumAutos()).concat("%')"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSolicitudDesde())) {
			
			if(Pattern.matches("\\d\\d/\\d\\d/\\d\\d\\d\\d", dto.getFechaSolicitudDesde())){
				hqlWhere.append(sqlFechaMayorOIgual(dto.getFechaSolicitudDesde(),
						"s.fechaSolicitud"));
			}
		}

		if (!StringUtils.emtpyString(dto.getFechaSolicitudHasta())) {
			
			if(Pattern.matches("\\d\\d/\\d\\d/\\d\\d\\d\\d", dto.getFechaSolicitudHasta())){
				hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaSolicitudHasta(),
						"s.fechaSolicitud"));
			}
			
//			hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaSolicitudHasta(),
//					"s.fechaSolicitud"));
		}

		if (!StringUtils.emtpyString(dto.getFechaAnuncioDesde())) {
			
			if(Pattern.matches("\\d\\d/\\d\\d/\\d\\d\\d\\d", dto.getFechaAnuncioDesde())){
				hqlWhere.append(sqlFechaMayorOIgual(dto.getFechaAnuncioDesde(),
						"s.fechaAnuncio"));
			}
			
//			hqlWhere.append(sqlFechaMayorOIgual(dto.getFechaAnuncioDesde(),
//					"s.fechaAnuncio"));
		}

		if (!StringUtils.emtpyString(dto.getFechaAnuncioHasta())) {
			
			if(Pattern.matches("\\d\\d/\\d\\d/\\d\\d\\d\\d", dto.getFechaAnuncioHasta())){
				hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaAnuncioHasta(),
						"s.fechaAnuncio"));
			}
			
//			hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaAnuncioHasta(),
//					"s.fechaAnuncio"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSenyalamientoDesde())) {
			
			if(Pattern.matches("\\d\\d/\\d\\d/\\d\\d\\d\\d", dto.getFechaSenyalamientoDesde())){
				hqlWhere.append(sqlFechaMayorOIgual(dto.getFechaSenyalamientoDesde(),
						"s.fechaSenyalamiento"));
			}
			
//			hqlWhere.append(sqlFechaMayorOIgual(
//					dto.getFechaSenyalamientoDesde(), "s.fechaSenyalamiento"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSenyalamientoHasta())) {
			
			if(Pattern.matches("\\d\\d/\\d\\d/\\d\\d\\d\\d", dto.getFechaSenyalamientoHasta())){
				hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaSenyalamientoHasta(),
						"s.fechaSenyalamiento"));
			}
			
//			hqlWhere.append(sqlFechaMenorOIgual(
//					dto.getFechaSenyalamientoHasta(), "s.fechaSenyalamiento"));
		}

		if (!StringUtils.emtpyString(dto.getIdComboInfLetradoCompleto())) {
			hqlWhere.append(" and s.infoLetrado = ".concat(dto
					.getIdComboInfLetradoCompleto()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboInstruccionesCompletadas())) {
			hqlWhere.append(" and s.instrucciones = ".concat(dto
					.getIdComboInstruccionesCompletadas()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboSubastaRevisada())) {
			hqlWhere.append(" and s.subastaRevisada = ".concat(dto
					.getIdComboSubastaRevisada()));
		}

		if (!StringUtils.emtpyString(dto.getComboFiltroEstadoDeGestion())) {
			hqlWhere.append(" and s.estadoSubasta.codigo in (".concat(
					anyadirApostrofesParaSql(dto
							.getComboFiltroEstadoDeGestion())).concat(")"));
		}

		if ((!StringUtils.emtpyString(dto.getComboFiltroTareasSubastaBankia()))
				|| (!StringUtils.emtpyString(dto
						.getComboFiltroTareasSubastaSareb()))) {
			hqlFrom.append("  , VTARTareaVsUsuario v ");
			hqlWhere.append(" and p=v.procedimiento ");
			hqlWhere.append(" and v.nombreTarea in ( "
					+ "                     select t.descripcion"
					+ "                     from TareaProcedimiento t "
					+ "                     where t.codigo in (".concat(
							anyadirApostrofesParaSql(dto
									.getComboFiltroTareasSubastaBankia()))
							.concat(")) "));
		}
		
		if ((!StringUtils.emtpyString(dto.getComboFiltroTareasSubastaSareb()))
				|| (!StringUtils.emtpyString(dto
						.getComboFiltroTareasSubastaSareb()))) {
			hqlFrom.append("  , VTARTareaVsUsuario v ");
			hqlWhere.append(" and p=v.procedimiento ");
			hqlWhere.append(" and v.nombreTarea in ( "
					+ "                     select t.descripcion"
					+ "                     from TareaProcedimiento t "
					+ "                     where t.codigo in (".concat(
							anyadirApostrofesParaSql(dto
									.getComboFiltroTareasSubastaSareb()))
							.concat(")) "));
		}

		if (!StringUtils.emtpyString(dto.getIdComboEntidad())) {
			if (dto.getIdComboEntidad().equalsIgnoreCase("BANKIA")) {
				hqlWhere.append(" and s.procedimiento.tipoProcedimiento.codigo='"
						.concat(CODIGO_TIPO_SUBASTA_BANKIA).concat("'"));
			} else {
				hqlWhere.append(" and s.procedimiento.tipoProcedimiento.codigo='"
						.concat(CODIGO_TIPO_SUBASTA_SAREB).concat("'"));
			}
		}

		if (!StringUtils.emtpyString(dto.getTotalCargasAnterioresDesde())) {
			
			if(Pattern.matches("^\\d+|^\\d+\\.?\\d+",dto.getTotalCargasAnterioresDesde())){
				hqlWhere.append(" and to_number(s.cargasAnteriores)>= ".concat(dto
						.getTotalCargasAnterioresDesde()));
			}
			
//			hqlWhere.append(" and to_number(s.cargasAnteriores)>= ".concat(dto
//					.getTotalCargasAnterioresDesde()));
		}

		if (!StringUtils.emtpyString(dto.getTotalCargasAnterioresHasta())) {
			
			if(Pattern.matches("^\\d+|^\\d+\\.?\\d+",dto.getTotalCargasAnterioresHasta())){
				hqlWhere.append(" and to_number(s.cargasAnteriores)<= ".concat(dto
						.getTotalCargasAnterioresHasta()));
			}
//			hqlWhere.append(" and to_number(s.cargasAnteriores)<= ".concat(dto
//					.getTotalCargasAnterioresHasta()));
		}

		if (!StringUtils.emtpyString(dto.getTotalImporteAdjudicadoDesde())) {
			
			if(Pattern.matches("^\\d+|^\\d+\\.?\\d+",dto.getTotalImporteAdjudicadoDesde())){
				hqlWhere.append(" and to_number(s.totalImporteAdjudicado)<= ".concat(dto
						.getTotalImporteAdjudicadoDesde()));
			}
			
//			hqlWhere.append(" and to_number(s.totalImporteAdjudicado)>= "
//					.concat(dto.getTotalImporteAdjudicadoDesde()));
		}

		if (!StringUtils.emtpyString(dto.getTotalImporteAdjudicadoHasta())) {
			
			if(Pattern.matches("^\\d+|^\\d+\\.?\\d+",dto.getTotalImporteAdjudicadoHasta())){
				hqlWhere.append(" and to_number(s.totalImporteAdjudicado)<= ".concat(dto
						.getTotalImporteAdjudicadoHasta()));
			}
			
//			hqlWhere.append(" and to_number(s.totalImporteAdjudicado)<= "
//					.concat(dto.getTotalImporteAdjudicadoHasta()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboTasacionCompletada())) {
			hqlWhere.append(" and s.tasacion = ".concat(dto
					.getIdComboTasacionCompletada()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboEmbargo())) {
			// (SERGIO):
			// "Indica si la subasta es consecuencia de un embargo, esto es, que alguno de los bienes de la subasta este asociado a un embargo en alguno de los tr?mite del asunto donde esta la subasta"
			if (dto.getIdComboEmbargo().equalsIgnoreCase("1")) {
				hqlWhere.append(" and s.embargo=1 ");
			} else if (dto.getIdComboEmbargo().equalsIgnoreCase("0")) {
				hqlWhere.append(" and s.embargo=0 ");
			}
		}

		// Filtros de pesta?a de Cliente
		if (!StringUtils.emtpyString(dto.getCodigoCliente())
				|| !StringUtils.emtpyString(dto.getNombre())
				|| !StringUtils.emtpyString(dto.getApellidos())
				|| !StringUtils.emtpyString(dto.getNif())
				|| !StringUtils.emtpyString(dto.getTipoPersona())) {
			hqlFrom.append(" , ProcedimientoPersona pp, Persona pers ");
			hqlWhere.append(" and p=pp.procedimiento ");
			hqlWhere.append(" and pp.persona=pers ");
		}

		if (!StringUtils.emtpyString(dto.getCodigoCliente())) {
			
			hqlWhere.append(" and pers.codClienteEntidad like '%'|| :codCli ||'%'");
			params.put("codCli", dto.getCodigoCliente());
			
//			hqlWhere.append(" and pers.codClienteEntidad like '%"
//					+ dto.getCodigoCliente() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getNombre())) {
			
			hqlWhere.append(" and upper(pers.nombre) like '%'|| :nomCli ||'%'");
			params.put("nomCli", dto.getNombre().toUpperCase());
			
//			hqlWhere.append(" and upper(pers.nombre) like '%"
//					+ dto.getNombre().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getApellidos())) {
			
			hqlWhere.append(" and upper(pers.apellido1)||' '||upper(pers.apellido2) like '%'|| :apeCli ||'%'");
			params.put("apeCli", dto.getApellidos().toUpperCase());
			
//			hqlWhere.append(" and upper(pers.apellido1)||' '||upper(pers.apellido2) like '%"
//					+ dto.getApellidos().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getNif())) {
			
			hqlWhere.append(" and upper(pers.docId) like '%'|| :docCli ||'%'");
			params.put("docCli", dto.getNif().toUpperCase());
			
//			hqlWhere.append(" and upper(pers.docId) like '%"
//					+ dto.getNif().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getTipoPersona())) {
			hqlFrom.append(" , DDTipoPersona tpe ");
			hqlWhere.append(" and tpe=pers.tipoPersona ");
			hqlWhere.append(" and tpe.codigo = '" + dto.getTipoPersona() + "' ");
		}

		// Filtros de pesta?a de Contrato
		if (existsFiltroContrato(dto)) {
			//TODO quitar todos estos comenarios

			/*
			 * hqlFrom.append(" , ExpedientePersona pe ");
			 * hqlFrom.append(" , Persona pers "); hqlFrom.append(
			 * ", LoteSubasta ls, LoteBien lb, NMBBien b, NMBContratoBien bc ");
			 * 
			 * hqlWhere.append(" and ls.id=lb.loteSubasta.id ");
			 * hqlWhere.append(" and b.id=lb.bien.id ");
			 * hqlWhere.append(" and lb.bien.id=bc.bien.id ");
			 * hqlWhere.append(" and bc.contrato.id=c.id ");
			 */
		}

		if (!StringUtils.emtpyString(dto.getNroContrato())) {
			
			hqlWhere.append(" and c.nroContrato like '%'|| :nroCon ||'%'");
			params.put("nroCon", dto.getNroContrato());
			
//			hqlWhere.append(" and c.nroContrato like '%" + dto.getNroContrato()
//					+ "%' ");
		}

		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de alg�n modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodRecibo())) {
			hqlFrom.append(", Recibo recibo");
			hqlWhere.append(" and  (recibo.codigoRecibo like '%"
					+ dto.getCodRecibo() + "%') ");
		}
		*/

		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de alg�n modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodEfecto())) {
			hqlFrom.append(", EfectoContrato efecto ");
			hqlWhere.append(" and  (efecto.codigoEfecto like '%"
					+ dto.getCodEfecto() + "%') ");
		}
		*/

		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de alg�n modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodDisposicion())) {
			hqlFrom.append(" , Disposicion disp ");
			hqlWhere.append(" and  (disp.codigoDisposicion like '%"
					+ dto.getCodDisposicion() + "%') ");
		}
		*/

		if (!StringUtils.emtpyString(dto.getStringEstadosContrato())) {
			hqlWhere.append(" and c.estadoContrato.codigo IN ( "
					+ dto.getStringEstadosContrato() + ")");
		}

		if (!StringUtils.emtpyString(dto.getTiposProductoEntidad())) {
			hqlWhere.append(" and c.tipoProductoEntidad.codigo in ("
					+ dto.getTiposProductoEntidad() + ")");
		}

		// Filtros de pesta?a de Jerarqu?a

		if (!StringUtils.emtpyString(dto.getCodigoZona())) {

			// Incluyo el cruce de tablas si a?n no se ha incluido
			if (hqlFrom.indexOf("Oficina oficinacontable") < 0) {
				hqlFrom.append(", Oficina oficinacontable ");
				hqlWhere.append(" and c.oficinaContable=oficinacontable ");
			}

			if (hqlFrom.indexOf("DDZona zonaoficinacontable") < 0) {
				hqlFrom.append(", DDZona zonaoficinacontable ");
				hqlWhere.append(" and zonaoficinacontable.oficina = oficinacontable ");
			}

			hqlWhere.append(" and zonaoficinacontable.codigo in ("
					+ anyadirApostrofesParaSql(dto.getCodigoZona()) + ") ");
		}

		if (!StringUtils.emtpyString(dto.getCodigoZonaAdm())) {
			// Incluyo el cruce de tablas si a?n no se ha incluido
			if (hqlFrom.indexOf("Oficina oficinaadministrativa") < 0) {
				hqlFrom.append(", Oficina oficinaadministrativa ");
				hqlWhere.append(" and c.oficinaAdministrativa=oficinaadministrativa ");
			}

			if (hqlFrom.indexOf("DDZona zonaoficinaadministrativa") < 0) {
				hqlFrom.append(", DDZona zonaoficinaadministrativa ");
				hqlWhere.append(" and zonaoficinaadministrativa.oficina = oficinaadministrativa ");
			}

			hqlWhere.append(" and zonaoficinaadministrativa.codigo in ("
					+ anyadirApostrofesParaSql(dto.getCodigoZona()) + ") ");
		}


		// Filtros pesta?a asuntos
		if (!StringUtils.emtpyString(dto.getGestion())) {
			hqlWhere.append(" and asu.gestionAsunto.codigo = '"
					+ dto.getGestion() + "' ");
		}

		if (!StringUtils.emtpyString(dto.getPropiedad())) {
			hqlWhere.append(" and asu.propiedadAsunto.codigo = '"
					+ dto.getPropiedad() + "' ");
		}

		return hqlSelect.toString().concat(hqlFrom.toString())
				.concat(hqlWhere.toString());

	}

	private String hqlFiltroEsGestorAsunto(Usuario usuLogado) {
		String monogestor = " (asu.id in (select a.id from Asunto a where a.gestor.usuario.id = "
				+ usuLogado.getId() + "))";
		//String multigestor = " (asu.id in (select gaa.asunto.id from EXTGestorAdicionalAsunto gaa where gaa.gestor.usuario.id = "+ +usuLogado.getId() + "))";
		
		List<Long> idsGrpUsuarios = extGrupoUsuariosDao.buscaGruposUsuario(usuLogado);
		String multigestor = filtroGestorGrupo(idsGrpUsuarios);
		if(!Checks.esNulo(multigestor)){
			return " and (" + monogestor + " or " + multigestor + ")";
		}
		else
			return "and (" + monogestor + " or " + filtroGestorPropio(usuLogado.getId()) + ")";
		
	}
		
	private String filtroGestorPropio(Long idUsuario) {
		if (Checks.esNulo(idUsuario))
			return "";
		
		StringBuilder hql = new StringBuilder();
		
		hql.append("(asu.id in (");
		hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
		hql.append("where gaa.gestor.usuario.id = ");
		hql.append(idUsuario);
		hql.append("))");
		return hql.toString();
	}
	
	private String filtroGestorGrupo(List<Long> idsUsuariosGrupo) {
		if (idsUsuariosGrupo==null || idsUsuariosGrupo.size()==0)
			return "";
		
		StringBuilder hql = new StringBuilder();
		
		hql.append("(asu.id in (");
		hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
		hql.append("where gaa.gestor.usuario.id IN (");
		
		StringBuilder idsUsuarios = new StringBuilder();
		for (Long idUsario : idsUsuariosGrupo) {
			idsUsuarios.append("," + idUsario.toString());
		}
		if (idsUsuarios.length()>1)
			hql.append(idsUsuarios.deleteCharAt(0).toString());
		
		hql.append(")))");
		return hql.toString();
	}

	/**
	 * Este m�todo nos dice si vamos a necesitar cruzar por Contratos en la
	 * b�squeda
	 * 
	 * @param dto
	 * @param usuLogado
	 * @return
	 */
	private boolean necesitaContratos(NMBDtoBuscarSubastas dto,
			Usuario usuLogado) {
		return (usuLogado!=null && usuLogado.getUsuarioExterno()) // need cex.sinActuacion = 0
				|| existsFiltroContrato(dto)
				|| existsFiltroZonificacion(dto)
		;
	}
	
	/**
	 * Nos dice si el usuario ha introducido alg�n filtro relativo a la Zonificaci�n en el DTO
	 * @param dto
	 * @return
	 */
	private boolean existsFiltroZonificacion(NMBDtoBuscarSubastas dto) {
		return (!StringUtils.emtpyString(dto.getCodigoZona()))
				|| (!StringUtils.emtpyString(dto.getCodigoZonaAdm()));
	}

	/**
	 * Nos dice si el usuario ha introducido alg�n filtro relativo al Contrato en el DTO
	 * @param dto
	 * @return
	 */
	private boolean existsFiltroContrato(NMBDtoBuscarSubastas dto) {
		return (!StringUtils.emtpyString(dto.getNroContrato()))
				|| (!StringUtils.emtpyString(dto.getCodRecibo()))
				|| (!StringUtils.emtpyString(dto.getCodEfecto()))
				|| (!StringUtils.emtpyString(dto.getCodDisposicion()))
				|| (!StringUtils.emtpyString(dto.getStringEstadosContrato()))
				|| (!StringUtils.emtpyString(dto.getTiposProductoEntidad()));
	}
	
	//FIXME esto funciona? LoteBien no existe
	public List<Subasta> getSubastasporIdBien (Long id){
		List<Subasta> listaSubastas = new ArrayList<Subasta>();
		HQLBuilder hql = new HQLBuilder("select lob.loteSubasta.subasta "
				+ "from Bien bi, "
				+ "LoteBien lob ");
		hql.appendWhere("bi.id="+id+" and lob.bien = bi and bi.auditoria.borrado = 0 "
				+ "and lob.loteSubasta.auditoria.borrado = 0 "
				+ "and lob.loteSubasta.subasta.auditoria.borrado = 0");
		listaSubastas = HibernateQueryUtils.list(this, hql);
		return listaSubastas;
		
	}

	private void setSortLotesSubastas(NMBDtoBuscarSubastas dto) {
		if (dto.getSort() != null) {
			if (dto.getSort().equals("valorSubasta")) {
				dto.setSort("coalesce(lot.valorBienes,0)");
			} else if (dto.getSort().equals("deudaJudicial")) {
				dto.setSort("coalesce(lot.deudaJudicial,0)");
			} else if (dto.getSort().equals("pujaSin")) {
				dto.setSort("coalesce(lot.insPujaSinPostores,0)");
			} else if (dto.getSort().equals("pujaConDesde")) {
				dto.setSort("coalesce(lot.insPujaPostoresDesde,0)");
			} else if (dto.getSort().equals("pujaConHasta")) {
				dto.setSort("coalesce(lot.insPujaPostoresHasta,0)");
			} else if (dto.getSort().equals("tasacion")) {
				dto.setSort("coalesce(lot.tasacionActiva,0)");
			} else if (dto.getSort().equals("fechaSubasta")) {
				dto.setSort("lot.subasta.fechaSenyalamiento");
			} else if (dto.getSort().equals("riesgoConsignacion")) {
				dto.setSort("coalesce(lot.riesgoConsignacion,0)");
			} else if (dto.getSort().equals("estado")) {
				dto.setSort("lot.estado.descripcion");
			} else if (dto.getSort().equals("cargas")) {
				dto.setSort("lot.tieneCargasAnteriores");
			}
		} else {
			dto.setSort("lot.id");
		}
	}

	@Override
	public Page buscarLotesSubastasPaginados(NMBDtoBuscarLotesSubastas dto) {
		return buscarLotesSubastasPaginados(dto, null);
	}
	
	@Override
	public Page buscarLotesSubastasPaginados(NMBDtoBuscarLotesSubastas dto,
			Usuario usuLogado) {
		// Establece el orden de la b�squeda
		setSortLotesSubastas(dto);
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				generarHQLBuscarLotesSubastasPaginados(dto, usuLogado), dto);
	}

	
	private String generarHQLBuscarLotesSubastasPaginados(NMBDtoBuscarLotesSubastas dto,
			Usuario usuLogado) {
		StringBuffer hqlSelect = new StringBuffer();
		StringBuffer hqlFrom = new StringBuffer();
		StringBuffer hqlWhere = new StringBuffer();

		// Consulta inicial b?sica
		hqlSelect.append("select lot ");

		hqlFrom.append("  from LoteSubasta lot ");
		hqlFrom.append(" , Asunto asu ");
		hqlFrom.append(" , Expediente e ");
		if (necesitaContratos(dto, usuLogado)) {
			hqlFrom.append(" , Contrato c ");
			hqlFrom.append(" , ExpedienteContrato cex ");
		}
		hqlFrom.append(" , Procedimiento p ");
		hqlFrom.append(" , TipoJuzgado j  ");
		hqlFrom.append(" , TipoPlaza pla ");

		hqlWhere.append(" where lot.auditoria.borrado = 0");

		hqlWhere.append(" and (asu=lot.subasta.asunto or lot.subasta.asunto is null) ");
		hqlWhere.append(" and asu.auditoria.borrado = 0 ");
		hqlWhere.append(" and (asu.expediente = e or asu.expediente is null)  ");
		if (necesitaContratos(dto, usuLogado)) {
			hqlWhere.append(" and (cex.expediente = e or cex.expediente is null) ");
			hqlWhere.append(" and (cex.contrato = c or cex.contrato is null) ");
			hqlWhere.append(" and cex.auditoria.borrado = 0 ");
		}
		hqlWhere.append(" and (lot.subasta.procedimiento = p or lot.subasta.procedimiento is null) ");
		hqlWhere.append(" and (p.juzgado = j or p.juzgado is null) ");
		hqlWhere.append(" and (j.plaza = pla or j.plaza is null) ");

		if (usuLogado!=null && usuLogado.getUsuarioExterno()) {
			hqlWhere.append(hqlFiltroEsGestorAsunto(usuLogado));
			if (necesitaContratos(dto, usuLogado)) {
				hqlWhere.append(" and cex.sinActuacion = 0 ");
			}
			hqlWhere.append(" and asu.estadoAsunto.codigo NOT IN ("
					+ DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO + ", "
					+ DDEstadoAsunto.ESTADO_ASUNTO_CERRADO + ")");
		}

		// Filtros de pesta?a de Subasta
		if (dto.getId() != null) {
			hqlWhere.append(" and lot.subasta.id = ".concat(dto.getId().toString()));
		}

		if (!StringUtils.emtpyString(dto.getNumAutos())) {
			hqlWhere.append(" and lot.subasta.procedimiento.codigoProcedimientoEnJuzgado like ('%"
					.concat(dto.getNumAutos()).concat("%')"));
		}

		// Busca por juzgado, sino por plaza
		if (!StringUtils.emtpyString(dto.getIdJuzgado())) {
			hqlWhere.append(String.format(" and j.codigo='%s'", dto.getIdJuzgado()));
		} else if (!StringUtils.emtpyString(dto.getIdPlazaJuzgado())) {
			hqlWhere.append(String.format(" and pla.codigo='%s'", dto.getIdPlazaJuzgado()));
		}


		if (!StringUtils.emtpyString(dto.getFechaSolicitudDesde())) {
			hqlWhere.append(sqlFechaMayorOIgual(dto.getFechaSolicitudDesde(), "lot.subasta.fechaSolicitud"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSolicitudHasta())) {
			hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaSolicitudHasta(), "lot.subasta.fechaSolicitud"));
		}

		if (!StringUtils.emtpyString(dto.getFechaAnuncioDesde())) {
			hqlWhere.append(sqlFechaMayorOIgual(dto.getFechaAnuncioDesde(), "lot.subasta.fechaAnuncio"));
		}

		if (!StringUtils.emtpyString(dto.getFechaAnuncioHasta())) {
			hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaAnuncioHasta(), "lot.subasta.fechaAnuncio"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSenyalamientoDesde())) {
			hqlWhere.append(sqlFechaMayorOIgual(
					dto.getFechaSenyalamientoDesde(), "lot.subasta.fechaSenyalamiento"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSenyalamientoHasta())) {
			hqlWhere.append(sqlFechaMenorOIgual(
					dto.getFechaSenyalamientoHasta(), "lot.subasta.fechaSenyalamiento"));
		}

		if (!StringUtils.emtpyString(dto.getIdComboInfLetradoCompleto())) {
			hqlWhere.append(" and lot.subasta.infoLetrado = ".concat(dto
					.getIdComboInfLetradoCompleto()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboInstruccionesCompletadas())) {
			hqlWhere.append(" and lot.subasta.instrucciones = ".concat(dto
					.getIdComboInstruccionesCompletadas()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboSubastaRevisada())) {
			hqlWhere.append(" and lot.subasta.subastaRevisada = ".concat(dto
					.getIdComboSubastaRevisada()));
		}

		if (!StringUtils.emtpyString(dto.getIdEstadoInstrucciones())) {
			hqlWhere.append(" and lot.estado.codigo in (".concat(
					anyadirApostrofesParaSql(dto
							.getIdEstadoInstrucciones())).concat(")"));
		}
		
		if (!StringUtils.emtpyString(dto.getComboFiltroEstadoDeGestion())) {
			hqlWhere.append(" and lot.subasta.estadoSubasta.codigo in (".concat(
					anyadirApostrofesParaSql(dto
							.getComboFiltroEstadoDeGestion())).concat(")"));
		}

		if ((!StringUtils.emtpyString(dto.getComboFiltroTareasSubastaBankia()))
				|| (!StringUtils.emtpyString(dto
						.getComboFiltroTareasSubastaSareb()))) {
			hqlFrom.append("  , VTARTareaVsUsuario v ");
			hqlWhere.append(" and p=v.procedimiento ");
			hqlWhere.append(" and v.nombreTarea in ( "
					+ "                     select t.descripcion"
					+ "                     from TareaProcedimiento t "
					+ "                     where t.codigo in (".concat(
							anyadirApostrofesParaSql(dto
									.getComboFiltroTareasSubastaBankia()))
							.concat(")) "));
		}
		
		if ((!StringUtils.emtpyString(dto.getComboFiltroTareasSubastaSareb()))
				|| (!StringUtils.emtpyString(dto
						.getComboFiltroTareasSubastaSareb()))) {
			hqlFrom.append("  , VTARTareaVsUsuario v ");
			hqlWhere.append(" and p=v.procedimiento ");
			hqlWhere.append(" and v.nombreTarea in ( "
					+ "                     select t.descripcion"
					+ "                     from TareaProcedimiento t "
					+ "                     where t.codigo in (".concat(
							anyadirApostrofesParaSql(dto
									.getComboFiltroTareasSubastaSareb()))
							.concat(")) "));
		}

		if (!StringUtils.emtpyString(dto.getIdComboEntidad())) {
			if (dto.getIdComboEntidad().equalsIgnoreCase("BANKIA")) {
				hqlWhere.append(" and lot.subasta.procedimiento.tipoProcedimiento.codigo='"
						.concat(CODIGO_TIPO_SUBASTA_BANKIA).concat("'"));
			} else {
				hqlWhere.append(" and lot.subasta.procedimiento.tipoProcedimiento.codigo='"
						.concat(CODIGO_TIPO_SUBASTA_SAREB).concat("'"));
			}
		}

		if (!StringUtils.emtpyString(dto.getTotalCargasAnterioresDesde())) {
			
			if(Pattern.matches("\\d+\\.*\\d+",dto.getTotalCargasAnterioresDesde())){
				hqlWhere.append(" and to_number(lot.subasta.cargasAnteriores)>= ".concat(dto
						.getTotalCargasAnterioresDesde()));
			}
			
			
		}

		if (!StringUtils.emtpyString(dto.getTotalCargasAnterioresHasta())) {
			hqlWhere.append(" and to_number(lot.subasta.cargasAnteriores)<= ".concat(dto
					.getTotalCargasAnterioresHasta()));
		}

		if (!StringUtils.emtpyString(dto.getTotalImporteAdjudicadoDesde())) {
			hqlWhere.append(" and to_number(lot.subasta.totalImporteAdjudicado)>= "
					.concat(dto.getTotalImporteAdjudicadoDesde()));
		}

		if (!StringUtils.emtpyString(dto.getTotalImporteAdjudicadoHasta())) {
			hqlWhere.append(" and to_number(lot.subasta.totalImporteAdjudicado)<= "
					.concat(dto.getTotalImporteAdjudicadoHasta()));
		}

		if (!StringUtils.emtpyString(dto.getTipoSubastaDesde())) {
			try {
				Float f = Float.parseFloat(dto.getTipoSubastaDesde());
				hqlWhere.append(String.format(" and to_number(lot.insValorSubasta)>=%f", f));
			} catch (Exception nfe) {
			}
		}

		if (!StringUtils.emtpyString(dto.getTipoSubastaHasta())) {
			try {
				Float f = Float.parseFloat(dto.getTipoSubastaHasta());
				hqlWhere.append(String.format(" and to_number(lot.insValorSubasta)<=%f", f));
			} catch (Exception nfe) {
			}
		}
		
		if (!StringUtils.emtpyString(dto.getIdComboTasacionCompletada())) {
			hqlWhere.append(" and lot.subasta.tasacion = ".concat(dto
					.getIdComboTasacionCompletada()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboEmbargo())) {
			// (SERGIO):
			// "Indica si la subasta es consecuencia de un embargo, esto es, que alguno de los bienes de la subasta este asociado a un embargo en alguno de los tr?mite del asunto donde esta la subasta"
			if (dto.getIdComboEmbargo().equalsIgnoreCase("1")) {
				hqlWhere.append(" and lot.subasta.embargo=1 ");
			} else if (dto.getIdComboEmbargo().equalsIgnoreCase("0")) {
				hqlWhere.append(" and lot.subasta.embargo=0 ");
			}
		}

		// Filtros de pesta?a de Cliente
		if (!StringUtils.emtpyString(dto.getCodigoCliente())
				|| !StringUtils.emtpyString(dto.getNombre())
				|| !StringUtils.emtpyString(dto.getApellidos())
				|| !StringUtils.emtpyString(dto.getNif())
				|| !StringUtils.emtpyString(dto.getTipoPersona())) {
			hqlFrom.append(" , ProcedimientoPersona pp, Persona pers ");
			hqlWhere.append(" and p=pp.procedimiento ");
			hqlWhere.append(" and pp.persona=pers ");
		}

		if (!StringUtils.emtpyString(dto.getCodigoCliente())) {
			hqlWhere.append(" and pers.codClienteEntidad like '%"
					+ dto.getCodigoCliente() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getNombre())) {
			hqlWhere.append(" and upper(pers.nombre) like '%"
					+ dto.getNombre().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getApellidos())) {
			hqlWhere.append(" and upper(pers.apellido1)||' '||upper(pers.apellido2) like '%"
					+ dto.getApellidos().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getNif())) {
			hqlWhere.append(" and upper(pers.docId) like '%"
					+ dto.getNif().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getTipoPersona())) {
			hqlFrom.append(" , DDTipoPersona tpe ");
			hqlWhere.append(" and tpe=pers.tipoPersona ");
			hqlWhere.append(" and tpe.codigo = '" + dto.getTipoPersona() + "' ");
		}

		// Filtros de pesta?a de Contrato
		if (existsFiltroContrato(dto)) {
			//TODO quitar todos estos comenarios

			/*
			 * hqlFrom.append(" , ExpedientePersona pe ");
			 * hqlFrom.append(" , Persona pers "); hqlFrom.append(
			 * ", LoteSubasta ls, LoteBien lb, NMBBien b, NMBContratoBien bc ");
			 * 
			 * hqlWhere.append(" and ls.id=lb.loteSubasta.id ");
			 * hqlWhere.append(" and b.id=lb.bien.id ");
			 * hqlWhere.append(" and lb.bien.id=bc.bien.id ");
			 * hqlWhere.append(" and bc.contrato.id=c.id ");
			 */
		}

		if (!StringUtils.emtpyString(dto.getNroContrato())) {
			hqlWhere.append(String.format(" and c.nroContrato like '%%%s%%' ", dto.getNroContrato()));
		}
		
		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de alg�n modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodRecibo())) {
			hqlFrom.append(", Recibo recibo");
			hqlWhere.append(" and  (recibo.codigoRecibo like '%"
					+ dto.getCodRecibo() + "%') ");
		}
		*/

		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de alg�n modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodEfecto())) {
			hqlFrom.append(", EfectoContrato efecto ");
			hqlWhere.append(" and  (efecto.codigoEfecto like '%"
					+ dto.getCodEfecto() + "%') ");
		}
		*/

		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de alg�n modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodDisposicion())) {
			hqlFrom.append(" , Disposicion disp ");
			hqlWhere.append(" and  (disp.codigoDisposicion like '%"
					+ dto.getCodDisposicion() + "%') ");
		}
		*/

		if (!StringUtils.emtpyString(dto.getStringEstadosContrato())) {
			hqlWhere.append(String.format("and c.estadoContrato.codigo in (%s)", dto.getStringEstadosContrato()));
		}

		if (!StringUtils.emtpyString(dto.getTiposProductoEntidad())) {
			hqlWhere.append(String.format("and c.tipoProductoEntidad.codigo in (%s)", dto.getTiposProductoEntidad()));
		}

		// Filtros de pesta?a de Jerarqu?a

		if (!StringUtils.emtpyString(dto.getCodigoZona())) {

			// Incluyo el cruce de tablas si a?n no se ha incluido
			if (hqlFrom.indexOf("Oficina oficinacontable") < 0) {
				hqlFrom.append(", Oficina oficinacontable ");
				hqlWhere.append(" and c.oficinaContable=oficinacontable ");
			}

			if (hqlFrom.indexOf("DDZona zonaoficinacontable") < 0) {
				hqlFrom.append(", DDZona zonaoficinacontable ");
				hqlWhere.append(" and zonaoficinacontable.oficina = oficinacontable ");
			}

			hqlWhere.append(" and zonaoficinacontable.codigo in ("
					+ anyadirApostrofesParaSql(dto.getCodigoZona()) + ") ");
		}

		if (!StringUtils.emtpyString(dto.getCodigoZonaAdm())) {
			// Incluyo el cruce de tablas si a?n no se ha incluido
			if (hqlFrom.indexOf("Oficina oficinaadministrativa") < 0) {
				hqlFrom.append(", Oficina oficinaadministrativa ");
				hqlWhere.append(" and c.oficinaAdministrativa=oficinaadministrativa ");
			}

			if (hqlFrom.indexOf("DDZona zonaoficinaadministrativa") < 0) {
				hqlFrom.append(", DDZona zonaoficinaadministrativa ");
				hqlWhere.append(" and zonaoficinaadministrativa.oficina = oficinaadministrativa ");
			}

			hqlWhere.append(" and zonaoficinaadministrativa.codigo in ("
					+ anyadirApostrofesParaSql(dto.getCodigoZona()) + ") ");
		}


		// Filtros pesta?a asuntos
		if (!StringUtils.emtpyString(dto.getGestion())) {
			hqlWhere.append(" and asu.gestionAsunto.codigo = '"
					+ dto.getGestion() + "' ");
		}

		if (!StringUtils.emtpyString(dto.getPropiedad())) {
			hqlWhere.append(" and asu.propiedadAsunto.codigo = '"
					+ dto.getPropiedad() + "' ");
		}
		
		setFiltroBienes(hqlWhere, dto);

		return hqlSelect.append(hqlFrom).append(hqlWhere).toString();

	}
	
	
	private void setFiltroBienes(StringBuffer where, NMBDtoBuscarLotesSubastas dto) {
		StringBuffer subWhere = new StringBuffer();
		if (StringUtils.emtpyString(dto.getNumeroActivo()) &&
				StringUtils.emtpyString(dto.getFincaRegistral())) {
			return;
		}
		String from = "select lb.loteSubasta.id from LoteBien lb";
		if (!StringUtils.emtpyString(dto.getNumeroActivo())) {
			subWhere.append(" and upper(nmbB.numeroActivo) like '%").append(dto.getNumeroActivo().toUpperCase()).append("%'");
			from = "LoteBien lb, NMBBien nmbB where nmbB.id=lb.bien.id";
		}
		if (!StringUtils.emtpyString(dto.getFincaRegistral())) {
			subWhere.append(" and infoReg.auditoria.borrado=0 and upper(infoReg.numFinca) like '%").append(dto.getFincaRegistral().toUpperCase()).append("%'");
			from = "LoteBien lb, NMBBien nmbB, NMBInformacionRegistralBien infoReg where nmbB.id=lb.bien.id and infoReg.bien.id=nmbB.id";
		}
		
		where.append(" and lot.id in (select lb.loteSubasta.id from ").append(from).append(subWhere).append(")");
	}
	
	@Override
	public List<LoteSubasta> buscarLoteSubastasExcel(NMBDtoBuscarLotesSubastas dto) {
		return buscarLoteSubastasExcel(dto, null);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<LoteSubasta> buscarLoteSubastasExcel(NMBDtoBuscarLotesSubastas dto,
			Usuario usuLogado) {
		setSortLotesSubastas(dto);
		Query query = getSession().createQuery(
				generarHQLBuscarLotesSubastasPaginados(dto, usuLogado));
		return (List<LoteSubasta>) query.list();
	}


	@Override
	public Integer buscarSubastasExcelCount(NMBDtoBuscarSubastas dto, Usuario usuLogado) {
		final HashMap<String, Object> params = new HashMap<String, Object>();
		Query query = getSession().createQuery(
				generarHQLBuscarSubastasPaginados(dto, usuLogado,params));
		return query.list().size();
	}
	@Override
	public List<BatchAcuerdoCierreDeuda> findBatchAcuerdoCierreDeuda(Long idAsunto, Long idProcedimiento, Long idBien){
		Query query = getSession().createQuery(
				generarHQLBuscarBatchAcuerdoCierreDeuda(idAsunto, idProcedimiento, idBien));
		return (List<BatchAcuerdoCierreDeuda>) query.list();
	}

	private String generarHQLBuscarBatchAcuerdoCierreDeuda(Long idAsunto, Long idProcedimiento, Long idBien) {
		StringBuilder hql = new StringBuilder();

		// Consulta inicial b?sica
		hql.append(" select baccd ");
		hql.append(" from BatchAcuerdoCierreDeuda baccd ");
		hql.append(" where baccd.idProcedimiento = ").append(idProcedimiento);
		hql.append(" and baccd.idAsunto = ").append(idAsunto);
		if(!Checks.esNulo(idBien)) {
			hql.append(" and baccd.idBien = ").append(idBien);
		}
		hql.append(" and baccd.fechaEntrega is null ");
		
		SimpleDateFormat dateFormatInit = new SimpleDateFormat("dd/MM/yyyy 00:00:00");
		SimpleDateFormat dateFormatFin = new SimpleDateFormat("dd/MM/yyyy 22:00:00");
		
		Date date = new Date();
		
		String formatInit = dateFormatInit.format(date); //2014/08/06 15:59:48
		String formatFin = dateFormatFin.format(date);
		
		hql.append(" and baccd.fechaAlta between to_date('").append(formatInit).append("', 'DD/MM/YYYY HH24:MI:SS')");
		hql.append(" and to_date('").append(formatFin).append("', 'DD/MM/YYYY HH24:MI:SS')");
		
		return hql.toString();
	}
	
	
	public void guardarBatchAcuerdoCierreDeuda(BatchAcuerdoCierreDeuda acuerdoCierreDeuda){
		StringBuilder sb = new StringBuilder();
		sb.append(" insert into BatchAcuerdoCierreDeuda ");
		sb.append(" (idProcedimiento, fechaAlta, idAsunto, fechaEntrega, usuarioCrear, idBien, entidad) ");
		sb.append(" values ");
		sb.append(" (");
		sb.append(acuerdoCierreDeuda.getProcedimiento().getId()).append(",");
		sb.append(DateFormat.toString(acuerdoCierreDeuda.getFechaAlta())).append(",");
		sb.append(acuerdoCierreDeuda.getAsunto().getId()).append(",");
		sb.append(DateFormat.toString(acuerdoCierreDeuda.getFechaEntrega())).append(",");
		sb.append(acuerdoCierreDeuda.getUsuarioCrear()).append(",");
		sb.append(!Checks.esNulo(acuerdoCierreDeuda.getBien()) ? acuerdoCierreDeuda.getBien().getId() : "").append(",");
		sb.append(acuerdoCierreDeuda.getEntidad());
		sb.append(")");
		
		Query query = getSession().createQuery(sb.toString());
		query.executeUpdate();
	}
	
	@Override
	public void eliminarBatchAcuerdoCierreDeuda(BatchAcuerdoCierreDeuda acuerdoCierreDeuda){
		//Se eliminan todos los registros por id de BACD
                StringBuilder sb = new StringBuilder();
		sb.append(" delete from BatchAcuerdoCierreDeuda bacd");
		sb.append(" where 1=1 ");
		//bacd.resultadoValidacion = ").append(BatchAcuerdoCierreDeuda.PROPIEDAD_RESULTADO_KO);
                sb.append(" and bacd.id = ").append(acuerdoCierreDeuda.getId());
		
		Query query = getSession().createQuery(sb.toString());
		query.executeUpdate();
	}
        
	@Override
	public void eliminarBatchCDDResultadoNuse(BatchCDDResultadoNuse acuerdoCierreDeudaNuse){
		//Se eliminan todos los registros KO por ide BCDDNuse
                StringBuilder sb = new StringBuilder();
		sb.append(" delete from BatchCDDResultadoNuse bnus");
		sb.append(" where bnus.resultado <> 0 ");
		sb.append(" and borrado = 0 ");
        sb.append(" and bnus.id = ").append(acuerdoCierreDeudaNuse.getId());
		
		Query query = getSession().createQuery(sb.toString());
		query.executeUpdate();
	}
	
	@Override
	public BatchAcuerdoCierreDeuda findBatchAcuerdoCierreDeuda(AcuerdoCierreDeudaDto acuerdo){
		Query query = getSession().createQuery(
				generarHQLBuscarBatchAcuerdoCierreDeuda(acuerdo));
		return (BatchAcuerdoCierreDeuda) query.uniqueResult();
	}

	/**
	 * Funci�n que buscar� un registro en BatchAcuerdoCierreDeuda que coincida con los filtros
	 * a�adidos a la consulta en funci�n de los valores recibidos. El asunto es obligatorio.
	 * @param acuerdo
	 * @return BatchAcuerdoCierreDeuda acuerdo
	 */
	private String generarHQLBuscarBatchAcuerdoCierreDeuda(AcuerdoCierreDeudaDto acuerdo) {

	
		StringBuilder hql = new StringBuilder();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		// Consulta inicial b?sica	
		hql.append(" select baccd ");
		hql.append(" from BatchAcuerdoCierreDeuda baccd ");
		// Siempre tendremos el asunto
		hql.append(" where baccd.asunto.id = ").append(acuerdo.getAsunto().getId());
		
		// A�adimos filtros en funci�n de los valores recibidos
//		if(!Checks.esNulo(acuerdo.getId())) {
//			hql.append(" and baccd.id = ").append(acuerdo.getId());
//		}		
		
		if(!Checks.esNulo(acuerdo.getProcedimiento().getId())) {
			hql.append(" and baccd.procedimiento.id = ").append(acuerdo.getProcedimiento().getId());
		}
		
		if(!Checks.esNulo(acuerdo.getBien()) && !Checks.esNulo(acuerdo.getBien().getId())) {
			hql.append(" and baccd.bien.id = ").append(acuerdo.getBien().getId());
		}else {
			hql.append(" and baccd.bien is null ");
		}
		
		if(Checks.esNulo(acuerdo.getFechaEntrega())) {
			hql.append(" and baccd.fechaEntrega is null ");
		} else {
			String fechaEntrega = dateFormat.format(acuerdo.getFechaEntrega());
			hql.append(" and baccd.fechaEntrega = to_date('").append(fechaEntrega).append("', 'DD/MM/YYYY')");
		}

		return hql.toString();

	}

	@Override
	public Contrato getContratoByNroContrato(String nroContrato) {
        String hql = "from Contrato where nroContrato like ?";
        List<Contrato> lista = getHibernateTemplate().find(hql, new Object[] { "%" + nroContrato + "%" });
        if (lista.size() > 0) { return lista.get(0); }
        return null;
	}
	
}