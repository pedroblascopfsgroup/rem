package es.pfsgroup.plugin.recovery.mejoras.cliente;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Hibernate;
import org.hibernate.Query;
import org.hibernate.transform.ResultTransformer;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.persona.dao.EXTPersonaDao;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.persona.dto.EXTDtoClienteResultado;
import es.capgemini.pfs.persona.model.DDTipoInfoCliente;
import es.capgemini.pfs.persona.model.EXTPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.cliente.dao.MEJClienteDao;
import es.pfsgroup.plugin.recovery.mejoras.cliente.dto.MEJBuscarClientesDto;

@Repository("MEJClienteDao")
public class MEJClienteDaoImpl extends AbstractEntityDao<Cliente, Long>
		implements MEJClienteDao {

	@Resource
	private Properties appProperties;

	/*
	 * Las siguientes variables tienen como propÃ³sito hacer este DAO flexible en
	 * el sentido de que, mediante una cierta configuraciÃ³n en devon.properties,
	 * podamos adaptar la bÃºsqueda de contratos con distintas estrategias de
	 * optimizaciÃ³n
	 * 
	 * Estas variables no se acceden directamente, sino que tienen asociado un
	 * determinado mÃ©todo. Estas variables sÃ³lo cachean el valor a devolver por
	 * dicho mÃ©todo de modo que no tengamos que consultar devon.properties cada
	 * vez.
	 */

	// Flag para propÃ³sito de testeo. True significa que usamos variables para
	// el paso de parÃ¡metros a Oracle, false que usamos constantes. Esta
	// variable no se accede directamente, sino a travÃ©s del mÃ©todo
	// pasoDeVariables()
	private Boolean pasoVariables;

	private class RowWithTotalCount {
		private Long id;
		private int totalRows;

		public RowWithTotalCount(Long id, int totalRows) {
			super();
			this.id = id;
			this.totalRows = totalRows;
		}

		public Long getId() {
			return id;
		}

		public int getTotalRows() {
			return totalRows;
		}
	}

	private class FiltroPersonaBuilder {
		private StringBuilder sb;

		public FiltroPersonaBuilder() {
			sb = new StringBuilder();
		}

		public void addFiltro(String nuevoFiltroPersona) {
			// if (Checks.esNulo(sb.toString())) {
			// sb.append("(" + nuevoFiltroPersona + ")");
			// } else {
			// sb.append(" INTERSECT (" + nuevoFiltroPersona + ")");
			// }

			sb.append("AND p.per_id in (" + nuevoFiltroPersona + ")");

		}

		public String getFiltro() {
			return sb.toString();
		}

	}

	@SuppressWarnings({ "unchecked", "serial" })
	@Override
	public Page findClientesPage(MEJBuscarClientesDto clientes,
			Usuario usuarioLogueado, boolean conCarterizacion) {

		// Plantilla del HQL para recuperar las personas
		String hql = " from Persona p where p.id in (:idlist)";
		String sOrderBy = this.getHibernateOrderBy(clientes);
		if (sOrderBy!=null)
			hql += sOrderBy;

		// AlmacÃ©n de los parÃ¡metros que necesitarÃ¡ la query que recupera los
		// id'S
		final HashMap<String, Object> parameters = new HashMap<String, Object>();

		// Generamos la query que recupera los ID's y rellenamos los parÃ¡metros
		// que vamos necesitando
		String sqlPersonas = generateHQLClientesFilterSQL(clientes,
				usuarioLogueado, conCarterizacion, parameters);
		PageSql page = new PageSql();

		try {
			// Recuperamos los Ids de las personas a mostrar

			Query q = getSession().createSQLQuery(sqlPersonas)
					.addScalar("PER_ID", Hibernate.LONG)
					.addScalar("TOTALROWS", Hibernate.INTEGER)
					.setResultTransformer(new ResultTransformer() {

						@Override
						public Object transformTuple(Object[] tuple,
								String[] aliases) {
							return new RowWithTotalCount((Long) tuple[0],
									(Integer) tuple[1]);
						}

						@SuppressWarnings("rawtypes")
						@Override
						public List transformList(List collection) {
							return collection;
						}
					});

			// Parametrizamos la query
			parametrizaQuery(q, parameters);

			final List<RowWithTotalCount> rows = q.list();
			int size = 0;

			final ArrayList<Long> idList = new ArrayList<Long>();
			if (!rows.isEmpty()) {
				for (RowWithTotalCount r : rows) {
					size = r.getTotalRows();
					idList.add(r.getId());
				}
			}

			List<Object> list = null;
			if (size != 0) {
				Query query = getSession().createQuery(hql).setParameterList(
						"idlist", idList);
				list = query.list();
			} else {
				list = new ArrayList<Object>();
			}

			page.setResults(transformToDTO(clientes, list));
			page.setTotalCount(size);
		} catch (Exception e) {
			logger.error(sqlPersonas, e);
		}

		return page;
	}

	/**
	 * Este mÃ©todo aÃ±ade parÃ¡metros a una determinada query
	 * 
	 * @param q
	 *            Query a parametrizar
	 * @param parameters
	 *            ParÃ¡metros
	 */
	private void parametrizaQuery(final Query q,
			final HashMap<String, Object> parameters) {
		if (q == null)
			return;
		if (parameters == null)
			return;
		if (parameters.isEmpty())
			return;

		for (Entry<String, Object> e : parameters.entrySet()) {
			q.setParameter(e.getKey(), e.getValue());
		}

	}

	/**
	 * Transforma la lista de personas devueltas por la BBDD en los DTO que
	 * espera la vista
	 * 
	 * @param clientes
	 *            DTO con los parÃ¡metros de la bÃºsqueda
	 * @param list
	 *            Lista de personas devuelta por la BBDD
	 * @return
	 */
	private List<?> transformToDTO(MEJBuscarClientesDto clientes,
			List<Object> list) {
		final ArrayList<EXTDtoClienteResultado> dtolist = new ArrayList<EXTDtoClienteResultado>();
		for (Object o : list) {
			if (!(o instanceof EXTPersona)) {
				throw new IllegalStateException(o.toString()
						+ ": No es del tipo esperado, se esperaba "
						+ EXTPersona.class.getName());
			}
			EXTPersona p = (EXTPersona) o;
			EXTDtoClienteResultado dto = new EXTDtoClienteResultado();

			dto.setPersona(p);

			if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equalsIgnoreCase(clientes
					.getTipoRiesgo())) {
				dto.setDiasVencidos(p.getDiasVencidoRiegoDirecto());
				dto.setRiesgoTotal(p.getRiesgoTotalDirecto());
			} else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO
					.equalsIgnoreCase(clientes.getTipoRiesgo())) {
				dto.setDiasVencidos(p.getDiasVencidoRiegoIndirecto());
				dto.setRiesgoTotal(p.getRiesgoTotalIndirecto());
			} else {
				dto.setDiasVencidos(p.getDiasVencido());
				dto.setRiesgoTotal(p.getRiesgoTot());
			}
			dtolist.add(dto);
		}
		return dtolist;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Persona> findClientesExcel(MEJBuscarClientesDto clientes,
			Usuario usuarioLogueado, boolean conCarterizacion) {
		List<Persona> list = new ArrayList<Persona>();
		// AlmacÃ©n de los parÃ¡metros que necesitarÃ¡ la query que recupera los
		// id'S
		final HashMap<String, Object> parameters = new HashMap<String, Object>();

		String sql = generateHQLClientesFilterSQL(clientes, usuarioLogueado,
				conCarterizacion, parameters);

		// Plantilla del HQL para recuperar las personas
		String hql = " from Persona per where per.id in (:idlist)";

		Query q = getSession().createSQLQuery(sql).addScalar("PER_ID",
				Hibernate.LONG);
		// Parametrizamos la query
		parametrizaQuery(q, parameters);

		List<Long> idList = q.list();

		// List<Object> list = new ArrayList<Object>(idList.size());
		Query query = getSession().createQuery(hql).setParameterList("idlist",
				idList);
		list = query.list();

		return list;
	}

	private String generateHQLClientesFilterSQL(MEJBuscarClientesDto clientes,
			Usuario usuarioLogueado, boolean conCarterizacion,
			HashMap<String, Object> parameters) {
		StringBuilder hql = new StringBuilder();

		if (clientes.getLimit() > 0) {
			// Encapsularemos la query para poder paginar.
			hql.append("select  per_id, totalRows from (select row_number() over (order by 1) n, per_id, totalRows from (");
		}

		// Devolvemos totalRows como parte del resultado de la query por si
		// paginamos.
		// [OptimizaciÃ³n para oracle] Esta query lleva un hint para su Ã³ptimo
		// funcionamiento en Oracle
		hql.append("select /*+ MATERIALIZE */ p.per_id, count(1) over () totalRows from PER_PERSONAS p ");
		hql.append(" JOIN ${master.schema}.DD_TPE_TIPO_PERSONA tpe ON tpe.dd_tpe_id = p.dd_tpe_id ");

		/* 
		 * Seteo de variables locales
		 */
		boolean necesitaCruzarCliente = isNecesitaCruzarCliente(clientes);
		boolean necesitaCruzarEstado = isNecesitaCruzarEstado(clientes);
		boolean saldovencido = compruebaSaldoVencido(clientes);
		boolean riesgoTotal = compruebaRiesgoTotal(clientes);

		String fechaMinima = calculaFechaMinima(clientes);
		String fechaMaxima = calculaFechaMaxima(clientes);
 
		boolean necesitaCruzarSaldos = isNecesitaCruzarSaldos(saldovencido,
				riesgoTotal, fechaMinima, fechaMaxima);

		FiltroPersonaBuilder fpb = new FiltroPersonaBuilder();
		/*
		 * Joins con otras tablas
		 */
		if (necesitaCruzarCliente) {
			if (pasoDeVariables()) {
				hql.append(" JOIN CLI_CLIENTES cli ON cli.per_id = p.per_id AND cli.borrado = :no_borrado ");
			} else {
				hql.append(" JOIN CLI_CLIENTES cli ON cli.per_id = p.per_id AND cli.borrado = 0 ");
			}
		}

		if (necesitaCruzarEstado) {
			hql.append(" JOIN EST_ESTADOS est ON est.DD_EST_ID = cli.DD_EST_ID ");
			hql.append(" JOIN ARQ_ARQUETIPOS arq ON cli.ARQ_ID = arq.ARQ_ID and arq.ITI_ID = est.ITI_ID ");
			// AÃ¯Â¿Â½adimos soporte para perfiles carterizados
			if (conCarterizacion) {
				hql.append(" JOIN PEF_PERFILES pef ON  est.pef_id_gestor = pef.pef_id ");
			}
		}

		if (conCarterizacion) {
			hql.append("  JOIN GE_GESTOR_ENTIDAD ge on ge.ug_id = p.per_id and "
					+ "   ge.USU_ID = " + usuarioLogueado.getId());
			if (pasoDeVariables()) {
				hql.append("  JOIN ${master.schema}.dd_ein_entidad_informacion ein on ge.dd_ein_id = ein.dd_ein_id and ein.dd_ein_codigo = :codigo_entidad_cliente ");

				parameters.put("codigo_entidad_cliente",
						DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);

			} else {
				hql.append("  JOIN ${master.schema}.dd_ein_entidad_informacion ein on ge.dd_ein_id = ein.dd_ein_id and ein.dd_ein_codigo = '"
						+ DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE + "'");
			}
		}
		if (!Checks.esNulo(clientes.getNominaPension())) {
			hql.append(" JOIN EXT_ICC_INFO_EXTRA_CLI icc on icc.per_id = p.per_id "
					+ "  and icc.dd_ifx_id = ("
					+ "select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = '"
					+ DDTipoInfoCliente.TIPO_INFO_ADICIONAL_CLIENTE_NOMINA_PENSION
					+ "')");
		}
		/*
		 * Criterios de visibilidad
		 */
		if (pasoDeVariables()) {
			hql.append(" WHERE p.borrado = :no_borrado ");
		} else {
			hql.append(" WHERE p.borrado = 0 ");
		}

		/*
		 * FIXME Comentamos esta parte para quitar de momento la zonificaciÃ³n
		 * 
		 * hql.append("and (")
		 * 
		 * // AÃƒÂ±ade la persona si es gestionada por el usuario
		 * hql.append("(p.per_id in ( ");
		 * hql.append(generaFiltroPersonaPorGestor(usuarioLogueado,
		 * parameters)); // hql.append(" ))");
		 * 
		 * if ((!Checks.esNulo(clientes.getJerarquia())) ||
		 * (!Checks.esNulo(clientes.getCodigoZonas()))) {
		 * hql.append(" union all "); // hql.append("p.per_id in ( ");
		 * hql.append(generaFiltroPersonaPorJerarquia(clientes, usuarioLogueado,
		 * parameters)); hql.append(" ))"); } else { hql.append(" ))"); }
		 * hql.append(") ");
		 */

		// AÃ¯Â¿Â½adimos soporte para perfiles carterizados
		/*
		 * if (necesitaCruzarEstado && conCarterizacion) {
		 * hql.append("and (pef.pef_es_carterizado = 0 or " +
		 * usuarioLogueado.getId() + " in (select usu_id " +
		 * "from ge_gestor_entidad ge " +
		 * "join unmaster.dd_ein_entidad_informacion ein on ge.dd_ein_id = ein.dd_ein_id "
		 * + " where ein.dd_ein_codigo = '" +
		 * DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE +
		 * "' and ge.ug_id = p.per_id))"); } else if (conCarterizacion) {
		 * hql.append("and ( " + usuarioLogueado.getId() + " in (select usu_id "
		 * + "from ge_gestor_entidad ge " +
		 * "join unmaster.dd_ein_entidad_informacion ein on ge.dd_ein_id = ein.dd_ein_id "
		 * + " where ein.dd_ein_codigo = '" +
		 * DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE +
		 * "' and ge.ug_id = p.per_id))"); }
		 */

		/*
		 * Filtros de las bÃƒÂºsquedas
		 */
		// Input de situacion conscursal
		if (!Checks.esNulo(clientes.getConcurso())) {
			filtroSituacionConcursal(clientes, hql);
		}
		if (!Checks.esNulo(clientes.getNominaPension())) {
			String tieneNominaPension = "0";
			if (DDSiNo.SI.equals(clientes.getNominaPension())) {
				tieneNominaPension = "1";
			}
			hql.append("and (icc.icc_value like '%" + tieneNominaPension
					+ "%') ");
		}
		if (!Checks.esNulo(clientes.getPropietario())) {
			hql.append("and (p.dd_pro_id=(select dd_pro_id from DD_PRO_PROPIETARIOS where dd_pro_codigo= '"
					+ clientes.getPropietario() + "') )");
		}
		if (!Checks.esNulo(clientes.getCodigoColectivoSingular())) {
			hql.append("and (p.DD_COS_ID=(select DD_COS_ID from DD_COS_COLECTIVO_SINGULAR where DD_COS_CODIGO= '"
					+ clientes.getCodigoColectivoSingular() + "') )");
		}
		if (necesitaCruzarEstado) {
			filtroEstadoPersona(clientes, hql);
		}
		// Input de cÃƒÂ³digo de cliente
		if (!Checks.esNulo(clientes.getCodigoEntidad())) {
			filtroCodigoCliente(clientes, hql);
		}
		// Input de nombre de persona
		if (!Checks.esNulo(clientes.getNombre())) {
			filtroNombrePersona(clientes, hql);
		}

		if (!Checks.esNulo(clientes.getApellidos())) {
			filtroApellidos(clientes, hql);
		}
		// Input de apellido de persona
		if (!Checks.esNulo(clientes.getApellido1())) {
			filtroApellido1(clientes, hql);
		}

		// Input de segundo apellido de persona
		if (!Checks.esNulo(clientes.getApellido2())) {
			filtroApellido2(clientes, hql);
		}

		// Input de nif de persona
		if (!Checks.esNulo(clientes.getDocId())) {
			filtroNifPersona(clientes, hql, parameters);
		}

		// Combo tipo de persona
		if (!Checks.esNulo(clientes.getTipoPersona())) {
			filtroTipoPersona(clientes, hql, parameters);
		}

		// Combo Tipo de intervencion
		if (!Checks.esNulo(clientes.getTipoIntervercion())
				&& !Checks.esNulo(clientes.getIsPrimerTitContratoPase())
				&& clientes.getIsPrimerTitContratoPase()) {
			filtroTipoIntervencion(clientes, fpb);
		}
		// Check contrato de pase
		if (!Checks.esNulo(clientes.getIsPrimerTitContratoPase())
				&& clientes.getIsPrimerTitContratoPase()) {
			filtroContratoPase(fpb);
		}
		// Input nÃƒÂºmero de contrato
		if (!Checks.esNulo(clientes.getNroContrato())) {
			filtroNumeroContrato(clientes, fpb);
		}

		// Multicombo tipo de producto
		if (!Checks.esNulo(clientes.getTipoProducto())) {
			filtroTipoProducto(clientes, fpb);
		}

		// Multicombo tipo de producto
		if (!Checks.esNulo(clientes.getTipoProductoEntidad())) {
			filtroTipoProductoEntidad(clientes, fpb);
		}

		// Multicombo segmento
		if (!Checks.esNulo(clientes.getSegmento())) {
			filtroMulticomboSegmento(clientes, hql);
		}

		// Multicombo situaciÃƒÂ³n
		if (!Checks.esNulo(clientes.getSituacion())) {
			filtroMulticomboSituacion(clientes, hql);
		}

		// Multicombo situaciÃƒÂ³n financiera
		if (!Checks.esNulo(clientes.getSituacionFinanciera())) {
			filtroMulticomboSitFinanciera(clientes, fpb);
		}

		// Multicombo situaciÃƒÂ³n financiera del contrato
		if (!Checks.esNulo(clientes.getSituacionFinancieraContrato())) {
			filtroMulticomboSitFinancieraCnt(clientes, fpb);
		}

		// Check tipo de gestion
		if (!Checks.esNulo(clientes.getCodigoGestion())) {
			filtroMulticomboTipoGestion(clientes, hql, fpb);
		}
		if (fechaMinima != null || fechaMaxima != null) {
			filtroFechas(clientes, fechaMinima, fechaMaxima, fpb);
		}

		if (riesgoTotal) {
			// Se supone que este campo viene aprovisionado en el campo
			// PER_RIESGO_DISPUESTO
			// filtroRiesgoTotalNoAprovisionado(clientes, fpb);
			hql.append(filtroRiesgoTotalAprovisionado(clientes));
		}

		if (!fpb.getFiltro().equals("") && fpb.getFiltro() != null) {
			// hql.append(" and p.per_id IN (" + fpb.getFiltro() + ")");
			hql.append(" " + fpb.getFiltro() + " ");
		}
		// Inputs de riesgos, saldos y dÃƒÂ­as vencidos
		if (necesitaCruzarSaldos) {
			filtroNecesitaCruzarSaldos(clientes, hql, saldovencido);
		}

		String query = hql.toString() + " ";

		String orderBy = getOrderBy(clientes);
		if (orderBy != null) {
			query += orderBy;
		}

		if (clientes.getLimit() > 0) {
			if (pasoDeVariables()) {
				query += ")) where n between :first_row and :last_row";

				parameters.put("first_row", clientes.getStart() + 1);
				parameters.put("last_row",
						clientes.getStart() + clientes.getLimit());
			} else {
				query += ")) where n between " + (clientes.getStart() + 1)
						+ " and " + (clientes.getStart() + clientes.getLimit());
			}

		}

		if (pasoDeVariables()) {
			parameters.put("no_borrado", 0);
		}

		return query;
	}

	private void filtroApellidos(MEJBuscarClientesDto clientes,
			StringBuilder hql) {
		String apellidosPersona = clientes.getApellidos().trim().toLowerCase();

		hql.append(" and lower(p.PER_APELLIDO1)||' '||lower(p.PER_APELLIDO2) like '%"
				+ apellidosPersona + "%' ");

	}

	private void filtroNecesitaCruzarSaldos(MEJBuscarClientesDto clientes,
			StringBuilder hql, boolean saldovencido) {
		if (saldovencido) {

			if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
					.getTipoRiesgo())) {
				final String filtro = addSubselectDispuestoVencido(
						clientes.getMinSaldoVencido(),
						clientes.getMaxSaldoVencido());
				if (!Checks.esNulo(filtro)) {
					hql.append("and EXISTS (");
					hql.append(filtro);
					hql.append(")");
				}
			} else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO.equals(clientes
					.getTipoRiesgo())) {
				String campoBusqueda = "p.per_deuda_irregular_ind";
				if (!StringUtils.isBlank(clientes.getMinSaldoVencido())) {
					try {
						Float valor = Float.parseFloat(clientes.getMinSaldoVencido());
						String filtroFinal = String.format(" AND (%s IS NOT NULL and %s>=%f)", campoBusqueda, campoBusqueda, valor);
						hql.append(filtroFinal);
					} catch (NumberFormatException nfe) {}
				}
				if (!StringUtils.isBlank(clientes.getMaxSaldoVencido())) {
					try {
						Float valor = Float.parseFloat(clientes.getMaxSaldoVencido());
						String filtroFinal = String.format(" AND (%s IS NOT NULL and %s<=%f)", campoBusqueda, campoBusqueda, valor);
						hql.append(filtroFinal);
					} catch (NumberFormatException nfe) {}
				}
			}
		}
	}

	/**
	 * Genera una subselect para buscar que el extra del cliente NUM_EXTRA_2
	 * estÃ© entre dos valores
	 * 
	 * @param minValue
	 * @param maxValue
	 * @return Devuelve NULL si no puede generar el filtro
	 */
	private String addSubselectDispuestoVencido(final String minValue,
			final String maxValue) {
		final StringBuilder srtbuilder = new StringBuilder();

		if (!StringUtils.isBlank(minValue) || !StringUtils.isBlank(maxValue)) {
			srtbuilder.append("SELECT 1 FROM V_PER_PERSONAS_FORMULAS v WHERE p.PER_ID = v.PER_ID AND TO_NUMBER(REPLACE(NVL(v.DISPUESTO_VENCIDO, 0), ',', '.')) BETWEEN ");
						
			if (!StringUtils.isBlank(minValue)) {
				try {
					Float valor = Float.parseFloat(minValue);
					String filtroFinal = new DecimalFormat("#.##").format(valor);
					srtbuilder.append(filtroFinal);
				} catch (NumberFormatException nfe) {}
			}
			else {
				String filtroFinal = String.format("0");
				srtbuilder.append(filtroFinal);
			}
			
			srtbuilder.append(" AND ");
			
			if (!StringUtils.isBlank(maxValue)) {
				try {
					Float valor = Float.parseFloat(maxValue);
					String filtroFinal = new DecimalFormat("#.##").format(valor);
					srtbuilder.append(filtroFinal);
				} catch (NumberFormatException nfe) {}
			}
			else {
				String filtroFinal =  new DecimalFormat("#.##").format(Float.MAX_VALUE);
				srtbuilder.append(filtroFinal);
			}			
			
			return srtbuilder.toString();
		} 
		else {
			return null;
		}
	}

	/**
	 * Este mÃ©todo construye un filtro para la bÃºsqueda del riesgo total
	 * (Directo e Indirecto) usando el campo aprovisionado a tal efecto.
	 * 
	 * @param clientes
	 * 
	 * @return
	 */
	private String filtroRiesgoTotalAprovisionado(
			final MEJBuscarClientesDto clientes) {

		final StringBuilder filtroRiesgoBuilder = new StringBuilder();
		String campoBusqueda = (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO.equals(clientes.getTipoRiesgo()))
						? "PER_RIESGO_IND"
						: "PER_RIESGO_DISPUESTO";

		if (!StringUtils.isBlank(clientes.getMinRiesgoTotal())) {
			try {
				Float valor = Float.parseFloat(clientes.getMinRiesgoTotal());
				String filtroFinal = String.format(" AND (p.%s IS NOT NULL and p.%s>=%f)", campoBusqueda, campoBusqueda, valor);
				filtroRiesgoBuilder.append(filtroFinal);
			} catch (NumberFormatException nfe) {}
		}
		if (!StringUtils.isBlank(clientes.getMaxRiesgoTotal())) {
			try {
				Float valor = Float.parseFloat(clientes.getMaxRiesgoTotal());
				String filtroFinal = String.format(" AND (p.%s IS NOT NULL and p.%s<=%f)", campoBusqueda, campoBusqueda, valor);
				filtroRiesgoBuilder.append(filtroFinal);
			} catch (NumberFormatException nfe) {}
		}
		return filtroRiesgoBuilder.toString();
	}

	private void filtroFechas(MEJBuscarClientesDto clientes,
			String fechaMinima, String fechaMaxima, FiltroPersonaBuilder fpb) {

		if (StringUtils.isBlank(fechaMinima) || StringUtils.isBlank(fechaMaxima)) {
			return;
		}
		
		StringBuilder filtro = new StringBuilder();
		filtro.append("SELECT PER_ID FROM V_PER_PERSONAS_FORMULAS WHERE NVL(V_PER_PERSONAS_FORMULAS.DIAS_VENCIDO, 0) BETWEEN ");
		
		if (!StringUtils.isBlank(fechaMinima)) {
			filtro.append(fechaMinima);
		}
		else {
			filtro.append("0");
		}
		
		filtro.append(" AND ");
		
		if (!StringUtils.isBlank(fechaMaxima)) {
			filtro.append(fechaMaxima);
		}
		else {
			filtro.append(Integer.MAX_VALUE);
		}
				
		fpb.addFiltro(filtro.toString());
	}

	private void filtroMulticomboTipoGestion(MEJBuscarClientesDto clientes,
			StringBuilder hql, FiltroPersonaBuilder fpb) {
		// Si ha seleccionado representar clientes sin gestiÃƒÂ³n, decimos que
		// no tenga ningÃƒÂºn cliente activo
		if (DDTipoItinerario.ITINERARIO_ESPECIAL_SIN_GESTION.equals(clientes
				.getCodigoGestion())) {
			if (pasoDeVariables()) {
				hql.append(" and not exists (SELECT c.per_id FROM CLI_CLIENTES c where borrado = :no_borrado and c.per_id = p.per_id) ");
			} else {
				hql.append(" and not exists (SELECT c.per_id FROM CLI_CLIENTES c where borrado = 0 and c.per_id = p.per_id) ");
			}

		}

		// Si ha seleccionado un itinerario concreto, cruzamos con clientes
		else {
			// Subquery que busca personas con contrato de pase
			String filtroCodigoGestion = "SELECT c.per_id FROM CLI_CLIENTES c, ARQ_ARQUETIPOS a, ITI_ITINERARIOS i, ${master.schema}.DD_TIT_TIPO_ITINERARIOS dd "
					+ " WHERE c.arq_id = a.arq_id and a.iti_id = i.iti_id and i.dd_tit_id = dd.dd_tit_id "
					+ " and dd.dd_tit_codigo = '" + clientes.getCodigoGestion();
			// +
			if (pasoDeVariables()) {
				filtroCodigoGestion += "' and c.borrado = :no_borrado";
			} else {
				filtroCodigoGestion += "' and c.borrado = 0";
			}

			fpb.addFiltro(filtroCodigoGestion);
		}
	}

	private void filtroMulticomboSitFinancieraCnt(
			MEJBuscarClientesDto clientes, FiltroPersonaBuilder fpb) {
		String filtroSituacionFinancieraContrato = null;
		if (pasoDeVariables()) {
			filtroSituacionFinancieraContrato = "select cpe.per_id from CPE_CONTRATOS_PERSONAS cpe "
					+ " JOIN CNT_CONTRATOS c ON cpe.cnt_id = c.cnt_id "
					+ " JOIN DD_EFC_ESTADO_FINAN_CNT efc ON c.dd_efc_id = efc.dd_efc_id "
					+ " JOIN ${master.schema}.DD_ESC_ESTADO_CNT esc ON c.dd_esc_id = esc.dd_esc_id "
					+ " WHERE cpe.borrado = :no_borrado and dd_esc_codigo <> '"
					+ DDEstadoContrato.ESTADO_CONTRATO_CANCELADO
					+ "' AND DD_EFC_CODIGO IN (";
		} else {
			filtroSituacionFinancieraContrato = "select cpe.per_id from CPE_CONTRATOS_PERSONAS cpe "
					+ " JOIN CNT_CONTRATOS c ON cpe.cnt_id = c.cnt_id "
					+ " JOIN DD_EFC_ESTADO_FINAN_CNT efc ON c.dd_efc_id = efc.dd_efc_id "
					+ " JOIN ${master.schema}.DD_ESC_ESTADO_CNT esc ON c.dd_esc_id = esc.dd_esc_id "
					+ " WHERE cpe.borrado = 0 and dd_esc_codigo <> '"
					+ DDEstadoContrato.ESTADO_CONTRATO_CANCELADO
					+ "' AND DD_EFC_CODIGO IN (";
		}

		StringTokenizer tokensSituaciones = new StringTokenizer(
				clientes.getSituacionFinancieraContrato(), ",");

		while (tokensSituaciones.hasMoreTokens()) {
			filtroSituacionFinancieraContrato += "'"
					+ tokensSituaciones.nextElement() + "'";
			if (tokensSituaciones.hasMoreTokens()) {
				filtroSituacionFinancieraContrato += ",";
			}
		}
		filtroSituacionFinancieraContrato += ")";

		fpb.addFiltro(filtroSituacionFinancieraContrato);
	}

	private void filtroMulticomboSitFinanciera(MEJBuscarClientesDto clientes,
			FiltroPersonaBuilder fpb) {
		String filtroSituacionFinanciera = null;
		if (pasoDeVariables()) {
			filtroSituacionFinanciera = "SELECT per.per_id FROM PER_PERSONAS per, DD_EFC_ESTADO_FINAN_CNT efc "
					+ "WHERE per.borrado = :no_borrado and per.dd_efc_id = efc.dd_efc_id AND DD_EFC_CODIGO IN (";
		} else {
			filtroSituacionFinanciera = "SELECT per.per_id FROM PER_PERSONAS per, DD_EFC_ESTADO_FINAN_CNT efc "
					+ "WHERE per.borrado = 0 and per.dd_efc_id = efc.dd_efc_id AND DD_EFC_CODIGO IN (";

		}
		StringTokenizer tokensSituaciones = new StringTokenizer(
				clientes.getSituacionFinanciera(), ",");

		while (tokensSituaciones.hasMoreTokens()) {
			filtroSituacionFinanciera += "'" + tokensSituaciones.nextElement()
					+ "'";
			if (tokensSituaciones.hasMoreTokens()) {
				filtroSituacionFinanciera += ",";
			}
		}
		filtroSituacionFinanciera += ")";

		fpb.addFiltro(filtroSituacionFinanciera);
	}

	private void filtroMulticomboSituacion(MEJBuscarClientesDto clientes,
			StringBuilder hql) {
		StringTokenizer tokensSituaciones = new StringTokenizer(
				clientes.getSituacion(), ",");
		hql.append(" and cli.DD_EST_ID IN (SELECT DD_EST_ID FROM ${master.schema}.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO IN (");
		while (tokensSituaciones.hasMoreTokens()) {
			hql.append("'" + tokensSituaciones.nextElement() + "'");
			if (tokensSituaciones.hasMoreTokens()) {
				hql.append(",");
			}
		}
		hql.append(")) ");
	}

	private void filtroMulticomboSegmento(MEJBuscarClientesDto clientes,
			StringBuilder hql) {
		String segmentoPersona = clientes.getSegmento();
		if (segmentoPersona != null && segmentoPersona.length() > 0) {
			StringTokenizer tokensSegmentos = new StringTokenizer(
					segmentoPersona, ",");
			hql.append(" and p.DD_SCL_ID IN (SELECT DD_SCL_ID FROM DD_SCL_SEGTO_CLI WHERE DD_SCL_CODIGO IN (");
			while (tokensSegmentos.hasMoreTokens()) {
				hql.append("'" + tokensSegmentos.nextElement() + "'");
				if (tokensSegmentos.hasMoreTokens()) {
					hql.append(",");
				}
			}
			hql.append(")) ");
		}
	}

	private void filtroTipoProducto(MEJBuscarClientesDto clientes,
			FiltroPersonaBuilder fpb) {
		String selectTipoProductos = null;
		if (pasoDeVariables()) {
			selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPR_TIPO_PROD tpr, CPE_CONTRATOS_PERSONAS cpe "
					+ "WHERE c.dd_tpr_id = tpr.dd_tpr_id and c.borrado = :no_borrado and cpe.cnt_id = c.cnt_id and cpe.borrado = :no_borrado "
					+ "AND dd_tpr_codigo = '"
					+ clientes.getTipoProducto()
					+ "'";
		} else {
			selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPR_TIPO_PROD tpr, CPE_CONTRATOS_PERSONAS cpe "
					+ "WHERE c.dd_tpr_id = tpr.dd_tpr_id and c.borrado = 0 and cpe.cnt_id = c.cnt_id and cpe.borrado = 0 "
					+ "AND dd_tpr_codigo = '"
					+ clientes.getTipoProducto()
					+ "'";

		}
		fpb.addFiltro(selectTipoProductos);
	}

	private void filtroTipoProductoEntidad(MEJBuscarClientesDto clientes,
			FiltroPersonaBuilder fpb) {
		String selectTipoProductos = null;
		if (pasoDeVariables()) {
			selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPE_TIPO_PROD_ENTIDAD tpe, CPE_CONTRATOS_PERSONAS cpe "
					+ "WHERE c.dd_tpe_id = tpe.dd_tpe_id and c.borrado = :no_borrado and cpe.cnt_id = c.cnt_id and cpe.borrado = :no_borrado "
					+ "AND dd_tpe_codigo = '"
					+ clientes.getTipoProductoEntidad() + "'";
		} else {
			selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPE_TIPO_PROD_ENTIDAD tpe, CPE_CONTRATOS_PERSONAS cpe "
					+ "WHERE c.dd_tpe_id = tpe.dd_tpe_id and c.borrado = 0 and cpe.cnt_id = c.cnt_id and cpe.borrado = 0 "
					+ "AND dd_tpe_codigo = '"
					+ clientes.getTipoProductoEntidad() + "'";
		}

		fpb.addFiltro(selectTipoProductos);
	}

	private void filtroNumeroContrato(MEJBuscarClientesDto clientes,
			FiltroPersonaBuilder fpb) {
		String filtroContrato = null;

		if (pasoDeVariables()) {
			filtroContrato = "SELECT cp.per_id FROM CNT_CONTRATOS c, CPE_CONTRATOS_PERSONAS cp "
					+ " WHERE c.borrado = :no_borrado and c.cnt_id = cp.cnt_id and cp.borrado = :no_borrado and c.CNT_CONTRATO like '%"
					+ clientes.getNroContrato().trim() + "%'";
		} else {
			filtroContrato = "SELECT cp.per_id FROM CNT_CONTRATOS c, CPE_CONTRATOS_PERSONAS cp "
					+ " WHERE c.borrado = 0 and c.cnt_id = cp.cnt_id and cp.borrado = 0 and c.CNT_CONTRATO like '%"
					+ clientes.getNroContrato().trim() + "%'";
		}
		fpb.addFiltro(filtroContrato);
	}

	private void filtroContratoPase(FiltroPersonaBuilder fpb) {
		// Subquery que busca personas con contrato de pase
		String filtroContratoPase = null;

		if (pasoDeVariables()) {
			filtroContratoPase = "SELECT cp.per_id FROM CNT_CONTRATOS c"
					+ ", CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
					+ ", CLI_CLIENTES cli, CCL_CONTRATOS_CLIENTE ccl"
					+ " WHERE cp.borrado = :no_borrado "
					+ " AND cp.cnt_id = c.cnt_id and c.borrado = :no_borrado"
					+ " AND cp.dd_tin_id = tin.dd_tin_id"
					+ " AND tin.DD_TIN_TITULAR = 1 "
					+ " AND cli.cli_id = ccl.cli_id AND ccl.cnt_id = cp.cnt_id "
					+ " AND cli.per_id = cp.per_id"
					+ " AND ccl.ccl_pase = 1 AND cp.cpe_orden = 1";

		} else {
			filtroContratoPase = "SELECT cp.per_id FROM CNT_CONTRATOS c"
					+ ", CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
					+ ", CLI_CLIENTES cli, CCL_CONTRATOS_CLIENTE ccl"
					+ " WHERE cp.borrado = 0 "
					+ " AND cp.cnt_id = c.cnt_id and c.borrado = 0"
					+ " AND cp.dd_tin_id = tin.dd_tin_id"
					+ " AND tin.DD_TIN_TITULAR = 1 "
					+ " AND cli.cli_id = ccl.cli_id AND ccl.cnt_id = cp.cnt_id "
					+ " AND cli.per_id = cp.per_id"
					+ " AND ccl.ccl_pase = 1 AND cp.cpe_orden = 1";

		}

		fpb.addFiltro(filtroContratoPase);
	}

	private void filtroTipoIntervencion(MEJBuscarClientesDto clientes,
			FiltroPersonaBuilder fpb) {
		// Subquery que busca personas con algÃƒÂºn tipo de intervenciÃƒÂ³n
		String filtroTipoIntervencion = null;

		if (pasoDeVariables()) {
			filtroTipoIntervencion = "SELECT cp.per_id FROM CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
					+ " WHERE cp.borrado = :no_borrado "
					+ " AND tin.dd_tin_id = cp.dd_tin_id";
		} else {
			filtroTipoIntervencion = "SELECT cp.per_id FROM CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
					+ " WHERE cp.borrado = 0 "
					+ " AND tin.dd_tin_id = cp.dd_tin_id";
		}

		if (EXTPersonaDao.BUSQUEDA_PRIMER_TITULAR.equals(clientes
				.getTipoIntervercion())) {
			filtroTipoIntervencion += " and cp.CPE_ORDEN = 1 ";
			filtroTipoIntervencion += " and tin.DD_TIN_TITULAR = 1 ";
		} else if (EXTPersonaDao.BUSQUEDA_TITULARES.equals(clientes
				.getTipoIntervercion())) {
			filtroTipoIntervencion += " and tin.DD_TIN_TITULAR = 1 ";
		} else if (EXTPersonaDao.BUSQUEDA_AVALISTAS.equals(clientes
				.getTipoIntervercion())) {
			filtroTipoIntervencion += " and tin.DD_TIN_TITULAR = 0 ";
		}

		fpb.addFiltro(filtroTipoIntervencion);
	}

	private void filtroTipoPersona(MEJBuscarClientesDto clientes,
			StringBuilder hql, Map<String, Object> parameters) {
		if (pasoDeVariables()) {
			hql.append(" and tpe.DD_TPE_CODIGO = :tipoDePersona");
			parameters.put("tipoDePersona", clientes.getTipoPersona());
		} else {
			hql.append(" and tpe.DD_TPE_CODIGO = '" + clientes.getTipoPersona()
					+ "' ");
		}
	}

	private void filtroNifPersona(MEJBuscarClientesDto clientes,
			StringBuilder hql, Map<String, Object> parameters) {
		String nifPersona = clientes.getDocId().trim().toUpperCase();

		if (pasoDeVariables()) {
			hql.append(" and p.PER_DOC_ID like :nifpersona ");
			parameters.put("nifpersona", "%" + nifPersona + "%");

		} else {
			hql.append(" and p.PER_DOC_ID like '%" + nifPersona + "%' ");
		}

	}

	private void filtroApellido2(MEJBuscarClientesDto clientes,
			StringBuilder hql) {
		String apellido2Persona = clientes.getApellido2().trim().toLowerCase();

		hql.append(" and lower(p.PER_APELLIDO2) like '%" + apellido2Persona
				+ "%' ");
	}

	private void filtroApellido1(MEJBuscarClientesDto clientes,
			StringBuilder hql) {
		String apellido1Persona = clientes.getApellido1().trim().toLowerCase();

		hql.append(" and lower(p.PER_APELLIDO1) like '%" + apellido1Persona
				+ "%' ");
	}

	private void filtroNombrePersona(MEJBuscarClientesDto clientes,
			StringBuilder hql) {
		String nombrePersona = clientes.getNombre().trim().toLowerCase();
		hql.append(" and lower(p.PER_NOMBRE) like '%" + nombrePersona + "%' ");
	}

	private void filtroCodigoCliente(MEJBuscarClientesDto clientes,
			StringBuilder hql) {
		String codigoCliente = clientes.getCodigoEntidad().trim();
		hql.append(" and p.PER_COD_CLIENTE_ENTIDAD like '%" + codigoCliente
				+ "%'");
	}

	private void filtroEstadoPersona(MEJBuscarClientesDto clientes,
			StringBuilder hql) {
		int cantPer = 0;
		List<Perfil> perfiles = clientes.getPerfiles();
		if (perfiles != null) {
			cantPer = perfiles.size();
		}
		if (cantPer > 0) {
			hql.append(" and ( ");

			StringBuilder listadoPerfiles = new StringBuilder();
			for (Perfil p : perfiles) {
				listadoPerfiles.append(p.getId() + ",");
			}
			listadoPerfiles.delete(listadoPerfiles.length() - 1,
					listadoPerfiles.length());

			hql.append(" est.PEF_ID_GESTOR IN (").append(listadoPerfiles)
					.append(") ");

			// Solo permitimos ver personas de este itinerario al supervisor
			// si no se trata de la bÃƒÂºsqueda por GV
			// Los supervisores de GV no tienen que ver personas en gestion
			// de vencidos
			if (!clientes.getIsBusquedaGV()) {
				hql.append(" or est.PEF_ID_SUPERVISOR IN (")
						.append(listadoPerfiles).append(") ");
			}

			hql.append(" ) ");
		}
	}

	private void filtroSituacionConcursal(MEJBuscarClientesDto clientes,
			StringBuilder hql) {
		hql.append("and p.per_id in (select cli_per.per_id from cli_clientes cli_per, ext_icc_info_extra_cli icc where ICC.DD_IFX_ID='21' and cli_per.cli_id = icc.cli_id and ICC.ICC_VALUE = '"
				+ clientes.getConcurso() + "')");
	}

	private boolean isNecesitaCruzarSaldos(boolean saldovencido,
			boolean riesgoTotal, String fechaMinima, String fechaMaxima) {
		return saldovencido || riesgoTotal || fechaMinima != null
				|| fechaMaxima != null;
	}

	private String calculaFechaMaxima(MEJBuscarClientesDto clientes) {
		String fechaMaxima = null;
		if (clientes.getMaxDiasVencido() != null
				&& clientes.getMaxDiasVencido().length() > 0) {
			fechaMaxima = clientes.getMaxDiasVencido();
		}
		return fechaMaxima;
	}

	private String calculaFechaMinima(MEJBuscarClientesDto clientes) {
		String fechaMinima = null;
		if (clientes.getMinDiasVencido() != null
				&& clientes.getMinDiasVencido().length() > 0) {
			fechaMinima = clientes.getMinDiasVencido();
		}
		return fechaMinima;
	}

	private boolean compruebaRiesgoTotal(MEJBuscarClientesDto clientes) {
		boolean riesgoTotal = false;
		if (clientes.getMaxRiesgoTotal() == null
				|| clientes.getMaxRiesgoTotal().length() < 1) {
			clientes.setMaxRiesgoTotal("" + Integer.MAX_VALUE);
		} else {
			riesgoTotal = true;
		}
		if (clientes.getMinRiesgoTotal() == null
				|| clientes.getMinRiesgoTotal().length() < 1) {
			clientes.setMinRiesgoTotal("" + Integer.MIN_VALUE);
		} else {
			riesgoTotal = true;
		}
		return riesgoTotal;
	}

	private boolean compruebaSaldoVencido(MEJBuscarClientesDto clientes) {
		boolean saldovencido = false;
		if (clientes.getMaxSaldoVencido() == null
				|| clientes.getMaxSaldoVencido().length() < 1) {
			clientes.setMaxSaldoVencido("" + Integer.MAX_VALUE);
		} else {
			saldovencido = true;
		}
		if (clientes.getMinSaldoVencido() == null
				|| clientes.getMinSaldoVencido().length() < 1) {
			clientes.setMinSaldoVencido("" + Integer.MIN_VALUE);
		} else {
			saldovencido = true;
		}
		return saldovencido;
	}

	private boolean isNecesitaCruzarEstado(MEJBuscarClientesDto clientes) {
		return clientes.getIsBusquedaGV() != null
				&& clientes.getIsBusquedaGV().booleanValue();
	}

	private boolean isNecesitaCruzarCliente(MEJBuscarClientesDto clientes) {
		return isNecesitaCruzarEstado(clientes)
				|| (clientes.getSituacion() != null && clientes.getSituacion()
						.length() > 0)
				|| (clientes.getIsPrimerTitContratoPase() != null && clientes
						.getIsPrimerTitContratoPase().booleanValue());
	}

	/**
	 * Construye la clausula orderBy en SQL en funciÃƒÂ³n del parÃƒÂ¡metro que le
	 * pasa.
	 * 
	 * @param clientes
	 *            El dto para extraer la columna y la orientaciÃƒÂ³n de la
	 *            ordenaciÃƒÂ³n
	 * @return La clausula order by generada
	 */
	private String getOrderBy(DtoBuscarClientes clientes) {
		String orderBy = null;
		String campo = clientes.getSort();

		if (campo == null || campo.length() == 0) {
			return null;
		}

		if (campo.equals("nombre")) {
			orderBy = " ORDER BY p.per_nombre ";
		}

		else if (campo.equals("apellido1") || campo.equals("apellidos")) {
			orderBy = " ORDER BY p.per_apellido1 ";
		}

		else if (campo.equals("apellido2")) {
			orderBy = " ORDER BY p.per_apellido2 ";
		}

		else if (campo.equals("codClienteEntidad")) {
			orderBy = " ORDER BY p.per_cod_cliente_entidad ";
		}

		else if (campo.equals("docId")) {
			orderBy = " ORDER BY p.per_doc_id ";
		}

		else if (campo.equals("telefono1")) {
			orderBy = " ORDER BY p.per_telefono_1 ";
		}

		// Saldo vencido
		else if (campo.equals("riesgoAutorizado")) {
			orderBy = " ORDER BY p.PER_RIESGO_AUTORIZADO ";
		}

		else if (campo.equals("dispuestoVencido")) {
			orderBy = " ORDER BY p.PER_RIESGO_DIR_VENCIDO ";
		}
		
		else if (campo.equals("dispuestoNoVencido")) {
			orderBy = " ORDER BY p.PER_RIESGO_DIR_DANYADO ";
		}
		
		else if (campo.equals("riesgoDispuesto")) {
			orderBy = "ORDER BY p.PER_RIESGO_DISPUESTO ";
		}
		
		
		// Riesgo total
		else if (campo.equals("totalSaldo")) {
			orderBy = " ORDER BY p.PER_TOTAL_SALDO ";
		}

		// Riesgo directo
		else if (campo.equals("deudaDirecta")) {
			orderBy = " ORDER BY p.PER_RIESGO_DIR_VENCIDO ";
		}

		// Riesgo Directo DaÃƒÂ±ado
		else if (campo.equals("riesgoDirectoNoVencidoDanyado")) {
			orderBy = " ORDER BY p.PER_VR_DANIADO_OTRAS_ENT ";
		}

		// Num contratos
		else if (campo.equals("numContratos")) {
			orderBy = " ORDER BY p.PER_NUM_CONTRATOS ";
		}

		if (orderBy != null && clientes.getDir() != null) {
			orderBy += " " + clientes.getDir();
		}

		return orderBy;
	}	

	/**
	 * Construye la clausula orderBy en Hibernate en funciÃƒÂ³n del parÃƒÂ¡metro que le
	 * pasa.
	 * 
	 * @param clientes
	 *            El dto para extraer la columna y la orientaciÃƒÂ³n de la
	 *            ordenaciÃƒÂ³n
	 * @return La clausula order by generada
	 */
	private String getHibernateOrderBy(DtoBuscarClientes clientes) {
		String orderBy = null;
		String campo = clientes.getSort();

		if (campo == null || campo.length() == 0) {
			return null;
		}

		if (campo.equals("nombre")) {
			orderBy = " ORDER BY p.nombre ";
		}

		else if (campo.equals("apellido1") || campo.equals("apellidos")) {
			orderBy = " ORDER BY p.apellido1 ";
		}

		else if (campo.equals("apellido2")) {
			orderBy = " ORDER BY p.apellido2 ";
		}

		else if (campo.equals("codClienteEntidad")) {
			orderBy = " ORDER BY p.codClienteEntidad ";
		}

		else if (campo.equals("docId")) {
			orderBy = " ORDER BY p.docId ";
		}

		else if (campo.equals("telefono1")) {
			orderBy = " ORDER BY p.telefono1 ";
		}

		// Saldo vencido
		else if (campo.equals("riesgoAutorizado")) {
			orderBy = " ORDER BY p.riesgoAutorizado ";
		}

		else if (campo.equals("dispuestoVencido")) {
			orderBy = " ORDER BY p.riesgoDirectoVencido ";
		}
		
		else if (campo.equals("dispuestoNoVencido")) {
			orderBy = " ORDER BY p.riesgoDirectoDanyado ";
		}
		
		else if (campo.equals("riesgoDispuesto")) {
			orderBy = "ORDER BY p.riesgoDispuesto ";
		}
		
		// Riesgo total
		else if (campo.equals("totalSaldo")) {
			orderBy = " ORDER BY p.totalSaldo ";
		}

		// Riesgo directo
		else if (campo.equals("deudaDirecta")) {
			orderBy = " ORDER BY p.riesgoDirecto ";
		}

		// Riesgo Directo DaÃƒÂ±ado
		else if (campo.equals("riesgoDirectoNoVencidoDanyado")) {
			orderBy = " ORDER BY p.riesgoDirectoNoVencidoDanyado ";
		}
		
		// Num contratos
		else if (campo.equals("numContratos")) {
			orderBy = " ORDER BY p.numContratos ";
		}

		if (orderBy != null && clientes.getDir() != null) {
			orderBy += " " + clientes.getDir();
		}

		return orderBy;
	}

	@Override
	public String getGestorSolvencias(Long idPersona) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page findClientesPaginated(DtoBuscarClientes clientes,
			Usuario usuarioLogueado) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int buscarClientesPaginadosCount(MEJBuscarClientesDto clientes,
			Usuario usuLogado, boolean conCarterizacion) {
		final HashMap<String, Object> parameters = new HashMap<String, Object>();

		String hql = createQueryForCount(generateHQLClientesFilterSQL(clientes,
				usuLogado, conCarterizacion, parameters));
		try {
			Query q = getSession().createSQLQuery(hql);

			return ((BigDecimal) q.list().get(0)).intValue();

		} catch (RuntimeException t) {
			throw t;
		}
	}

	/**
	 * Este mÃ©todo obtiene la configuraciÃ³n de devon.properties sobre si
	 * queremos usar o no paso de variables para las consultas en Oracle. Cachea
	 * el valor en la propiedad pasoVariables
	 * 
	 * @return TRUE Si usamos paso de variables, FALSE si usamos paso de
	 *         constantes
	 */
	private boolean pasoDeVariables() {
		if (pasoVariables == null) { // inicializaciÃ³n
			final String testPasoVar = appProperties
					.getProperty("test.oraclevars.clientes");
			if (testPasoVar == null) {
				// Valor por default
				pasoVariables = Boolean.FALSE;
			} else {
				try {
					final int op = Integer.parseInt(testPasoVar.trim());
					switch (op) {
					case 1:
						pasoVariables = Boolean.FALSE;
						break;
					case 2:
						pasoVariables = Boolean.TRUE;
						break;
					default:
						pasoVariables = Boolean.FALSE;
						break;
					}

				} catch (NumberFormatException nfe) {
					// Usamos el valor por default
					pasoVariables = Boolean.FALSE;
				}
			}
		} // fin inicializaciÃ³n
		return pasoVariables;
	}

	/**
	 * createQueryForCount.
	 * 
	 * @param query
	 *            query original
	 * @return count query
	 */
	private String createQueryForCount(String query) {
		StringBuffer queryR = new StringBuffer();
		if (query.toUpperCase().indexOf("SELECT") >= 0) {
			int fromOn = query.toUpperCase().indexOf("FROM");
			queryR.append("select count(*) ").append(query.substring(fromOn));
		} else {
			queryR.append("select count(*) ").append(query);
		}
		return queryR.toString();
	}

}