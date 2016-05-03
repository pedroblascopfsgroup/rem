package es.capgemini.pfs.acuerdo.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Hibernate;
import org.hibernate.SQLQuery;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.dto.BusquedaAcuerdosDTO;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.model.DDEntidadAcuerdo;
import es.capgemini.pfs.users.domain.Usuario;
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
	
	 public List<DDEntidadAcuerdo> getListEntidadAcuerdo(){
		 
	       	String hql = "from DDEntidadAcuerdo where auditoria.borrado = 0";
	   		List<DDEntidadAcuerdo> lista = getHibernateTemplate().find(hql);
		 	List<DDEntidadAcuerdo> lista2= null;
		 	/*
		 	for(int i=0;i<=lista.size();i++)
		 	{
		 		if(lista.get(i).getCodigo().equals(lista.get(i).CODIGO_ENTIDAD_ASUNTO)){
			 	lista2.add(lista.get(i));
		 		}
		 		else{
		 			if(lista.get(i).getCodigo().equals(lista.get(i).CODIGO_ENTIDAD_EXPEDIENTE)){
					 	lista2.add(lista.get(i));
				 		}
		 		}
		 	}
	   			*/	
		 	
		 	for(int i=0;i<lista.size();i++)
		 	{
		 		if(!lista.get(i).getCodigo().equals(lista.get(i).CODIGO_ENTIDAD_ASUNTO) && !lista.get(i).getCodigo().equals(lista.get(i).CODIGO_ENTIDAD_EXPEDIENTE)){
		 			lista.remove(i);
				 }
		 	}
		 	
	   		return lista;
	    }

	public Page buscarAcuerdos(BusquedaAcuerdosDTO dto) {
		return paginationManager.getHibernatePage(getHibernateTemplate(),generarHQLBuscarAcuerdos(dto), (PaginationParams) dto);
	}
	
	private String generarHQLBuscarAcuerdos(BusquedaAcuerdosDTO dto) {
		
		return null;
		
	}

}
