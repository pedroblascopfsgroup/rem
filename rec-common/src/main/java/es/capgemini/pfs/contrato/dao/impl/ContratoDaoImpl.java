package es.capgemini.pfs.contrato.dao.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.dao.ContratoDao;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.AcnAntecedContratos;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

/**
 * Clase que implementa los métodos de la interfaz ContratoDao.
 * 
 * @author mtorrado
 *
 */
@Repository("ContratoDao")
public class ContratoDaoImpl extends AbstractEntityDao<Contrato, Long>
		implements ContratoDao {

	private static Long staticCheckFechaCargaTimestamp = null;

	private static Date staticCacheFechaCarga = null;

	private static final long FECHA_CARGA_CACHE_TIMEOUT = 14400000;
	
	@Autowired
	private GenericABMDao genericDao;

	@Resource
	private PaginationManager paginationManager;

	/**
	 * Devuelve un HQL con los contratos existentes en los procedimientos en
	 * curso.
	 * 
	 * @param columnaRelacion
	 *            Si se le pasa este parametro (!= null) comparará solamente los
	 *            contrato.id que relacionen con el parametro
	 * @return
	 */
	private String getHqlContratosEnProcedimientos(String columnaRelacion) {
		StringBuilder hql = new StringBuilder();

		hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, ProcedimientoContratoExpediente pce, Procedimiento prc ");
		hql.append("WHERE cex.id = pce.expedienteContrato ");
		hql.append("and pce.procedimiento = prc.id ");
		hql.append("and cex.auditoria." + Auditoria.UNDELETED_RESTICTION
				+ " and prc.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
		hql.append("and prc.estadoProcedimiento.codigo IN ('"
				+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO + "', '"
				+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO
				+ "', '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO
				+ "', '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO
				+ "', '"
				+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION
				+ "') ");

		if (columnaRelacion != null) {
			hql.append("and cex.contrato.id = ").append(columnaRelacion);
		}
		return hql.toString();
	}

	/**
	 * Devuelve un HQL con los contratos existentes en los expedientes en curso.
	 * 
	 * @param columnaRelacion
	 *            Si se le pasa este parametro (!= null) comparará solamente los
	 *            contrato.id que relacionen con el parametro
	 * @return
	 */
	private String getHqlContratosEnExpedientes(String columnaRelacion) {
		StringBuilder hql = new StringBuilder();

		hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, Expediente exp  ");
		hql.append("WHERE exp.id = cex.expediente.id ");
		hql.append("and cex.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
		hql.append("and exp.estadoExpediente.codigo IN ('"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO + "', '"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO + "', '"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO + "') ");

		if (columnaRelacion != null) {
			hql.append("and cex.contrato.id = ").append(columnaRelacion);
		}

		return hql.toString();
	}

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	public Date getUltimaFechaCarga() {
		// si no hemos cacheado la fecha o ha pasado demasiado tiempo desde que la hemos cacheado, la volvemos a consultar.
		if ((staticCheckFechaCargaTimestamp == null)
				|| (staticCacheFechaCarga == null)
				|| ((new Date().getTime() - staticCheckFechaCargaTimestamp) > FECHA_CARGA_CACHE_TIMEOUT)) {
			staticCacheFechaCarga = recuperaUltimaFechaCargaDeBBDD();
                        staticCheckFechaCargaTimestamp = new Date().getTime();
		}

		return staticCacheFechaCarga;
	}

	/**
	 * {@inheritDoc}
	 */
	public Page buscarContratosCliente(DtoBuscarContrato dto) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		StringBuffer hql = new StringBuffer();
		hql.append("select cp.contrato from ");
		hql.append(" ContratoPersona cp, Movimiento m");
		hql.append(" where cp.persona.id = :persona");
		hql.append(" and cp.auditoria.borrado = false ");
		hql.append(" and cp.contrato.id = m.contrato.id");
		hql.append(" and cp.contrato.fechaExtraccion = m.fechaExtraccion");
		param.put("persona", dto.getIdPersona());
		switch (dto.getTipoBusquedaPersona()) {
		case 0:
			// ver persona.getContratosRiesgoDirectoActivo
			hql.append(" and cp.tipoIntervencion.titular= true ");
			hql.append(" and m.riesgo > 0");
			break;
		case 1:
			// ver persona.getContratosRiesgoDirectoPasivo
			hql.append(" and cp.tipoIntervencion.titular= true ");
			hql.append(" and m.riesgo = 0");
			break;
		case 2:
			// ver persona.getContratosRiesgosIndirectos
			hql.append(" and cp.tipoIntervencion.titular = false");
			hql.append(" and m.riesgo > 0");
			break;
		default:
			break;

		}
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql.toString(), dto, param);
	}

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> buscarTotalContratosCliente(
			DtoBuscarContrato dto) {
		StringBuffer hql = new StringBuffer();
		hql.append("select sum(abs(m.posVivaNoVencida)), sum(abs(m.posVivaVencida)), sum(abs(m.saldoPasivo)) from ");
		hql.append(" ContratoPersona cp, Movimiento m");
		hql.append(" where cp.persona.id = ?");
		hql.append(" and cp.auditoria.borrado = false ");
		hql.append(" and cp.contrato.id = m.contrato.id");
		hql.append(" and cp.contrato.fechaExtraccion = m.fechaExtraccion");
		switch (dto.getTipoBusquedaPersona()) {
		case 0:
			// ver persona.getContratosRiesgoDirectoActivo
			hql.append(" and cp.tipoIntervencion.titular= true ");
			hql.append(" and m.riesgo > 0");
			break;
		case 1:
			// ver persona.getContratosRiesgoDirectoPasivo
			hql.append(" and cp.tipoIntervencion.titular= true ");
			hql.append(" and m.riesgo = 0");
			break;
		case 2:
			// ver persona.getContratosRiesgosIndirectos
			hql.append(" and cp.tipoIntervencion.titular= false ");
			hql.append(" and m.riesgo > 0");
			break;
		default:
			break;

		}

		List lista = getHibernateTemplate().find(hql.toString(),
				new Object[] { dto.getIdPersona() });

		Object[] r = (Object[]) lista.get(0);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("posVivaNoVencida", r[0]);
		map.put("posVivaVencida", r[1]);
		map.put("saldoPasivo", r[2]);

		return map;
	}

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	public List<Contrato> obtenerContratosPersonaParaGeneracionExpManual(
			Long idPersona) {
		StringBuffer sb = new StringBuffer();
		String columnaRelacion = "cnt.id";
		sb.append("select cnt from Contrato cnt, ContratoPersona cp ");
		sb.append(" where cnt.id = cp.contrato.id ");
		sb.append(" and cp.persona.id = ?");
		sb.append(" and cp.auditoria.borrado = false");
		sb.append(" and cnt.auditoria.borrado = false");
		// Que no esté en procedimientos (mirando si son o no cancelados)
		sb.append(" and cnt.id not in (")
				.append(getHqlContratosEnProcedimientos(columnaRelacion))
				.append(") ");
		// Que no esté en expedientes (mirando si son o no cancelados)
		sb.append(" and cnt.id not in (")
				.append(getHqlContratosEnExpedientes(columnaRelacion))
				.append(") ");
		// Que el contrato no esté cancelado
		sb.append(" and cnt.estadoContrato.codigo not in (?)");

		// return getHibernateTemplate().find(sb.toString(), new Object[] {
		// idPersona });
		return getHibernateTemplate().find(
				sb.toString(),
				new Object[] { idPersona,
						DDEstadoContrato.ESTADO_CONTRATO_CANCELADO });
	}

	/**
	 * {@inheritDoc}
	 */
	public Page buscarContratosExpediente(DtoBuscarContrato dto) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		StringBuffer hql = new StringBuffer();
		hql.append(" select ec.contrato from ");
		hql.append(" ExpedienteContrato ec, Contrato c, Movimiento m ");
		hql.append(" where ec.expediente.id = :expediente ");
		hql.append(" and ec.auditoria.borrado = false ");
		hql.append(" and ec.contrato.id = c.id ");
		hql.append(" and c.id = m.contrato.id");
		hql.append(" and c.fechaExtraccion = m.fechaExtraccion");
		hql.append(" and m.riesgo > 0");

		hql.append(" order by ec.pase desc");

		param.put("expediente", dto.getIdExpediente());
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql.toString(), dto, param);
	}

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	public List<Persona> buscarClientesDeContratos(String[] contratos) {
		String hql = "select distinct cpe.persona "
				+ "from ContratoPersona cpe " + "where cpe.contrato.id in (";
		for (int i = 0; i < contratos.length; i++) {
			if (i > 0) {
				hql += ", ";
			}
			hql += contratos[i];
		}
		hql += ")";
		return getHibernateTemplate().find(hql);
	}

	/**
	 * Busca el ExpedienteContrato a partir del contrato.
	 * 
	 * @param idContrato
	 *            el id del contrato
	 * @return el ExpedienteContrato
	 */
	@SuppressWarnings("unchecked")
	public ExpedienteContrato buscarExpedienteContrato(Long idContrato) {
		String hql = "from ExpedienteContrato where contrato.id = ? and auditoria.borrado = 0 and expediente.auditoria.borrado = 0";
		List<ExpedienteContrato> ecs = getHibernateTemplate().find(hql,
				idContrato);
		if (ecs.size() > 0) {
			return ecs.get(0);
		}
		return null;
	}

	/**
	 * Busca el ExpedienteContrato a partir del contrato y el expediente.
	 * 
	 * @param idContrato
	 *            el id del contrato
	 * @param idExpediente
	 *            el id del expediente
	 * @return el ExpedienteContrato
	 */
	@SuppressWarnings("unchecked")
	public ExpedienteContrato buscarExpedienteContratoByContratoExpediente(
			Long idContrato, Long idExpediente) {
		String hql = "from ExpedienteContrato where contrato.id = ? and expediente.id = ? and auditoria.borrado = 0 and expediente.auditoria.borrado = 0";
		List<ExpedienteContrato> ecs = getHibernateTemplate().find(hql,
				new Object[] { idContrato, idExpediente });
		if (ecs.size() > 0) {
			return ecs.get(0);
		}
		return null;
	}

	/**
	 * Genera la query HQL para la búsqueda de contratos.
	 * 
	 * @param dto
	 *            BusquedaContratosDto: con los parámetros de búsqueda
	 * @return String
	 */
	private String generarHQLBuscarContratosPaginados(BusquedaContratosDto dto) {
		StringBuffer hql = new StringBuffer();

		boolean cruzaMovimientos = (dto.existenCamposMinMaxCargados() || dto
				.isInclusion());
		boolean cruzaPersonas = ((dto.getNombre() != null && dto.getNombre()
				.trim().length() > 0)
				|| (dto.getApellido1() != null && dto.getApellido1().trim()
						.length() > 0)
				|| (dto.getApellido2() != null && dto.getApellido2().trim()
						.length() > 0) || (dto.getDocumento() != null && dto
				.getDocumento().trim().length() > 0));
		boolean cruzaExpediente = (dto.getDescripcionExpediente() != null && dto
				.getDescripcionExpediente().trim().length() > 0);
		boolean cruzaAsuntos = (dto.getNombreAsunto() != null && dto
				.getNombreAsunto().trim().length() > 0);

		hql.append("select distinct c ");
		hql.append("from ");

		// LAS TABLAS QUE NECESITO
		hql.append("Contrato c ");

		if (cruzaMovimientos) {
			hql.append(", Movimiento mov");
		}
		if (cruzaPersonas) {
			hql.append(", Persona p, ContratoPersona cp");
		}
		if (cruzaExpediente || cruzaAsuntos) {
			hql.append(", Expediente e, ExpedienteContrato cex");
		}
		if (cruzaAsuntos) {
			hql.append(", Asunto asu");
		}
		hql.append(" where 1=1 ");

		// *** LOS CRUCES CON LAS TABLAS ***
		if (cruzaMovimientos) {
			hql.append(" and mov.contrato = c");
			hql.append(" and mov.fechaExtraccion = c.fechaExtraccion"); // selec.
																		// de
																		// últim.
																		// mov.
		}
		if (cruzaPersonas) {
			hql.append(" and cp.persona = p and cp.contrato = c ");
                        //hql.append(" and  cp.auditoria.borrado = 0 ");
			//hql.append(" and cp.tipoIntervencion.titular = true and cp.orden = 1 ");
		}
		if (cruzaExpediente || cruzaAsuntos) {
			hql.append(" and cex.auditoria.borrado = 0 and cex.contrato = c and cex.expediente = e ");
		}
		if (cruzaAsuntos) {
			hql.append(" and asu.auditoria.borrado = 0 and asu.expediente = e ");
		}

		// *** LAS CONDICIONES ***
		// En caso de que sea una búsqueda para una inclusión de contratos a un
		// expediente (F3_WEB-10)
		if (dto.isInclusion()) {
			String columnaRelacion = "c.id";
			// Que no esté en procedimientos (mirando si son o no cancelados)
			hql.append(" and c.id not in (")
					.append(getHqlContratosEnProcedimientos(columnaRelacion))
					.append(")");
			// Que no esté en expedientes (mirando si son o no cancelados)
			//hql.append(" and c.id not in (")
			//		.append(getHqlContratosEnExpedientes(columnaRelacion))
			//		.append(")");
			// Que sea activo o pasivo negativo
			hql.append(" and mov.riesgo > 0 ");
		}
		// Numero de contrato
		if (dto.getNroContrato() != null
				&& dto.getNroContrato().trim().length() > 0) {
			hql.append(" and c.nroContrato like '%"
					+ dto.getNroContrato().trim() + "%'");
		}
		// Nombre
		if (dto.getNombre() != null && dto.getNombre().trim().length() > 0) {
			hql.append(" and upper(p.nombre) like '%"
					+ dto.getNombre().trim().toUpperCase() + "%'");
		}
		// Apellido1
		if (dto.getApellido1() != null
				&& dto.getApellido1().trim().length() > 0) {
			hql.append(" and upper(p.apellido1) like '%"
					+ dto.getApellido1().trim().toUpperCase() + "%'");
		}
		// Apellido2
		if (dto.getApellido2() != null
				&& dto.getApellido2().trim().length() > 0) {
			hql.append(" and upper(p.apellido2) like '%"
					+ dto.getApellido2().trim().toUpperCase() + "%'");
		}
		// DNI
		if (dto.getDocumento() != null
				&& dto.getDocumento().trim().length() > 0) {
			hql.append(" and upper(p.docId) like '%"
					+ dto.getDocumento().toUpperCase() + "%'");
		}
		// Nombre del Expediente
		if (dto.getDescripcionExpediente() != null
				&& dto.getDescripcionExpediente().trim().length() > 0) {
			hql.append(" and UPPER(e.descripcionExpediente) like '%"
					+ dto.getDescripcionExpediente().toUpperCase() + "%' ");
			hql.append(" and e.estadoExpediente.codigo NOT IN ("
					+ DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO + ", "
					+ DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO + ") ");
		}
		// Nombre del Asunto
		if (dto.getNombreAsunto() != null
				&& dto.getNombreAsunto().trim().length() > 0) {
			hql.append(" and UPPER(asu.nombre) like '%"
					+ dto.getNombreAsunto().toUpperCase()
					+ "%' and cex.sinActuacion = 0 ");
			hql.append(" and asu.estadoAsunto.codigo NOT IN ("
					+ DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO + ", "
					+ DDEstadoAsunto.ESTADO_ASUNTO_CERRADO + ")");
		}
		// Estado del contrato
		if (dto.getEstadosContrato() != null
				&& dto.getEstadosContrato().size() > 0) {
			hql.append(" and c.estadoContrato.codigo IN (");
			for (Iterator<String> it = dto.getEstadosContrato().iterator(); it
					.hasNext();) {
				String codigo = it.next();
				hql.append("'" + codigo + "'");
				if (it.hasNext()) {
					hql.append(", ");
				}
			}
			hql.append(")");
		}
		// Estado financiero
		if (dto.getEstadosFinancieros() != null
				&& dto.getEstadosFinancieros().size() > 0) {
			hql.append(" and c.estadoFinanciero.codigo IN (");
			for (Iterator<String> it = dto.getEstadosFinancieros().iterator(); it
					.hasNext();) {
				String codigo = it.next();
				hql.append("'" + codigo + "'");
				if (it.hasNext()) {
					hql.append(", ");
				}
			}
			hql.append(")");
		}
		// Tipo de producto
		if (dto.getTiposProducto() != null
				&& !dto.getTiposProducto().equals("")) {
			hql.append(" and c.tipoProducto.codigo in ("
					+ dto.getTiposProducto() + ")");
		}
		if (cruzaMovimientos) {
			if (dto.getMaxVolRiesgoVencido() != null
					&& dto.getMaxVolRiesgoVencido().trim().length() > 0) {
				String valor = dto.getMaxVolRiesgoVencido();
				hql.append(" and mov.posVivaVencida <= " + valor + " ");
			}

			if (dto.getMinVolRiesgoVencido() != null
					&& dto.getMinVolRiesgoVencido().trim().length() > 0) {
				String valor = dto.getMinVolRiesgoVencido();
				hql.append(" and mov.posVivaVencida >= " + valor + " ");
			}
			String maxVolTotalRiesgo = null;
			String minVolTotalRiesgo = null;
			if (dto.getMaxVolTotalRiesgo() != null
					&& dto.getMaxVolTotalRiesgo().trim().length() > 0) {
				maxVolTotalRiesgo = dto.getMaxVolTotalRiesgo();
			}
			if (dto.getMinVolTotalRiesgo() != null
					&& dto.getMinVolTotalRiesgo().trim().length() > 0) {
				minVolTotalRiesgo = dto.getMinVolTotalRiesgo();
			}
			if (dto.getTieneRiesgo() != null && !dto.getTieneRiesgo()) {
				maxVolTotalRiesgo = "0";
				minVolTotalRiesgo = "0";
			}
			if (minVolTotalRiesgo != null) {
				hql.append(" and mov.riesgo >= " + minVolTotalRiesgo + " ");
			}
			if (maxVolTotalRiesgo != null) {
				hql.append(" and mov.riesgo <= " + maxVolTotalRiesgo + " ");
			}
			if (dto.getMinDiasVencidos() != null
					&& dto.getMinDiasVencidos().trim().length() > 0) {
				hql.append(" and FLOOR(SYSDATE-mov.fechaPosVencida) >= "
						+ dto.getMinDiasVencidos() + " ");
			}
			if (dto.getMaxDiasVencidos() != null
					&& dto.getMaxDiasVencidos().trim().length() > 0) {
				hql.append(" and FLOOR(SYSDATE-mov.fechaPosVencida) <= "
						+ dto.getMaxDiasVencidos() + " ");
			}
		}
		if (dto.getCodigosZona() != null && dto.getCodigosZona().size() > 0) {
			int cantZonas = dto.getCodigosZona().size();
			if (cantZonas > 0) {
				hql.append(" and ( ");
				for (Iterator<String> it = dto.getCodigosZona().iterator(); it
						.hasNext();) {
					String codigoZ = it.next();
					hql.append(" c.oficina.zona.codigo like '" + codigoZ + "%'");
					if (it.hasNext()) {
						hql.append(" OR");
					}
				}
				hql.append(" ) ");
			}
		}
		return hql.toString();
	}

	/**
	 * {@inheritDoc}
	 */
	public Page buscarContratosPaginados(BusquedaContratosDto dto) {
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				generarHQLBuscarContratosPaginados(dto), dto);
	}

	/**
	 * {@inheritDoc}
	 */
	public int buscarContratosPaginadosCount(BusquedaContratosDto dto) {
		String hql = createQueryForCount(generarHQLBuscarContratosPaginados(dto));
		return ((Long) getHibernateTemplate().find(hql).get(0)).intValue();
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

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings({ "unchecked", "cast" })
	public List<Contrato> getContratosById(String ids) {
		String hql = "from Contrato cnt " + "where cnt.id in (" + ids + ")"
				+ "      and cnt.auditoria." + Auditoria.UNDELETED_RESTICTION;
		try {
			return (List<Contrato>) getHibernateTemplate().find(hql);
		} catch (org.springframework.dao.DataAccessException e) {
			throw new UserException(
					"inclusionContratos.error.contratosInvalidos");
		}
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Page getTitulosContratoPaginado(DtoBuscarContrato dto) {
		String hql = "from Titulo t where t.contrato.id = :idContrato and t.auditoria.borrado = 0";
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("idContrato", dto.getId());
		return paginationManager.getHibernatePage(getHibernateTemplate(), hql,
				dto, params);
	}

	/**
	 * busca los expedientes en los que esté o haya estado el contrato.
	 * 
	 * @param idContrato
	 *            el id del contrato.
	 * @return la lista de expedientes.
	 */
	@SuppressWarnings("unchecked")
	public List<Expediente> buscarExpedientesHistoricosContrato(Long idContrato) {
		String hql = "select expediente from ExpedienteContrato ec where ec.contrato.id = ? order by ec.expediente.auditoria.fechaCrear desc";
		return getHibernateTemplate().find(hql, idContrato);
	}

	@Override
	public List<ExpedienteContrato> buscarContratosExpedientesHistoricosContrato(
			Long idContrato) {
		String hql = "select ec from ExpedienteContrato ec where ec.contrato.id = ? and ec.auditoria.borrado = 0 order by ec.expediente.auditoria.fechaCrear desc";
		return getHibernateTemplate().find(hql, idContrato);
	}

	/**
	 * Ejecuta la consulta para recuperar la úliima fecha de carga contra la
	 * BBDD
	 * 
	 * @return
	 */
	private Date recuperaUltimaFechaCargaDeBBDD() {
		String hql = "select max(cnt.fechaExtraccion) as fecha from Contrato cnt";
		List<Date> lista = getSession().createQuery(hql).list();
		if (lista.size() > 0) {
			return lista.get(0);
		}
		return null;
	}
	
	public Integer contadorReincidencias(Long idContrato){
		
		
		AcnAntecedContratos acn = genericDao.get(AcnAntecedContratos.class, genericDao.createFilter(FilterType.EQUALS, "id", idContrato) );
		
		if(acn==null)
			return 0;
		else
			return acn.getNumeroReincidencias();
		
	}

}
