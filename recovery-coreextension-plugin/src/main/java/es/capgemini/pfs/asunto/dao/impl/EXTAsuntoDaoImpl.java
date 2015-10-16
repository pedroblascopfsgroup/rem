package es.capgemini.pfs.asunto.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.asunto.dao.EXTAsuntoDao;
import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;
import es.capgemini.pfs.asunto.dto.DtoReportAnotacionAgenda;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.FichaAceptacion;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comite.dao.ComiteDao;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoFondo;
import es.pfsgroup.recovery.ext.api.asunto.EXTBusquedaAsuntoFiltroDinamico;
import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoBusquedaAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@Repository
public class EXTAsuntoDaoImpl extends AbstractEntityDao<Asunto, Long> implements
		EXTAsuntoDao {

	@Resource
	private PaginationManager paginationManager;

	@Autowired
	private ComiteDao comiteDao;

	@Autowired
	GenericABMDao genericDao;

	@Autowired(required = false)
	private List<EXTBusquedaAsuntoFiltroDinamico> filtrosBusquedaDinamica;

	@Override
	public Page buscarAsuntosPaginated(Usuario usuarioLogado,
			EXTDtoBusquedaAsunto dto) {
		HashMap<String, Object> params = new HashMap<String, Object>();
		final int bufferSize = 1024;
		StringBuffer hql = new StringBuffer(bufferSize);
		hql.append("from Asunto a where a.id in (select distinct asu.id from Asunto asu");

		if (requiereContrato(dto) || requiereProcedimiento(dto)) {
			hql.append(", Procedimiento prc");
		}
		if (requiereContrato(dto)) {
			hql.append(", ProcedimientoContratoExpediente pce, ExpedienteContrato cex, Contrato cnt ");
		}
		if (dto.getIdSesionComite() != null || dto.getIdComite() != null) {
			hql.append(", DecisionComite dco , DDEstadoItinerario estIti ");
		}
		hql.append(" where asu.auditoria." + Auditoria.UNDELETED_RESTICTION);

		if (requiereContrato(dto) || requiereProcedimiento(dto)) {
			hql.append(" and prc.asunto.id = asu.id ");
			hql.append(" and prc.auditoria." + Auditoria.UNDELETED_RESTICTION);

		}
		if (requiereContrato(dto)) {
			hql.append(" and prc.id = pce.procedimiento and cex.id = pce.expedienteContrato and cex.contrato.id = cnt.id ");
			hql.append(" and cex.auditoria." + Auditoria.UNDELETED_RESTICTION);
		}

		// PERMISOS DEL USUARIO (en caso de que sea externo)
		if (usuarioLogado.getUsuarioExterno()) {
			hql.append(" and ("
					+ filtroGestorSupervisorAsuntoMonoGestor(usuarioLogado,
							params)
					+ " or "
					+ filtroGestorSupervisorAsuntoMultiGestor(usuarioLogado,
							params)
					+ " or "
					+ filtroGestorSupervisorAsuntoMultiGestorVariasEntidades(
							usuarioLogado, params) + ")");

		}
		// ASUNTO
		if (dto.getCodigoAsunto() != null) {
			hql.append(" and asu.id = :asuCod");
			params.put("asuCod", dto.getCodigoAsunto());
		}
		// NOMBRE
		if (dto.getNombre() != null && !"".equals(dto.getNombre())) {
			hql.append(" and lower(asu.nombre) like '%'|| :asuName ||'%'");
			params.put("asuName", dto.getNombre().toLowerCase());
		}
		// DESPACHO
		if (dto.getComboDespachos() != null
				&& !"".equals(dto.getComboDespachos())) {
			hql.append(" and asu.id in ("
					+ getIdsAsuntosDelDespacho(
							new Long(dto.getComboDespachos()), params) + ")");
		}
		// GESTOR
		if (dto.getComboGestor() != null && !"".equals(dto.getComboGestor())) {
			hql.append(" and asu.id in ("
					+ getIdsAsuntosParaGestor(dto.getComboGestor(),
							dto.getComboTiposGestor()) + ")");
		}

		// ESTADO ASUNTO
		if (dto.getComboEstados() != null && !"".equals(dto.getComboEstados())) {
			hql.append(" and asu.estadoAsunto.codigo = :estadoAsu");
			params.put("estadoAsu", dto.getComboEstados());
		}
		// ESTADO ITINERARIO ASUNTO
		if (dto.getEstadoItinerario() != null
				&& !"".equals(dto.getEstadoItinerario())) {
			hql.append(" and asu.estadoItinerario.codigo = :estadoIti");
			params.put("estadoIti", dto.getEstadoItinerario());
		}
		// COMITE ASUNTO
		if (dto.getIdComite() != null) {
			hql.append(" and (( asu.comite.id = :comiteId");
			params.put("comiteId", dto.getIdComite());
			hql.append(" and asu.estadoItinerario.id = estIti.id and estIti.codigo = :estadoDC");
			hql.append(" and asu.estadoAsunto.codigo = :estadoAsuntoPropuesto )");
			params.put("estadoDC", DDEstadoItinerario.ESTADO_DECISION_COMIT);
			params.put("estadoAsuntoPropuesto",
					DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO);
			Comite comite = comiteDao.get(dto.getIdComite());
			hql.append(" or (asu.decisionComite.id = dco.id and dco.sesion.id = :ultimaSesionComiteId))");
			params.put("ultimaSesionComiteId", comite.getUltimaSesion().getId());
		}
		if (dto.getIdSesionComite() != null) {
			hql.append(" and asu.decisionComite.id = dco.id and dco.sesion.id = :sesionComiteId");
			params.put("sesionComiteId", dto.getIdSesionComite());
		}

		// ESTADO ANALISIS
		// TODO VER CON FO: artf429805
		/*
		 * if (dto.getEstadoAnalisis()!=null){ hql.append(" and ");
		 * StringTokenizer tokensEstados = new
		 * StringTokenizer(dto.getEstadoAnalisis(), ","); hql.append("("); while
		 * (tokensEstados.hasMoreElements()){
		 * hql.append(" as.gestor.gestorDespacho.id = '"
		 * +tokensEstados.nextToken()+"'"); if
		 * (tokensEstados.hasMoreElements()){ hql.append(" or "); } }
		 * hql.append(")"); }
		 */

		// CODIGO CONTRATO
		if (dto.getFiltroContrato() != null && dto.getFiltroContrato() > 0L) {
			hql.append(" and cnt.nroContrato like '%'|| :filtroCnt ||'%'");
			params.put("filtroCnt", dto.getFiltroContrato());
		}
		// FECHA DESDE
		if (dto.getFechaCreacionDesde() != null
				&& !"".equals(dto.getFechaCreacionDesde())) {
			hql.append(" and asu.auditoria.fechaCrear >= :fechaCrearDesde");
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
			try {
				params.put("fechaCrearDesde",
						sdf1.parse(dto.getFechaCreacionDesde()));
			} catch (ParseException e) {
				logger.error("Error parseando la fecha desde", e);
			}
		}
		// FECHA HASTA
		if (dto.getFechaCreacionHasta() != null
				&& !"".equals(dto.getFechaCreacionHasta())) {
			hql.append(" and asu.auditoria.fechaCrear <= :fechaCrearHasta");
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
			try {
				Calendar c = new GregorianCalendar();
				c.setTime(sdf1.parse(dto.getFechaCreacionHasta()));
				c.add(Calendar.DAY_OF_YEAR, 1);
				params.put("fechaCrearHasta", c.getTime());
			} catch (ParseException e) {
				logger.error("Error parseando la fecha hasta", e);
			}
		}

		// VISIBILIDAD
		// Se suma la visibilidad por pertenencia al asunto + la visibilidad por
		// zonas
		// FIXME Aï¿½adir la visibilidad por zonas
		/*
		 * hql.append(" and (("); hql.append("(asu.gestor is not null and " +
		 * filtroUsuarioMonogestor(usuarioLogado.getId().toString()) + ")");
		 * hql.append("or (asu.gestor is null and " +
		 * filtroUsuarioMultiGestor(usuarioLogado.getId().toString()) + ")");
		 * hql.append(") or asu.supervisorComite.id  = " + usuarioLogado.getId()
		 * + ") ");
		 * 
		 * // O visibilidad por zonas if (!usuarioLogado.getUsuarioExterno()) {
		 * if (dto.getCodigoZonas().size() > 0) { hql.append(" or ( "); for
		 * (String codigoZ : dto.getCodigoZonas()) { // si alguno de los
		 * contratos del asunto tiene alguna de las // zonas....
		 * hql.append(" cnt.zona.codigo like '" + codigoZ + "%' OR"); }
		 * hql.delete(hql.length() - 2, hql.length()); hql.append(" ) "); }
		 * hql.append(")"); }
		 */

		// FILTRO DE ZONAS
		if (dto.getJerarquia() != null && dto.getJerarquia().length() > 0) {
			hql.append(" and cnt.zona.nivel.id >= :nivelId");
			params.put("nivelId", new Long(dto.getJerarquia()));

			if (dto.getCodigoZonas().size() > 0) {
				hql.append(" and ( ");
				for (String codigoZ : dto.getCodigoZonas()) {
					// si alguno de los contratos del asunto tiene alguna de
					// las
					// zonas....
					hql.append(" cnt.zona.codigo like '" + codigoZ + "%' OR");
				}
				hql.delete(hql.length() - 2, hql.length());
				hql.append(" ) ");
			}
		}

		if (requiereProcedimiento(dto)) {

			// Codigo de procedimiento en juzgado
			if (dto.getCodigoProcedimientoEnJuzgado() != null
					&& !dto.getCodigoProcedimientoEnJuzgado().equals("")) {
				hql.append(" and (");
				hql.append(" prc.codigoProcedimientoEnJuzgado like '%"
						+ dto.getCodigoProcedimientoEnJuzgado() + "%' ");
				hql.append(" ) ");
			}
			// Tipos de procedimiento
			if (dto.getTiposProcedimiento() != null
					&& dto.getTiposProcedimiento().size() > 0) {
				hql.append(" and (");
				boolean first = true;
				for (String cod : dto.getTiposProcedimiento()) {
					if (first)
						first = false;
					else
						hql.append(" OR ");
					hql.append(" prc.tipoProcedimiento.codigo like '" + cod
							+ "' ");
				}
				hql.append(" ) ");
			}

		}
		hql.append(" group by asu.id  ");

		hql.append(")"); // El que cierra la subquery
		// MAX MINS

		if (requiereProcedimiento(dto) && requiereFiltrarPorSaldoTotal(dto)) {

			if (dto.getMaxSaldoTotalContratos() == null) {
				dto.setMaxSaldoTotalContratos((double) Integer.MAX_VALUE);
			}
			if (dto.getMinSaldoTotalContratos() == null) {
				dto.setMinSaldoTotalContratos(0d);
			}

			hql.append(" and a.id in ");
			hql.append(" ( ");
			hql.append(" select distinct a.id from Movimiento m, Asunto a ");
			hql.append(" where (m.contrato.id, a.id) in ");
			hql.append(" ( ");
			hql.append(" select distinct d.id, a.id ");
			hql.append(" from Asunto a, Procedimiento p, ProcedimientoContratoExpediente x, ExpedienteContrato c, Contrato d, DDEstadoProcedimiento esp ");
			hql.append(" where a.id = p.asunto.id and p.auditoria.borrado = 0  ");
			hql.append(" and p.id = x.procedimiento and x.expedienteContrato = c.id");
			hql.append(" and c.contrato.id = d.id ");
			hql.append(" and p.estadoProcedimiento.id = esp.id");
			hql.append(" and  ( ");
			hql.append(" esp.codigo = '"
					+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO
					+ "' or");
			hql.append(" esp.codigo = '"
					+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO
					+ "' or");
			hql.append(" esp.codigo = '"
					+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO + "'");
			hql.append(" )");
			hql.append(" ) ");
			hql.append(" and m.fechaExtraccion =  ");
			hql.append(" ( ");
			hql.append(" select max(m2.fechaExtraccion) from Movimiento m2 where m2.contrato.id = m.contrato.id  ");
			hql.append(" ) ");
			hql.append(" group by a.id ");
			hql.append(" having (");
			hql.append(" sum(m.posVivaVencida + m.posVivaNoVencida) between :minSaldoTotalCnt and :maxSaldoTotalCnt ");
			hql.append(" ) ");
			hql.append(" ) ");

			params.put("minSaldoTotalCnt", dto.getMinSaldoTotalContratos());
			params.put("maxSaldoTotalCnt", dto.getMaxSaldoTotalContratos());

		}
		if (requiereProcedimiento(dto) && requiereFiltrarPorPadreNulo(dto)) {
			if (dto.getMaxImporteEstimado() == null) {
				dto.setMaxImporteEstimado((double) Integer.MAX_VALUE);
			}
			if (dto.getMinImporteEstimado() == null) {
				dto.setMinImporteEstimado(0d);
			}

			hql.append(" and a.id in ");
			hql.append("(");
			hql.append(" select distinct asu.id from Asunto asu, Procedimiento prc ");
			hql.append(" where asu.auditoria.borrado = 0 and prc.auditoria.borrado = 0 ");
			hql.append(" and asu.id = prc.asunto.id ");
			hql.append(" and prc.procedimientoPadre is null ");
			hql.append(" group by asu.id having ( ");
			hql.append(" sum( abs(prc.saldoRecuperacion)) between :minImporteEst and :maxImporteEst )");

			hql.append(")");

			params.put("minImporteEst",
					new BigDecimal(dto.getMinImporteEstimado()));
			params.put("maxImporteEst",
					new BigDecimal(dto.getMaxImporteEstimado()));

		}

		if (DtoBusquedaAsunto.SALIDA_XLS.equals(dto.getTipoSalida())) {
			dto.setLimit(Integer.MAX_VALUE);
		}
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql.toString(), dto, params);
	}

	private boolean requiereFiltrarPorPadreNulo(DtoBusquedaAsunto dto) {

		return dto.getMaxImporteEstimado() != null
				|| dto.getMinImporteEstimado() != null;
	}

	private boolean requiereFiltrarPorSaldoTotal(DtoBusquedaAsunto dto) {

		return dto.getMaxSaldoTotalContratos() != null
				|| dto.getMinSaldoTotalContratos() != null;
	}

	private boolean requiereProcedimiento(EXTDtoBusquedaAsunto dto) {
		return dto.getMaxImporteEstimado() != null
				|| dto.getMinImporteEstimado() != null
				|| dto.getMaxSaldoTotalContratos() != null
				|| dto.getMinSaldoTotalContratos() != null
				|| (dto.getCodigoProcedimientoEnJuzgado() != null && !dto
						.getCodigoProcedimientoEnJuzgado().equals(""))
				|| (dto.getNumeroProcedimientoEnJuzgado() != null && !dto
						.getNumeroProcedimientoEnJuzgado().equals(""))
				|| (dto.getAnyoProcedimientoEnJuzgado() != null && !dto
						.getAnyoProcedimientoEnJuzgado().equals(""))
				|| (dto.getTiposProcedimiento() != null && dto
						.getTiposProcedimiento().size() > 0);
	}

	private boolean requiereContrato(DtoBusquedaAsunto dto) {
		return (dto.getCodigoZonas().size() > 0 || (dto.getFiltroContrato() != null && dto
				.getFiltroContrato() > 0L) || (dto.getJerarquia() != null && dto.getJerarquia().length() > 0));
	}

	private String filtroGestorSupervisorAsuntoMonoGestor(
			Usuario usuarioLogado, HashMap<String, Object> params) {
		StringBuilder hql = new StringBuilder();
		hql.append(" (asu.id in (");
		hql.append("select a.id from Asunto a ");
		hql.append("where (a.gestor.usuario.id = :usuarioLogado) or (a.supervisor.usuario.id = :usuarioLogado)");
		hql.append("))");
		params.put("usuarioLogado", usuarioLogado.getId());
		return hql.toString();
	}

	private String filtroGestorGrupo(List<Long> idsUsuariosGrupo) {
		if (idsUsuariosGrupo == null || idsUsuariosGrupo.size() == 0)
			return "";

		StringBuilder hql = new StringBuilder();

		hql.append("or (asu.id in (");
		hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
		hql.append("where gaa.gestor.usuario.id IN (");

		StringBuilder idsUsuarios = new StringBuilder();
		for (Long idUsario : idsUsuariosGrupo) {
			idsUsuarios.append("," + idUsario.toString());
		}
		if (idsUsuarios.length() > 1)
			hql.append(idsUsuarios.deleteCharAt(0).toString());

		hql.append(")))");
		return hql.toString();
	}

	private String filtroGestorSupervisorAsuntoMultiGestor(
			Usuario usuarioLogado, HashMap<String, Object> params) {
		StringBuilder hql = new StringBuilder();
		hql.append(" (asu.id in (");
		hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
		hql.append("where gaa.gestor.usuario.id = :usuarioLogado");
		hql.append("))");
		params.put("usuarioLogado", usuarioLogado.getId());
		return hql.toString();
	}

	private String filtroGestorSupervisorAsuntoMultiGestorVariasEntidades(
			Usuario usuarioLogado, HashMap<String, Object> params) {
		StringBuilder hql = new StringBuilder();
		hql.append(" (asu.id in (");
		hql.append("select ge.unidadGestionId from EXTGestorEntidad ge");
		hql.append(" where ge.tipoEntidad.codigo = "
				+ DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
		hql.append(" and ge.gestor.id = :usuarioLogado");
		hql.append("))");
		params.put("usuarioLogado", usuarioLogado.getId());
		return hql.toString();
	}

	private String getIdsAsuntosDelDespacho(Long idDespacho,
			HashMap<String, Object> params) {
		params.put("despExtId", idDespacho);
		return "select asu.id from VTARAsuntoVsUsuario gaa , Asunto asu "
				+ "where  gaa.asunto = asu.id and gaa.despachoExterno = :despExtId";
	}

	private String getIdsAsuntosParaGestor(String comboGestor,
			String comboTiposGestor) {
		if (Checks.esNulo(comboTiposGestor) && Checks.esNulo(comboGestor)) {
			throw new IllegalArgumentException(
					"comboGestor y comboTiposGestor están vacíos.");
		}
		StringBuilder subhql = new StringBuilder(
				"select asu.id from VTARAsuntoVsUsuario gaa , Asunto asu ");
		String and = "";
		subhql.append(" where gaa.asunto = asu.id and ");
		if (!Checks.esNulo(comboTiposGestor)) {
			subhql.append("gaa.tipoGestor = '" + comboTiposGestor + "'");
			and = " and ";
		}
		if (!Checks.esNulo(comboGestor)) {
			subhql.append(and + "gaa.usuario in (");
			StringTokenizer tokensGestores = new StringTokenizer(comboGestor,
					",");
			while (tokensGestores.hasMoreElements()) {
				subhql.append(tokensGestores.nextToken());
				if (tokensGestores.hasMoreElements()) {
					subhql.append(",");
				}
			}
			subhql.append(")");
		}
		return subhql.toString();
	}

	@Override
	public Long crearAsunto(GestorDespacho gestorDespacho,
			GestorDespacho supervisor, GestorDespacho procurador,
			String nombreAsunto, Expediente expediente, String observaciones) {
		EXTAsunto extAsunto = new EXTAsunto();

		extAsunto.setObservacion(observaciones);
		extAsunto.setSupervisor(supervisor);
		extAsunto.setGestor(gestorDespacho);
		extAsunto.setProcurador(procurador);
		// extAsunto.setGestoresAsunto(gestoresAsunto);

		// Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo",
		// DDEstadoAsunto.ESTADO_ASUNTO_EN_CONFORMACION);
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo",
				DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
		extAsunto.setEstadoAsunto(genericDao.get(DDEstadoAsunto.class, f1));

		extAsunto.setNombre(nombreAsunto);
		extAsunto.setExpediente(expediente);
		extAsunto.setFechaEstado(new Date(System.currentTimeMillis()));

		// extAsunto.setEstadoItinerario(ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_ASUNTO).get(0));
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "codigo",
				DDEstadoItinerario.ESTADO_ASUNTO);
		extAsunto.setEstadoItinerario(genericDao.get(DDEstadoItinerario.class,
				f2));

		FichaAceptacion ficha = new FichaAceptacion();
		Long idAsunto = save(extAsunto);
		ficha.setAsunto(extAsunto);

		// fichaAceptacionDao.save(ficha);
		genericDao.save(FichaAceptacion.class, ficha);

		// Gestores adicionales Asunto
		// for (EXTGestorAdicionalAsunto extGestorAdicionalAsunto :
		// gestoresAsunto) {
		// extGestorAdicionalAsunto.setAsunto(extAsunto);
		// genericDao.save(EXTGestorAdicionalAsunto.class,
		// extGestorAdicionalAsunto);
		// }

		return idAsunto;
	}

	@Override
	public Long modificarAsunto(Long idAsunto, GestorDespacho gestorDespacho,
			GestorDespacho supervisor, GestorDespacho procurador,
			String nombreAsunto, String observaciones) {
		EXTAsunto extAsunto = (EXTAsunto) get(idAsunto);
		if (!Checks.esNulo(gestorDespacho)
				&& (gestorDespacho.getId().longValue() != extAsunto.getGestor()
						.getId().longValue())) {
			extAsunto.setGestor(gestorDespacho);
		}
		extAsunto.setProcurador(procurador);
		extAsunto.setObservacion(observaciones);
		extAsunto.setSupervisor(supervisor);
		extAsunto.setNombre(nombreAsunto);

		// Gestores adicionales Asunto
		// List<EXTGestorAdicionalAsunto> gestoresAsuntoGet =
		// extAsunto.getGestoresAsunto();
		// for (EXTGestorAdicionalAsunto extGestorAdicionalAsunto :
		// gestoresAsuntoGet) {
		// gestoresAsuntoGet OJO TODO
		// extGestorAdicionalAsunto.
		// genericDao.update(EXTGestorAdicionalAsunto.class,
		// extGestorAdicionalAsunto);
		// }

		update(extAsunto);

		return idAsunto;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Boolean isNombreAsuntoDuplicado(String nombreAsunto,
			Long idAsuntoOriginal) {
		DetachedCriteria crit = DetachedCriteria.forClass(Asunto.class);
		crit.add(Restrictions.eq("nombre", nombreAsunto));
		crit.add(Restrictions.eq("auditoria.borrado", false));
		if (idAsuntoOriginal != null)
			crit.add(Restrictions.ne("id", idAsuntoOriginal));

		List<Asunto> listado = getHibernateTemplate().findByCriteria(crit);
		if (listado == null || listado.size() == 0)
			return false;
		else
			return true;
	}

	@Override
	public Page buscarAsuntosPaginatedDinamico(Usuario usuarioLogado,
			EXTDtoBusquedaAsunto dto, String paramsDinamicos) {
		HashMap<String, Object> params = buscarAsuntosPaginatedDinamicoComun(
				usuarioLogado, dto, paramsDinamicos);
		StringBuffer hql = (StringBuffer) params.get("hql");
		params.remove("hql");
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql.toString(), dto, params);
	}

	@Override
	public Integer buscarAsuntosPaginatedDinamicoCount(Usuario usuarioLogado,
			EXTDtoBusquedaAsunto dto, String paramsDinamicos) {
		HashMap<String, Object> params = buscarAsuntosPaginatedDinamicoComun(
				usuarioLogado, dto, paramsDinamicos);
		StringBuffer hql = (StringBuffer) params.get("hql");
		params.remove("hql");
		return paginationManager
				.getHibernatePage(getHibernateTemplate(), hql.toString(), dto,
						params).getResults().size();
	}

	private HashMap<String, Object> buscarAsuntosPaginatedDinamicoComun(
			Usuario usuarioLogado, EXTDtoBusquedaAsunto dto,
			String paramsDinamicos) {

		HashMap<String, Object> params = new HashMap<String, Object>();
		final int bufferSize = 1024;
		if(dto != null && !Checks.esNulo(dto.getSort())){
			if("fechaCrear".equals(dto.getSort())){
				dto.setSort("a.auditoria." + dto.getSort());
			} else {
				dto.setSort("a." + dto.getSort());
			}
		}
		StringBuffer hql = new StringBuffer(bufferSize);

		hql.append("from Asunto a ");
		hql.append(" JOIN FETCH a.estadoAsunto ");
		hql.append(" LEFT JOIN FETCH a.fichaAceptacion ");
		hql.append(" where a.id in ");

		/***
		 * La lista de los parï¿½metros dinï¿½nmicos debe venir de la siguiente
		 * manera
		 * 
		 * _param_origen:plugin1;plugin1param1:valor1;plugin1param2:valor2;%
		 * param%origen:plugin2;plugin2param1:valor1;plugin2param2:valor2;
		 * 
		 * */

		if (paramsDinamicos != null && filtrosBusquedaDinamica != null) {
			String[] paramsVector = paramsDinamicos.split("_param_");
			if (paramsVector != null && paramsVector.length > 0) {
				for (String paramDinamico : paramsVector) {
					for (EXTBusquedaAsuntoFiltroDinamico filtro : filtrosBusquedaDinamica) {
						if (filtro.isValid(paramDinamico)) {

							hql.append(" ( ");
							hql.append(filtro.obtenerFiltro(paramDinamico));
							hql.append(" ) and a.id in ");

						}
					}
				}
			}
		}

		hql.append(" (select distinct asu.id from Asunto asu");

		if (requiereContrato(dto) || requiereProcedimiento(dto)) {
			hql.append(", Procedimiento prc ");
		}
		if (requiereContrato(dto)) {
			hql.append(", ProcedimientoContratoExpediente pce, ExpedienteContrato cex, Contrato cnt ");
		}
		if (dto.getIdSesionComite() != null || dto.getIdComite() != null) {
			hql.append(", DecisionComite dco , DDEstadoItinerario estIti ");
		}

		if (requierePrevioCDD(dto)) {
			hql.append(", BatchAcuerdoCierreDeuda cdd ");
		}

		if (requierePostCDD(dto)) {
			hql.append(", BatchAcuerdoCierreDeuda cdd2, DDResultadoValidacionNuse rvn ,BatchCDDResultadoNuse crn ");
		}
		
		hql.append(" where asu.auditoria." + Auditoria.UNDELETED_RESTICTION);

		if (requiereContrato(dto) || requiereProcedimiento(dto)) {
			hql.append(" and prc.asunto.id = asu.id ");
			hql.append(" and prc.auditoria." + Auditoria.UNDELETED_RESTICTION);

		}
		if (requiereContrato(dto)) {
			hql.append(" and prc.id = pce.procedimiento and cex.id = pce.expedienteContrato and cex.contrato.id = cnt.id ");
			hql.append(" and cex.auditoria." + Auditoria.UNDELETED_RESTICTION);
		}

		if (requierePrevioCDD(dto)) {
			hql.append(" and asu.id = cdd.asunto.id ");
                        
			hql.append(" and cdd.id in ( ");
			hql.append(" select max(cdd1.id) ");
			hql.append(" from  BatchAcuerdoCierreDeuda cdd1 ");
			hql.append(" group by cdd1.asunto.id ) ");	
		}

		if (requierePostCDD(dto)) {
			hql.append(" and cdd2.id = crn.batchAcuerdoCierreDeuda.id ");
			hql.append(" and asu.id = cdd2.asunto.id ");
			hql.append(" and crn.resultado = rvn.codigo and crn.descripcionResultado = rvn.descripcion ");
			
			hql.append(" and crn.id in ( ");
			hql.append(" select max(crn1.id) ");
			hql.append(" from  BatchCDDResultadoNuse crn1 ");
			hql.append(" group by crn1.codigoExterno, crn1.batchAcuerdoCierreDeuda.id ) ");			
		}

		// PERMISOS DEL USUARIO (en caso de que sea externo)
		if (usuarioLogado.getUsuarioExterno()) {
			hql.append(" and ("
					+ filtroGestorSupervisorAsuntoMonoGestor(usuarioLogado,
							params)
					+ " or "
					+ filtroGestorSupervisorAsuntoMultiGestor(usuarioLogado,
							params)
					+ " or "
					+ filtroGestorSupervisorAsuntoMultiGestorVariasEntidades(
							usuarioLogado, params)
					+ filtroGestorGrupo(dto.getIdsUsuariosGrupos()) + ")");

		}
		// ASUNTO
		if (dto.getCodigoAsunto() != null) {
			hql.append(" and asu.id = :asuCod");
			params.put("asuCod", dto.getCodigoAsunto());
		}
		// NOMBRE
		if (dto.getNombre() != null && !"".equals(dto.getNombre())) {
			hql.append(" and lower(asu.nombre) like '%'|| :asuName ||'%'");
			params.put("asuName", dto.getNombre().toLowerCase());
		}
		// DESPACHO
		if (dto.getComboDespachos() != null
				&& !"".equals(dto.getComboDespachos())) {
			hql.append(" and asu.id in ("
					+ getIdsAsuntosDelDespacho(
							new Long(dto.getComboDespachos()), params) + ")");
		}
		// GESTOR
		if (!es.capgemini.pfs.utils.StringUtils.emtpyString(dto
				.getComboGestor())
				|| !es.capgemini.pfs.utils.StringUtils.emtpyString(dto
						.getComboTiposGestor())) {
			hql.append(" and asu.id in ("
					+ getIdsAsuntosParaGestor(dto.getComboGestor(),
							dto.getComboTiposGestor()) + ")");
		}

		// ESTADO ASUNTO
		if (dto.getComboEstados() != null && !"".equals(dto.getComboEstados())) {
			hql.append(" and asu.estadoAsunto.codigo = :estadoAsu");
			params.put("estadoAsu", dto.getComboEstados());
		}
		// TIPO ASUNTO
		if (dto.getComboTipoAsunto() != null
				&& !"".equals(dto.getComboTipoAsunto())) {
			hql.append(" and asu.tipoAsunto.descripcion = :tipoAsu");
			params.put("tipoAsu", dto.getComboTipoAsunto());
		}
		// ESTADO ITINERARIO ASUNTO
		if (dto.getEstadoItinerario() != null
				&& !"".equals(dto.getEstadoItinerario())) {
			hql.append(" and asu.estadoItinerario.codigo = :estadoIti");
			params.put("estadoIti", dto.getEstadoItinerario());
		}
		// COMITE ASUNTO
		if (dto.getIdComite() != null) {
			hql.append(" and (( asu.comite.id = :comiteId");
			params.put("comiteId", dto.getIdComite());
			hql.append(" and asu.estadoItinerario.id = estIti.id and estIti.codigo = :estadoDC");
			hql.append(" and asu.estadoAsunto.codigo = :estadoAsuntoPropuesto )");
			params.put("estadoDC", DDEstadoItinerario.ESTADO_DECISION_COMIT);
			params.put("estadoAsuntoPropuesto",
					DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO);
			Comite comite = comiteDao.get(dto.getIdComite());
			hql.append(" or (asu.decisionComite.id = dco.id and dco.sesion.id = :ultimaSesionComiteId))");
			params.put("ultimaSesionComiteId", comite.getUltimaSesion().getId());
		}
		if (dto.getIdSesionComite() != null) {
			hql.append(" and asu.decisionComite.id = dco.id and dco.sesion.id = :sesionComiteId");
			params.put("sesionComiteId", dto.getIdSesionComite());
		}

		// ESTADO ANALISIS
		// TODO VER CON FO: artf429805
		/*
		 * if (dto.getEstadoAnalisis()!=null){ hql.append(" and ");
		 * StringTokenizer tokensEstados = new
		 * StringTokenizer(dto.getEstadoAnalisis(), ","); hql.append("("); while
		 * (tokensEstados.hasMoreElements()){
		 * hql.append(" as.gestor.gestorDespacho.id = '"
		 * +tokensEstados.nextToken()+"'"); if
		 * (tokensEstados.hasMoreElements()){ hql.append(" or "); } }
		 * hql.append(")"); }
		 */

		// CODIGO CONTRATO
		if (dto.getFiltroContrato() != null && dto.getFiltroContrato() > 0L) {
			hql.append(" and cnt.nroContrato like '%'|| :filtroCnt ||'%'");
			params.put("filtroCnt", dto.getFiltroContrato());
		}
		// FECHA DESDE
		if (dto.getFechaCreacionDesde() != null
				&& !"".equals(dto.getFechaCreacionDesde())) {
			hql.append(" and asu.auditoria.fechaCrear >= :fechaCrearDesde");
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
			try {
				params.put("fechaCrearDesde",
						sdf1.parse(dto.getFechaCreacionDesde()));
			} catch (ParseException e) {
				logger.error("Error parseando la fecha desde", e);
			}
		}
		// FECHA HASTA
		if (dto.getFechaCreacionHasta() != null
				&& !"".equals(dto.getFechaCreacionHasta())) {
			hql.append(" and asu.auditoria.fechaCrear <= :fechaCrearHasta");
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
			try {
				Calendar c = new GregorianCalendar();
				c.setTime(sdf1.parse(dto.getFechaCreacionHasta()));
				c.add(Calendar.DAY_OF_YEAR, 1);
				params.put("fechaCrearHasta", c.getTime());
			} catch (ParseException e) {
				logger.error("Error parseando la fecha hasta", e);
			}
		}
		
		//FILTRO ERROR CDD
		if (!Checks.esNulo(dto.getComboErrorPreviCDD())) {
                        hql.append(" and cdd.fechaEntrega is null ");
                        //Si se buscan KOs de Pivote, se debe filtrar también por fechaEntrega vacío
                        
			if("Todos".equals(dto.getComboErrorPreviCDD())){
                                hql.append(" and cdd.resultadoValidacion <> 1");
//				hql.append(" and cdd.resultadoValidacionCDD is not null");
			}
			else{
                            hql.append(" and cdd.resultadoValidacion <> 1");
                            hql.append(" and cdd.resultadoValidacionCDD.codigo = :errorPrevio");
				params.put("errorPrevio", dto.getComboErrorPreviCDD());
			}
		}
		
		if (!Checks.esNulo(dto.getComboErrorPostCDD())) {
			if("0".equals(dto.getComboErrorPostCDD())){
				hql.append(" and rvn.codigo <> '0' and cdd2.fechaAlta <= crn.fechaResultado");
			}else{
				hql.append(" and rvn.id = :errorPost and cdd2.fechaAlta <= crn.fechaResultado ");
				params.put("errorPost", (Long.valueOf(dto.getComboErrorPostCDD())));
			}			
		}
		
		// FECHA DESDE ENVIO PIVOTE
		if (!Checks.esNulo(dto.getFechaEntregaDesde())) {
			hql.append(" and cdd.fechaEntrega >= :fechaEntregaDesde");
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
			try {
				params.put("fechaEntregaDesde",
						sdf1.parse(dto.getFechaEntregaDesde()));
			} catch (ParseException e) {
				logger.error("Error parseando la fecha entrega desde", e);
			}
		}
		// FECHA HASTA ENVIO PIVOTE
		if (!Checks.esNulo(dto.getFechaEntregaHasta())) {
			hql.append(" and cdd.fechaEntrega <= :fechaEntregaHasta");
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
			try {
				Calendar c = new GregorianCalendar();
				c.setTime(sdf1.parse(dto.getFechaEntregaHasta()));
				c.add(Calendar.DAY_OF_YEAR, 1);
				params.put("fechaEntregaHasta", c.getTime());
			} catch (ParseException e) {
				logger.error("Error parseando la fecha hasta", e);
			}
		}
		
		// FILTRO GESTION
		if (dto.getComboGestion() != null && !"".equals(dto.getComboGestion())) {
			hql.append(" and asu.gestionAsunto.codigo = :gestionAsunto");
			params.put("gestionAsunto", dto.getComboGestion());
		}

		// FILTRO PROPIEDAD
		if (dto.getComboPropiedades() != null
				&& !"".equals(dto.getComboPropiedades())) {
			hql.append(" and asu.propiedadAsunto.codigo = :propiedadAsunto");
			params.put("propiedadAsunto", dto.getComboPropiedades());
		}

		// VISIBILIDAD
		// Se suma la visibilidad por pertenencia al asunto + la visibilidad por
		// zonas
		// FIXME Aï¿½adir la visibilidad por zonas
		/*
		 * hql.append(" and (("); hql.append("(asu.gestor is not null and " +
		 * filtroUsuarioMonogestor(usuarioLogado.getId().toString()) + ")");
		 * hql.append("or (asu.gestor is null and " +
		 * filtroUsuarioMultiGestor(usuarioLogado.getId().toString()) + ")");
		 * hql.append(") or asu.supervisorComite.id  = " + usuarioLogado.getId()
		 * + ") ");
		 * 
		 * // O visibilidad por zonas if (!usuarioLogado.getUsuarioExterno()) {
		 * if (dto.getCodigoZonas().size() > 0) { hql.append(" or ( "); for
		 * (String codigoZ : dto.getCodigoZonas()) { // si alguno de los
		 * contratos del asunto tiene alguna de las // zonas....
		 * hql.append(" cnt.zona.codigo like '" + codigoZ + "%' OR"); }
		 * hql.delete(hql.length() - 2, hql.length()); hql.append(" ) "); }
		 * hql.append(")"); }
		 */

		// FILTRO DE ZONAS
		if (dto.getJerarquia() != null && dto.getJerarquia().length() > 0) {
			hql.append(" and cnt.zona.nivel.codigo <= :nivelId");
			params.put("nivelId", Integer.valueOf(dto.getJerarquia()));

			if (dto.getCodigoZonas().size() > 0) {
				hql.append(" and ( ");
				for (String codigoZ : dto.getCodigoZonas()) {
					// si alguno de los contratos del asunto tiene alguna de
					// las
					// zonas....
					hql.append(" cnt.zona.codigo like '" + codigoZ + "%' OR");
				}
				hql.delete(hql.length() - 2, hql.length());
				hql.append(" ) ");
			}
		}

		if (requiereProcedimiento(dto)) {

			// Codigo de procedimiento en juzgado
			if (dto.getCodigoProcedimientoEnJuzgado() != null
					&& !dto.getCodigoProcedimientoEnJuzgado().equals("")) {
				hql.append(" and (");
				hql.append(" prc.codigoProcedimientoEnJuzgado like '%"
						+ dto.getCodigoProcedimientoEnJuzgado() + "%' ");
				hql.append(" ) ");
			}
			// UGAS-188
			if (!Checks.esNulo(dto.getNumeroProcedimientoEnJuzgado())
					&& !Checks.esNulo(dto.getAnyoProcedimientoEnJuzgado())) {
				hql.append(" and (prc.codigoProcedimientoEnJuzgado like '%"
						+ dto.getNumeroProcedimientoEnJuzgado() + "%-%"
						+ dto.getAnyoProcedimientoEnJuzgado() + "%'");
				hql.append(" or prc.codigoProcedimientoEnJuzgado like '%"
						+ dto.getNumeroProcedimientoEnJuzgado() + "%/%"
						+ dto.getAnyoProcedimientoEnJuzgado() + "%')");
			} else if (!Checks.esNulo(dto.getNumeroProcedimientoEnJuzgado())) {
				hql.append(" and (prc.codigoProcedimientoEnJuzgado like '%"
						+ dto.getNumeroProcedimientoEnJuzgado() + "%-%'");
				hql.append(" or prc.codigoProcedimientoEnJuzgado like '%"
						+ dto.getNumeroProcedimientoEnJuzgado() + "%/%')");
			} else if (!Checks.esNulo(dto.getAnyoProcedimientoEnJuzgado())) {
				hql.append(" and (prc.codigoProcedimientoEnJuzgado like '%-%"
						+ dto.getAnyoProcedimientoEnJuzgado() + "%'");
				hql.append(" or prc.codigoProcedimientoEnJuzgado like '%/%"
						+ dto.getAnyoProcedimientoEnJuzgado() + "%')");
			}

			// Tipos de procedimiento
			if (dto.getTiposProcedimiento() != null
					&& dto.getTiposProcedimiento().size() > 0) {
				hql.append(" and (");
				boolean first = true;
				for (String cod : dto.getTiposProcedimiento()) {
					if (first)
						first = false;
					else
						hql.append(" OR ");
					hql.append(" prc.tipoProcedimiento.codigo like '" + cod
							+ "' ");
				}
				hql.append(" ) ");
			}

		}
		hql.append(" group by asu.id  ");

		hql.append(")"); // El que cierra la subquery
		// MAX MINS

		if (requiereProcedimiento(dto) && requiereFiltrarPorSaldoTotal(dto)) {

			if (dto.getMaxSaldoTotalContratos() == null) {
				dto.setMaxSaldoTotalContratos((double) Integer.MAX_VALUE);
			}
			if (dto.getMinSaldoTotalContratos() == null) {
				dto.setMinSaldoTotalContratos(0d);
			}

			hql.append(" and a.id in ");
			hql.append(" ( ");
			hql.append(" select distinct a.id from Movimiento m, Asunto a ");
			hql.append(" where (m.contrato.id, a.id) in ");
			hql.append(" ( ");
			hql.append(" select distinct d.id, a.id ");
			hql.append(" from Asunto a, Procedimiento p, ProcedimientoContratoExpediente x, ExpedienteContrato c, Contrato d, DDEstadoProcedimiento esp ");
			hql.append(" where a.id = p.asunto.id and p.auditoria.borrado = 0  ");
			hql.append(" and p.id = x.procedimiento and x.expedienteContrato = c.id");
			hql.append(" and c.contrato.id = d.id ");
			hql.append(" and p.estadoProcedimiento.id = esp.id");
			hql.append(" and  ( ");
			hql.append(" esp.codigo = '"
					+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO
					+ "' or");
			hql.append(" esp.codigo = '"
					+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO
					+ "' or");
			hql.append(" esp.codigo = '"
					+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO + "'");
			hql.append(" )");
			hql.append(" ) ");
			hql.append(" and m.fechaExtraccion =  ");
			hql.append(" ( ");
			hql.append(" select max(m2.fechaExtraccion) from Movimiento m2 where m2.contrato.id = m.contrato.id  ");
			hql.append(" ) ");
			hql.append(" group by a.id ");
			hql.append(" having (");
			hql.append(" sum(m.posVivaVencida + m.posVivaNoVencida) between :minSaldoTotalCnt and :maxSaldoTotalCnt ");
			hql.append(" ) ");
			hql.append(" ) ");

			params.put("minSaldoTotalCnt", dto.getMinSaldoTotalContratos());
			params.put("maxSaldoTotalCnt", dto.getMaxSaldoTotalContratos());

		}
		if (requiereProcedimiento(dto) && requiereFiltrarPorPadreNulo(dto)) {
			if (dto.getMaxImporteEstimado() == null) {
				dto.setMaxImporteEstimado((double) Integer.MAX_VALUE);
			}
			if (dto.getMinImporteEstimado() == null) {
				dto.setMinImporteEstimado(0d);
			}

			hql.append(" and a.id in ");
			hql.append("(");
			hql.append(" select distinct asu.id from Asunto asu, Procedimiento prc ");
			hql.append(" where asu.auditoria.borrado = 0 and prc.auditoria.borrado = 0 ");
			hql.append(" and asu.id = prc.asunto.id ");
			hql.append(" and prc.procedimientoPadre is null ");
			hql.append(" group by asu.id having ( ");
			hql.append(" sum( abs(prc.saldoRecuperacion)) between :minImporteEst and :maxImporteEst )");

			hql.append(")");

			params.put("minImporteEst",
					new BigDecimal(dto.getMinImporteEstimado()));
			params.put("maxImporteEst",
					new BigDecimal(dto.getMaxImporteEstimado()));

		}

		if (DtoBusquedaAsunto.SALIDA_XLS.equals(dto.getTipoSalida())) {
			dto.setLimit(Integer.MAX_VALUE);
		}
		params.put("hql", hql);

		return params;
	}

	private boolean requierePrevioCDD(EXTDtoBusquedaAsunto dto) {
		
		if(!Checks.esNulo(dto.getComboErrorPreviCDD()) || !Checks.esNulo(dto.getFechaEntregaDesde()) || !Checks.esNulo(dto.getFechaEntregaHasta())){
			return true;
		}
		return false;
	}
	
	private boolean requierePostCDD(EXTDtoBusquedaAsunto dto) {
		
		if(!Checks.esNulo(dto.getComboErrorPostCDD())){
			return true;
		}
		return false;
	}

	@SuppressWarnings("unused")
	private Set<String> getCodigosDeZona(DtoBusquedaAsunto dtoBusquedaAsuntos) {
		Set<String> zonas;
		if (dtoBusquedaAsuntos.getCodigoZona() != null
				&& dtoBusquedaAsuntos.getCodigoZona().trim().length() > 0) {
			List<String> list = Arrays.asList((dtoBusquedaAsuntos
					.getCodigoZona().split(",")));
			zonas = new HashSet<String>(list);
		} else {

			zonas = new HashSet<String>();
		}
		return zonas;
	}

	@SuppressWarnings("unused")
	private Set<String> getTiposProcedimiento(
			DtoBusquedaAsunto dtoBusquedaAsuntos) {
		Set<String> tiposProcedimiento = null;
		if (dtoBusquedaAsuntos.getTipoProcedimiento() != null
				&& dtoBusquedaAsuntos.getTipoProcedimiento().trim().length() > 0) {
			tiposProcedimiento = new HashSet<String>(
					Arrays.asList((dtoBusquedaAsuntos.getTipoProcedimiento()
							.split(","))));
		}
		return tiposProcedimiento;
	}

	/**
	 * Devuelve las tareas pendientes por asunto.
	 * 
	 * @param asuId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<DtoReportAnotacionAgenda> getListaTareasPendientes(Long asuId) {
		String queryString = " select tar_tarea, usu_nombre || ' ' || usu_apellido1 || ' ' || usu_apellido2 nombre, tar.dd_tar_descripcion, tar_fecha_ini, tar_fecha_venc, tar_id, dd_tpo_descripcion "
				+ " from vtar_tarea_vs_usuario vta "
				+ " join prc_procedimientos prc on prc.prc_id=vta.prc_id "
				+ " join dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id=prc.dd_tpo_id "
				+ " join ${master.schema}.usu_usuarios usu on vta.usu_pendientes = usu.usu_id and vta.asu_id="
				+ asuId
				+ " join ${master.schema}.dd_sta_subtipo_tarea_base sta on sta.dd_sta_id=vta.dd_sta_id "
				+ " join ${master.schema}.dd_tar_tipo_tarea_base tar on tar.dd_tar_id=sta.dd_tar_id and tar.dd_tar_codigo='"
				+ TipoTarea.TIPO_TAREA + "'";

		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory()
				.getCurrentSession().createSQLQuery(queryString);

		List<DtoReportAnotacionAgenda> listado = new ArrayList<DtoReportAnotacionAgenda>();
		List<Object[]> lista = sqlQuery.list();
		for (Object[] obj : lista) {
			DtoReportAnotacionAgenda anotacion = new DtoReportAnotacionAgenda();
			anotacion.setDescripcionTarea(obj[0] != null ? obj[0].toString()
					: "");
			anotacion.setUsuario(obj[1] != null ? obj[1].toString() : "");
			anotacion.setTipo(obj[2] != null ? obj[2].toString() : "");
			anotacion.setFechaInicio(obj[3] != null ? (Date) obj[3] : null);
			anotacion.setFechaVto(obj[4] != null ? (Date) obj[4] : null);
			anotacion.setIdTarea(obj[5] != null ? obj[5].toString() : "");
			anotacion.setActuacion(obj[6] != null ? obj[6].toString() : "");
			listado.add(anotacion);
		}

		return listado;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DDTipoFondo> esTitulizada(Long idAsunto) {
		
		List<DDTipoFondo> listResultado = new ArrayList<DDTipoFondo>();
		StringBuffer hql = new StringBuffer();
		hql.append(" select distinct tfo ");
		hql.append(" from Contrato cnt, ExpedienteContrato cex, ProcedimientoContratoExpediente pc,");
		hql.append(" Procedimiento prc, Asunto asu, EXTInfoAdicionalContrato iac, DDTipoFondo tfo");
		hql.append(" where asu.id = :idAsunto ");
		hql.append(" and cex.contrato.id = cnt.id");
		hql.append(" and pc.expedienteContrato = cex.id");
		hql.append(" and prc.id = pc.procedimiento");
		hql.append(" and asu.id = prc.asunto.id");
		hql.append(" and iac.contrato.id = cnt.id and iac.tipoInfoContrato.codigo = :codigo");
		hql.append(" and tfo.codigo = iac.value and tfo.cesionRemate = 1");
		
		Query q = getSession().createQuery(hql.toString());
		
		q.setParameter("idAsunto", idAsunto);
		q.setParameter("codigo", APPConstants.CHAR_EXTRA7);
		;
		listResultado = q.list();
		
		return listResultado;
	}
        
	@Override
	public String getMsgErrorEnvioCDD(Long idAsunto) {

            String msgErrorEnvioCDD = new String();
            String sql = new String();
            sql =  " SELECT rvc.dd_rvc_descripcion ";
            sql += " FROM CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv ";
            sql += " INNER JOIN DD_RVC_RES_VALIDACION_CDD rvc ";
            sql += " ON cnv.dd_rvc_id               = rvc.dd_rvc_id ";
            sql += " INNER JOIN ( ";
            sql += "   SELECT cnv1.asu_id, max(cnv1.id_acuerdo_cierre) max_id_acuerdo_cierre ";
            sql += "   FROM CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv1 ";
//            sql += "   WHERE cnv1.resultado_validacion = 0 ";
            sql += "   GROUP BY cnv1.asu_id  ";
            sql += " ) mcnv ON cnv.id_acuerdo_cierre = mcnv.max_id_acuerdo_cierre ";
            sql += " WHERE cnv.resultado_validacion <> 1 ";
            sql += " AND cnv.fecha_entrega is null ";
            sql += " AND cnv.asu_id = " + idAsunto;
            sql += " AND ROWNUM = 1 ";

            SQLQuery q = getSession().createSQLQuery(sql);

            if (!q.list().isEmpty()){
                if(!Checks.esNulo(q.list().get(0).toString()) || q.list().get(0).toString() != ""){
                    msgErrorEnvioCDD = "Error validación CDD: " + q.list().get(0).toString();
                }
            }

            return msgErrorEnvioCDD;
                
        }

	@Override
	public String getMsgErrorEnvioCDDNuse(Long idAsunto) {

            String msgErrorEnvioCDD = new String();
            String sql = new String();
            sql =  " SELECT rvn.dd_rvn_descripcion ";
            sql += " FROM CDD_CRN_RESULTADO_NUSE crn ";
            sql += " INNER JOIN CNV_AUX_CCDD_PR_CONV_CIERR_DD cnv ";
            sql += " ON crn.id_acuerdo_cierre = cnv.id_acuerdo_cierre ";
            sql += " INNER JOIN DD_RVN_RES_VALIDACION_NUSE rvn ";
            sql += " ON crn.crn_resultado   = rvn.dd_rvn_codigo ";
            sql += " INNER JOIN ";
            sql += "   (SELECT crn1.asu_id_externo, ";
            sql += "     MAX(crn1.crn_id) max_crn_id ";
            sql += "   FROM CDD_CRN_RESULTADO_NUSE crn1 ";
//            sql += "   WHERE crn1.crn_resultado <> '0' ";
            sql += "   GROUP BY crn1.asu_id_externo ";
            sql += "   ) mcrn ";
            sql += " ON crn.crn_id = mcrn.max_crn_id ";
            sql += " WHERE cnv.fecha_alta <= crn.crn_fecha_result ";
            sql += " AND rvn.dd_rvn_codigo <> '0' ";
            sql += " AND cnv.asu_id = " + idAsunto;
            sql += " AND ROWNUM = 1 ";

            SQLQuery q = getSession().createSQLQuery(sql);
            
            if (!q.list().isEmpty()){
                if (!Checks.esNulo(q.list().get(0).toString()) || q.list().get(0).toString() != ""){
                    msgErrorEnvioCDD = "Error NUSE CDD: " + q.list().get(0).toString();
                }
            }

            return msgErrorEnvioCDD;
                
        }
        
	@Override
	public String getMsgErrorEnvioCDDCabecera(Long idAsunto) {

            if (!Checks.esNulo(this.getMsgErrorEnvioCDD(idAsunto))){
                
                return this.getMsgErrorEnvioCDD(idAsunto);
                        
            }else{
                if (!Checks.esNulo(this.getMsgErrorEnvioCDDNuse(idAsunto))){
                    
                    return this.getMsgErrorEnvioCDDNuse(idAsunto);
                    
                }
            }
            
            return new String();
        }
        
}