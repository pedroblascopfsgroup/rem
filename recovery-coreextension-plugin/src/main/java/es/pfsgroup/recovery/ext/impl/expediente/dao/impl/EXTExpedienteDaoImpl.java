package es.pfsgroup.recovery.ext.impl.expediente.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.comite.dao.ComiteDao;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.ext.impl.expediente.dao.EXTExpedienteDao;
import es.pfsgroup.recovery.ext.impl.utils.StringUtils;

@Repository
public class EXTExpedienteDaoImpl extends AbstractEntityDao<Expediente, Long> implements EXTExpedienteDao{

	@Autowired
    private ComiteDao comiteDao;
	
	@Autowired
	private PaginationManager paginationManager;
	
	@Override
	public List<? extends Expediente> buscaExpedientesConContrato(
			Long idContrato, String[] estados) {
		HQLBuilder b = new HQLBuilder("select e from ExpedienteContrato cex join cex.expediente e");
		b.appendWhere("cex.auditoria.borrado = false");
		b.appendWhere("e.auditoria.borrado = false");
		b.appendWhere("cex.contrato.id = " + idContrato);
		if ((estados != null) && (estados.length > 0)){
			b.appendWhere("e.estadoExpediente.codigo in (" + stringEstados(estados) + ")");
		}
		return HibernateQueryUtils.list(this, b);
	}
	
	
	private String stringEstados(String[] estados) {
		if ((estados == null) || (estados.length == 0)) return "";
		StringBuilder sb = new StringBuilder("\"" + estados[0] + "\"");
		for (int i = 1; i < estados.length; i++) {
			sb.append(",\"" + estados[i] + "\"");
		}
		return sb.toString();
	}
	
	 public Page buscarExpedientesPaginado(DtoBuscarExpedientes dtoExpediente,Usuario usuarioLogueado) {
	        HashMap<String, Object> params = new HashMap<String, Object>();

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
	            hql.append(" and exp.id IN ");
	            hql
	                    .append("(select ec.expediente.id from ExpedienteContrato ec where ec.auditoria.borrado = false and lower(ec.contrato.nroContrato) like '%'|| :nroCnt ||'%') ");
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
	            hql.append(" and exp.id IN (select pex.expediente.id FROM ExpedientePersona pex, Persona p ");
	            hql.append(" where pex.auditoria.borrado = false and pex.persona.id = p.id and pex.pase = 1 ");

	            if (tipoPersona) {
	                hql.append(" and p.tipoPersona.codigo = :tipoPer ");
	                params.put("tipoPer", dtoExpediente.getTipoPersona());
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
	            params.put("minSaldoVencido", new Double(dtoExpediente.getMinSaldoVencido()));
	            params.put("maxSaldoVencido", new Double(dtoExpediente.getMaxSaldoVencido()));

	            hql.append(" and sum(m.riesgo) between :minRiesgoTotal and :maxRiesgoTotal ");
	            params.put("minRiesgoTotal", new Double(dtoExpediente.getMinRiesgoTotal()));
	            params.put("maxRiesgoTotal", new Double(dtoExpediente.getMaxRiesgoTotal()));
	        }

	        hql.append(")");
	        return paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dtoExpediente, params);
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
			hql.append(" and ge.gestor.id = ").append(usuLogado.getId());
			return hql.toString();
		}


	@SuppressWarnings("unchecked")
	@Override
	public Expediente getByGuid(String guid) {
		
		Expediente expediente = null;
		
		DetachedCriteria crit = DetachedCriteria.forClass(Expediente.class);
		crit.add(Restrictions.eq("guid", guid));
        crit.add(Restrictions.eq("auditoria.borrado", false));
        
        List<Expediente> listado = getHibernateTemplate().findByCriteria(crit);
        if(listado != null && listado.size() > 0) {
        	expediente = listado.get(0);
        }
        
        return expediente;
	}

}
