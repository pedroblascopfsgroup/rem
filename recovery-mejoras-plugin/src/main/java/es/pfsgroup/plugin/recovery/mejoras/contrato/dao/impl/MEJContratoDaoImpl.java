package es.pfsgroup.plugin.recovery.mejoras.contrato.dao.impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.contrato.dao.MEJContratoDao;
import es.pfsgroup.plugin.recovery.mejoras.contrato.dto.MEJBusquedaContratosDto;

@Repository("MEJContratoDao")
public class MEJContratoDaoImpl extends AbstractEntityDao<Contrato, Long> implements MEJContratoDao{

	 @Resource
	 private PaginationManager paginationManager;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
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
            //ver persona.getContratosRiesgoDirectoActivo
            hql.append(" and cp.tipoIntervencion.titular= true ");
            hql.append(" and (m.riesgo + m.posVivaNoVencida + m.posVivaVencida + m.movIntRemuneratorios + m.movIntMoratorios + m.comisiones + m.gastos ) > 0 ");
            break;
        case 1:
            //ver persona.getContratosRiesgoDirectoPasivo
            hql.append(" and cp.tipoIntervencion.titular= true ");
            hql.append(" and (m.riesgo + m.posVivaNoVencida + m.posVivaVencida + m.movIntRemuneratorios + m.movIntMoratorios + m.comisiones + m.gastos ) = 0 ");
            break;
        case 2:
            //ver persona.getContratosRiesgosIndirectos
            hql.append(" and cp.tipoIntervencion.titular = false");
            appendFiltroAvalista(hql);
            hql.append(" and (m.riesgo + m.posVivaNoVencida + m.posVivaVencida + m.movIntRemuneratorios + m.movIntMoratorios + m.comisiones + m.gastos ) > 0 ");
            break;
        default:
            break;

        }

        return paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dto, param);
    }

	/**
     * {@inheritDoc}
     */
    public HashMap<String, Object> buscarTotalContratosCliente(DtoBuscarContrato dto) {
        StringBuffer hql = new StringBuffer();
        hql.append("select sum(abs(m.posVivaNoVencida)), sum(abs(m.posVivaVencida)), sum(abs(m.saldoPasivo)) from ");
        hql.append(" ContratoPersona cp, Movimiento m");
        hql.append(" where cp.persona.id = ?");
        hql.append(" and cp.auditoria.borrado = false ");
        hql.append(" and cp.contrato.id = m.contrato.id");
        hql.append(" and cp.contrato.fechaExtraccion = m.fechaExtraccion");
        switch (dto.getTipoBusquedaPersona()) {
        case 0:
            //ver persona.getContratosRiesgoDirectoActivo
            hql.append(" and cp.tipoIntervencion.titular= true ");
            hql.append(" and (m.riesgo + m.posVivaNoVencida + m.posVivaVencida + m.movIntRemuneratorios + m.movIntMoratorios + m.comisiones + m.gastos ) > 0 ");
            break;
        case 1:
            //ver persona.getContratosRiesgoDirectoPasivo
            hql.append(" and cp.tipoIntervencion.titular= true ");
            hql.append(" and (m.riesgo + m.posVivaNoVencida + m.posVivaVencida + m.movIntRemuneratorios + m.movIntMoratorios + m.comisiones + m.gastos ) = 0 ");
            break;
        case 2:
            //ver persona.getContratosRiesgosIndirectos
            hql.append(" and cp.tipoIntervencion.titular = false");
            appendFiltroAvalista(hql);
            hql.append(" and (m.riesgo + m.posVivaNoVencida + m.posVivaVencida + m.movIntRemuneratorios + m.movIntMoratorios + m.comisiones + m.gastos ) > 0 ");
            break;
        default:
            break;

        }

        List<?> lista = getHibernateTemplate().find(hql.toString(), new Object[] { dto.getIdPersona() });

        Object[] r = (Object[]) lista.get(0);
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("posVivaNoVencida", r[0]);
        map.put("posVivaVencida", r[1]);
        map.put("saldoPasivo", r[2]);

        return map;
    }

    /** Añade la condición de avalista para las entidades "HAYA" y "CAJAMAR".
	 * 
	 * @param hql
	 */
	private void appendFiltroAvalista(final StringBuffer hql){
		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
        if("CAJAMAR".equals(usuario.getEntidad().getDescripcion()) || "HAYA".equals(usuario.getEntidad().getDescripcion())){
        	hql.append(" and cp.tipoIntervencion.avalista = true");
        }
	}

    public Page buscarContratosExpedienteSinAsignar(DtoBuscarContrato dto) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        StringBuffer hql = new StringBuffer();
        hql.append(" select cex from ");
        hql.append(" ExpedienteContrato cex ");
        hql.append(" where cex.expediente.id = :expediente ");
        hql.append(" and cex.auditoria.borrado = false ");
        hql.append(" and cex.contrato.id not in ");
        hql.append("(select distinct cex.contrato.id from ExpedienteContrato cex,ProcedimientoContratoExpediente pce ");	
        hql.append(" where cex.id = pce.expedienteContrato and cex.expediente.id=: expediente )");

        param.put("expediente", dto.getIdExpediente());
        return paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dto, param);
    }
    
	/******** INTRODUCIDO POR PBO AL ELIMINAR LAS REFERENCIAS A UNNIM EN MEJORAS ********/
	/** AHORA ESTÁ DEPENDIENDO DE UGAS, PERO DEBERÍA DEPENDER DIRACTAMENTE DE MEJORAS ***/
	
	@Override
	public Page buscaContratosSinAsignar(Long idAsunto,
			List<Procedimiento> procedimientos, MEJBusquedaContratosDto dto) {
		return paginationManager.getHibernatePage(
				getHibernateTemplate(),
				generarHQLBuscarContratosSinAsignar(idAsunto, procedimientos,
						dto), dto);
	}

	private String generarHQLBuscarContratosSinAsignar(Long idAsunto,
			List<Procedimiento> procedimientos, MEJBusquedaContratosDto dto) {
		StringBuffer hql = new StringBuffer();

		hql.append("select distinct c ");
		hql.append("from Contrato c left join "

		+ "	  c.contratoPersona cp left join " + "	  cp.persona p left join "
				+ "   c.expedienteContratos cex left join "
				+ "	  cex.expediente exp left join "
				+ "	  exp.asuntos asu left join " + "	  c.movimientos mov ");
		hql.append(" where 1=1 ");
		hql.append(" and mov.fechaExtraccion = c.fechaExtraccion ");

		// Procedimientos
		int i = 0;
		hql.append(" and p.id in (select per.id from Procedimiento proc join proc.personasAfectadas per where proc in (");
		for (Procedimiento procedimiento : procedimientos) {
			i++;
			hql.append(procedimiento.getId() + " ");
			if (i != procedimientos.size()) {
				hql.append(",");
			}
		}
		hql.append("))");

		String columnaRelacion = "c.id";
		// Que no est� en procedimientos (mirando si son o no cancelados)
		hql.append(" and c.id not in (")
				.append(getHqlContratosEnProcedimientos(columnaRelacion))
				.append(")");
		// Que no est� en expedientes (mirando si son o no cancelados)
		hql.append(" and c.id not in (")
				.append(getHqlContratosEnExpedientes(columnaRelacion))
				.append(")");

		// Nombre del Expediente
		if (dto.getDescripcionExpediente() != null
				&& dto.getDescripcionExpediente().trim().length() > 0) {
			hql.append(" and UPPER(e.descripcionExpediente) like '%"
					+ dto.getDescripcionExpediente().toUpperCase() + "%' ");
			hql.append(" and e.estadoExpediente.codigo NOT IN ("
					+ DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO + ", "
					+ DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO + ") ");
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

		return hql.toString();
	}

	/**
	 * Devuelve un HQL con los contratos existentes en los procedimientos en
	 * curso.
	 * 
	 * @param columnaRelacion
	 *            Si se le pasa este parametro (!= null) comparar� solamente los
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
	 *            Si se le pasa este parametro (!= null) comparar� solamente los
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
	
}
