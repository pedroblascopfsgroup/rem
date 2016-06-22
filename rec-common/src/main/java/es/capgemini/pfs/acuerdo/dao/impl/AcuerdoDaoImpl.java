package es.capgemini.pfs.acuerdo.dao.impl;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.hibernate.Hibernate;
import org.hibernate.SQLQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.dto.DTOTerminosFiltro;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.AcuerdoConfigAsuntoUsers;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.tareaNotificacion.model.DDEntidadAcuerdo;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.CollectionUtils;
import es.capgemini.pfs.utils.StringUtils;
import es.pfsgroup.commons.utils.Checks;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("AcuerdoDao")
public class AcuerdoDaoImpl extends AbstractEntityDao<Acuerdo, Long> implements AcuerdoDao {

	@Resource
	private PaginationManager paginationManager;
	
    /**
     * Busca Acuerdos de un asunto.
     * @param idAsunto id del asunto
     * @return lista Acuerdo.
     */
    @SuppressWarnings("unchecked")
    public List<Acuerdo> getAcuerdosDelAsunto(Long idAsunto) {
        String hql = "from Acuerdo a where a.asunto.id = ?";
        List<Acuerdo> acuerdos = getHibernateTemplate().find(hql, idAsunto);
        return acuerdos;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public Acuerdo getUltimoAcuerdoUsuario(Usuario usuario) {
        String hql = "from Acuerdo a where a.auditoria.usuarioCrear = ?"
                + " and a.id = (select max(a1.id) from Acuerdo a1 where a1.auditoria.usuarioCrear = ?)";
        List<Acuerdo> acuerdos = getHibernateTemplate().find(hql, new Object[] { usuario.getUsername(), usuario.getUsername() });
        if (acuerdos.size() > 0) { return acuerdos.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Acuerdo> getAcuerdosDelExpediente(Long idExpediente) {
        String hql = "from Acuerdo a where a.expediente.id = ? and a.auditoria.borrado = 0";
        List<Acuerdo> acuerdos = getHibernateTemplate().find(hql, idExpediente);
        return acuerdos;
    }
    
    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Acuerdo> getAcuerdosDelExpedienteDespacho(Long idExpediente, List<Long> idsDespacho) {
        String hql = "from Acuerdo a where a.expediente.id = ? and a.auditoria.borrado = 0";
        if (!Checks.estaVacio(idsDespacho)) {
        	if (idsDespacho.size()==1) {
        		hql += " and a.despacho.id="+idsDespacho.get(0);
        	} else {
        		hql += " and a.despacho.id in ("+convertirEnStringComas(idsDespacho)+")";
        	}
        }
        List<Acuerdo> acuerdos = getHibernateTemplate().find(hql, idExpediente);
        return acuerdos;
    }
    
    
	private Object convertirEnStringComas(List<Long> cadena) {
		String r = null;
		for (Long cad : cadena){
			if (!Checks.esNulo(r)){
				r = r + ',' + cad.toString();
			}else{
				r = cad.toString();
			}
		}
		return r;
	}
    /**
     * Buscar otros Acuerdos vigentes para el mismo Asunto.
     * @param idAsunto el id del asunto.
     * @param idAcuerdo el id del acuerdo que se quiere guardar.
     * @return boolean
     */
    @SuppressWarnings("unchecked")
    public boolean hayAcuerdosVigentes(Long idAsunto, Long idAcuerdo) {
        String hql = "from Acuerdo ac where ac.asunto.id = ? and ac.estadoAcuerdo.codigo = " + DDEstadoAcuerdo.ACUERDO_ACEPTADO;
        List<Acuerdo> acuerdos;
        if (idAcuerdo != null) {
            hql += " and ac.id != ? ";
            acuerdos = getHibernateTemplate().find(hql, new Object[] { idAsunto, idAcuerdo });
        } else {
            acuerdos = getHibernateTemplate().find(hql, new Object[] { idAsunto });
        }
        if (acuerdos != null) { return acuerdos.size() > 0; }
        return false;
    }
    
	public String getFechaPaseMora(Long idContrato){
		StringBuffer query = new StringBuffer();
	    query.append("SELECT  ");
	    query.append("CASE WHEN TRUNC(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA) < 0 ");
	    query.append("THEN TO_CHAR(TRUNC(SYSDATE + 90), 'dd/MM/yyyy') ");
	    //query.append("ELSE TO_CHAR((SYSDATE+90) - TRUNC(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA), 'dd/MM/yyyy') ");
	    query.append("ELSE TO_CHAR(TRUNC(MOV.MOV_FECHA_POS_VENCIDA + 90), 'dd/MM/yyyy') ");
	    query.append("END FECHA_PASE_A_MORA_CNT ");
	    query.append("FROM MOV_MOVIMIENTOS mov ");
	    query.append("JOIN CNT_CONTRATOS cnt ON cnt.CNT_ID = mov.CNT_ID ");
	    query.append("WHERE cnt.CNT_ID = ");
	    query.append(idContrato);
	    query.append(" AND mov.MOV_FECHA_EXTRACCION = cnt.CNT_FECHA_EXTRACCION ");
	    
	    SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory().getCurrentSession().createSQLQuery(query.toString());
	    return (String) sqlQuery.uniqueResult();
    }
	
	//Devuelve solo el código de asunto y expediente.
	 public List<DDEntidadAcuerdo> getListEntidadAcuerdo(){
		 
	       	String hql = "from DDEntidadAcuerdo where auditoria.borrado = 0";
	   		List<DDEntidadAcuerdo> lista = getHibernateTemplate().find(hql);
		 	List<DDEntidadAcuerdo> lista2= null;
		 
		 	for(int i=0;i<lista.size();i++)
		 	{
		 		if(!lista.get(i).getCodigo().equals(lista.get(i).CODIGO_ENTIDAD_ASUNTO) && !lista.get(i).getCodigo().equals(lista.get(i).CODIGO_ENTIDAD_EXPEDIENTE)){
		 			lista.remove(i);
				 }
		 	}
		 	
	   		return lista;
	    }

	public Page buscarAcuerdos(DTOTerminosFiltro terminosFiltroDto, Usuario usuario, List<Long> idGrpsUsuario) {
		Page page = paginationManager.getHibernatePage(getHibernateTemplate(), 
				generarHQLBuscarAcuerdos(terminosFiltroDto,usuario,idGrpsUsuario), terminosFiltroDto);
		return page;
	}
	
	
	private String generarHQLBuscarAcuerdos(DTOTerminosFiltro dto, Usuario usuarioLogueado, List<Long> idGrpsUsuario) {
		
		StringBuffer hql = new StringBuffer();
		
		boolean cruzaContratos = (!Checks.esNulo(dto.getNroContrato()));
		boolean cruzaClientes= (!Checks.esNulo(dto.getNroCliente()));
		boolean cruzaTipoAcuerdo= (!Checks.esNulo(dto.getTipoAcuerdo()));
		boolean cruzaTipoTermino= (!Checks.esNulo(dto.getTipoTermino()));
		boolean cruzaDespachos = (!Checks.esNulo(dto.getSolicitantes()) || !StringUtils.emtpyString(dto.getSolicitantes()));
		boolean cruzaEstado = (!Checks.esNulo(dto.getEstado()));
		boolean cruzaJerarquia = (!Checks.esNulo(dto.getJerarquia()));
		boolean cruzaCentros = (!Checks.esNulo(dto.getCentros()));
		
		hql.append(" select acu, ter from");
		hql.append(" Acuerdo acu left join acu.terminos ter");
		
		if(cruzaContratos){
			hql.append(", TerminoContrato terCnt");
		}
		
		if(cruzaClientes){
			if(!cruzaContratos){
				hql.append(", TerminoContrato terCnt");
			}
			hql.append(", ClienteContrato cliCnt");
		}
		
		//para jerarquía y zonas de acuerdos de asuntos
		if (requiereContrato(dto) && (dto.getTipoAcuerdo().equals("ASU") || dto.getTipoAcuerdo().equals("AMBAS"))) {
			hql.append(", ProcedimientoContratoExpediente pce, ExpedienteContrato cex, Contrato cnt, Procedimiento prc ");
		}
		
		hql.append(" where 1=1 ");
		
		if(cruzaJerarquia && (dto.getTipoAcuerdo().equals("ASU") || dto.getTipoAcuerdo().equals("AMBAS"))){
			hql.append(" and prc.asunto.id = acu.asunto.id ");
			hql.append(" and prc.auditoria." + Auditoria.UNDELETED_RESTICTION);
			hql.append(" and prc.id = pce.procedimiento and cex.id = pce.expedienteContrato and cex.contrato.id = cnt.id ");
			hql.append(" and cex.auditoria." + Auditoria.UNDELETED_RESTICTION);
		}
	
		//// FILTROS /////
		
		//CONTRATO
		if(cruzaContratos){
			hql.append(" and ter.id=terCnt.termino.id and terCnt.contrato.nroContrato like '%" + dto.getNroContrato() + "%'");	
		}
		
		//CLIENTE
		if(cruzaClientes){
			if(!cruzaContratos){
				hql.append(" and ter.id=terCnt.termino.id ");
			}
			hql.append(" and terCnt.contrato.id=cliCnt.contrato.id and cliCnt.cliente.id= "+dto.getNroCliente());
		}
		
		//TIPO ACUERDO ASUNTO
		if(dto.getTipoAcuerdo().equals("ASU")){
			
			hql.append(" and acu.asunto.id is not null ");	
			//Si es usuario externo, se muestran los acuerdos de asuntos con restricciones
			//PERMISOS DEL USUARIO
			if (usuarioLogueado.getUsuarioExterno()) {
				hql=filtroUsuarioExterno(usuarioLogueado, idGrpsUsuario, hql);
			}
			
			// FILTRO JERARQUÍA Y ZONAS
			if (cruzaJerarquia) {				
				hql=filtroJerarquiaZonaAcuerdosAsuntos(dto, hql);
			}
				
		}else{	
			//TIPO ACUERDO EXPEDIENTE
			if(dto.getTipoAcuerdo().equals("EXP")){
				//Si es usuario externo, no se muestran acuerdos de expedientes
				if (usuarioLogueado.getUsuarioExterno()) {
					hql.append(" and 1=2 ");
				}else{
					//Si no es usuario externo, se muestran los acuerdos de expedientes
					hql.append(" and acu.expediente.id is not null ");
					
					//FILTRO JERARQUIA Y ZONAS
			        if (cruzaJerarquia) {
			            filtroJerarquiaZonaAcuerdosExpedientes(dto, hql);
			        }
				}	
			}else{
				//TIPO ACUERDO AMBAS
				//Si es usuario externo, solo se muestran acuerdos de asuntos con las restricciones correspondientes
				if (usuarioLogueado.getUsuarioExterno()) {	
					
					//PERMISOS PARA ASUNTOS
					hql.append(" and acu.asunto.id is not null ");
					hql=filtroUsuarioExterno(usuarioLogueado, idGrpsUsuario, hql);
					
					// FILTRO JERARQUÍA Y ZONAS
					if (cruzaJerarquia) {				
						hql=filtroJerarquiaZonaAcuerdosAsuntos(dto, hql);
					}
					
				}else{
					//Si no es usuario externo, se muestran Acuerdos de asuntos y expedientes sin restricciones	salvo las de jerarquía				
					// FILTRO JERARQUÍA Y ZONAS
					if (cruzaJerarquia){
						hql.append(" and (acu.asunto.id is not null or acu.expediente.id is not null) ");
						hql=filtroJerarquiaZonasAcuerdosTodos(dto, hql, cruzaJerarquia);
					}else{
						hql.append(" and (acu.asunto.id is not null or acu.expediente.id is not null) ");
					}
				}
			}
		}	
			
		//TIPO TERMINO
		if(cruzaTipoTermino){
			hql.append(" and (ter.acuerdo.tipoAcuerdo.codigo = '"+ dto.getTipoTermino() + "' ");
			hql.append(" or acu.tipoAcuerdo.codigo = '"+ dto.getTipoTermino() + "') ");
		}		
		//ESTADO
		if(cruzaEstado){
			hql.append(" and acu.estadoAcuerdo.codigo = '"+ dto.getEstado() + "' ");
		}		
		//SOLICITANTES
		if (cruzaDespachos) {			
			hql.append(" and acu.gestorDespacho.despachoExterno.id in (" + dto.getSolicitantes() + ")) ");
		}	
		//FECHA PROPUESTA DESDE
		if (dto.getFechaAltaDesde() != null && !"".equals(dto.getFechaAltaDesde())) {        		
			hql.append(" and acu.fechaPropuesta >= TO_DATE('"+dto.getFechaAltaDesde() + "','dd/MM/yyyy')" );    
	    }   
	    //FECHA PROPUESTA HASTA
	    if (dto.getFechaAltaHasta() != null && !"".equals(dto.getFechaAltaHasta())) {        		
			hql.append(" and acu.fechaPropuesta <= TO_DATE('"+dto.getFechaAltaHasta() + " 23:59:59','dd/MM/rrrr hh24:mi:ss')" );    
	    }	
	    //FECHA ESTADO DESDE
	    if (dto.getFechaEstadoDesde() != null && !"".equals(dto.getFechaEstadoDesde())) {        		
			hql.append(" and acu.fechaEstado >= TO_DATE('"+dto.getFechaEstadoDesde() + "','dd/MM/yyyy')" );    
	    }        
	    //FECHA ESTADO HASTA
	    if (dto.getFechaEstadoHasta() != null && !"".equals(dto.getFechaEstadoHasta())) {        		
			hql.append(" and acu.fechaEstado <= TO_DATE('"+dto.getFechaEstadoHasta() + " 23:59:59','dd/MM/rrrr hh24:mi:ss')" );    
	    }	        
	    //FECHA VIGENCIA DESDE
	    if (dto.getFechaVigenciaDesde() != null && !"".equals(dto.getFechaVigenciaDesde())) {        		
			hql.append(" and acu.fechaLimite >= TO_DATE('"+dto.getFechaVigenciaDesde() + "','dd/MM/yyyy')" );  
	    }
	    //FECHA VIGENCIA HASTA
	    if (dto.getFechaVigenciaHasta() != null && !"".equals(dto.getFechaVigenciaHasta())) {        		
			hql.append(" and acu.fechaLimite <= TO_DATE('"+dto.getFechaVigenciaHasta() + " 23:59:59','dd/MM/rrrr hh24:mi:ss')" );   
	    } 	  
        // DESPACHO
        if (dto.getDespacho() != null && !"".equals(dto.getDespacho())) {
     		hql.append(" and acu.asunto.id in (" + getIdsAsuntosDelDespacho(new Long(dto.getDespacho())) + ")");
        }    
        // GESTOR
        if (!es.capgemini.pfs.utils.StringUtils.emtpyString(dto.getGestores()) || !es.capgemini.pfs.utils.StringUtils.emtpyString(dto.getTipoGestor())) {
    		hql.append(" and acu.asunto.id in (" + getIdsAsuntosParaGestor(dto.getGestores(), dto.getTipoGestor()) + ")");
        }
            
		return hql.toString();
	}
	
	private StringBuffer filtroJerarquiaZonasAcuerdosTodos(DTOTerminosFiltro dto, StringBuffer hql, boolean cruzaJerarquia) {

		// FILTRO JERARQUÍA Y ZONAS acuerdos asuntos	
		hql.append(" and ((cnt.zona.nivel.codigo >= "+ dto.getJerarquia());

		if (dto.getCodigoZonas().size() > 0) {
			hql.append(" and ( ");
			for (String codigoZ : dto.getCodigoZonas()) {
				// si alguno de los contratos del asunto tiene alguna de las zonas
				hql.append(" cnt.zona.codigo like '" + codigoZ + "%' OR");
			}
			hql.delete(hql.length() - 2, hql.length());
			hql.append(" ) ");
		}
		hql.append(" ) ");
		
		//FILTRO JERARQUIA Y ZONAS acuerdos expedientes			        
		hql.append(" or (acu.expediente.oficina.zona.nivel.id >= "+ dto.getJerarquia());
			        
		int cantZonas = dto.getCodigoZonas().size();
		if (cantZonas > 0) {
		    hql.append(" and ( ");
		    for (String codigoZ : dto.getCodigoZonas()) {
		        hql.append(" acu.expediente.oficina.zona.codigo like '" + codigoZ + "%' OR");
		    }
		    hql.deleteCharAt(hql.length() - 1);
		    hql.deleteCharAt(hql.length() - 1);
		    hql.append(" ) ");
		}
		hql.append(" ) ");
		hql.append(" ) ");
		return hql;		
	}

	private void filtroJerarquiaZonaAcuerdosExpedientes(DTOTerminosFiltro dto, StringBuffer hql) {
		hql.append(" and acu.expediente.oficina.zona.nivel.id >= "+ dto.getJerarquia());
		        
		int cantZonas = dto.getCodigoZonas().size();
		if (cantZonas > 0) {
		    hql.append(" and ( ");
		    for (String codigoZ : dto.getCodigoZonas()) {
		        hql.append(" acu.expediente.oficina.zona.codigo like '" + codigoZ + "%' OR");
		    }
		    hql.deleteCharAt(hql.length() - 1);
		    hql.deleteCharAt(hql.length() - 1);
		    hql.append(" ) ");
		}
	}

	private StringBuffer filtroJerarquiaZonaAcuerdosAsuntos(DTOTerminosFiltro dto, StringBuffer hql) {
	
		hql.append(" and (cnt.zona.nivel.codigo >= "+ dto.getJerarquia());

		if (dto.getCodigoZonas().size() > 0) {
			hql.append(" and ( ");
			for (String codigoZ : dto.getCodigoZonas()) {
				// si alguno de los contratos del asunto tiene alguna de las zonas
				hql.append(" cnt.zona.codigo like '" + codigoZ + "%' OR");
			}
			hql.delete(hql.length() - 2, hql.length());
			hql.append(" ) ");
		}
		hql.append(" ) ");
		return hql;
	}

	private StringBuffer filtroUsuarioExterno(Usuario usuarioLogueado,
			List<Long> idGrpsUsuario, StringBuffer hql) {
		hql.append(" and ("
				+ filtroGestorSupervisorAsuntoMonoGestor(usuarioLogueado)
				+ " or "
				+ filtroGestorSupervisorAsuntoMultiGestor(usuarioLogueado)
				+ " or "
				+ filtroGestorSupervisorAsuntoMultiGestorVariasEntidades(usuarioLogueado)
				+ filtroGestorGrupo(idGrpsUsuario) + ")");
		return hql;
	}
	
	private boolean requiereContrato(DTOTerminosFiltro dto) {
		return (dto.getCodigoZonas().size() > 0 || (!Checks.esNulo(dto.getJerarquia()) && dto.getJerarquia().length() > 0));
	}
	
	private String filtroGestorSupervisorAsuntoMonoGestor(
			Usuario usuarioLogado) {
		StringBuilder hql = new StringBuilder();
		hql.append(" acu.asunto.id in (");
		hql.append("select a.id from Asunto a ");
		hql.append("where (a.gestor.usuario.id = "+ usuarioLogado.getId()+ ") or (a.supervisor.usuario.id = "+ usuarioLogado.getId());
		hql.append("))");
		return hql.toString();
	}
	
	private String filtroGestorSupervisorAsuntoMultiGestor(
			Usuario usuarioLogado) {
		StringBuilder hql = new StringBuilder();
		hql.append(" (acu.asunto.id in (");
		hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
		hql.append("where gaa.gestor.usuario.id = "+ usuarioLogado.getId());
		hql.append("))");
		return hql.toString();
	}
	
	private String filtroGestorSupervisorAsuntoMultiGestorVariasEntidades(
			Usuario usuarioLogado) {
		StringBuilder hql = new StringBuilder();
		hql.append(" (acu.asunto.id in (");
		hql.append("select ge.unidadGestionId from EXTGestorEntidad ge");
		hql.append(" where ge.tipoEntidad.codigo = "
				+ DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
		hql.append(" and ge.gestor.id = "+ usuarioLogado.getId());
		hql.append("))");
		return hql.toString();
	}
	
	private String filtroGestorGrupo(List<Long> idsUsuariosGrupo) {
		if (idsUsuariosGrupo == null || idsUsuariosGrupo.size() == 0)
			return "";

		StringBuilder hql = new StringBuilder();

		hql.append("or (acu.asunto.id in (");
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
	
	 private String generaFiltroExpedientesPorGestor(Usuario usuLogado){
         StringBuffer hql = new StringBuffer();
         hql.append(" select exp.id from Expediente exp , EXTGestorEntidad ge ");
         hql.append(" where exp.id = ge.unidadGestionId and ge.tipoEntidad.codigo = '").append(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE).append("' ");
         hql.append(" and ge.gestor.id in (");
         hql.append(obtenerListaUsuariosDelGrupo(usuLogado.getId()));
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
	
	private String getIdsAsuntosDelDespacho(Long idDespacho) {
		return "select asu.id from VTARAsuntoVsUsuario gaa , Asunto asu "
				+ "where  gaa.asunto = asu.id and gaa.despachoExterno = " + idDespacho;
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

	public List<AcuerdoConfigAsuntoUsers> getProponentesAcuerdo(){
		String hql = "from AcuerdoConfigAsuntoUsers where auditoria.borrado = 0";
        List<AcuerdoConfigAsuntoUsers> lista = getHibernateTemplate().find(hql);
		return lista;
    }
	
	 public List<DespachoExterno> getDespachosProponentesValidos(Usuario usuLogado){
         String hql = " select gd.despachoExterno from GestorDespacho gd , AcuerdoConfigAsuntoUsers config "
        		 		+" where gd.despachoExterno.tipoDespacho.id = config.proponente.id and gd.usuario.id = "+ usuLogado.getId()
         				+" and gd.auditoria.borrado = false and config.auditoria.borrado = false ";
         
         List<DespachoExterno> despachos = getHibernateTemplate().find(hql);
         return despachos;
	 }
}
