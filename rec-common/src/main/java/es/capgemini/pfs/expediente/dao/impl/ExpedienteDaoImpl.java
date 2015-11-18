package es.capgemini.pfs.expediente.dao.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.dto.DtoListadoExpedientes;
import es.capgemini.pfs.comite.dao.ComiteDao;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.BusquedaExpedienteFiltroDinamico;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.ReglasElevacion;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoGestorEntidad;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.StringUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

/**
 * Clase que agrupa m�todo para la creaci�n y acceso de datos de los
 * expedientes.
 *
 * @author mtorrado
 */
@Repository("ExpedienteDao")
public class ExpedienteDaoImpl extends AbstractEntityDao<Expediente, Long> implements ExpedienteDao {

    private final Log logger = LogFactory.getLog(getClass());

    @Resource
    private PaginationManager paginationManager;
    
	@Autowired
	GenericABMDao genericDao;

    @Autowired
    private ComiteDao comiteDao;

    @Autowired(required = false)
	private List<BusquedaExpedienteFiltroDinamico> filtrosBusquedaDinamica;
    /**
    * {@inheritDoc}
    */
    @SuppressWarnings("unchecked")
    public List<ExpedienteContrato> findContratosExpediente(Long idExpediente, BigDecimal riesgo) {
        StringBuffer hql = new StringBuffer();
        hql.append(" select ec from ");
        hql.append(" ExpedienteContrato ec, Movimiento m, Contrato c");
        hql.append(" where ec.expediente.id = ? ");
        hql.append(" and ec.auditoria.borrado = false ");
        hql.append(" and c.id = ec.contrato.id");
        hql.append(" and c.id = m.contrato.id");
        hql.append(" and c.fechaExtraccion = m.fechaExtraccion");
        if (riesgo!=null)
        {
        	hql.append(" and m.riesgo > ?" );
        	return getHibernateTemplate().find(hql.toString(), new Object[] { idExpediente, riesgo });
        }

        return getHibernateTemplate().find(hql.toString(), new Object[] { idExpediente });
    }
    /**
     * {@inheritDoc}
     */
     @SuppressWarnings("unchecked")
     public List<ExpedienteContrato> findContratosExpediente(Long idExpediente) {         
         return findContratosExpediente(idExpediente,new BigDecimal(0));
     }
    /**
     * {@inheritDoc}
     */
    @Override
    public Long getNumExpedientesActivos(Long idPersona, Boolean isRecuperacion) {
        StringBuffer hql = new StringBuffer();
        hql.append(" select count(distinct e.id) from ");
        hql.append(" Expediente e, ExpedientePersona pex ");
        hql.append(" where e.id = pex.expediente.id and pex.auditoria.borrado = false and e.auditoria.borrado = false ");
        hql.append(" and e.estadoExpediente.codigo in (:estadoActivo, :estadoBloqueado, :estadoCongelado) ");
        hql.append(" and pex.persona.id = :idPersona ");

        if (isRecuperacion)
            hql.append(" and e.arquetipo.itinerario.dDtipoItinerario.codigo = :codigoItinerario");
        else
            hql.append(" and e.arquetipo.itinerario.dDtipoItinerario.codigo <> :codigoItinerario");

        Query q = getSession().createQuery(hql.toString());

        q.setParameter("estadoActivo", DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO);
        q.setParameter("estadoBloqueado", DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO);
        q.setParameter("estadoCongelado", DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO);
        q.setParameter("codigoItinerario", DDTipoItinerario.ITINERARIO_RECUPERACION);
        q.setParameter("idPersona", idPersona);

        return (Long) q.uniqueResult();
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<ExpedienteContrato> findExpedientesContrato(DtoBuscarExpedientes expediente) {
        logger.debug("Buscando expedientes del contrato con id: " + expediente.getIdCnt());

        String hql = "from ExpedienteContrato where ";
        hql += "contrato.id = ? and auditoria.borrado = false";

        return getHibernateTemplate().find(hql, expediente.getIdCnt());
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<String> obtenerSupervisorGeneracionExpediente(DtoBuscarExpedientes expediente) {

        logger.debug("Buscando supervisor del contrato con id: " + expediente.getIdCnt());
        List<String> objects;

        String hql = "from ContratoPersona cp, Cliente cli, DDTipoIntervencion ti, ";
        hql += "Arquetipo arq, Itinerario it, Estado est, DDEstadoItinerario est_it";
        hql += " where ";
        hql += " cp.contrato.id = ? and ";
        hql += " cp.persona.id = cli.persona.id and cp.tipoIntervencion.id = ti.id";
        hql += " and cp.orden = 1 and ti.titular = true ";
        hql += " and cli.arquetipo.id = arq.id and arq.itinerario.id = it.id";
        hql += " and it.id = est.itinerario.id and est.estadoItinerario.id = est_it.id";
        hql += " and UPPER(est_it.codigo) = ? ";
        hql += " and cp.auditoria.borrado = false and cli.auditoria.borrado = false";
        hql += " and ti.auditoria.borrado = false and arq.auditoria.borrado = false";
        hql += " and it.auditoria.borrado = false and est.auditoria.borrado = false";
        hql += " and est_it.auditoria.borrado = false";

        objects = getHibernateTemplate().find(hql, new Object[] { expediente.getIdCnt(), DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE });

        return objects;

    }

    /**
     * {@inheritDoc}
     */
    public Page buscarExpedientesPaginado(DtoBuscarExpedientes dtoExpediente) {
        HashMap<String, Object> params = new HashMap<String, Object>();

        StringBuilder hql = new StringBuilder();
        Boolean requiereRiesgoSaldo = false;

        //BKREC-943
        //hql.append("select e from Expediente e where e.id IN (select exp.id FROM Expediente exp ");
        hql.append("select exp FROM Expediente exp ");

        if (dtoExpediente.getIdComite() != null) {
            hql.append(" left join exp.decisionComite dco left join dco.sesion sesion ");
        }

        if (!StringUtils.emtpyString(dtoExpediente.getMaxSaldoVencido()) || !StringUtils.emtpyString(dtoExpediente.getMaxRiesgoTotal())
                || !StringUtils.emtpyString(dtoExpediente.getMinSaldoVencido()) || !StringUtils.emtpyString(dtoExpediente.getMinRiesgoTotal())) {

            hql.append(", ExpedienteContrato expc, Contrato c, Movimiento m ");
            requiereRiesgoSaldo = true;
        }

        hql.append(" where  ");

        //BKREC-943
        hql.append(" EXISTS (select 1 from Expediente exp1 where exp1.id = exp.id and exp1.auditoria.borrado = 0) ");
        
        if (requiereRiesgoSaldo) {
            hql.append(" and expc.expediente.id = exp.id and expc.auditoria.borrado = 0");
            hql.append(" and expc.contrato.id = c.id ");
            hql.append(" and m.contrato.id = c.id and m.fechaExtraccion = c.fechaExtraccion ");
        }

        //C�digo
        if (dtoExpediente.getCodigo() != null) {
            hql.append(" and exp.id = :expId ");
            params.put("expId", dtoExpediente.getCodigo());
        }

        //Descripcion
        if (!StringUtils.emtpyString(dtoExpediente.getDescripcion())) {
            hql.append(" and LOWER(exp.descripcionExpediente) LIKE '%'|| :descExpediente ||'%' ");
            params.put("descExpediente", dtoExpediente.getDescripcion().toLowerCase().replaceAll("'", "''"));
        }

        // Si no se esta buscando expedientes por comite uso esta busqueda de estado
        if (dtoExpediente.getIdComite() == null && !StringUtils.emtpyString(dtoExpediente.getIdEstado())) {
            hql.append(" and exp.estadoExpediente.codigo = :estExpCod");
            params.put("estExpCod", dtoExpediente.getIdEstado());
        }

        // ***************************************************************************************** //
        // ** Estas opciones me parece que son para la sesion de comite, para mostrar expedientes ** //
        // ***************************************************************************************** //
        //Si busca por comite
        if (dtoExpediente.getIdComite() != null && dtoExpediente.getIdSesion() == null) {
            hql.append(" and (( exp.comite.id = :comiteId and exp.estadoExpediente.codigo = :estExpCong )");
            params.put("comiteId", new Long(dtoExpediente.getIdComite()));
            params.put("estExpCong", DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO);

            Comite comite = comiteDao.get(dtoExpediente.getIdComite());
            hql.append(" or sesion.id = :ultimaSesionId)");
            params.put("ultimaSesionId", new Long(comite.getUltimaSesion().getId()));
        }
        // busco por sesion
        if (dtoExpediente.getIdComite() != null && dtoExpediente.getIdSesion() != null) {
            hql.append(" and exp.comite.id = :comiteId and exp.estadoExpediente.codigo = :estExpDC ");
            params.put("comiteId", new Long(dtoExpediente.getIdComite()));
            params.put("estExpDC", DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO);

            hql.append(" and sesion.id = :sesionId");
            params.put("sesionId", new Long(dtoExpediente.getIdSesion()));
        }
        // ***************************************************************************************** //

        //Numero de contrato
        if (!StringUtils.emtpyString(dtoExpediente.getNroContrato())) {
            hql.append(" and EXISTS ");
            hql.append("(select 1 from ExpedienteContrato ec ");
            hql.append(" where ec.auditoria.borrado = false ");
            hql.append(" and ec.expediente.id = exp.id ");
            hql.append(" and ec.contrato.nroContrato like '%'|| :nroCnt ||'%') ");
            params.put("nroCnt", dtoExpediente.getNroContrato().toLowerCase());
        }

        // *** Este comit� se utiliza para la b�squeda desde la p�gina de b�squedas de expedientes *** //
        if (dtoExpediente.getComiteBusqueda() != null) {
            hql.append(" and exp.comite.id = :comiteBusquedaId ");
            params.put("comiteBusquedaId", dtoExpediente.getComiteBusqueda());
        }

        //Tipo de Gesti�n
        if (!StringUtils.emtpyString(dtoExpediente.getCodigoGestion())) {
            hql.append(" and exp.arquetipo.itinerario.dDtipoItinerario.codigo = :codigoGestion ");
            params.put("codigoGestion", dtoExpediente.getCodigoGestion());
        }

        //VISIBILIDAD
        int cantZonas = dtoExpediente.getCodigoZonas().size();
        if (cantZonas > 0) {
            hql.append(" and ( ");
            for (String codigoZ : dtoExpediente.getCodigoZonas()) {
                hql.append(" exp.oficina.zona.codigo like '" + codigoZ + "%' OR");
            }
            hql.deleteCharAt(hql.length() - 1);
            hql.deleteCharAt(hql.length() - 1);
            hql.append(" ) ");
        }

        //Centros
        if (!StringUtils.emtpyString(dtoExpediente.getCodigoEntidad())) {
            hql.append("  and exp.oficina.zona.nivel.id >= :nivelId ");
            params.put("nivelId", new Long(dtoExpediente.getCodigoEntidad()));
        }

        //Situacion
        if (!StringUtils.emtpyString(dtoExpediente.getCodigoSituacion())) {
            StringTokenizer tokensSituaciones = new StringTokenizer(dtoExpediente.getCodigoSituacion(), ",");
            hql.append(" and exp.estadoItinerario.codigo IN (");
            while (tokensSituaciones.hasMoreTokens()) {
                hql.append("'" + tokensSituaciones.nextElement() + "'");
                if (tokensSituaciones.hasMoreTokens()) {
                    hql.append(",");
                }
            }
            hql.append(" ) ");
        }

        //Tipo de persona y segmentos
        Boolean tipoPersona = !StringUtils.emtpyString(dtoExpediente.getTipoPersona());
        Boolean segmentos = !StringUtils.emtpyString(dtoExpediente.getSegmentos());

        if (tipoPersona || segmentos) {
            hql.append(" and EXISTS (select 1 FROM ExpedientePersona pex, Persona p ");
            hql.append(" where pex.auditoria.borrado = false and pex.persona.id = p.id and pex.pase = 1 ");
            hql.append(" and pex.expediente.id = exp.id ");

            if (tipoPersona) {
                hql.append(" and p.tipoPersona.codigo = :tipoPer ");
                params.put("tipoPer", dtoExpediente.getTipoPersona());
            }

            if (segmentos) {
                hql.append(" and p.segmento.id IN (" + dtoExpediente.getSegmentos() + ") ");
            }
            hql.append(" ) ");

        }

        // ********* RIESGO Y SALDO TOTAL  ************** //
        if (requiereRiesgoSaldo) {
            hql.append(" group by exp.id ");
            if (dtoExpediente.getMaxSaldoVencido() == null || dtoExpediente.getMaxSaldoVencido().length() < 1) {
                dtoExpediente.setMaxSaldoVencido("" + Integer.MAX_VALUE);
            }
            if (dtoExpediente.getMinSaldoVencido() == null || dtoExpediente.getMinSaldoVencido().length() < 1) {
                dtoExpediente.setMinSaldoVencido("" + Integer.MIN_VALUE);
            }
            if (dtoExpediente.getMaxRiesgoTotal() == null || dtoExpediente.getMaxRiesgoTotal().length() < 1) {
                dtoExpediente.setMaxRiesgoTotal("" + Integer.MAX_VALUE);
            }
            if (dtoExpediente.getMinRiesgoTotal() == null || dtoExpediente.getMinRiesgoTotal().length() < 1) {
                dtoExpediente.setMinRiesgoTotal("" + Integer.MIN_VALUE);
            }

            hql.append(" having sum(case when m.riesgo > 0 then m.deudaIrregular else 0 end ) between :minSaldoVencido and :maxSaldoVencido ");
            params.put("minSaldoVencido", new Double(dtoExpediente.getMinSaldoVencido()));
            params.put("maxSaldoVencido", new Double(dtoExpediente.getMaxSaldoVencido()));

            hql.append(" and sum(m.riesgo) between :minRiesgoTotal and :maxRiesgoTotal ");
            params.put("minRiesgoTotal", new Double(dtoExpediente.getMinRiesgoTotal()));
            params.put("maxRiesgoTotal", new Double(dtoExpediente.getMaxRiesgoTotal()));
        }

        hql.append(")");

        return paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dtoExpediente, params);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Expediente> obtenerExpedientesDeUnaPersona(Long idPersona) {
        String hqlExpedientesPersonas = "select distinct pex.expediente from ExpedientePersona pex ";
        hqlExpedientesPersonas += " where pex.auditoria.borrado = false ";
        hqlExpedientesPersonas += " and  pex.expediente.auditoria.borrado = false ";
        hqlExpedientesPersonas += " and pex.persona.id = ?";

        return getHibernateTemplate().find(hqlExpedientesPersonas, new Object[] { idPersona });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Long> obtenerExpedientesDeUnaPersonaNoCancelados(Long idPersona) {

        String hqlExpedientesPersonas = "select distinct pex.expediente.id from ExpedientePersona pex ";
        hqlExpedientesPersonas += " where pex.auditoria.borrado = false ";
        hqlExpedientesPersonas += " and  pex.expediente.auditoria.borrado = false ";
        hqlExpedientesPersonas += " and pex.persona.id = ?";
        hqlExpedientesPersonas += " and pex.expediente.estadoExpediente.codigo in (?, ?, ?)";

        return getHibernateTemplate().find(
                hqlExpedientesPersonas,
                new Object[] { idPersona, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO, DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO,
                        DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Persona> findPersonasContratosExpediente(Long id) {
        String hqlExpedientesPersonas = "select distinct pex.persona from ExpedientePersona pex ";
        hqlExpedientesPersonas += " where pex.auditoria.borrado = false ";
        hqlExpedientesPersonas += " and  pex.expediente.auditoria.borrado = false ";
        hqlExpedientesPersonas += " and pex.expediente.id = ?";

        return getHibernateTemplate().find(hqlExpedientesPersonas, new Object[] { id });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Persona> findPersonasContratosConAdjuntos(Long id) {
        String hqlExpedientesPersonas = "select distinct pex.persona from ExpedientePersona pex, AdjuntoPersona adp ";
        hqlExpedientesPersonas += " where pex.expediente.id = ? ";
        hqlExpedientesPersonas += " and pex.persona = adp.persona ";
        hqlExpedientesPersonas += " and pex.expediente.auditoria.borrado = false ";
        hqlExpedientesPersonas += " and adp.auditoria." + Auditoria.UNDELETED_RESTICTION;
        hqlExpedientesPersonas += " and pex.auditoria." + Auditoria.UNDELETED_RESTICTION;

        return getHibernateTemplate().find(hqlExpedientesPersonas, new Object[] { id });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Persona> findPersonasTitContratosExpediente(Long id) {
        String hql = "select distinct(cex.persona) ";
        hql += " from Expediente exp, ";
        hql += " ExpedienteContrato cex, ";
        hql += " ContratoPersona cpe, ";
        hql += " DDTipoIntervencion tin ";
        hql += " where cex.expediente.id = exp.id ";
        hql += "  and cex.contrato.id = cpe.id ";
        hql += "  and cpe.tipoIntervencion.id = tin.id ";
        hql += "  and exp.id = ? ";
        hql += "  and tin.titular = true ";
        hql += "  and exp.auditoria.borrado = false ";
        hql += "  and cex.auditoria.borrado = false ";
        hql += "  and cpe.auditoria.borrado = false ";
        hql += "  and tin.auditoria.borrado = false ";

        return getHibernateTemplate().find(hql, new Object[] { id });
    }

    /**
      * {@inheritDoc}
      */
    @SuppressWarnings("unchecked")
    public List<Persona> findContratosConAdjuntos(Long idExpediente) {
        String hql = "select distinct expCnt.contrato " + " from Expediente exp join exp.contratos expCnt "
                + "      join expCnt.contrato.adjuntos adj " + " where exp.id = ? " + "       and exp.auditoria." + Auditoria.UNDELETED_RESTICTION;

        return getHibernateTemplate().find(hql, idExpediente);
    }

    /**
      * {@inheritDoc}
      */
    @SuppressWarnings("unchecked")
    @Override
    public Expediente buscarExpedientesParaContrato(Long idContrato) {
        StringBuilder hql = new StringBuilder();

        hql.append(" select e from Expediente e, ExpedienteContrato cex ");
        hql.append(" where e.auditoria.borrado = false and cex.auditoria.borrado = false and e.id = cex.expediente.id ");
        hql.append(" and cex.contrato.id = ? ");
        hql.append(" and e.estadoExpediente.codigo in ( ?, ?, ?) ");

        List<Expediente> expedientes = getHibernateTemplate().find(
                hql.toString(),
                new Object[] { idContrato, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO, DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO,
                        DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO });
        if (expedientes.size() > 1) { throw new BusinessOperationException("expediente.contrato.invalido.masDeUnExpediente", idContrato); }
        if (expedientes.size() == 1) { return expedientes.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Expediente buscarExpedientesSeguimientoParaPersona(Long idPersona) {
        StringBuilder hql = new StringBuilder();
        hql.append(" select e from Expediente e, ExpedientePersona pex ");
        hql.append(" where e.auditoria.borrado = false and pex.auditoria.borrado = false and e.id = pex.expediente.id ");
        hql.append(" and pex.persona.id = ? ");
        hql.append(" and e.estadoExpediente.codigo in ( ?, ?, ?) ");
        hql.append(" and e.arquetipo.itinerario.dDtipoItinerario.codigo IN (?, ?) ");

        List<Expediente> expedientes = getHibernateTemplate().find(
                hql.toString(),
                new Object[] { idPersona, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO, DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO,
                        DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO, DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SINTOMATICO,
                        DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SISTEMATICO });

        if (expedientes.size() > 1) { throw new BusinessOperationException("expediente.persona.invalido.masDeUnExpediente", idPersona); }
        if (expedientes.size() == 1) { return expedientes.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Long> obtenerContratosRelacionadosExpedienteGrupo(List<Long> contratosExpediente, Long idPersona) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        StringBuilder hql = new StringBuilder();

        String listadoContratos = armarParamContratos(contratosExpediente);
        String columnaRelacion = "con.id";

        hql.append(" select con.id from Persona p, ContratoPersona cp, Contrato con, Movimiento mov ");
        hql.append(" where cp.persona.id = p.id and cp.auditoria.borrado = false and p.auditoria.borrado = 0 ");
        hql.append(" and cp.contrato.id = con.id and con.auditoria.borrado = 0 ");
        hql.append(" and con.id = mov.contrato.id and con.fechaExtraccion = mov.fechaExtraccion ");

        //Que el contrato no est� cancelado
        hql.append(" and con.estadoContrato.codigo <> :estadoContratoCancelado ");
        param.put("estadoContratoCancelado", DDEstadoContrato.ESTADO_CONTRATO_CANCELADO);

        
        //Que pertenezca al grupo de personas
//        hql.append(" and "
//        		+ "p.grupos.grupoCliente.id "
//        		+ " in (select pg.grupoCliente.id from PersonaGrupo pg where pg.persona.id = :idPersona) ");

        hql.append(" and p.id in ("
        		+ "select pg.persona.id from PersonaGrupo pg where pg.grupoCliente.id in"        		
        		+ "(select gc.grupoCliente.id from PersonaGrupo gc where gc.persona.id = :idPersona)) ");

        param.put("idPersona", idPersona);

        //Que no est� dentro de los contratos ya seleccionados
        hql.append(" and con.id not in (").append(listadoContratos).append(")");

        //Que no est� en otros asuntos
        hql.append(" and con.id not in (").append(getHqlContratosEnProcedimientos(columnaRelacion)).append(")");

        //Que no est� en otros expedientes
        hql.append(" and con.id not in (").append(getHqlContratosEnExpedientes(columnaRelacion)).append(")");

        //Agrupamos por contrato y ordenamos por el vencimiento para poder extraer los m�s altos primero
        hql.append(" order by mov.riesgo DESC");

        Query query = getSession().createQuery(hql.toString());
        query.setProperties(param);

        return query.list();
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Long> obtenerContratosRelacionadosExpedientePrimeraGeneracion(List<Long> contratosExpediente) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        StringBuilder hql = new StringBuilder();

        String listadoContratos = armarParamContratos(contratosExpediente);
        String columnaRelacion = "con.id";

        hql.append(" select con.id from Persona p, ContratoPersona cp, Contrato con, Movimiento mov ");
        hql.append(" where cp.persona.id = p.id and cp.auditoria.borrado = false and p.auditoria.borrado = false ");
        hql.append(" and cp.contrato.id = con.id and con.auditoria.borrado = false ");
        hql.append(" and con.id = mov.contrato.id and con.fechaExtraccion = mov.fechaExtraccion ");

        //Que el contrato no est� cancelado
        hql.append(" and con.estadoContrato.codigo <> :estadoContratoCancelado ");
        param.put("estadoContratoCancelado", DDEstadoContrato.ESTADO_CONTRATO_CANCELADO);

        //Que pertenezca a las personas de los contratos seleccionados
        hql.append(" and cp.persona in (").append(armarQueryObtienePersonasRelacionadas(listadoContratos)).append(" )");

        //Que no est� dentro de los contratos ya seleccionados
        hql.append(" and con.id not in (").append(listadoContratos).append(")");

        //Que no est� en otros asuntos
        hql.append(" and con.id not in (").append(getHqlContratosEnProcedimientos(columnaRelacion)).append(")");

        //Que no est� en otros expedientes
        hql.append(" and con.id not in (").append(getHqlContratosEnExpedientes(columnaRelacion)).append(")");

        //Agrupamos por contrato y ordenamos por el vencimiento para poder extraer los m�s altos primero
        hql.append(" order by mov.riesgo DESC");

        Query query = getSession().createQuery(hql.toString());
        query.setProperties(param);

        return query.list();
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Long> obtenerContratosRelacionadosExpedienteSegundaGeneracion(List<Long> contratosExpediente) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        StringBuilder hql = new StringBuilder();

        String listadoContratos = armarParamContratos(contratosExpediente);
        String columnaRelacion = "con.id";

        hql.append(" select con.id from Persona p, ContratoPersona cp, Contrato con, Movimiento mov ");
        hql.append(" where cp.persona.id = p.id and cp.auditoria.borrado = false and p.auditoria.borrado = false ");
        hql.append(" and cp.contrato.id = con.id and con.auditoria.borrado = false ");
        hql.append(" and con.id = mov.contrato.id and con.fechaExtraccion = mov.fechaExtraccion ");

        //Que el contrato no est� cancelado
        hql.append(" and con.estadoContrato.codigo <> :estadoContratoCancelado ");
        param.put("estadoContratoCancelado", DDEstadoContrato.ESTADO_CONTRATO_CANCELADO);

        //Solo los contratos de riesgo de los contratos titulares
        hql.append(" and mov.riesgo > 0 ");
        hql.append(" and cp.tipoIntervencion.titular = true ");

        //Que pertenezca a las personas de los contratos seleccionados
        hql.append(" and cp.persona in (").append(armarQueryObtienePersonasRelacionadas(listadoContratos)).append(" )");

        //Que no est� dentro de los contratos ya seleccionados
        hql.append(" and con.id not in (").append(listadoContratos).append(")");

        //Que no est� en otros asuntos
        hql.append(" and con.id not in (").append(getHqlContratosEnProcedimientos(columnaRelacion)).append(")");

        //Que no est� en otros expedientes
        hql.append(" and con.id not in (").append(getHqlContratosEnExpedientes(columnaRelacion)).append(")");

        //Agrupamos por contrato y ordenamos por el vencimiento para poder extraer los m�s altos primero
        hql.append(" order by mov.riesgo DESC");

        Query query = getSession().createQuery(hql.toString());
        query.setProperties(param);

        return query.list();
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Long> obtenerPersonasRelacionadosExpedienteGrupo(Long idPersona) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        StringBuilder hql = new StringBuilder();
		
        hql.append(" select distinct p.id from Persona p ");
        hql.append(" where p.id in ("
        		+ "select pg.persona.id from PersonaGrupo pg where pg.grupoCliente.id in"        		
        		+ "(select gc.grupoCliente.id from PersonaGrupo gc where gc.persona.id = :idPersona)) ");
        		        		
//        		+ "p.grupo.grupoCliente.id"
//        		+ " in (select pg.grupoCliente.id from PersonaGrupo pg where pg.persona.id = :idPersona) ");
        param.put("idPersona", idPersona);

        //Que no est� dentro de los contratos ya seleccionados
        hql.append(" and p.id <> :idPersona ");

        //Que no est� en otros expedientes
        hql.append(" and p.id not in (").append(getHqlPersonasEnExpedientes("p.id")).append(") ");

        Query query = getSession().createQuery(hql.toString());
        query.setProperties(param);

        return query.list();
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Long> obtenerPersonasRelacionadosExpedientePrimeraGeneracion(List<Long> personasExpediente) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        StringBuilder hql = new StringBuilder();

        String listadoPersonas = armarParamContratos(personasExpediente);

        hql.append(" select distinct cp.persona.id from ContratoPersona cp ");

        //Que sean titulares
        hql.append(" where cp.tipoIntervencion.titular = true ");

        hql.append(" and cp.contrato.id in ");
        hql.append(" (select distinct con.id from Persona p, ContratoPersona cp, Contrato con, Movimiento m ");
        hql.append(" where cp.persona.id = p.id and cp.auditoria.borrado = false and p.auditoria.borrado = false ");
        hql.append(" and cp.contrato.id = con.id and con.auditoria.borrado = false ");
        hql.append(" and con.id = m.contrato.id and con.fechaExtraccion = m.fechaExtraccion and m.riesgo > 0 ");

        //Que sean titulares
        hql.append(" and (cp.tipoIntervencion.titular = true or cp.tipoIntervencion.avalista = true)");

        //Que pertenezca a las personas seleccionados
        hql.append(" and p.id in (").append(listadoPersonas).append(" )");

        //Que el contrato no est� cancelado
        hql.append(" and con.estadoContrato.codigo <> :estadoContratoCancelado) ");
        param.put("estadoContratoCancelado", DDEstadoContrato.ESTADO_CONTRATO_CANCELADO);

        //Que no sea ninguna de las personas seleccionados
        hql.append(" and cp.persona.id not in (").append(listadoPersonas).append(" ) ");

        //Que no est� en otros expedientes
        hql.append(" and cp.persona.id not in (").append(getHqlPersonasEnExpedientes("cp.persona.id")).append(") ");

        Query query = getSession().createQuery(hql.toString());
        query.setProperties(param);

        return query.list();
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Long> obtenerPersonasRelacionadosExpedienteSegundaGeneracion(List<Long> personasExpediente) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        StringBuilder hql = new StringBuilder();

        String listadoPersonas = armarParamContratos(personasExpediente);

        hql.append(" select distinct cp.persona.id from ContratoPersona cp ");
        hql.append(" where cp.tipoIntervencion.titular = true ");

        hql.append(" and cp.contrato.id in ");
        hql.append(" (select distinct con.id from Persona p, ContratoPersona cp, Contrato con, Movimiento mov ");
        hql.append(" where cp.persona.id = p.id and cp.auditoria.borrado = false and p.auditoria.borrado = false ");
        hql.append(" and cp.contrato.id = con.id and con.auditoria.borrado = false ");
        hql.append(" and con.id = mov.contrato.id and con.fechaExtraccion = mov.fechaExtraccion ");

        //Solo los contratos de riesgo de los contratos titulares
        hql.append(" and mov.riesgo > 0 ");
        hql.append(" and cp.tipoIntervencion.titular = true ");

        //Que pertenezca a las personas seleccionados
        hql.append(" and p.id in (").append(listadoPersonas).append(" )");

        //Que el contrato no est� cancelado
        hql.append(" and con.estadoContrato.codigo <> :estadoContratoCancelado) ");
        param.put("estadoContratoCancelado", DDEstadoContrato.ESTADO_CONTRATO_CANCELADO);

        //Que no sean las personas ya seleccionados
        hql.append(" and cp.persona.id not in (").append(listadoPersonas).append(" ) ");

        //Que no est� en otros expedientes
        hql.append(" and cp.persona.id not in (").append(getHqlPersonasEnExpedientes("cp.persona.id")).append(") ");

        Query query = getSession().createQuery(hql.toString());
        query.setProperties(param);

        return query.list();
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Long> obtenerPersonasDeContratos(Long idPersona, Long idContrato, List<Long> contratosAdicionales, Integer limitePersonas) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        StringBuilder hql = new StringBuilder();

        String listadoContratos = armarParamContratos(contratosAdicionales);
        if (listadoContratos != null && listadoContratos.trim().length() > 0) {
            listadoContratos += "," + String.valueOf(idContrato);
        } else {
            listadoContratos = String.valueOf(idContrato);
        }

        hql.append(" select distinct cp.persona.id from ContratoPersona cp ");
        hql.append(" where cp.contrato.id in (").append(listadoContratos).append(")");

        //Excluimos a la persona de pase
        hql.append(" and cp.persona.id <> :idPersona ");

        //Que sean titulares
        hql.append(" and (cp.tipoIntervencion.titular = true or cp.tipoIntervencion.avalista = true)");

        //Que no est�n en otros expedientes
        hql.append(" and cp.persona.id not in (").append(getHqlPersonasEnExpedientesSeguimiento("cp.persona.id")).append(") ");

        param.put("idPersona", idPersona);

        Query query = getSession().createQuery(hql.toString());
        query.setProperties(param);

        List<Long> lista = query.list();

        int cant = lista.size();
        if (cant > limitePersonas.intValue()) {
            lista = lista.subList(0, limitePersonas.intValue());
        }
        return lista;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Long> obtenerContratosDePersonas(Long idContrato, Long idPersona, List<Long> personasAdicionales, Integer limiteContratos) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        StringBuilder hql = new StringBuilder();
        String columnaRelacion = "c.id";

        String listadoPersonas = armarParamContratos(personasAdicionales);
        if (listadoPersonas != null && listadoPersonas.trim().length() > 0) {
            listadoPersonas += "," + String.valueOf(idPersona);
        } else {
            listadoPersonas = String.valueOf(idPersona);
        }

        hql.append(" select distinct cp.contrato.id from ContratoPersona cp, Contrato c, Movimiento m ");
        hql.append(" where cp.persona.id in (").append(listadoPersonas).append(") ");
        hql.append(" and cp.contrato.id = c.id ");
        hql.append(" and c.id = m.contrato.id and c.fechaExtraccion = m.fechaExtraccion ");

        //Que sean titulares
        hql.append(" and (cp.tipoIntervencion.titular = true or cp.tipoIntervencion.avalista = true)");

        //Excluimos al contrato de pase
        hql.append(" and c.id <> :idContrato ");

        //Que no est� en otros asuntos
        hql.append(" and c.id not in (").append(getHqlContratosEnProcedimientos(columnaRelacion)).append(")");

        //Que no est� en otros expedientes
        hql.append(" and c.id not in (").append(getHqlContratosEnExpedientesRecuperacion(columnaRelacion)).append(")");

        param.put("idContrato", idContrato);

        Query query = getSession().createQuery(hql.toString());
        query.setProperties(param);

        List<Long> lista = query.list();

        int cant = lista.size();
        if (cant > limiteContratos.intValue()) {
            lista = lista.subList(0, limiteContratos.intValue());
        }
        return lista;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<ReglasElevacion> getReglasElevacion(Estado estado) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        StringBuilder hql = new StringBuilder();

        hql.append("select reg from ReglasElevacion reg ");
        hql.append(" where reg.estadoItinerario.id = " + estado.getId());
        hql.append(" and reg.auditoria.borrado = false");

        Query query = getSession().createQuery(hql.toString());
        query.setProperties(param);

        return query.list();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Page obtenerExpedientesDeUnaPersonaPaginados(DtoListadoExpedientes dto) {
        StringBuilder hql = new StringBuilder();
        hql.append("select distinct pex.expediente from ExpedientePersona pex ");
        hql.append(" where pex.auditoria.borrado = false ");
        hql.append(" and  pex.expediente.auditoria.borrado = false ");
        hql.append(" and pex.persona.id = :idPersona");

        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("idPersona", dto.getIdPersona());

        return paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dto, params);
    }

    // **************************************************************************************************** //
    // **************************************************************************************************** //
    // ***                                  METODOS PRIVADOS DEL DAO                                    *** //
    // **************************************************************************************************** //
    // **************************************************************************************************** //

    /**
     * Devuelve un HQL con los contratos existentes en los procedimientos en curso.
     * @param columnaRelacion Si se le pasa este parametro (!= null) comparar� solamente los contrato.id que relacionen con el parametro
     * @return
     */
    private String getHqlContratosEnProcedimientos(String columnaRelacion) {
        StringBuilder hql = new StringBuilder();

        hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, ProcedimientoContratoExpediente pce, Procedimiento prc ");
        hql.append("WHERE cex.id = pce.expedienteContrato ");
        hql.append("and pce.procedimiento = prc.id ");
        hql.append("and cex.expediente.auditoria.borrado = false ");
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
     * @param columnaRelacion Si se le pasa este parametro (!= null) comparar� solamente los contrato.id que relacionen con el parametro
     * @return
     */
    private String getHqlContratosEnExpedientes(String columnaRelacion) {
        StringBuilder hql = new StringBuilder();

        hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, Expediente exp  ");
        hql.append("WHERE exp.id = cex.expediente.id ");
        hql.append("and cex.expediente.auditoria.borrado = false ");
        hql.append("and cex.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
        hql.append("and exp.estadoExpediente.codigo IN ('" + DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO + "', '"
                + DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO + "', '" + DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO + "') ");

        if (columnaRelacion != null) {
            hql.append("and cex.contrato.id = ").append(columnaRelacion);
        }

        return hql.toString();
    }

    /**
     * Devuelve un HQL con los contratos existentes en los expedientes en curso.
     * @param columnaRelacion Si se le pasa este parametro (!= null) comparar� solamente los contrato.id que relacionen con el parametro
     * @return
     */
    private String getHqlContratosEnExpedientesRecuperacion(String columnaRelacion) {
        StringBuilder hql = new StringBuilder();

        hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, Expediente exp  ");
        hql.append("WHERE exp.id = cex.expediente.id ");
        hql.append("and cex.expediente.auditoria.borrado = false ");
        hql.append("and cex.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
        hql.append("and exp.estadoExpediente.codigo IN ('" + DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO + "', '"
                + DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO + "', '" + DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO + "') ");
        hql.append(" and exp.arquetipo.itinerario.dDtipoItinerario.codigo IN ('" + DDTipoItinerario.ITINERARIO_RECUPERACION + "') ");

        if (columnaRelacion != null) {
            hql.append("and cex.contrato.id = ").append(columnaRelacion);
        }

        return hql.toString();
    }

    /**
     * Devuelve un HQL con las personas existentes en los expedientes en curso.
     * @param columnaRelacion Si se le pasa este parametro (!= null) comparar� solamente los contrato.id que relacionen con el parametro
     * @return
     */
    private String getHqlPersonasEnExpedientes(String columnaRelacion) {
        StringBuilder hql = new StringBuilder();

        hql.append("SELECT DISTINCT pex.persona.id FROM ExpedientePersona pex, Expediente exp  ");
        hql.append("WHERE exp.id = pex.expediente.id and exp.auditoria.borrado = false ");
        hql.append(" and pex.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
        hql.append(" and exp.estadoExpediente.codigo IN ('" + DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO + "', '"
                + DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO + "', '" + DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO + "') ");

        if (columnaRelacion != null) {
            hql.append(" and pex.persona.id = ").append(columnaRelacion);
        }

        return hql.toString();
    }

    /**
     * Devuelve un HQL con las personas existentes en los expedientes en curso.
     * @param columnaRelacion Si se le pasa este parametro (!= null) comparar� solamente los contrato.id que relacionen con el parametro
     * @return
     */
    private String getHqlPersonasEnExpedientesSeguimiento(String columnaRelacion) {
        StringBuilder hql = new StringBuilder();

        hql.append("SELECT DISTINCT pex.persona.id FROM ExpedientePersona pex, Expediente exp  ");
        hql.append("WHERE exp.id = pex.expediente.id and exp.auditoria.borrado = false ");
        hql.append(" and pex.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
        hql.append(" and exp.estadoExpediente.codigo IN ('" + DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO + "', '"
                + DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO + "', '" + DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO + "') ");
        hql.append(" and exp.arquetipo.itinerario.dDtipoItinerario.codigo IN ('" + DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SINTOMATICO + "', '"
                + DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SISTEMATICO + "') ");

        if (columnaRelacion != null) {
            hql.append(" and pex.persona.id = ").append(columnaRelacion);
        }

        return hql.toString();
    }

    private String armarParamContratos(List<Long> contratos) {
        String parametros = "";
        Iterator<Long> it = contratos.iterator();
        while (it.hasNext()) {
            parametros += it.next();
            if (it.hasNext()) {
                parametros += ", ";
            }
        }
        return parametros;
    }

    /**
     * arma la query que obtiene las personas relacionadas a una lista de contratos.
     * @param listaContratos contratos
     * @return query
     */
    private StringBuffer armarQueryObtienePersonasRelacionadas(String listaContratos) {
        StringBuffer hql = new StringBuffer();

        hql.append(" (select cp2.persona from ContratoPersona cp2 ");
        hql.append(" where cp2.contrato.id in (").append(listaContratos).append(")");
        hql.append(" and cp2.auditoria.borrado = 0 and (cp2.tipoIntervencion.titular = true or cp2.tipoIntervencion.avalista = true))");
        return hql;
    }

    	@Override
	public Page buscarExpedientesPaginadoDinamico(
			DtoBuscarExpedientes dtoExpediente,Usuario usuarioLogueado,String paramsDinamicos) {
		HashMap<String, Object> paramsMap = new HashMap<String, Object>();

        StringBuilder hql = new StringBuilder();
        Boolean requiereRiesgoSaldo = false;

        hql.append("select e from Expediente e where e.id IN (select exp.id FROM Expediente exp ");
        //hql.append("select exp FROM Expediente exp ");

        if (dtoExpediente.getIdComite() != null) {
            hql.append(" left join exp.decisionComite dco left join dco.sesion sesion ");
        }

        if (!StringUtils.emtpyString(dtoExpediente.getMaxSaldoVencido()) || !StringUtils.emtpyString(dtoExpediente.getMaxRiesgoTotal())
                || !StringUtils.emtpyString(dtoExpediente.getMinSaldoVencido()) || !StringUtils.emtpyString(dtoExpediente.getMinRiesgoTotal())) {

            hql.append(", ExpedienteContrato expc, Contrato c, Movimiento m ");
            requiereRiesgoSaldo = true;
        }

        hql.append(" where exp.auditoria.borrado = 0 ");

        /***
		 * La lista de los parámetros dinánmicos debe venir de la siguiente manera
		 * 
		 * _param_origen:plugin1;plugin1param1:valor1;plugin1param2:valor2;%param%origen:plugin2;plugin2param1:valor1;plugin2param2:valor2;
		 * 
		 * */
		
		if(paramsDinamicos != null && filtrosBusquedaDinamica != null){
			String[] paramsVector = paramsDinamicos.split("_param_");
			if(paramsVector != null && paramsVector.length>0){
				for(String paramDinamico:paramsVector){
					for(BusquedaExpedienteFiltroDinamico filtro:filtrosBusquedaDinamica){
						if(filtro.isValid(paramDinamico)){
							
							hql.append(" and exp.id in ( ");
							hql.append(filtro.obtenerFiltro(paramDinamico));
							hql.append(" ) ");
							
						}
					}
				}
			}
		}
		
		
        if (requiereRiesgoSaldo) {
            hql.append(" and expc.expediente.id = exp.id and expc.auditoria.borrado = 0");
            hql.append(" and expc.contrato.id = c.id ");
            hql.append(" and m.contrato.id = c.id and m.fechaExtraccion = c.fechaExtraccion ");
        }

        //Código
        if (dtoExpediente.getCodigo() != null) {
            hql.append(" and exp.id = :expId ");
            paramsMap.put("expId", dtoExpediente.getCodigo());
        }

        //Descripcion
        if (!StringUtils.emtpyString(dtoExpediente.getDescripcion())) {
            hql.append(" and LOWER(exp.descripcionExpediente) LIKE '%'|| :descExpediente ||'%' ");
            paramsMap.put("descExpediente", dtoExpediente.getDescripcion().toLowerCase().replaceAll("'", "''"));
        }

        // Si no se esta buscando expedientes por comite uso esta busqueda de estado
        if (dtoExpediente.getIdComite() == null && !StringUtils.emtpyString(dtoExpediente.getIdEstado())) {
            hql.append(" and exp.estadoExpediente.codigo = :estExpCod");
            paramsMap.put("estExpCod", dtoExpediente.getIdEstado());
        }

        // ***************************************************************************************** //
        // ** Estas opciones me parece que son para la sesion de comite, para mostrar expedientes ** //
        // ***************************************************************************************** //
        //Si busca por comite
        if (dtoExpediente.getIdComite() != null && dtoExpediente.getIdSesion() == null) {
            hql.append(" and (( exp.comite.id = :comiteId and exp.estadoExpediente.codigo = :estExpCong )");
            paramsMap.put("comiteId", new Long(dtoExpediente.getIdComite()));
            paramsMap.put("estExpCong", DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO);

            Comite comite = comiteDao.get(dtoExpediente.getIdComite());
            hql.append(" or sesion.id = :ultimaSesionId)");
            paramsMap.put("ultimaSesionId", new Long(comite.getUltimaSesion().getId()));
        }
        // busco por sesion
        if (dtoExpediente.getIdComite() != null && dtoExpediente.getIdSesion() != null) {
            hql.append(" and exp.comite.id = :comiteId and exp.estadoExpediente.codigo = :estExpDC ");
            paramsMap.put("comiteId", new Long(dtoExpediente.getIdComite()));
            paramsMap.put("estExpDC", DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO);

            hql.append(" and sesion.id = :sesionId");
            paramsMap.put("sesionId", new Long(dtoExpediente.getIdSesion()));
        }
        // ***************************************************************************************** //

        //Numero de contrato
        if (!StringUtils.emtpyString(dtoExpediente.getNroContrato())) {
            hql.append(" and exp.id IN ");
            hql
                    .append("(select ec.expediente.id from ExpedienteContrato ec where ec.auditoria.borrado = false and lower(ec.contrato.nroContrato) like '%'|| :nroCnt ||'%') ");
            paramsMap.put("nroCnt", dtoExpediente.getNroContrato().toLowerCase());
        }

        // *** Este comité se utiliza para la búsqueda desde la página de búsquedas de expedientes *** //
        if (dtoExpediente.getComiteBusqueda() != null) {
            hql.append(" and exp.comite.id = :comiteBusquedaId ");
            paramsMap.put("comiteBusquedaId", dtoExpediente.getComiteBusqueda());
        }

        //Tipo de Gestión
        if (!StringUtils.emtpyString(dtoExpediente.getCodigoGestion())) {
            hql.append(" and exp.arquetipo.itinerario.dDtipoItinerario.codigo = :codigoGestion ");
            paramsMap.put("codigoGestion", dtoExpediente.getCodigoGestion());
        }

        //VISIBILIDAD
        int cantZonas = dtoExpediente.getCodigoZonas().size();
        if (cantZonas > 0) {
            hql.append(" and ( ");
            for (String codigoZ : dtoExpediente.getCodigoZonas()) {
                hql.append(" exp.oficina.zona.codigo like '" + codigoZ + "%' OR");
            }
            hql.deleteCharAt(hql.length() - 1);
            hql.deleteCharAt(hql.length() - 1);
            
            hql.append(" or exp.id in ( ");
            	hql.append(generaFiltroExpedientesPorGestor(usuarioLogueado));
	        hql.append(" ) ");
            
	        hql.append(" ) ");
        }
        else{
        	 //GESTORES EXPEDIENTE
	        hql.append(" and exp.id in ( ");
	        	hql.append(generaFiltroExpedientesPorGestor(usuarioLogueado));
	        hql.append(" ) ");
        }

        //Centros
        if (!StringUtils.emtpyString(dtoExpediente.getCodigoEntidad())) {
            hql.append("  and exp.oficina.zona.nivel.id >= :nivelId ");
            paramsMap.put("nivelId", new Long(dtoExpediente.getCodigoEntidad()));
        }

        //Situacion
        if (!StringUtils.emtpyString(dtoExpediente.getCodigoSituacion())) {
            StringTokenizer tokensSituaciones = new StringTokenizer(dtoExpediente.getCodigoSituacion(), ",");
            hql.append(" and exp.estadoItinerario.codigo IN (");
            while (tokensSituaciones.hasMoreTokens()) {
                hql.append("'" + tokensSituaciones.nextElement() + "'");
                if (tokensSituaciones.hasMoreTokens()) {
                    hql.append(",");
                }
            }
            hql.append(" ) ");
        }
        
        //Tipo de persona y segmentos
        Boolean tipoPersona = !StringUtils.emtpyString(dtoExpediente.getTipoPersona());
        Boolean segmentos = !StringUtils.emtpyString(dtoExpediente.getSegmentos());

        if (tipoPersona || segmentos) {
            hql.append(" and exp.id IN (select pex.expediente.id FROM ExpedientePersona pex, Persona p ");
            hql.append(" where pex.auditoria.borrado = false and pex.persona.id = p.id and pex.pase = 1 ");

            if (tipoPersona) {
                hql.append(" and p.tipoPersona.codigo = :tipoPer ");
                paramsMap.put("tipoPer", dtoExpediente.getTipoPersona());
            }

            if (segmentos) {
            	StringBuilder hqlSegmento = new StringBuilder();
				StringTokenizer tokensSegmentos = new StringTokenizer(dtoExpediente.getSegmentos(), ",");
				while (tokensSegmentos.hasMoreTokens()) {
					hqlSegmento.append("'" + tokensSegmentos.nextElement() + "'");
					if (tokensSegmentos.hasMoreTokens()) {
						hqlSegmento.append(",");
					}
				}
            	
                hql.append(" and p.segmento.codigo IN (" + hqlSegmento + ") ");
            }
            hql.append(" ) ");

        }

        // ********* RIESGO Y SALDO TOTAL  ************** //
        if (requiereRiesgoSaldo) {
            hql.append(" group by exp.id ");
            if (dtoExpediente.getMaxSaldoVencido() == null || dtoExpediente.getMaxSaldoVencido().length() < 1) {
                dtoExpediente.setMaxSaldoVencido("" + Integer.MAX_VALUE);
            }
            if (dtoExpediente.getMinSaldoVencido() == null || dtoExpediente.getMinSaldoVencido().length() < 1) {
                dtoExpediente.setMinSaldoVencido("" + Integer.MIN_VALUE);
            }
            if (dtoExpediente.getMaxRiesgoTotal() == null || dtoExpediente.getMaxRiesgoTotal().length() < 1) {
                dtoExpediente.setMaxRiesgoTotal("" + Integer.MAX_VALUE);
            }
            if (dtoExpediente.getMinRiesgoTotal() == null || dtoExpediente.getMinRiesgoTotal().length() < 1) {
                dtoExpediente.setMinRiesgoTotal("" + Integer.MIN_VALUE);
            }

            hql.append(" having sum(case when m.riesgo > 0 then m.deudaIrregular else 0 end ) between :minSaldoVencido and :maxSaldoVencido ");
            paramsMap.put("minSaldoVencido", new Double(dtoExpediente.getMinSaldoVencido()));
            paramsMap.put("maxSaldoVencido", new Double(dtoExpediente.getMaxSaldoVencido()));

            hql.append(" and sum(m.riesgo) between :minRiesgoTotal and :maxRiesgoTotal ");
            paramsMap.put("minRiesgoTotal", new Double(dtoExpediente.getMinRiesgoTotal()));
            paramsMap.put("maxRiesgoTotal", new Double(dtoExpediente.getMaxRiesgoTotal()));
        }
        
        // ********* PARA USUARIOS EXTERNOS LIMITAMOS LA VISIBILIDAD A AQUELLOS USUARIOS 
        // ********* QUE SON GESTORES DE RECOBRO , SOLO VERÁN LOS EXPEDIENTES QUE ACTUALMENTE PERTENCEN A SU AGENCIA
        if (usuarioLogueado.getUsuarioExterno() ){
        	 //GESTORES DE RECOBRO EXPEDIENTE
	        hql.append(" and exp.id in ( ");
	        	hql.append(generaFiltroExpedientesGestorRecobro(usuarioLogueado));
	        hql.append(" ) ");
        }

        hql.append(")");
        return paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dtoExpediente, paramsMap);
	}
        
	@Override
	public Page buscarExpedientesRecobroPaginadoDinamico(DtoBuscarExpedientes dtoExpediente,Usuario usuarioLogueado,String paramsDinamicos) {
	
        HashMap<String, Object> paramsMap = new HashMap<String, Object>();

        StringBuilder hql = new StringBuilder();
        Boolean requiereRiesgoSaldo = false;

        //hql.append("select e from Expediente e where e.id IN (select exp.id FROM Expediente exp ");
        hql.append("select exp FROM Expediente exp ");

        if (dtoExpediente.getIdComite() != null) {
            hql.append(" left join exp.decisionComite dco left join dco.sesion sesion ");
        }

        if (!StringUtils.emtpyString(dtoExpediente.getMaxSaldoVencido()) || !StringUtils.emtpyString(dtoExpediente.getMaxRiesgoTotal())
                || !StringUtils.emtpyString(dtoExpediente.getMinSaldoVencido()) || !StringUtils.emtpyString(dtoExpediente.getMinRiesgoTotal())) {

            hql.append(", ExpedienteContrato expc, Contrato c, Movimiento m ");
            requiereRiesgoSaldo = true;
        }

        hql.append(" where exp.auditoria.borrado = 0 ");

		
        if (requiereRiesgoSaldo) {
            hql.append(" and expc.expediente.id = exp.id and expc.auditoria.borrado = 0");
            hql.append(" and expc.contrato.id = c.id ");
            hql.append(" and m.contrato.id = c.id and m.fechaExtraccion = c.fechaExtraccion ");
        }

        //Código
        if (dtoExpediente.getCodigo() != null) {
            hql.append(" and exp.id = :expId ");
            paramsMap.put("expId", dtoExpediente.getCodigo());
        }

        //Descripcion
        if (!StringUtils.emtpyString(dtoExpediente.getDescripcion())) {
            hql.append(" and LOWER(exp.descripcionExpediente) LIKE '%'|| :descExpediente ||'%' ");
            paramsMap.put("descExpediente", dtoExpediente.getDescripcion().toLowerCase().replaceAll("'", "''"));
        }

        // Si no se esta buscando expedientes por comite uso esta busqueda de estado
        if (dtoExpediente.getIdComite() == null && !StringUtils.emtpyString(dtoExpediente.getIdEstado())) {
            hql.append(" and exp.estadoExpediente.codigo = :estExpCod");
            paramsMap.put("estExpCod", dtoExpediente.getIdEstado());
        }

        // ***************************************************************************************** //
        // ** Estas opciones me parece que son para la sesion de comite, para mostrar expedientes ** //
        // ***************************************************************************************** //
        //Si busca por comite
        if (dtoExpediente.getIdComite() != null && dtoExpediente.getIdSesion() == null) {
            hql.append(" and (( exp.comite.id = :comiteId and exp.estadoExpediente.codigo = :estExpCong )");
            paramsMap.put("comiteId", new Long(dtoExpediente.getIdComite()));
            paramsMap.put("estExpCong", DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO);

            Comite comite = comiteDao.get(dtoExpediente.getIdComite());
            hql.append(" or sesion.id = :ultimaSesionId)");
            paramsMap.put("ultimaSesionId", new Long(comite.getUltimaSesion().getId()));
        }
        // busco por sesion
        if (dtoExpediente.getIdComite() != null && dtoExpediente.getIdSesion() != null) {
            hql.append(" and exp.comite.id = :comiteId and exp.estadoExpediente.codigo = :estExpDC ");
            paramsMap.put("comiteId", new Long(dtoExpediente.getIdComite()));
            paramsMap.put("estExpDC", DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO);

            hql.append(" and sesion.id = :sesionId");
            paramsMap.put("sesionId", new Long(dtoExpediente.getIdSesion()));
        }
        // ***************************************************************************************** //

        //Numero de contrato
        if (!StringUtils.emtpyString(dtoExpediente.getNroContrato())) {
            hql.append(" and EXISTS ");
            hql.append("(select 1 from ExpedienteContrato ec where ec.auditoria.borrado = false and ec.expediente.id = exp.id and ec.contrato.nroContrato like '%'|| :nroCnt ||'%') ");
            paramsMap.put("nroCnt", dtoExpediente.getNroContrato().toLowerCase());
        }

        // *** Este comité se utiliza para la búsqueda desde la página de búsquedas de expedientes *** //
        if (dtoExpediente.getComiteBusqueda() != null) {
            hql.append(" and exp.comite.id = :comiteBusquedaId ");
            paramsMap.put("comiteBusquedaId", dtoExpediente.getComiteBusqueda());
        }

        //Tipo de Gestión
        if (!StringUtils.emtpyString(dtoExpediente.getCodigoGestion())) {
            hql.append(" and exp.arquetipo.itinerario.dDtipoItinerario.codigo = :codigoGestion ");
            paramsMap.put("codigoGestion", dtoExpediente.getCodigoGestion());
        }

        //VISIBILIDAD
        //BKREC-943
        //Se elimina este filtro porque NO es necesario:
        // En producción casi todos los codigos de zona empiezan por codigoZ
        // Además el filtro de abajo GESTORES EXPEDIENTE, filtra usando la tabla GE_GESTOR_EXPEDIENTE
        // la cual está siempre vacía (en cualquier entorno, incluso PRO)
//        int cantZonas = dtoExpediente.getCodigoZonas().size();
//        if (cantZonas > 0) {
//            hql.append(" and ( ");
//            for (String codigoZ : dtoExpediente.getCodigoZonas()) {
//                hql.append(" SUBSTR(exp.oficina.zona.codigo, 1, 2) = '" + codigoZ + "' OR");
//            }
//            hql.deleteCharAt(hql.length() - 1);
//            hql.deleteCharAt(hql.length() - 1);
//            
//            hql.append(" or EXISTS ( ");
//            	hql.append(generaFiltroExpedientesPorGestorRecobro(usuarioLogueado));
//	        hql.append(" ) ");
//            
//	        hql.append(" ) ");
//        }
//        else{
//        	 //GESTORES EXPEDIENTE
//	        hql.append(" and EXISTS ( ");
//	        	hql.append(generaFiltroExpedientesPorGestorRecobro(usuarioLogueado));
//	        hql.append(" ) ");
//        }

        //Centros
        if (!StringUtils.emtpyString(dtoExpediente.getCodigoEntidad())) {
            hql.append("  and exp.oficina.zona.nivel.id >= :nivelId ");
            paramsMap.put("nivelId", new Long(dtoExpediente.getCodigoEntidad()));
        }

        //Situacion
        if (!StringUtils.emtpyString(dtoExpediente.getCodigoSituacion())) {
            StringTokenizer tokensSituaciones = new StringTokenizer(dtoExpediente.getCodigoSituacion(), ",");
            hql.append(" and exp.estadoItinerario.codigo IN (");
            while (tokensSituaciones.hasMoreTokens()) {
                hql.append("'" + tokensSituaciones.nextElement() + "'");
                if (tokensSituaciones.hasMoreTokens()) {
                    hql.append(",");
                }
            }
            hql.append(" ) ");
        }
        
        //Tipo de persona y segmentos
        Boolean tipoPersona = !StringUtils.emtpyString(dtoExpediente.getTipoPersona());
        Boolean segmentos = !StringUtils.emtpyString(dtoExpediente.getSegmentos());

        if (tipoPersona || segmentos) {
            hql.append(" and EXISTS (select 1 FROM ExpedientePersona pex, Persona p ");
            hql.append(" where pex.auditoria.borrado = false and pex.persona.id = p.id and pex.pase = 1 and pex.expediente.id = exp.id ");

            if (tipoPersona) {
                hql.append(" and p.tipoPersona.codigo = :tipoPer ");
                paramsMap.put("tipoPer", dtoExpediente.getTipoPersona());
            }

            if (segmentos) {
            	StringBuilder hqlSegmento = new StringBuilder();
				StringTokenizer tokensSegmentos = new StringTokenizer(dtoExpediente.getSegmentos(), ",");
				while (tokensSegmentos.hasMoreTokens()) {
					hqlSegmento.append("'" + tokensSegmentos.nextElement() + "'");
					if (tokensSegmentos.hasMoreTokens()) {
						hqlSegmento.append(",");
					}
				}
            	
                hql.append(" and p.segmento.codigo IN (" + hqlSegmento + ") ");
            }
            hql.append(" ) ");

        }

        // ********* RIESGO Y SALDO TOTAL  ************** //
        //BKREC-943
        //Ver si se puede quitar el agrupador por exp.id
        if (requiereRiesgoSaldo) {
            hql.append(" group by exp.id ");
            if (dtoExpediente.getMaxSaldoVencido() == null || dtoExpediente.getMaxSaldoVencido().length() < 1) {
                dtoExpediente.setMaxSaldoVencido("" + Integer.MAX_VALUE);
            }
            if (dtoExpediente.getMinSaldoVencido() == null || dtoExpediente.getMinSaldoVencido().length() < 1) {
                dtoExpediente.setMinSaldoVencido("" + Integer.MIN_VALUE);
            }
            if (dtoExpediente.getMaxRiesgoTotal() == null || dtoExpediente.getMaxRiesgoTotal().length() < 1) {
                dtoExpediente.setMaxRiesgoTotal("" + Integer.MAX_VALUE);
            }
            if (dtoExpediente.getMinRiesgoTotal() == null || dtoExpediente.getMinRiesgoTotal().length() < 1) {
                dtoExpediente.setMinRiesgoTotal("" + Integer.MIN_VALUE);
            }

            hql.append(" having sum(case when m.riesgo > 0 then m.deudaIrregular else 0 end ) between :minSaldoVencido and :maxSaldoVencido ");
            paramsMap.put("minSaldoVencido", new Double(dtoExpediente.getMinSaldoVencido()));
            paramsMap.put("maxSaldoVencido", new Double(dtoExpediente.getMaxSaldoVencido()));

            hql.append(" and sum(m.riesgo) between :minRiesgoTotal and :maxRiesgoTotal ");
            paramsMap.put("minRiesgoTotal", new Double(dtoExpediente.getMinRiesgoTotal()));
            paramsMap.put("maxRiesgoTotal", new Double(dtoExpediente.getMaxRiesgoTotal()));
        }
        
        // ********* PARA USUARIOS EXTERNOS LIMITAMOS LA VISIBILIDAD A AQUELLOS USUARIOS 
        // ********* QUE SON GESTORES DE RECOBRO , SOLO VERÁN LOS EXPEDIENTES QUE ACTUALMENTE PERTENCEN A SU AGENCIA
        if (usuarioLogueado.getUsuarioExterno() ){
        	 //GESTORES DE RECOBRO EXPEDIENTE
	        hql.append(" and EXISTS ( ");
	        	hql.append(generaFiltroExpedientesGestorRecobro(usuarioLogueado));
	        hql.append(" ) ");
        }

        /***
        * La lista de los parámetros dinánmicos debe venir de la siguiente manera
        * 
        * _param_origen:plugin1;plugin1param1:valor1;plugin1param2:valor2;%param%origen:plugin2;plugin2param1:valor1;plugin2param2:valor2;
        * 
        * */
        //Si se incluyen filtros de expedientes, el filtro adicional ya no es el primero
        Boolean esAdicionalPrimerFiltro = !isBusquedaExpedientes(dtoExpediente);
        String entityId = "";
        String joinEntityId = "";
        String filtroAnt = "";
        String filtroActual = "";
        if(paramsDinamicos != null && filtrosBusquedaDinamica != null){
                String[] paramsVector = paramsDinamicos.split("_param_");
                if(paramsVector != null && paramsVector.length>0){
                        for(String paramDinamico:paramsVector){
                                for(BusquedaExpedienteFiltroDinamico filtro:filtrosBusquedaDinamica){
                                        if(filtro.isValid(paramDinamico)){

                                            //BKREC-943
                                            //Desvinculación de expedientes
                                            //Desvincular filtros de pestañas Recobro, Incidencia, Acuerdo,
                                            //de la busqueda principal con expedientes,
                                            //si no se busca por ningún parámetro que requiera Expediente
                                            //Desvincular la busqueda de expedientes para optimizar 
                                            filtroActual = filtro.getOrigenFiltros();

                                            //Si el filtro actual adicional es el primero de los filtros a aplicar (o es el único)
                                            //se construye el comienzo de la HQL sin relaciones a Expedientes
                                            if (esAdicionalPrimerFiltro){
                                                //Eliminar la vinculación con Expedientes es comenzar de nuevo la construccion HQL con el 1er filtro adicional
                                                hql = new StringBuilder();
                                                hql.append(filtro.obtenerFiltroRecobro(paramDinamico));
                                            } else {
                                                //Si son filtros adicionales o hay vinculacion de Expedientes, los adicionales se relacionan con los anteriores
                                                //por el filtro actual a relacionar
                                                if (filtroActual.equals("recobro")){ joinEntityId = "cre.expediente.id"; }
                                                if (filtroActual.equals("incidencia")){ joinEntityId = "ine.expediente.id"; }
                                                if (filtroActual.equals("acuerdo")){ joinEntityId = "acu.expediente.id"; }

                                                if (isBusquedaExpedientes(dtoExpediente)) {
                                                    //Si había vinculación con Expedientes las relaciones con cualquier filtro adicional se hacen por exp.id
                                                    entityId = "exp.id";
                                                }else{
                                                    if (filtroAnt.equals("recobro")){ entityId = "cre.expediente.id"; }
                                                    if (filtroAnt.equals("incidencia")){ entityId = "ine.expediente.id"; }
                                                    if (filtroAnt.equals("acuerdo")){ entityId = "acu.expediente.id"; } 
                                                }

                                                //Vinculación de filtros adicionales
                                                hql.append(" and EXISTS ( ");
                                                hql.append(filtro.obtenerFiltroRecobro(paramDinamico));
                                                hql.append(" and ");
                                                hql.append(entityId);
                                                hql.append(" = ");
                                                hql.append(joinEntityId);
                                                hql.append(" ) ");
                                            }

                                            //Actualización de variables de control para bucles > 1 filtros adicionales
                                            filtroAnt = filtroActual;
                                            esAdicionalPrimerFiltro = false;

                                            //Fin Optimizacion de Busqueda Expedientes separada de Recobro si es posible
                                        }

                                }
                        }
                }
        }
        
        return paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dtoExpediente, paramsMap);
	}

        /**
         * Indica si la búsqueda incluye necesariamente la tabla de Expedientes
         * o es una búsqueda solo vinculada a las otras entidades: Acuerdo, Incidencias, Recobro
         * @param dtoExp 
         */
        private Boolean isBusquedaExpedientes (DtoBuscarExpedientes dtoExp){
            return 
                (!Checks.esNulo(dtoExp.getCodigo()) ||
                 !StringUtils.emtpyString(dtoExp.getDescripcion()) ||
                 !StringUtils.emtpyString(dtoExp.getIdEstado()) ||
                 !StringUtils.emtpyString(dtoExp.getNroContrato()) ||
                 !Checks.esNulo(dtoExp.getComiteBusqueda()) ||
                 !StringUtils.emtpyString(dtoExp.getCodigoGestion()) ||
                 !StringUtils.emtpyString(dtoExp.getCodigoEntidad()) ||
                 !StringUtils.emtpyString(dtoExp.getCodigoSituacion()) ||
                 !StringUtils.emtpyString(dtoExp.getTipoPersona()) ||
                 !StringUtils.emtpyString(dtoExp.getSegmentos()) ||
                 !Checks.esNulo(dtoExp.getIdComite()) ||
                 !Checks.esNulo(dtoExp.getIdSesion()) ||
                 !StringUtils.emtpyString(dtoExp.getMaxSaldoVencido()) ||
                 !StringUtils.emtpyString(dtoExp.getMaxRiesgoTotal()) ||
                 !StringUtils.emtpyString(dtoExp.getMinSaldoVencido()) ||
                 !StringUtils.emtpyString(dtoExp.getMinRiesgoTotal())
                ) && dtoExp.isBusqueda();
        }
        
	/**
	 * Devuelve los expedientes de los que es gestor de recobro actual el usuario logado
	 * Analizar la posibilidad de cambiarlo para que devuelva los expedientes que se encuentran en 
	 * la agencia a la que pertenece el usuario logado, pero habría que extender esta clase, ya que la 
	 * agencia de recobro está mapeada en el plugin de recobro y no se tiene acceso a ella desde aquí
	 * @param usuarioLogueado
	 * @return
	 */
	 private String generaFiltroExpedientesGestorRecobro(Usuario usuarioLogueado) {
		StringBuffer hql = new StringBuffer();
		hql.append(" select 1 from GestorExpediente ge ");
		hql.append(" where exp.id = ge.expediente.id and ge.tipoGestor.codigo = '").append(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_AGENCIA_RECOBRO).append("' ");
		hql.append(" and ge.usuario.id in (");
		hql.append(obtenerListaUsuariosDelGrupo(usuarioLogueado.getId()));
		hql.append(")");
		return hql.toString();
	}

	@SuppressWarnings("unchecked")
	private String obtenerListaUsuariosDelGrupo(Long id) {

		StringBuffer sql = new StringBuffer();
		StringBuffer resultado = new StringBuffer();
		resultado.append(id).append(", ");
		sql.append("select usu_id_grupo from ${master.schema}.gru_grupos_usuarios where usu_id_usuario=");
		sql.append(id);
		List resultados = getSession().createSQLQuery(sql.toString()).list();
		for (Object idUsuario : resultados) {
			resultado.append(idUsuario.toString()).append(", ");
		}
		return resultado.substring(0, resultado.length()-2).toString();
	}
	
	/***
		 *  Devuelve un hql utilizado como subconsulta para obtener los expediente del que el usuario es gestor
		 *  
		 *  @param usuLogado Usuario logueado que ha realizado la busqueda
		 *  
		 *  @return hql con la busqueda del expediente por gestor
		 * 
		 * */
		private String generaFiltroExpedientesPorGestor(Usuario usuLogado){
			StringBuffer hql = new StringBuffer();
			hql.append(" select exp.id from Expediente exp , EXTGestorEntidad ge ");
			hql.append(" where exp.id = ge.unidadGestionId and ge.tipoEntidad.codigo = '").append(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE).append("' ");
			hql.append(" and ge.gestor.id in (");
			hql.append(obtenerListaUsuariosDelGrupo(usuLogado.getId()));
			hql.append(")");
			return hql.toString();
		}
                
		private String generaFiltroExpedientesPorGestorRecobro(Usuario usuLogado){
			StringBuffer hql = new StringBuffer();
			hql.append(" select 1 from  EXTGestorEntidad ge ");
			hql.append(" where exp.id = ge.unidadGestionId and ge.tipoEntidad.codigo = '").append(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE).append("' ");
			hql.append(" and ge.gestor.id in (");
			hql.append(obtenerListaUsuariosDelGrupo(usuLogado.getId()));
			hql.append(")");
			return hql.toString();
		}
}
