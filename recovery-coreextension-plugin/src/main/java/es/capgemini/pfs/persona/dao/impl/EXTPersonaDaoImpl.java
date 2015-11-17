package es.capgemini.pfs.persona.dao.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.persona.dao.EXTPersonaDao;
import es.capgemini.pfs.persona.dto.EXTDtoBuscarClientes;
import es.capgemini.pfs.persona.dto.EXTDtoClienteResultado;
import es.capgemini.pfs.persona.model.EXTPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.impl.visibilidad.model.EXTDDTipoVisibilidad ;


@Repository("EXTPersonaDao")
public class EXTPersonaDaoImpl extends AbstractEntityDao<EXTPersona, Long>
		implements EXTPersonaDao {

	@Autowired
	private GenericABMDao genericDao;

	 /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Persona> findClientesProveedorSolvenciaExcel(EXTDtoBuscarClientes clientes, GestorDespacho gestor) {
    	String hql = " from EXTPersona per where per.id = ?";
        List<Persona> list = new ArrayList();
        String sqlPersonas = generateHQLClientesFilterSQL(clientes,gestor);
       
        Query q = getSession().createSQLQuery(sqlPersonas);
        List<BigDecimal> idList = q.list();

        Persona pp = null;

        for (BigDecimal id : idList) {
            pp = (Persona) getHibernateTemplate().find(hql, Long.valueOf(id.longValue())).get(0);
            list.add(pp);
        }

        return list;
    }
    
	@Override
	public Page findClientesProveedorSolvenciaPaginated(EXTDtoBuscarClientes clientes, GestorDespacho gestor) {
		String hql = " from EXTPersona per where per.id = ?";

		String sqlPersonas = generateHQLClientesFilterSQL(clientes, gestor);
		PageSql page = new PageSql();

		try {
			// Recuperamos los Ids de las personas a mostrar

			Query q = getSession().createSQLQuery(sqlPersonas);
			List<BigDecimal> idList = q.list();
			int size = idList.size();

			int fromIndex = clientes.getStart();
			int toIndex = clientes.getStart() + clientes.getLimit();

			// Paginado, si no existe, creamos la paginaci�n nosotros
			if (fromIndex < 0 || toIndex < 0) {
				fromIndex = 0;
				toIndex = 25;
			}
			if (idList.size() >= clientes.getStart() + clientes.getLimit())
				idList = idList.subList(clientes.getStart(),
						clientes.getStart() + clientes.getLimit());
			else
				idList = idList.subList(clientes.getStart(), idList.size());

			List<Object> list = new ArrayList<Object>();
			for (BigDecimal objId : idList) {
				List<Object> o = getHibernateTemplate().find(hql,
						Long.valueOf(objId.longValue()));
				if (o != null && o.size() > 0) {
					Object qObj = o.get(0);
					list.add(qObj);
				}
			}

			page.setTotalCount(size);
			page.setResults(list);
		} catch (Exception e) {
			logger.error(sqlPersonas, e);
		}

		return page;
	}

	/**
	 * {@inheritDoc}
	 */
	public Long obtenerCantidadDeVencidosUsuario(DtoBuscarClientes clientes, boolean conCarterizacion, Usuario usuarioLogado) {
		StringBuffer query = new StringBuffer();
//		if (conCarterizacion)
//			query = generateHQLClientesFilterSQL(clientes, conCarterizacion, usuarioLogado);
//		else
//			query = generateHQLClientesVencidosFilterSQL(clientes, conCarterizacion, usuarioLogado);
		query.append("SELECT count(*) FROM (").append(generateHQLClientesVencidosFilterSQL(clientes, conCarterizacion, usuarioLogado)).append(")");
		Long cantidad = ((BigDecimal) getSession().createSQLQuery(query.toString())
				.uniqueResult()).longValue();

		if (cantidad == null) {
			cantidad = 0L;
		}

		return cantidad;
	}

	private String generateHQLClientesVencidosFilterSQL(
			DtoBuscarClientes clientes, boolean conCarterizacion,
			Usuario usuarioLogado) {
		StringBuilder hql = new StringBuilder("SELECT distinct v.per_id from V_CVE_CLIENTES_VENCIDOS_USU v where (1=1) ");
		
		// VISIBILIADA POR ZONAS
		int cantZonas = clientes.getCodigoZonas().size();
		String zonas = null;
		
		if (cantZonas > 0) {
			zonas = " and ( ";
			for (String codigoZ : clientes.getCodigoZonas()) {
				zonas += " v.zon_cod like '" + codigoZ + "%' OR";
			}
			zonas = zonas.substring(0, zonas.length() - 2);
			zonas += " ) ";
			
			hql.append(zonas);
		}
		
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

			hql.append(" v.pef_id_gestor IN (")
					.append(listadoPerfiles).append(") ");

			hql.append(" ) ");
		}
		
		// Check tipo de gestion
		if (clientes.getCodigoGestion() != null
				&& clientes.getCodigoGestion().length() != 0) {
			hql.append(" and (v.dd_tit_codigo = '").append(clientes.getCodigoGestion()).append("')");

		}
		
		// A�adimos soporte para perfiles carterizados
		if (conCarterizacion) {
			//hql.append(" and (v.pef_es_carterizado = 1 or "
			hql.append(" and (v.pef_es_carterizado = 1 and "		
					+ usuarioLogado.getId()
					+ " in (select usu_id " +
					"from ge_gestor_entidad ge " +
					"join unmaster.dd_ein_entidad_informacion ein on ge.dd_ein_id = ein.dd_ein_id " +
					"where ein.dd_ein_codigo = '" +DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE + "' and ge.ug_id = v.per_id))");
		}
		
		String query = hql.toString() + " ";
		
		return query;
	}

	/**
	 * Genera la query en SQL que devolver� los IDs de los clientes filtrados y
	 * ordenados.
	 * 
	 * @param clientes
	 *            El Dto con los filtros
	 * @param gestor
	 * @return La query en SQL
	 */
	private String generateHQLClientesFilterSQL(EXTDtoBuscarClientes clientes,
			GestorDespacho gestor) {
		StringBuilder hql = new StringBuilder(
				"SELECT distinct p.per_id from PER_PERSONAS p ");
		hql.append(" JOIN ${master.schema}.DD_TPE_TIPO_PERSONA tpe ON tpe.dd_tpe_id = p.dd_tpe_id ");

		boolean necesitaCruzarCliente = ((clientes.getIsBusquedaGV() != null && clientes
				.getIsBusquedaGV().booleanValue())
				|| (clientes.getSituacion() != null && clientes.getSituacion()
						.length() > 0) || (clientes
				.getIsPrimerTitContratoPase() != null && clientes
				.getIsPrimerTitContratoPase().booleanValue()));

		boolean necesitaCruzarEstado = (clientes.getIsBusquedaGV() != null && clientes
				.getIsBusquedaGV().booleanValue());

		boolean saldovencido = false;
		boolean riesgoTotal = false;

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

		String fechaMinima = null;
		String fechaMaxima = null;

		if (clientes.getMinDiasVencido() != null
				&& clientes.getMinDiasVencido().length() > 0) {
			fechaMinima = clientes.getMinDiasVencido();
		}

		if (clientes.getMaxDiasVencido() != null
				&& clientes.getMaxDiasVencido().length() > 0) {
			fechaMaxima = clientes.getMaxDiasVencido();
		}

		if (necesitaCruzarCliente) {
			hql.append(" JOIN CLI_CLIENTES cli ON cli.per_id = p.per_id AND cli.borrado = 0 ");
		}
		if (necesitaCruzarEstado) {
			hql.append(" JOIN EST_ESTADOS est ON est.DD_EST_ID = cli.DD_EST_ID ");
			hql.append(" JOIN ARQ_ARQUETIPOS arq ON cli.ARQ_ID = arq.ARQ_ID and arq.ITI_ID = est.ITI_ID ");
		}
		boolean necesitaCruzarSaldos = (saldovencido || riesgoTotal
				|| fechaMinima != null || fechaMaxima != null);

		if (!Checks.esNulo(gestor)) {
			hql.append(" JOIN VSB_VISIBILIDAD visib ON visib.VSB_ID = p.VSB_ID ");
			hql.append(" JOIN DD_TVB_TIPO_VISIBILIDAD tipovisib ON tipovisib.DD_TVB_ID = visib.DD_TVB_ID and tipovisib.DD_TVB_CODIGO ='"
					+ EXTDDTipoVisibilidad.CODIGO_VISIBILIDAD_DESPACHO + "'");

		}
		int cantZonas = clientes.getCodigoZonas().size();
		String zonas = null;

		if (cantZonas > 0) {
			// Si es primer titular del contrato de pase buscamos directamente
			// en los clientes
			if (clientes.getIsPrimerTitContratoPase() != null
					&& clientes.getIsPrimerTitContratoPase().booleanValue()) {
				hql.append(" JOIN CLI_CLIENTES cli ON cli.per_id=p.per_id JOIN OFI_OFICINAS o ON cli.ofi_id = o.ofi_id JOIN ZON_ZONIFICACION zon ON zon.ofi_id = o.ofi_id WHERE cli.borrado = 0  ");
			} else {
				// filtroJerarquia =
				// "SELECT cp.per_id FROM CNT_CONTRATOS c, CPE_CONTRATOS_PERSONAS cp, ZON_ZONIFICACION zon "
				// +
				// " WHERE cp.borrado = 0 and c.borrado = 0 and cp.cnt_id = c.cnt_id AND c.ZON_ID = zon.ZON_ID "
				// + jerarquia;
				hql.append("join cpe_contratos_personas cp on cp.per_id=p.per_id and cp.borrado=0 "
						+ "join  CNT_CONTRATOS c on c.cnt_id=cp.cnt_id and c.borrado=0 "
						+ "JOIN  ZON_ZONIFICACION zon on zon.zon_id=c.zon_id ");

			}
		}

		hql.append("WHERE p.borrado = 0 ");

		// A�ADIR QUE LA PERSONA TENGA LA VISIBILIDAD POR DESPACHO
		if (!Checks.esNulo(gestor)) {
			String filtroSolvencia = clientes.getFiltroSolvenciaRevisada();
			if (filtroSolvencia != null
					&& !filtroSolvencia.equalsIgnoreCase("")) {

				if (filtroSolvencia.equalsIgnoreCase("SI"))
					hql.append(" and p.PER_FECHA_REV_SOLVENCIA is not null ");

				if (filtroSolvencia.equalsIgnoreCase("NO"))
					hql.append(" and p.PER_FECHA_REV_SOLVENCIA is null ");
			}
			// hql.append(" and p.PER_FECHA_REV_SOLVENCIA is null ");
			hql.append(" and visib.VSB_IDENTIDAD="
					+ gestor.getDespachoExterno().getId());

			// VISIBILIADA POR ZONAS
			if (cantZonas > 0) {
				zonas = " and ( ";
				StringBuffer sbZonas = new StringBuffer();
				for (String codigoZ : clientes.getCodigoZonas()) {
					sbZonas.append(" zon.zon_cod like '" + codigoZ + "%' OR");
				}
				zonas += sbZonas.toString();
				zonas = zonas.substring(0, zonas.length() - 2);
				zonas += " ) ";

			}

			String jerarquia = null;
			if (clientes.getJerarquia() != null
					&& clientes.getJerarquia().length() > 0) {
				jerarquia = " and zon.ZON_ID >= " + clientes.getJerarquia();
				if (zonas != null)
					jerarquia += zonas;
			} else if (zonas != null) {
				jerarquia = zonas;
			}

			if (jerarquia != null) {
				hql.append(jerarquia);
			}

			if (necesitaCruzarEstado) {
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

					hql.append(" est.PEF_ID_GESTOR IN (")
							.append(listadoPerfiles).append(") ");

					// Solo permitimos ver personas de este itinerario al
					// supervisor si no se trata de la b�squeda por GV
					// Los supervisores de GV no tienen que ver personas en
					// gestion de vencidos
					if (!clientes.getIsBusquedaGV()) {
						hql.append(" or est.PEF_ID_SUPERVISOR IN (")
								.append(listadoPerfiles).append(") ");
					}

					hql.append(" ) ");
				}
			}

			// Input de c�digo de cliente
			String codigoCliente = clientes.getCodigoEntidad();
			if (codigoCliente != null) {
				codigoCliente = codigoCliente.trim();
				if (codigoCliente.length() > 0) {
					hql.append(" and p.PER_COD_CLIENTE_ENTIDAD = "
							+ codigoCliente + " ");
				}
			}

			// Input de nombre de persona
			String nombrePersona = clientes.getNombre();
			if (nombrePersona != null) {
				nombrePersona = nombrePersona.trim().toLowerCase();

				if (nombrePersona.length() > 0) {
					hql.append(" and lower(p.PER_NOMBRE) like '%"
							+ nombrePersona + "%' ");
				}
			}

			// Input de apellido de persona
			String apellido1Persona = clientes.getApellido1();
			if (apellido1Persona != null) {
				apellido1Persona = apellido1Persona.trim().toLowerCase();

				if (apellido1Persona.length() > 0) {
					hql.append(" and lower(p.PER_APELLIDO1) like '%"
							+ apellido1Persona + "%' ");
				}
			}

			// Input de segundo apellido de persona
			String apellido2Persona = clientes.getApellido2();
			if (apellido2Persona != null) {
				apellido2Persona = apellido2Persona.trim().toLowerCase();

				if (apellido2Persona.length() > 0) {
					hql.append(" and lower(p.PER_APELLIDO2) like '%"
							+ apellido2Persona + "%' ");
				}
			}

			// Input de nif de persona
			String nifPersona = clientes.getDocId();
			if (nifPersona != null) {
				nifPersona = nifPersona.trim().toUpperCase();

				if (nifPersona.length() > 0) {
					hql.append(" and p.PER_DOC_ID like '%" + nifPersona + "%' ");
					// hql.append(" and lower(p.docId) like '%" +
					// clientes.getNif().toLowerCase() + "%' ");
				}
			}

			// Combo tipo de persona
			if (clientes.getTipoPersona() != null
					&& clientes.getTipoPersona().length() > 0) {
				hql.append(" and tpe.DD_TPE_CODIGO = '"
						+ clientes.getTipoPersona() + "' ");
			}

			String sqlPersonaId = null;

			// Combo Tipo de intervencion
			if (clientes.getTipoIntervercion() != null
					&& clientes.getTipoIntervercion().length() > 0
					&& (clientes.getIsPrimerTitContratoPase() == null || !clientes
							.getIsPrimerTitContratoPase())) {

				// Subquery que busca personas con alg�n tipo de intervenci�n
				String filtroTipoIntervencion = "SELECT cp.per_id FROM CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
						+ " WHERE cp.borrado = 0 "
						+ " AND tin.dd_tin_id = cp.dd_tin_id";

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

				sqlPersonaId = "(" + filtroTipoIntervencion + ")";
			}

			// Check contrato de pase
			if (clientes.getIsPrimerTitContratoPase() != null
					&& clientes.getIsPrimerTitContratoPase().booleanValue()) {
				// Subquery que busca personas con contrato de pase
				String filtroContratoPase = "SELECT cp.per_id FROM CNT_CONTRATOS c"
						+ ", CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
						+ ", CLI_CLIENTES cli, CCL_CONTRATOS_CLIENTE ccl"
						+ " WHERE cp.borrado = 0 "
						+ " AND cp.cnt_id = c.cnt_id and c.borrado = 0"
						+ " AND cp.dd_tin_id = tin.dd_tin_id"
						+ " AND tin.DD_TIN_TITULAR = 1 "
						+ " AND cli.cli_id = ccl.cli_id AND ccl.cnt_id = cp.cnt_id "
						+ " AND cli.per_id = cp.per_id"
						+ " AND ccl.ccl_pase = 1 AND cp.cpe_orden = 1";

				if (sqlPersonaId == null) {
					sqlPersonaId = "(" + filtroContratoPase + ")";
				} else {
					sqlPersonaId += " INTERSECT (" + filtroContratoPase + ")";
				}
			}

			// Input n�mero de contrato
			if (clientes.getNroContrato() != null
					&& clientes.getNroContrato().length() > 0) {

				String filtroContrato = "SELECT cp.per_id FROM CNT_CONTRATOS c, CPE_CONTRATOS_PERSONAS cp "
						+ " WHERE c.borrado = 0 and c.cnt_id = cp.cnt_id and cp.borrado = 0 and c.CNT_CONTRATO like '%"
						+ clientes.getNroContrato() + "%'";

				if (sqlPersonaId == null) {
					sqlPersonaId = "(" + filtroContrato + ")";
				} else {
					sqlPersonaId += " INTERSECT (" + filtroContrato + ")";
				}
			}

			// Multicombo tipo de producto
			if ((clientes.getTipoProducto() != null && clientes
					.getTipoProducto().length() > 0)) {
				String selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPR_TIPO_PROD tpr, CPE_CONTRATOS_PERSONAS cpe "
						+ "WHERE c.dd_tpr_id = tpr.dd_tpr_id and c.borrado = 0 and cpe.cnt_id = c.cnt_id and cpe.borrado = 0 "
						+ "AND dd_tpr_codigo = '"
						+ clientes.getTipoProducto()
						+ "'";

				if (sqlPersonaId == null) {
					sqlPersonaId = "(" + selectTipoProductos + ")";
				} else {
					sqlPersonaId += " INTERSECT (" + selectTipoProductos + ")";
				}

			}
			
			// Multicombo tipo de producto
			if ((clientes.getTipoProductoEntidad() != null && clientes
					.getTipoProductoEntidad().length() > 0)) {
				String selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPE_TIPO_PROD_ENTIDAD tpe, CPE_CONTRATOS_PERSONAS cpe "
						+ "WHERE c.dd_tpe_id = tpe.dd_tpe_id and c.borrado = 0 and cpe.cnt_id = c.cnt_id and cpe.borrado = 0 "
						+ "AND dd_tpe_codigo = '"
						+ clientes.getTipoProductoEntidad()
						+ "'";

				if (sqlPersonaId == null) {
					sqlPersonaId = "(" + selectTipoProductos + ")";
				} else {
					sqlPersonaId += " INTERSECT (" + selectTipoProductos + ")";
				}

			}

			// Multicombo segmento
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

			// Multicombo situaci�n
			if ((clientes.getSituacion() != null && clientes.getSituacion()
					.length() > 0)) {
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

			// Multicombo situaci�n financiera
			if ((clientes.getSituacionFinanciera() != null && clientes
					.getSituacionFinanciera().length() > 0)) {
				String filtroSituacionFinanciera = "SELECT per.per_id FROM PER_PERSONAS per, DD_EFC_ESTADO_FINAN_CNT efc "
						+ "WHERE per.borrado = 0 and per.dd_efc_id = efc.dd_efc_id AND DD_EFC_CODIGO IN (";

				StringTokenizer tokensSituaciones = new StringTokenizer(
						clientes.getSituacionFinanciera(), ",");

				while (tokensSituaciones.hasMoreTokens()) {
					filtroSituacionFinanciera += "'"
							+ tokensSituaciones.nextElement() + "'";
					if (tokensSituaciones.hasMoreTokens()) {
						filtroSituacionFinanciera += ",";
					}
				}
				filtroSituacionFinanciera += ")";

				if (sqlPersonaId == null) {
					sqlPersonaId = "(" + filtroSituacionFinanciera + ")";
				} else {
					sqlPersonaId += " INTERSECT (" + filtroSituacionFinanciera
							+ ")";
				}

			}

			// Multicombo situaci�n financiera del contrato
			if ((clientes.getSituacionFinancieraContrato() != null && clientes
					.getSituacionFinancieraContrato().length() > 0)) {
				String filtroSituacionFinancieraContrato = "select cpe.per_id from CPE_CONTRATOS_PERSONAS cpe "
						+ " JOIN CNT_CONTRATOS c ON cpe.cnt_id = c.cnt_id "
						+ " JOIN DD_EFC_ESTADO_FINAN_CNT efc ON c.dd_efc_id = efc.dd_efc_id "
						+ " JOIN ${master.schema}.DD_ESC_ESTADO_CNT esc ON c.dd_esc_id = esc.dd_esc_id "
						+ " WHERE cpe.borrado = 0 and dd_esc_codigo <> '"
						+ DDEstadoContrato.ESTADO_CONTRATO_CANCELADO
						+ "' AND DD_EFC_CODIGO IN (";

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

				if (sqlPersonaId == null) {
					sqlPersonaId = "(" + filtroSituacionFinancieraContrato
							+ ")";
				} else {
					sqlPersonaId += " INTERSECT ("
							+ filtroSituacionFinancieraContrato + ")";
				}

			}

			// Check tipo de gestion
			if (clientes.getCodigoGestion() != null
					&& clientes.getCodigoGestion().length() != 0) {

				// Si ha seleccionado representar clientes sin gesti�n, decimos
				// que no tenga ning�n cliente activo
				if (DDTipoItinerario.ITINERARIO_ESPECIAL_SIN_GESTION
						.equals(clientes.getCodigoGestion())) {
					hql.append(" and not exists (SELECT c.per_id FROM CLI_CLIENTES c where borrado = 0 and c.per_id = p.per_id) ");
				}

				// Si ha seleccionado un itinerario concreto, cruzamos con
				// clientes
				else {
					// Subquery que busca personas con contrato de pase
					String filtroCodigoGestion = "SELECT c.per_id FROM CLI_CLIENTES c, ARQ_ARQUETIPOS a, ITI_ITINERARIOS i, ${master.schema}.DD_TIT_TIPO_ITINERARIOS dd "
							+ " WHERE c.arq_id = a.arq_id and a.iti_id = i.iti_id and i.dd_tit_id = dd.dd_tit_id "
							+ " and dd.dd_tit_codigo = '"
							+ clientes.getCodigoGestion()
							+ "' and c.borrado = 0";

					if (sqlPersonaId == null) {
						sqlPersonaId = "(" + filtroCodigoGestion + ")";
					} else {
						sqlPersonaId += " INTERSECT (" + filtroCodigoGestion
								+ ")";
					}
				}
			}

			if (sqlPersonaId != null) {
				hql.append(" and p.per_id IN (" + sqlPersonaId + ")");
			}

			// Inputs de riesgos, saldos y d�as vencidos
			if (necesitaCruzarSaldos) {
				if (saldovencido) {
					String col = "p.per_deuda_irregular";
					if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
							.getTipoRiesgo()))
						col += "_dir";
					else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO
							.equals(clientes.getTipoRiesgo()))
						col += "_ind";

					hql.append(" and " + col + " between "
							+ clientes.getMinSaldoVencido() + " and "
							+ clientes.getMaxSaldoVencido());
				}
				if (riesgoTotal) {
					String col = "";

					if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
							.getTipoRiesgo()))
						col = "p.PER_RIESGO";
					else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO
							.equals(clientes.getTipoRiesgo()))
						col = "p.PER_RIESGO_IND";
					else
						col = "p.PER_RIESGO_TOTAL";

					hql.append(" and " + col + " between "
							+ clientes.getMinRiesgoTotal() + " and "
							+ clientes.getMaxRiesgoTotal());
				}
				if (fechaMinima != null) {
					String col = "p.PER_FECHA_VENCIDA_";

					if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
							.getTipoRiesgo()))
						col += "DIRECTA";
					else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO
							.equals(clientes.getTipoRiesgo()))
						col += "INDIRECTA";
					else
						col += "TOTAL";

					hql.append(" and FLOOR(SYSDATE-" + col + ") >= "
							+ fechaMinima);
				}
				if (fechaMaxima != null) {
					String col = "p.PER_FECHA_VENCIDA_";

					if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
							.getTipoRiesgo()))
						col += "DIRECTA";
					else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO
							.equals(clientes.getTipoRiesgo()))
						col += "INDIRECTA";
					else
						col += "TOTAL";

					hql.append(" and FLOOR(SYSDATE-" + col + ") <= "
							+ fechaMaxima);
				}

			}
		} else {
			hql.append("and p.PER_ID is null");
		}

		String query = hql.toString() + " ";
		String orderBy = getOrderBy(clientes);
		if (orderBy != null) {
			query += orderBy;
		}

		logger.info(query);
		return query;
	}

	/**
	 * Construye la clausula orderBy en SQL en funci�n del par�metro que le
	 * pasa.
	 * 
	 * @param clientes
	 *            El dto para extraer la columna y la orientaci�n de la
	 *            ordenaci�n
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

		else if (campo.equals("apellido1")) {
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
		else if (campo.equals("deudaIrregular")) {
			orderBy = " ORDER BY p.PER_DEUDA_IRREGULAR ";
		}

		// Riesgo total
		else if (campo.equals("totalSaldo")) {
			orderBy = " ORDER BY p.PER_RIESGO_TOTAL ";
		}

		// Riesgo directo
		else if (campo.equals("deudaDirecta")) {
			orderBy = " ORDER BY p.PER_RIESGO ";
		}

		// Riesgo Directo Da�ado
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

	@Override
	public String getGestorSolvencias(Long idPersona) {
		String gestorPorDefecto = " AAA";
		if (idPersona != null) {
			try {
				EXTPersona per = this.get(idPersona);
				if (per != null && per.getVisibilidad() != null) {
					Long identidad = per.getVisibilidad().getIdEntidad();

					Filter filtro = genericDao.createFilter(FilterType.EQUALS,
							"despachoExterno.id", identidad);
					Filter filtroBorrado = genericDao.createFilter(
							FilterType.EQUALS, "auditoria.borrado", false);

					List<GestorDespacho> gd = genericDao.getList(
							GestorDespacho.class, filtro, filtroBorrado);
					if (gd != null) {
						for (GestorDespacho gestor : gd) {
							if (gestor.getGestorPorDefecto().booleanValue()) {
								gestorPorDefecto = gestor.getUsuario()
										.getUsername();
							}
						}
					}

				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return gestorPorDefecto;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Page findClientesPaginated(DtoBuscarClientes clientes,
			Usuario usuarioLogueado) {
		String hql = " from Persona per where per.id = ?";
		String sqlPersonas = generateHQLClientesFilterSQL(clientes,
				usuarioLogueado);
		PageSql page = new PageSql();

		try {
			// Recuperamos los Ids de las personas a mostrar

			Query q = getSession().createSQLQuery(sqlPersonas);
			List<BigDecimal> idList = q.list();
			int size = idList.size();

			int fromIndex = clientes.getStart();
			int toIndex = clientes.getStart() + clientes.getLimit();

			// Paginado, si no existe, creamos la paginaci�n nosotros
			if (fromIndex < 0 || toIndex < 0) {
				fromIndex = 0;
				toIndex = 25;
			}

			if (idList.size() >= clientes.getStart() + clientes.getLimit())
				idList = idList.subList(clientes.getStart(),
						clientes.getStart() + clientes.getLimit());
			else
				idList = idList.subList(clientes.getStart(), idList.size());

			List<Object> list = new ArrayList<Object>(idList.size());
			for (BigDecimal objId : idList) {
				EXTPersona p = (EXTPersona) getHibernateTemplate().find(hql,
						Long.valueOf(objId.longValue())).get(0);
				EXTDtoClienteResultado dto = new EXTDtoClienteResultado();

				dto.setPersona(p);
				// dto.setSituacion(p.getSituacionCliente());

				// if(clientes.getSituacionFinanciera() != null)
				// DDSituacionEstadoFinanciero situacionFinanciera =
				// genericDao.get(DDSituacionEstadoFinanciero.class,
				// genericDao.createFilter(FilterType.EQUALS,
				// "auditoria.borrado", false),
				// genericDao.createFilter(FilterType.EQUALS, "codigo",
				// clientes.getSituacionFinanciera()));

				if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO
						.equalsIgnoreCase(clientes.getTipoRiesgo())) {
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
				list.add(dto);
			}

			page.setResults(list);
			page.setTotalCount(size);
		} catch (Exception e) {
			logger.error(sqlPersonas, e);
		}

		return page;
	}

	/**
	 * Genera la query en SQL que devolver� los IDs de los clientes filtrados y
	 * ordenados.
	 * 
	 * @param clientes
	 *            El Dto con los filtros
	 * @return La query en SQL
	 */
	private String generateHQLClientesFilterSQL(DtoBuscarClientes clientes,
			Usuario usuarioLogueado) {

		StringBuilder hql = new StringBuilder(
				"SELECT p.per_id from PER_PERSONAS p ");
		hql.append(" JOIN ${master.schema}.DD_TPE_TIPO_PERSONA tpe ON tpe.dd_tpe_id = p.dd_tpe_id ");
	
		boolean necesitaCruzarCliente = ((clientes.getIsBusquedaGV() != null && clientes
				.getIsBusquedaGV().booleanValue())
				|| (clientes.getSituacion() != null && clientes.getSituacion()
						.length() > 0) || (clientes
				.getIsPrimerTitContratoPase() != null && clientes
				.getIsPrimerTitContratoPase().booleanValue()));

		boolean necesitaCruzarEstado = (clientes.getIsBusquedaGV() != null && clientes
				.getIsBusquedaGV().booleanValue());

		boolean saldovencido = false;
		boolean riesgoTotal = false;

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

		String fechaMinima = null;
		String fechaMaxima = null;

		if (clientes.getMinDiasVencido() != null
				&& clientes.getMinDiasVencido().length() > 0) {
			fechaMinima = clientes.getMinDiasVencido();
		}
		if (clientes.getMaxDiasVencido() != null
				&& clientes.getMaxDiasVencido().length() > 0) {
			fechaMaxima = clientes.getMaxDiasVencido();
		}

		if (necesitaCruzarCliente) {
			hql.append(" JOIN CLI_CLIENTES cli ON cli.per_id = p.per_id AND cli.borrado = 0 ");
		}
		if (necesitaCruzarEstado) {
			hql.append(" JOIN EST_ESTADOS est ON est.DD_EST_ID = cli.DD_EST_ID ");
			hql.append(" JOIN ARQ_ARQUETIPOS arq ON cli.ARQ_ID = arq.ARQ_ID and arq.ITI_ID = est.ITI_ID ");
		}

		boolean necesitaCruzarSaldos = (saldovencido || riesgoTotal
				|| fechaMinima != null || fechaMaxima != null);

		hql.append("WHERE p.borrado = 0 ");

		if (necesitaCruzarEstado) {
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
				// si no se trata de la b�squeda por GV
				// Los supervisores de GV no tienen que ver personas en gestion
				// de vencidos
				if (!clientes.getIsBusquedaGV()) {
					hql.append(" or est.PEF_ID_SUPERVISOR IN (")
							.append(listadoPerfiles).append(") ");
				}

				hql.append(" ) ");
			}
		}

		// Input de c�digo de cliente
		String codigoCliente = clientes.getCodigoEntidad();
		if (codigoCliente != null) {
			codigoCliente = codigoCliente.trim();
			if (codigoCliente.length() > 0) {
				hql.append(" and p.PER_COD_CLIENTE_ENTIDAD = " + codigoCliente
						+ " ");
			}
		}

		// Input de nombre de persona
		String nombrePersona = clientes.getNombre();
		if (nombrePersona != null) {
			nombrePersona = nombrePersona.trim().toLowerCase();

			if (nombrePersona.length() > 0) {
				hql.append(" and lower(p.PER_NOMBRE) like '%" + nombrePersona
						+ "%' ");
			}
		}

		// Input de apellido de persona
		String apellido1Persona = clientes.getApellido1();
		if (apellido1Persona != null) {
			apellido1Persona = apellido1Persona.trim().toLowerCase();

			if (apellido1Persona.length() > 0) {
				hql.append(" and lower(p.PER_APELLIDO1) like '%"
						+ apellido1Persona + "%' ");
			}
		}

		// Input de segundo apellido de persona
		String apellido2Persona = clientes.getApellido2();
		if (apellido2Persona != null) {
			apellido2Persona = apellido2Persona.trim().toLowerCase();

			if (apellido2Persona.length() > 0) {
				hql.append(" and lower(p.PER_APELLIDO2) like '%"
						+ apellido2Persona + "%' ");
			}
		}

		// Input de nif de persona
		String nifPersona = clientes.getDocId();
		if (nifPersona != null) {
			nifPersona = nifPersona.trim().toUpperCase();

			if (nifPersona.length() > 0) {
				hql.append(" and p.PER_DOC_ID like '%" + nifPersona + "%' ");
				// hql.append(" and lower(p.docId) like '%" +
				// clientes.getNif().toLowerCase() + "%' ");
			}
		}

		// Combo tipo de persona
		if (clientes.getTipoPersona() != null
				&& clientes.getTipoPersona().length() > 0) {
			hql.append(" and tpe.DD_TPE_CODIGO = '" + clientes.getTipoPersona()
					+ "' ");
		}

		String sqlPersonaId = null;

		// Combo Tipo de intervencion
		if (clientes.getTipoIntervercion() != null
				&& clientes.getTipoIntervercion().length() > 0
				&& (clientes.getIsPrimerTitContratoPase() == null || !clientes
						.getIsPrimerTitContratoPase())) {

			// Subquery que busca personas con alg�n tipo de intervenci�n
			String filtroTipoIntervencion = "SELECT cp.per_id FROM CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
					+ " WHERE cp.borrado = 0 "
					+ " AND tin.dd_tin_id = cp.dd_tin_id";

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

			sqlPersonaId = "(" + filtroTipoIntervencion + ")";
		}

		// Check contrato de pase
		if (clientes.getIsPrimerTitContratoPase() != null
				&& clientes.getIsPrimerTitContratoPase().booleanValue()) {
			// Subquery que busca personas con contrato de pase
			String filtroContratoPase = "SELECT cp.per_id FROM CNT_CONTRATOS c"
					+ ", CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
					+ ", CLI_CLIENTES cli, CCL_CONTRATOS_CLIENTE ccl"
					+ " WHERE cp.borrado = 0 "
					+ " AND cp.cnt_id = c.cnt_id and c.borrado = 0"
					+ " AND cp.dd_tin_id = tin.dd_tin_id"
					+ " AND tin.DD_TIN_TITULAR = 1 "
					+ " AND cli.cli_id = ccl.cli_id AND ccl.cnt_id = cp.cnt_id "
					+ " AND cli.per_id = cp.per_id"
					+ " AND ccl.ccl_pase = 1 AND cp.cpe_orden = 1";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroContratoPase + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + filtroContratoPase + ")";
			}
		}

		// Input n�mero de contrato
		if (clientes.getNroContrato() != null
				&& clientes.getNroContrato().length() > 0) {

			String filtroContrato = "SELECT cp.per_id FROM CNT_CONTRATOS c, CPE_CONTRATOS_PERSONAS cp "
					+ " WHERE c.borrado = 0 and c.cnt_id = cp.cnt_id and cp.borrado = 0 and c.CNT_CONTRATO like '%"
					+ clientes.getNroContrato() + "%'";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroContrato + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + filtroContrato + ")";
			}
		}

		// Multicombo tipo de producto
		if ((clientes.getTipoProducto() != null && clientes.getTipoProducto()
				.length() > 0)) {
			String selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPR_TIPO_PROD tpr, CPE_CONTRATOS_PERSONAS cpe "
					+ "WHERE c.dd_tpr_id = tpr.dd_tpr_id and c.borrado = 0 and cpe.cnt_id = c.cnt_id and cpe.borrado = 0 "
					+ "AND dd_tpr_codigo = '"
					+ clientes.getTipoProducto()
					+ "'";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + selectTipoProductos + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + selectTipoProductos + ")";
			}

		}
		
		// Multicombo tipo de producto
		if ((clientes.getTipoProductoEntidad() != null && clientes.getTipoProductoEntidad().length() > 0)) {
			String selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPE_TIPO_PROD_ENTIDAD tpe, CPE_CONTRATOS_PERSONAS cpe "
					+ "WHERE c.dd_tpe_id = tpe.dd_tpe_id and c.borrado = 0 and cpe.cnt_id = c.cnt_id and cpe.borrado = 0 "
					+ "AND dd_tpe_codigo = '"
					+ clientes.getTipoProductoEntidad()
					+ "'";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + selectTipoProductos + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + selectTipoProductos + ")";
			}

		}

		// Multicombo segmento
		String segmentoPersona = clientes.getSegmento();
		if (segmentoPersona != null && segmentoPersona.length() > 0) {
			StringTokenizer tokensSegmentos = new StringTokenizer(
					segmentoPersona, ",");
			hql.append(" and p.DD_SCL_ID IN ( SELECT SG.DD_SCL_ID  FROM DD_SCL_SEGTO_CLI SG WHERE (");
			while (tokensSegmentos.hasMoreTokens()) {
				hql.append(" SG.DD_SCL_CODIGO like '"
						+ tokensSegmentos.nextElement() + "' ");
				if (tokensSegmentos.hasMoreTokens()) {
					hql.append(" OR ");
				}
			}
			hql.append(")) ");
		}

		// Multicombo situaci�n
		if ((clientes.getSituacion() != null && clientes.getSituacion()
				.length() > 0)) {
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

		// if ((clientes.getSituacionFinanciera() != null &&
		// clientes.getSituacionFinanciera().length() > 0)) {
		// // String filtroSituacionFinanciera =
		// "SELECT per.per_id FROM PER_PERSONAS per, DD_EFC_ESTADO_FINAN_CNT efc "
		// // +
		// "WHERE per.borrado = 0 and per.dd_efc_id = efc.dd_efc_id AND DD_EFC_CODIGO IN (";
		// String filtroSituacionFinanciera ="";
		// StringTokenizer tokensSituaciones = new
		// StringTokenizer(clientes.getSituacionFinanciera(), ",");
		// logger.info("llega a filtro situacion financiara");
		// while (tokensSituaciones.hasMoreTokens()) {
		// // filtroSituacionFinanciera += "'" + tokensSituaciones.nextElement()
		// + "'";
		// // if (tokensSituaciones.hasMoreTokens()) {
		// // filtroSituacionFinanciera += ",";
		// // }
		// String codigo = tokensSituaciones.nextToken();
		// logger.info("Codigo "+codigo);
		// if("05".equalsIgnoreCase(codigo)){ //CONCURSOS
		//
		// filtroSituacionFinanciera =
		// "SELECT distinct P.PER_ID FROM PER_PERSONAS p , PRC_PER prc , PRC_PROCEDIMIENTOS pro"+
		// " where p.per_id = prc.per_id and prc.prc_id = pro.prc_id and pro.dd_tac_id = 3";
		// }
		// if("06".equalsIgnoreCase(codigo)){ // FALLIDOS DE ASUNTOS EN LITIGIO
		// NO CONCURSO
		//
		// filtroSituacionFinanciera =
		// "SELECT distinct p.per_id FROM PER_PERSONAS p , PRC_PER prc , PRC_PROCEDIMIENTOS pro, ASU_ASUNTOS asu "+
		// " where p.per_id = prc.per_id and prc.prc_id = pro.prc_id and pro.asu_id = asu.asu_id "+
		// " and p.dd_efc_id in (108,101,106) "+
		// "  and p.per_id  not in (SELECT per.per_id as per_id from PRC_PER per,PRC_PROCEDIMIENTOS pro where   per.prc_id = pro.prc_id and pro.dd_tac_id = 3  ) ";
		//
		// }
		// if("07".equalsIgnoreCase(codigo)){ //FALLIDOS DE ASUNTOS EN LITIGIO
		// EN CONCURSO
		// filtroSituacionFinanciera =
		// "SELECT distinct p.per_id FROM PER_PERSONAS p , PRC_PER prc , PRC_PROCEDIMIENTOS pro, ASU_ASUNTOS asu "+
		// " where p.per_id = prc.per_id and prc.prc_id = pro.prc_id and pro.asu_id = asu.asu_id "+
		// " and p.dd_efc_id in (108,101,106)  and pro.dd_tac_id = 3 ";
		// }
		//
		// if("04".equalsIgnoreCase(codigo)){ //LITIGIO NO CONCURSAL
		// filtroSituacionFinanciera =
		// "SELECT distinct p.per_id FROM PER_PERSONAS p , PRC_PER prc , PRC_PROCEDIMIENTOS pro, ASU_ASUNTOS asu "+
		// "  where p.per_id = prc.per_id and prc.prc_id = pro.prc_id and pro.asu_id = asu.asu_id "+
		// "  and p.dd_efc_id not in (108,101,106) and p.per_id  not in (SELECT per.per_id as per_id "+
		// "  from PRC_PER per,PRC_PROCEDIMIENTOS pro  where   per.prc_id = pro.prc_id and (pro.dd_tac_id = 3 or pro.dd_tpo_id = 643) )";
		//
		// }
		//
		// if("03".equalsIgnoreCase(codigo)){ //DUDOSO NO LITIGIO
		// filtroSituacionFinanciera =
		// " SELECT distinct p.per_id FROM PER_PERSONAS p "+
		// " where p.dd_efc_id  in (103,107) and p.per_id not in (select prc.per_id FROM PRC_PER prc , PRC_PROCEDIMIENTOS pro, ASU_ASUNTOS asu "
		// +
		// " where prc.prc_id = pro.prc_id and pro.asu_id = asu.asu_id)";
		//
		// }
		// if("02".equalsIgnoreCase(codigo)){ //VENCIDO NORMAL GESTI�N RECOBRO
		// filtroSituacionFinanciera = "";
		//
		//
		// }
		// logger.info("filtro sitaucion "+filtroSituacionFinanciera);
		// if (sqlPersonaId == null) {
		// sqlPersonaId = "(" + filtroSituacionFinanciera + ")";
		// } else {
		// sqlPersonaId += " INTERSECT (" + filtroSituacionFinanciera + ")";
		// }
		// filtroSituacionFinanciera ="";
		// }

		// Multicombo situaci�n financiera
		if ((clientes.getSituacionFinanciera() != null && clientes
				.getSituacionFinanciera().length() > 0)) {
			String filtroSituacionFinanciera = "SELECT per.per_id FROM PER_PERSONAS per, DD_EFC_ESTADO_FINAN_CNT efc "
					+ "WHERE per.borrado = 0 and per.dd_efc_id = efc.dd_efc_id AND DD_EFC_CODIGO IN (";

			StringTokenizer tokensSituaciones = new StringTokenizer(
					clientes.getSituacionFinanciera(), ",");

			while (tokensSituaciones.hasMoreTokens()) {
				filtroSituacionFinanciera += "'"
						+ tokensSituaciones.nextElement() + "'";
				if (tokensSituaciones.hasMoreTokens()) {
					filtroSituacionFinanciera += ",";
				}
			}
			filtroSituacionFinanciera += ")";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroSituacionFinanciera + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + filtroSituacionFinanciera
						+ ")";
			}

		}

		// Multicombo situaci�n financiera del contrato
		if ((clientes.getSituacionFinancieraContrato() != null && clientes
				.getSituacionFinancieraContrato().length() > 0)) {
			String filtroSituacionFinancieraContrato = "select cpe.per_id from CPE_CONTRATOS_PERSONAS cpe "
					+ " JOIN CNT_CONTRATOS c ON cpe.cnt_id = c.cnt_id "
					+ " JOIN DD_EFC_ESTADO_FINAN_CNT efc ON c.dd_efc_id = efc.dd_efc_id "
					+ " JOIN ${master.schema}.DD_ESC_ESTADO_CNT esc ON c.dd_esc_id = esc.dd_esc_id "
					+ " WHERE cpe.borrado = 0 and dd_esc_codigo <> '"
					+ DDEstadoContrato.ESTADO_CONTRATO_CANCELADO
					+ "' AND DD_EFC_CODIGO IN (";

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

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroSituacionFinancieraContrato + ")";
			} else {
				sqlPersonaId += " INTERSECT ("
						+ filtroSituacionFinancieraContrato + ")";
			}

		}

		int cantZonas = clientes.getCodigoZonas().size();
		String zonas = null;
		if (cantZonas > 0) {
			zonas = " and ( ";
			for (String codigoZ : clientes.getCodigoZonas()) {
				zonas += " zon.zon_cod like '" + codigoZ + "%' OR";
			}
			zonas = zonas.substring(0, zonas.length() - 2);

			hql.append(" OR p.per_id in ( ");
			hql.append(generaFiltroPersonaPorGestor(usuarioLogueado));
			hql.append(" ) ");

			zonas += " ) ";

		} else {
			hql.append(" and p.per_id in ( ");
			hql.append(generaFiltroPersonaPorGestor(usuarioLogueado));
			hql.append(" ) ");
		}

		String jerarquia = null;
		if (clientes.getJerarquia() != null
				&& clientes.getJerarquia().length() > 0) {
			jerarquia = " and zon.ZON_ID >= " + clientes.getJerarquia();
			if (zonas != null)
				jerarquia += zonas;
		} else if (zonas != null) {
			jerarquia = zonas;
		}

		if (jerarquia != null) {
			String filtroJerarquia = "";

			// Si es primer titular del contrato de pase buscamos directamente
			// en los clientes
			if (clientes.getIsPrimerTitContratoPase() != null
					&& clientes.getIsPrimerTitContratoPase().booleanValue()) {
				filtroJerarquia = "SELECT cli.per_id FROM CLI_CLIENTES cli JOIN OFI_OFICINAS o ON cli.ofi_id = o.ofi_id JOIN ZON_ZONIFICACION zon ON zon.ofi_id = o.ofi_id WHERE cli.borrado = 0 "
						+ jerarquia;
			} else {
				filtroJerarquia = "SELECT cp.per_id FROM CNT_CONTRATOS c, CPE_CONTRATOS_PERSONAS cp, ZON_ZONIFICACION zon "
						+ " WHERE cp.borrado = 0 and c.borrado = 0 and cp.cnt_id = c.cnt_id AND c.ZON_ID = zon.ZON_ID "
						+ jerarquia;
			}

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroJerarquia + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + filtroJerarquia + ")";
			}
		}

		// Check tipo de gestion
		if (clientes.getCodigoGestion() != null
				&& clientes.getCodigoGestion().length() != 0) {

			// Si ha seleccionado representar clientes sin gesti�n, decimos que
			// no tenga ning�n cliente activo
			if (DDTipoItinerario.ITINERARIO_ESPECIAL_SIN_GESTION
					.equals(clientes.getCodigoGestion())) {
				hql.append(" and not exists (SELECT c.per_id FROM CLI_CLIENTES c where borrado = 0 and c.per_id = p.per_id) ");
			}

			// Si ha seleccionado un itinerario concreto, cruzamos con clientes
			else {
				// Subquery que busca personas con contrato de pase
				String filtroCodigoGestion = "SELECT c.per_id FROM CLI_CLIENTES c, ARQ_ARQUETIPOS a, ITI_ITINERARIOS i, ${master.schema}.DD_TIT_TIPO_ITINERARIOS dd "
						+ " WHERE c.arq_id = a.arq_id and a.iti_id = i.iti_id and i.dd_tit_id = dd.dd_tit_id "
						+ " and dd.dd_tit_codigo = '"
						+ clientes.getCodigoGestion() + "' and c.borrado = 0";

				if (sqlPersonaId == null) {
					sqlPersonaId = "(" + filtroCodigoGestion + ")";
				} else {
					sqlPersonaId += " INTERSECT (" + filtroCodigoGestion + ")";
				}
			}
		}
		if (fechaMinima != null || fechaMaxima != null) {

			String filtroFechas = "select cpe.per_id  FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV,(select cpe.per_id as id ,MIN(MOV.MOV_FECHA_POS_VENCIDA) as fechaMin FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV "
					+ "WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION ";

			if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
					.getTipoRiesgo()))
				filtroFechas += " and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 1) ";

			if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO.equals(clientes
					.getTipoRiesgo()))
				filtroFechas += " and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 0) ";

			filtroFechas += "group by cpe.per_id) sub "
					+ "WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION ";
			if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
					.getTipoRiesgo()))
				filtroFechas += " and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 1) ";

			if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO.equals(clientes
					.getTipoRiesgo()))
				filtroFechas += " and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 0) ";

			filtroFechas += " and cpe.per_id = sub.id and mov.mov_fecha_pos_vencida = sub.fechaMin ";

			if (fechaMinima != null)
				filtroFechas += " and FLOOR(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA) >= "
						+ fechaMinima;

			if (fechaMaxima != null)
				filtroFechas += " and FLOOR(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA) <= "
						+ fechaMaxima;

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroFechas + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + filtroFechas + ")";
			}
		}

		if (riesgoTotal) {

			String suma;
			// if
			// (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes.getTipoRiesgo()))
			// suma = "sum(MOV.mov_pos_viva_vencida)";
			// else if
			// (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO.equals(clientes.getTipoRiesgo()))
			// suma = "sum(MOV.mov_pos_viva_no_vencida)";
			// else
			suma = "sum(MOV.mov_pos_viva_vencida + MOV.mov_pos_viva_no_vencida)";

			String filtroRiesgo = "select cpe.per_id as id  "
					+ "FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV "
					+ "WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION ";

			if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
					.getTipoRiesgo()))
				filtroRiesgo += " and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 1) ";

			if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO.equals(clientes
					.getTipoRiesgo()))
				filtroRiesgo += " and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 0) ";

			filtroRiesgo += " having (";
			boolean anyadeAnd = false;
			if (clientes.getMinRiesgoTotal() != null) {
				filtroRiesgo += suma + " > " + clientes.getMinRiesgoTotal();
				anyadeAnd = true;
			}
			if (clientes.getMaxRiesgoTotal() != null) {
				if (anyadeAnd)
					filtroRiesgo += " and ";

				filtroRiesgo += suma + " < " + clientes.getMaxRiesgoTotal();
			}

			filtroRiesgo += ") group by cpe.per_id";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroRiesgo + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + filtroRiesgo + ")";
			}

		}

		if (sqlPersonaId != null) {
			hql.append(" and p.per_id IN (" + sqlPersonaId + ")");
		}
		// Inputs de riesgos, saldos y d�as vencidos
		if (necesitaCruzarSaldos) {
			if (saldovencido) {
				String col = "p.per_deuda_irregular";
				if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
						.getTipoRiesgo()))
					col += "_dir";
				else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO
						.equals(clientes.getTipoRiesgo()))
					col += "_ind";

				hql.append(" and " + col + " between "
						+ clientes.getMinSaldoVencido() + " and "
						+ clientes.getMaxSaldoVencido());
			}

		}

		String query = hql.toString() + " ";
		// String query = "SELECT p.per_id FROM PER_PERSONAS p JOIN (" +
		// hql.toString() + ") aux ON aux.per_id = p.per_id ";

		String orderBy = getOrderBy(clientes);
		if (orderBy != null) {
			query += orderBy;
		}
		return query;
	}

	/***
	 * Devuelve un hql utilizado como subconsulta para obtener los clientes del
	 * que el usuario es gestor
	 * 
	 * @param usuLogado
	 *            Usuario logueado que ha realizado la busqueda
	 * 
	 * @return hql con la busqueda del clientes por gestor
	 * 
	 * */
	private String generaFiltroPersonaPorGestor(Usuario usuLogado) {
		StringBuffer hql = new StringBuffer();
		hql.append(" select p.per_id from per_personas p , GE_GESTOR_ENTIDAD ge ");
		hql.append(" where p.per_id = ge.ug_ID and ge.DD_EIN_ID = '")
				.append(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE).append("' ");
		hql.append(" and ge.USU_ID = ").append(usuLogado.getId());
		return hql.toString();
	}

	/**
	 * Genera la consulta SQL que se va a utilizar para obtener los clientes
	 * 
	 * @param clientes
	 *            DTO con las opciones de b�squeda
	 * @param conCarterizacion
	 *            Flag que indica si queremos usar o no la carterizaci�n
	 * @return
	 */
	private String generateHQLClientesFilterSQL(DtoBuscarClientes clientes,
			boolean conCarterizacion, Usuario usuarioLogado) {
		
		if (usuarioLogado == null){
			throw new IllegalStateException("No se permite 'usuarioLogado = null' en este DAO");
		}

		StringBuilder hql = new StringBuilder(
				"SELECT p.per_id from PER_PERSONAS p ");
		hql.append(" JOIN ${master.schema}.DD_TPE_TIPO_PERSONA tpe ON tpe.dd_tpe_id = p.dd_tpe_id ");

		boolean necesitaCruzarCliente = ((clientes.getIsBusquedaGV() != null && clientes
				.getIsBusquedaGV().booleanValue())
				|| (clientes.getSituacion() != null && clientes.getSituacion()
						.length() > 0) || (clientes
				.getIsPrimerTitContratoPase() != null && clientes
				.getIsPrimerTitContratoPase().booleanValue()));

		boolean necesitaCruzarEstado = (clientes.getIsBusquedaGV() != null && clientes
				.getIsBusquedaGV().booleanValue());

		boolean saldovencido = false;
		boolean riesgoTotal = false;

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

		String fechaMinima = null;
		String fechaMaxima = null;

		if (clientes.getMinDiasVencido() != null
				&& clientes.getMinDiasVencido().length() > 0) {
			fechaMinima = clientes.getMinDiasVencido();
		}

		if (clientes.getMaxDiasVencido() != null
				&& clientes.getMaxDiasVencido().length() > 0) {
			fechaMaxima = clientes.getMaxDiasVencido();
		}

		if (necesitaCruzarCliente) {
			hql.append(" JOIN CLI_CLIENTES cli ON cli.per_id = p.per_id AND cli.borrado = 0 ");
		}
		if (necesitaCruzarEstado) {
			hql.append(" JOIN EST_ESTADOS est ON est.DD_EST_ID = cli.DD_EST_ID ");
			hql.append(" JOIN ARQ_ARQUETIPOS arq ON cli.ARQ_ID = arq.ARQ_ID and arq.ITI_ID = est.ITI_ID ");
			// A�adimos soporte para perfiles carterizados
			if (conCarterizacion) {
				hql.append(" JOIN PEF_PERFILES pef ON  est.pef_id_gestor = pef.pef_id ");
			}
		}
		boolean necesitaCruzarSaldos = (saldovencido || riesgoTotal
				|| fechaMinima != null || fechaMaxima != null);

		hql.append("WHERE p.borrado = 0 ");

		if (necesitaCruzarEstado) {
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
				// si no se trata de la b�squeda por GV
				// Los supervisores de GV no tienen que ver personas en gestion
				// de vencidos
				if (!clientes.getIsBusquedaGV()) {
					hql.append(" or est.PEF_ID_SUPERVISOR IN (")
							.append(listadoPerfiles).append(") ");
				}

				hql.append(" ) ");

				// A�adimos soporte para perfiles carterizados
				if (conCarterizacion) {
					hql.append("and (pef.pef_es_carterizado = 0 or "
							+ usuarioLogado.getId()
							+ " in (select usu_id " +
							"from ge_gestor_entidad ge " +
							"join unmaster.dd_ein_entidad_informacion ein on ge.dd_ein_id = ein.dd_ein_id " +
							"where ein.dd_ein_codigo = '" +DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE + "' and ge.ug_id = p.per_id))");
				}

			}
		}

		// Input de c�digo de cliente
		String codigoCliente = clientes.getCodigoEntidad();
		if (codigoCliente != null) {
			codigoCliente = codigoCliente.trim();
			if (codigoCliente.length() > 0) {
				hql.append(" and p.PER_COD_CLIENTE_ENTIDAD = " + codigoCliente
						+ " ");
			}
		}

		// Input de nombre de persona
		String nombrePersona = clientes.getNombre();
		if (nombrePersona != null) {
			nombrePersona = nombrePersona.trim().toLowerCase();

			if (nombrePersona.length() > 0) {
				hql.append(" and lower(p.PER_NOMBRE) like '%" + nombrePersona
						+ "%' ");
			}
		}

		// Input de apellido de persona
		String apellido1Persona = clientes.getApellido1();
		if (apellido1Persona != null) {
			apellido1Persona = apellido1Persona.trim().toLowerCase();

			if (apellido1Persona.length() > 0) {
				hql.append(" and lower(p.PER_APELLIDO1) like '%"
						+ apellido1Persona + "%' ");
			}
		}

		// Input de segundo apellido de persona
		String apellido2Persona = clientes.getApellido2();
		if (apellido2Persona != null) {
			apellido2Persona = apellido2Persona.trim().toLowerCase();

			if (apellido2Persona.length() > 0) {
				hql.append(" and lower(p.PER_APELLIDO2) like '%"
						+ apellido2Persona + "%' ");
			}
		}

		// Input de nif de persona
		String nifPersona = clientes.getDocId();
		if (nifPersona != null) {
			nifPersona = nifPersona.trim().toUpperCase();

			if (nifPersona.length() > 0) {
				hql.append(" and p.PER_DOC_ID like '%" + nifPersona + "%' ");
				// hql.append(" and lower(p.docId) like '%" +
				// clientes.getNif().toLowerCase() + "%' ");
			}
		}

		// Combo tipo de persona
		if (clientes.getTipoPersona() != null
				&& clientes.getTipoPersona().length() > 0) {
			hql.append(" and tpe.DD_TPE_CODIGO = '" + clientes.getTipoPersona()
					+ "' ");
		}

		String sqlPersonaId = null;

		// Combo Tipo de intervencion
		if (clientes.getTipoIntervercion() != null
				&& clientes.getTipoIntervercion().length() > 0
				&& (clientes.getIsPrimerTitContratoPase() == null || !clientes
						.getIsPrimerTitContratoPase())) {

			// Subquery que busca personas con alg�n tipo de intervenci�n
			String filtroTipoIntervencion = "SELECT cp.per_id FROM CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
					+ " WHERE cp.borrado = 0 "
					+ " AND tin.dd_tin_id = cp.dd_tin_id";

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

			sqlPersonaId = "(" + filtroTipoIntervencion + ")";
		}

		// Check contrato de pase
		if (clientes.getIsPrimerTitContratoPase() != null
				&& clientes.getIsPrimerTitContratoPase().booleanValue()) {
			// Subquery que busca personas con contrato de pase
			String filtroContratoPase = "SELECT cp.per_id FROM CNT_CONTRATOS c"
					+ ", CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
					+ ", CLI_CLIENTES cli, CCL_CONTRATOS_CLIENTE ccl"
					+ " WHERE cp.borrado = 0 "
					+ " AND cp.cnt_id = c.cnt_id and c.borrado = 0"
					+ " AND cp.dd_tin_id = tin.dd_tin_id"
					+ " AND tin.DD_TIN_TITULAR = 1 "
					+ " AND cli.cli_id = ccl.cli_id AND ccl.cnt_id = cp.cnt_id "
					+ " AND cli.per_id = cp.per_id"
					+ " AND ccl.ccl_pase = 1 AND cp.cpe_orden = 1";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroContratoPase + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + filtroContratoPase + ")";
			}
		}

		// Input n�mero de contrato
		if (clientes.getNroContrato() != null
				&& clientes.getNroContrato().length() > 0) {

			String filtroContrato = "SELECT cp.per_id FROM CNT_CONTRATOS c, CPE_CONTRATOS_PERSONAS cp "
					+ " WHERE c.borrado = 0 and c.cnt_id = cp.cnt_id and cp.borrado = 0 and c.CNT_CONTRATO like '%"
					+ clientes.getNroContrato() + "%'";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroContrato + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + filtroContrato + ")";
			}
		}

		// Multicombo tipo de producto
		if ((clientes.getTipoProducto() != null && clientes.getTipoProducto()
				.length() > 0)) {
			String selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPR_TIPO_PROD tpr, CPE_CONTRATOS_PERSONAS cpe "
					+ "WHERE c.dd_tpr_id = tpr.dd_tpr_id and c.borrado = 0 and cpe.cnt_id = c.cnt_id and cpe.borrado = 0 "
					+ "AND dd_tpr_codigo = '"
					+ clientes.getTipoProducto()
					+ "'";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + selectTipoProductos + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + selectTipoProductos + ")";
			}

		}

		// Multicombo tipo de producto
		if ((clientes.getTipoProductoEntidad() != null && clientes
				.getTipoProductoEntidad().length() > 0)) {
			String selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPE_TIPO_PROD_ENTIDAD tpe, CPE_CONTRATOS_PERSONAS cpe "
					+ "WHERE c.dd_tpe_id = tpe.dd_tpe_id and c.borrado = 0 and cpe.cnt_id = c.cnt_id and cpe.borrado = 0 "
					+ "AND dd_tpe_codigo = '"
					+ clientes.getTipoProductoEntidad()
					+ "'";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + selectTipoProductos + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + selectTipoProductos + ")";
			}

		}
		
		
		// Multicombo segmento
		String segmentoPersona = clientes.getSegmento();
		if (segmentoPersona != null && segmentoPersona.length() > 0) {
			StringTokenizer tokensSegmentos = new StringTokenizer(
					segmentoPersona, ",");
			hql.append(" and p.DD_SCL_ID IN (");
			while (tokensSegmentos.hasMoreTokens()) {
				hql.append(tokensSegmentos.nextElement());
				if (tokensSegmentos.hasMoreTokens()) {
					hql.append(",");
				}
			}
			hql.append(") ");
		}

		// Multicombo situaci�n
		if ((clientes.getSituacion() != null && clientes.getSituacion()
				.length() > 0)) {
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

		// Multicombo situaci�n financiera
		if ((clientes.getSituacionFinanciera() != null && clientes
				.getSituacionFinanciera().length() > 0)) {
			String filtroSituacionFinanciera = "SELECT per.per_id FROM PER_PERSONAS per, DD_EFC_ESTADO_FINAN_CNT efc "
					+ "WHERE per.borrado = 0 and per.dd_efc_id = efc.dd_efc_id AND DD_EFC_CODIGO IN (";

			StringTokenizer tokensSituaciones = new StringTokenizer(
					clientes.getSituacionFinanciera(), ",");

			while (tokensSituaciones.hasMoreTokens()) {
				filtroSituacionFinanciera += "'"
						+ tokensSituaciones.nextElement() + "'";
				if (tokensSituaciones.hasMoreTokens()) {
					filtroSituacionFinanciera += ",";
				}
			}
			filtroSituacionFinanciera += ")";

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroSituacionFinanciera + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + filtroSituacionFinanciera
						+ ")";
			}

		}

		// Multicombo situaci�n financiera del contrato
		if ((clientes.getSituacionFinancieraContrato() != null && clientes
				.getSituacionFinancieraContrato().length() > 0)) {
			String filtroSituacionFinancieraContrato = "select cpe.per_id from CPE_CONTRATOS_PERSONAS cpe "
					+ " JOIN CNT_CONTRATOS c ON cpe.cnt_id = c.cnt_id "
					+ " JOIN DD_EFC_ESTADO_FINAN_CNT efc ON c.dd_efc_id = efc.dd_efc_id "
					+ " JOIN ${master.schema}.DD_ESC_ESTADO_CNT esc ON c.dd_esc_id = esc.dd_esc_id "
					+ " WHERE cpe.borrado = 0 and dd_esc_codigo <> '"
					+ DDEstadoContrato.ESTADO_CONTRATO_CANCELADO
					+ "' AND DD_EFC_CODIGO IN (";

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

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroSituacionFinancieraContrato + ")";
			} else {
				sqlPersonaId += " INTERSECT ("
						+ filtroSituacionFinancieraContrato + ")";
			}

		}

		int cantZonas = clientes.getCodigoZonas().size();
		String zonas = null;
		if (cantZonas > 0) {
			zonas = " and ( ";
			for (String codigoZ : clientes.getCodigoZonas()) {
				zonas += " zon.zon_cod like '" + codigoZ + "%' OR";
			}
			zonas = zonas.substring(0, zonas.length() - 2);
			zonas += " ) ";

		}

		String jerarquia = null;
		if (clientes.getJerarquia() != null
				&& clientes.getJerarquia().length() > 0) {
			jerarquia = " and zon.ZON_ID >= " + clientes.getJerarquia();
			if (zonas != null)
				jerarquia += zonas;
		} else if (zonas != null) {
			jerarquia = zonas;
		}

		if (jerarquia != null) {
			String filtroJerarquia = "";

			// Si es primer titular del contrato de pase buscamos directamente
			// en los clientes
			if (clientes.getIsPrimerTitContratoPase() != null
					&& clientes.getIsPrimerTitContratoPase().booleanValue()) {
				filtroJerarquia = "SELECT cli.per_id FROM CLI_CLIENTES cli JOIN OFI_OFICINAS o ON cli.ofi_id = o.ofi_id JOIN ZON_ZONIFICACION zon ON zon.ofi_id = o.ofi_id WHERE cli.borrado = 0 "
						+ jerarquia;
			} else {
				filtroJerarquia = "SELECT cp.per_id FROM CNT_CONTRATOS c, CPE_CONTRATOS_PERSONAS cp, ZON_ZONIFICACION zon "
						+ " WHERE cp.borrado = 0 and c.borrado = 0 and cp.cnt_id = c.cnt_id AND c.ZON_ID = zon.ZON_ID "
						+ jerarquia;
			}

			if (sqlPersonaId == null) {
				sqlPersonaId = "(" + filtroJerarquia + ")";
			} else {
				sqlPersonaId += " INTERSECT (" + filtroJerarquia + ")";
			}
		}

		// Check tipo de gestion
		if (clientes.getCodigoGestion() != null
				&& clientes.getCodigoGestion().length() != 0) {

			// Si ha seleccionado representar clientes sin gesti�n, decimos que
			// no tenga ning�n cliente activo
			if (DDTipoItinerario.ITINERARIO_ESPECIAL_SIN_GESTION
					.equals(clientes.getCodigoGestion())) {
				hql.append(" and not exists (SELECT c.per_id FROM CLI_CLIENTES c where borrado = 0 and c.per_id = p.per_id) ");
			}

			// Si ha seleccionado un itinerario concreto, cruzamos con clientes
			else {
				// Subquery que busca personas con contrato de pase
				String filtroCodigoGestion = "SELECT c.per_id FROM CLI_CLIENTES c, ARQ_ARQUETIPOS a, ITI_ITINERARIOS i, ${master.schema}.DD_TIT_TIPO_ITINERARIOS dd "
						+ " WHERE c.arq_id = a.arq_id and a.iti_id = i.iti_id and i.dd_tit_id = dd.dd_tit_id "
						+ " and dd.dd_tit_codigo = '"
						+ clientes.getCodigoGestion() + "' and c.borrado = 0";

				if (sqlPersonaId == null) {
					sqlPersonaId = "(" + filtroCodigoGestion + ")";
				} else {
					sqlPersonaId += " INTERSECT (" + filtroCodigoGestion + ")";
				}
			}
		}

		if (sqlPersonaId != null) {
			hql.append(" and p.per_id IN (" + sqlPersonaId + ")");
		}

		// Inputs de riesgos, saldos y d�as vencidos
		if (necesitaCruzarSaldos) {
			if (saldovencido) {
				String col = "p.per_deuda_irregular";
				if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
						.getTipoRiesgo()))
					col += "_dir";
				else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO
						.equals(clientes.getTipoRiesgo()))
					col += "_ind";

				hql.append(" and " + col + " between "
						+ clientes.getMinSaldoVencido() + " and "
						+ clientes.getMaxSaldoVencido());
			}
			if (riesgoTotal) {
				String col = "";

				if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
						.getTipoRiesgo()))
					col = "p.PER_RIESGO";
				else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO
						.equals(clientes.getTipoRiesgo()))
					col = "p.PER_RIESGO_IND";
				else
					col = "p.PER_RIESGO_TOTAL";

				hql.append(" and " + col + " between "
						+ clientes.getMinRiesgoTotal() + " and "
						+ clientes.getMaxRiesgoTotal());
			}
			if (fechaMinima != null) {
				String col = "p.PER_FECHA_VENCIDA_";

				if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
						.getTipoRiesgo()))
					col += "DIRECTA";
				else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO
						.equals(clientes.getTipoRiesgo()))
					col += "INDIRECTA";
				else
					col += "TOTAL";

				hql.append(" and FLOOR(SYSDATE-" + col + ") >= " + fechaMinima);
			}
			if (fechaMaxima != null) {
				String col = "p.PER_FECHA_VENCIDA_";

				if (EXTPersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes
						.getTipoRiesgo()))
					col += "DIRECTA";
				else if (EXTPersonaDao.BUSQUEDA_RIESGO_INDIRECTO
						.equals(clientes.getTipoRiesgo()))
					col += "INDIRECTA";
				else
					col += "TOTAL";

				hql.append(" and FLOOR(SYSDATE-" + col + ") <= " + fechaMaxima);
			}

		}

		String query = hql.toString() + " ";
		// String query = "SELECT p.per_id FROM PER_PERSONAS p JOIN (" +
		// hql.toString() + ") aux ON aux.per_id = p.per_id ";

		String orderBy = getOrderBy(clientes);
		if (orderBy != null) {
			query += orderBy;
		}

		return query;
	}

}
