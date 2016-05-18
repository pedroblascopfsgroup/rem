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
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.dao.AbstractEntityDao;
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

	public Page buscarAcuerdos(DTOTerminosFiltro terminosFiltroDto, Usuario usuario) {
		Page page = paginationManager.getHibernatePage(getHibernateTemplate(), 
				generarHQLBuscarAcuerdos(terminosFiltroDto,usuario), terminosFiltroDto);
		return page;
	}
	
	private String generarHQLBuscarAcuerdos(DTOTerminosFiltro dto, Usuario usuarioLogueado) {
		
		StringBuffer hql = new StringBuffer();
		
		boolean cruzaContratos = (!Checks.esNulo(dto.getNroContrato()));
		boolean cruzaClientes= (!Checks.esNulo(dto.getNroCliente()));
		boolean cruzaTipoAcuerdo= (!Checks.esNulo(dto.getTipoAcuerdo()));
		boolean cruzaTipoTermino= (!Checks.esNulo(dto.getTipoTermino()));
		boolean cruzaDespachos = (!Checks.esNulo(dto.getSolicitantes()) || !StringUtils.emtpyString(dto.getSolicitantes()));
		boolean cruzaEstado = (!Checks.esNulo(dto.getEstado()));
		
		hql.append("select distinct ter ");
		
		// LAS TABLAS QUE NECESITO
		hql.append("from TerminoAcuerdo ter ");
		
		if(cruzaContratos){
			hql.append(", TerminoContrato terCnt");
		}
		
		if(cruzaClientes){
			if(!cruzaContratos){
				hql.append(", TerminoContrato terCnt");
			}
			hql.append(", ClienteContrato cliCnt");
		}
		
		hql.append(" where 1=1 ");
		
		
		//// FILTROS /////
		
		//CONTRATO
		if(cruzaContratos){
			hql.append(" and ter.id=terCnt.termino.id and terCnt.contrato.nroContrato= '"
					+ dto.getNroContrato() + "'  ");		
		}
		
		//CLIENTE
		if(cruzaClientes){
			if(!cruzaContratos){
				hql.append(" and ter.id=terCnt.termino.id ");
			}
			hql.append(" and terCnt.contrato.id=cliCnt.contrato.id and cliCnt.cliente.id= "+dto.getNroCliente());
		}

		//TIPO ACUERDO
		if(cruzaTipoAcuerdo){
			
			if(dto.getTipoAcuerdo().equals("ASU")){
				hql.append(" and ter.acuerdo.asunto.id is not null ");
			}
			if(dto.getTipoAcuerdo().equals("EXP")){
				hql.append(" and ter.acuerdo.expediente.id is not null ");
			}
			if(dto.getTipoAcuerdo().equals("AMBAS")){
				hql.append(" and ter.acuerdo.expediente.id is not null and ter.acuerdo.asunto.id is not null ");
			}
		}
		
		//TIPO TERMINO
		if(cruzaTipoTermino){
			hql.append(" and ter.tipoAcuerdo.codigo = '"+ dto.getTipoTermino() + "' ");
		}
		
		//ESTADO
		if(cruzaEstado){
			hql.append(" and ter.acuerdo.estadoAcuerdo.codigo = '"+ dto.getEstado() + "' ");
		}
		
		//SOLICITANTES
		if (cruzaDespachos) {			
			hql.append(" and ter.acuerdo.gestorDespacho.despachoExterno.id IN (").append(dto.getSolicitantes()).append(") ");
			}
		
		//FECHA PROPUESTA DESDE
        if (dto.getFechaAltaDesde() != null && !"".equals(dto.getFechaAltaDesde())) {        		
			 hql.append(" and ter.acuerdo.fechaPropuesta >= TO_DATE('"+dto.getFechaAltaDesde() + "','dd/MM/yyyy')" );    
        }
        
        //FECHA PROPUESTA HASTA
        if (dto.getFechaAltaHasta() != null && !"".equals(dto.getFechaAltaHasta())) {        		
			 hql.append(" and ter.acuerdo.fechaPropuesta <= TO_DATE('"+dto.getFechaAltaHasta() + "','dd/MM/yyyy')" );    
        }
        
        //FECHA ESTADO DESDE
        if (dto.getFechaEstadoDesde() != null && !"".equals(dto.getFechaEstadoDesde())) {        		
			 hql.append(" and ter.acuerdo.fechaEstado >= TO_DATE('"+dto.getFechaEstadoDesde() + "','dd/MM/yyyy')" );    
        }
        
        //FECHA ESTADO HASTA
        if (dto.getFechaEstadoHasta() != null && !"".equals(dto.getFechaEstadoHasta())) {        		
			 hql.append(" and ter.acuerdo.fechaEstado <= TO_DATE('"+dto.getFechaEstadoHasta() + "','dd/MM/yyyy')" );    
        }
        
        //FECHA VIGENCIA DESDE
        if (dto.getFechaVigenciaDesde() != null && !"".equals(dto.getFechaVigenciaDesde())) {        		
			 hql.append(" and ter.acuerdo.fechaLimite >= TO_DATE('"+dto.getFechaVigenciaDesde() + "','dd/MM/yyyy')" );    
        }
         
        //FECHA VIGENCIA HASTA
        if (dto.getFechaVigenciaHasta() != null && !"".equals(dto.getFechaVigenciaHasta())) {        		
			 hql.append(" and ter.acuerdo.fechaLimite <= TO_DATE('"+dto.getFechaVigenciaHasta() + "','dd/MM/yyyy')" );    
        }
        
       
        // DESPACHO
        if (dto.getDespacho() != null && !"".equals(dto.getDespacho())) {
     		hql.append(" and ter.acuerdo.asunto.id in (" + getIdsAsuntosDelDespacho(new Long(dto.getDespacho())) + ")");
        }
     
        // GESTOR
        if (!es.capgemini.pfs.utils.StringUtils.emtpyString(dto.getGestores()) || !es.capgemini.pfs.utils.StringUtils.emtpyString(dto.getTipoGestor())) {
    		hql.append(" and ter.acuerdo.asunto.id in (" + getIdsAsuntosParaGestor(dto.getGestores(), dto.getTipoGestor()) + ")");
        }
     		
        //JERARQUÍA
        int cantZonas = dto.getCodigoZonas().size();
            
        if (cantZonas > 0) {
                hql.append(" and ( ");
                for (String codigoZ : dto.getCodigoZonas()) {
                    hql.append(" ter.acuerdo.expediente.oficina.zona.codigo like '" + codigoZ + "%' OR");
                }
                hql.deleteCharAt(hql.length() - 1);
                hql.deleteCharAt(hql.length() - 1);
                
                hql.append(" or ter.acuerdo.expediente.id in ( ");
                	hql.append(generaFiltroExpedientesPorGestor(usuarioLogueado));
    	        hql.append(" ) ");
                
    	        hql.append(" ) ");
        }else{
        		//GESTORES EXPEDIENTE
    	    	hql.append(" and ter.acuerdo.expediente.id in ( ");
    	        hql.append(generaFiltroExpedientesPorGestor(usuarioLogueado));
    	        hql.append(" ) ");
            	}

        //CENTROS
        if (!StringUtils.emtpyString(dto.getJerarquia())) {
               	hql.append("  and ter.acuerdo.expediente.oficina.zona.nivel.id >= "+ dto.getJerarquia());
        }
        
        hql.append(" order by ter.acuerdo.id desc ");
                  
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
		String hql = "from AcuerdoConfigAsuntoUsers a where a.auditoria.borrado = 0";
        List<AcuerdoConfigAsuntoUsers> lista = getHibernateTemplate().find(hql);
		return lista;
    }

}
