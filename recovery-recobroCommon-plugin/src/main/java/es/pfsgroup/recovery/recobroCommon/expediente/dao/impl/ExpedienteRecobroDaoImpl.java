package es.pfsgroup.recovery.recobroCommon.expediente.dao.impl;

import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.expediente.dao.ExpedienteRecobroDao;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroDDTipoCorrector;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;

@Repository("ExpedienteRecobroDao")
public class ExpedienteRecobroDaoImpl extends AbstractEntityDao<ExpedienteRecobro, Long> implements ExpedienteRecobroDao {

	@Resource
	private PaginationManager paginationManager;
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Contrato> obtenerContratosPersonaParaGeneracionExpManual(Long idPersona) {
		StringBuffer sb = new StringBuffer();
		String columnaRelacion = "cnt.id";
		sb.append("select cnt from Contrato cnt, ContratoPersona cp ");
		sb.append(" where cnt.id = cp.contrato.id ");
		sb.append(" and cp.persona.id = ?");
		sb.append(" and cp.auditoria.borrado = false");
		sb.append(" and cnt.auditoria.borrado = false");
		// Que no está en procedimientos (mirando si son o no cancelados)
		sb.append(" and cnt.id not in (").append(getHqlContratosEnProcedimientos(columnaRelacion)).append(") ");
		// Que no está en expedientes (mirando si son o no cancelados)
		sb.append(" and cnt.id not in (").append(getHqlContratosEnExpedientes(columnaRelacion)).append(") ");
		// Que el contrato no está cancelado
		sb.append(" and cnt.estadoContrato.codigo not in (?)");

		// return getHibernateTemplate().find(sb.toString(), new Object[] {
		// idPersona });
		return getHibernateTemplate().find(sb.toString(), new Object[] { idPersona, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO });
	}
	
	/**
     * Devuelve un HQL con los contratos existentes en los procedimientos en curso.
     * @param columnaRelacion Si se le pasa este parametro (!= null) comparará solamente los contrato.id que relacionen con el parametro
     * @return
     */
    private String getHqlContratosEnProcedimientos(String columnaRelacion) {
        StringBuilder hql = new StringBuilder();

        hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, ProcedimientoContratoExpediente pce, Procedimiento prc ");
        hql.append("WHERE cex.id = pce.expedienteContrato ");
        hql.append("and pce.procedimiento = prc.id ");
        hql.append("and cex.auditoria." + Auditoria.UNDELETED_RESTICTION + " and prc.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
        hql.append("and prc.estadoProcedimiento.codigo IN ('" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO + "', '"
                + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO + "', '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO + "', '"
                + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO + "', '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION + "') ");

        if (columnaRelacion != null) {
            hql.append("and cex.contrato.id = ").append(columnaRelacion);
        }
        return hql.toString();
    }
    
    /**
     * Devuelve un HQL con los contratos existentes en los expedientes en curso.
     * @param columnaRelacion Si se le pasa este parametro (!= null) comparará solamente los contrato.id que relacionen con el parametro
     * @return
     */
    private String getHqlContratosEnExpedientes(String columnaRelacion) {
        StringBuilder hql = new StringBuilder();

        hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, ExpedienteRecobro exp  ");
        hql.append("WHERE exp.id = cex.expediente.id ");
        hql.append("and cex.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
        hql.append("and exp.estadoExpediente.codigo IN ('" + DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO + "', '"
                + DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO + "', '" + DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO + "') ");

        if (columnaRelacion != null) {
            hql.append("and cex.contrato.id = ").append(columnaRelacion);
        }

        return hql.toString();
    }

	@SuppressWarnings("unchecked")
	@Override
	public List<RecobroModeloFacturacion> getModeloFacturacion() {
		
		StringBuffer sb = new StringBuffer();
		sb.append(" select rmf from RecobroModeloFacturacion rmf");
		sb.append(" where rmf.auditoria.borrado = false");
		// Que no este en definición
		sb.append(" and rmf.estado.codigo <> '"+RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION+"'");
		// Que no esté en tipo corrector ranking
		sb.append(" AND (rmf.tipoCorrector NOT IN (FROM RecobroDDTipoCorrector TCO WHERE TCO.codigo = '"+RecobroDDTipoCorrector.CORRECTO_TIPO_RANKING +"')");
		sb.append(" OR rmf.tipoCorrector is null)");
		
		return getHibernateTemplate().find(sb.toString(), new Object[] { });
	}

	@Override
	public void deletePersonaExpediente(Long idExpediente, Long idPersona) {
        String sql = "DELETE FROM pex_personas_expediente WHERE EXP_ID = " + idExpediente + " AND PER_ID = " + idPersona;

        Session sesion = getSession();

        try {
            sesion.createSQLQuery(sql).executeUpdate();
        } finally {
            releaseSession(sesion);
        }
		
	}

	@Override
	public Page buscarContratosRecobroPaginados(BusquedaContratosDto dto, Usuario usuLogado) {
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				generarHQLBuscarContratosPaginados(dto, usuLogado), dto);
	}

	/**
	 * Genera la query HQL para la búsqueda de contratos.
	 * 
	 * @param dto
	 *            BusquedaContratosDto: con los parámetros de búsqueda
	 * @return String
	 */
	private String generarHQLBuscarContratosPaginados(BusquedaContratosDto dto,
			Usuario usuLogado) {
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
		boolean cruzaAsuntos = ((dto.getNombreAsunto() != null && dto
				.getNombreAsunto().trim().length() > 0) || usuLogado
				.getUsuarioExterno());

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
			hql.append(", ExpedienteRecobro e, ExpedienteContrato cex");
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
																		// ï¿½ltim.
																		// mov.
		}
		if (cruzaPersonas) {
			hql
					.append(" and cp.persona = p and cp.contrato = c and cp.auditoria.borrado = 0 ");
			hql
					.append(" and cp.tipoIntervencion.titular = true and cp.orden = 1 ");
		}
		if (cruzaExpediente || cruzaAsuntos) {
			hql
					.append(" and cex.auditoria.borrado = 0 and cex.contrato = c and cex.expediente = e ");
		}
		if (cruzaAsuntos) {
			hql
					.append(" and asu.auditoria.borrado = 0 and asu.expediente = e ");
		}

		// *** LAS CONDICIONES ***
		// En caso de que sea una búsqueda para una inclusión de contratos a un
		// expediente (F3_WEB-10)
		if (dto.isInclusion()) {
			String columnaRelacion = "c.id";
			// Que no estï¿½ en procedimientos (mirando si son o no cancelados)
			hql.append(" and c.id not in (").append(
					getHqlContratosEnProcedimientos(columnaRelacion)).append(
					")");
			// Que no estï¿½ en expedientes (mirando si son o no cancelados)
			hql.append(" and c.id not in (").append(
					getHqlContratosEnExpedientes(columnaRelacion)).append(")");
			// Que sea activo o pasivo negativo
			hql.append(" and mov.riesgo > 0 ");
		}
		// Numero de contrato
		if (dto.getNroContrato() != null
				&& dto.getNroContrato().trim().length() > 0) {
			hql.append(" and (c.nroContrato like '%"
					+ dto.getNroContrato().trim().replaceFirst("^0*", "")
					+ "%' or c.nroContrato like '%"
					+ dto.getNroContrato().trim() + "%')");
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
		// Usuario externo, muestra solo los contratos que estï¿½n en sus asuntos
		if (usuLogado.getUsuarioExterno()) {
			hql.append(hqlFiltroEsGestorAsunto(usuLogado)
					+ " and cex.sinActuacion = 0 ");
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
					hql
							.append(" c.oficina.zona.codigo like '" + codigoZ
									+ "%'");
					if (it.hasNext()) {
						hql.append(" OR");
					}
				}
				// SE PONE ESTE FILTRO AQUï¿½, DEBIDO A QUE PARA VISUALIZAR EL
				// CONTRATO, PUEDE O BIEN PERTENECER A LA ZONA
				// DEL USUARIO LOGEADO, O QUE ESTE SEA GESTOR DEL CONTRATO
				hql.append(" or c.id in (");
				hql.append(generaFiltroContratosPorGestor(usuLogado));
				hql.append(")");
				hql.append(" ) ");
			}
		} else {// EN CASO DE QUE NO TENGA ZONAS ASIGNADAS Y SEA GESTOR DEL
				// CONTRATO
			// DEBE PODER SEGUIR VISUALIZANDO EL CONTRATO
			hql.append(" and c.id in ( ");
			hql.append(generaFiltroContratosPorGestor(usuLogado));
			hql.append(" ) ");
		}
		return hql.toString();
	}
	
	private String hqlFiltroEsGestorAsunto(Usuario usuLogado) {
		String monogestor = "(asu.id in (select a.id from Asunto a where a.gestor.usuario.id = "
				+ usuLogado.getId() + "))";
		String multigestor = "(asu.id in (select gaa.asunto.id from EXTGestorAdicionalAsunto gaa where gaa.gestor.usuario.id = "
				+ +usuLogado.getId() + "))";
		return "and (" + monogestor + " or " + multigestor + ")";
	}
	
	/***
	 * Devuelve un hql utilizado como subconsulta para obtener los contratos del
	 * que el usuario es gestor
	 * 
	 * @param usuLogado
	 *            Usuario logueado que ha realizado la busqueda
	 * 
	 * @return hql con la busqueda del contrato por gestor
	 * 
	 * */
	private String generaFiltroContratosPorGestor(Usuario usuLogado) {
		StringBuffer hql = new StringBuffer();
		hql.append(" select cnt.id from Contrato cnt , EXTGestorEntidad ge ");
		hql
				.append(
						" where cnt.id = ge.unidadGestionId and ge.tipoEntidad.codigo = '")
				.append(DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO).append("' ");
		hql.append(" and ge.gestor.id = ").append(usuLogado.getId());
		return hql.toString();
	}

}
