package es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.comite.model.SesionComite;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dao.MEJSesionComiteDao;
import es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dto.MEJDtoBusquedaActas;

@Repository("MEJSesionComiteDao")
public class MEJSesionComiteDaoImpl extends AbstractEntityDao<SesionComite, Long> implements MEJSesionComiteDao{

	@Autowired
	private PaginationManager paginationManager;
	
	@Override
	public Page buscarActasComites(MEJDtoBusquedaActas dto) {
		Page page = null;
		try {
            HashMap<String, Object> params = new HashMap<String, Object>();
            String hql = construyeQueryActasComite(dto, params);
            page = paginationManager.getHibernatePage(getHibernateTemplate(), hql, dto, params);
        } catch (Exception e) {
            e.printStackTrace();
        }
		
        return page;
	}

	private String construyeQueryActasComite(MEJDtoBusquedaActas dto,
			HashMap<String, Object> params) {
		String listadoZonas = getListadoZonas(dto.getUsuarioLogado());
		StringBuilder sb = new StringBuilder();
		
		sb.append(	"  select sesion " +
					"  from SesionComite sesion inner join " +
					"		sesion.comite com "+		
					"  where sesion.fechaFin is not null and " +
					"  		 com.id in (select comi.id " + 
					"  				    from Comite comi left join " +
					"					     comi.puestosComites pc left join " +
					"					     pc.zona zonasComite " +
					"  				    where zonasComite.id in (" + listadoZonas + ")) ");
		
		String hql = sb.toString();
		
        if (dto.isBusqueda()) {
             hql += " and sesion in ( ";
             hql += armarFiltroBusquedaActasComite(dto, params) + " ) ";
        }
		
		return hql;
	}

    private StringBuffer armarFiltroBusquedaActasComite(MEJDtoBusquedaActas dto, HashMap<String, Object> params) {
    	StringBuffer hql = new StringBuffer(); 
    	hql.append("select ses ");
    	hql.append("from SesionComite ses where 1=1 ");
    	
    	//Fecha Fin Desde
        if (!emtpyString(dto.getFechaFinDesde()) && !emtpyString(dto.getFechaFinDesdeOperador())) {
             SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
             Date fecha = null;
             try {
                 fecha = sdf1.parse(dto.getFechaFinDesde());
             } catch (ParseException e) {
                 logger.error("Error parseando la fecha");
             }
             hql.append(" and trunc (ses.fechaFin) " + dto.getFechaFinDesdeOperador() + " trunc (:fechaFinDesde) ");
             params.put("fechaFinDesde", fecha);
        }
        //Fecha Fin Hasta
        if (!emtpyString(dto.getFechaFinHasta()) && !emtpyString(dto.getFechaFinHastaOperador())) {
             SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
             Date fecha = null;
             try {
                 fecha = sdf1.parse(dto.getFechaFinHasta());
             } catch (ParseException e) {
                 logger.error("Error parseando la fecha");
             }
             hql.append(" and trunc (ses.fechaFin) " + dto.getFechaFinHastaOperador() + " trunc (:fechaFinHasta) ");
             params.put("fechaFinHasta", fecha);
        }
      	//Fecha Inicio Desde
        if (!emtpyString(dto.getFechaInicioDesde()) && !emtpyString(dto.getFechaInicioDesdeOperador())) {
             SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
             Date fecha = null;
             try {
                 fecha = sdf1.parse(dto.getFechaInicioDesde());
             } catch (ParseException e) {
                 logger.error("Error parseando la fecha");
             }
             hql.append(" and trunc (ses.fechaInicio) " + dto.getFechaInicioDesdeOperador() + " trunc (:fechaInicioDesde) ");
             params.put("fechaInicioDesde", fecha);
        }
        //Fecha Inicio Hasta
        if (!emtpyString(dto.getFechaInicioHasta()) && !emtpyString(dto.getFechaInicioHastaOperador())) {
             SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
             Date fecha = null;
             try {
                 fecha = sdf1.parse(dto.getFechaInicioHasta());
             } catch (ParseException e) {
                 logger.error("Error parseando la fecha");
             }
             hql.append(" and trunc (ses.fechaInicio) " + dto.getFechaInicioHastaOperador() + " trunc (:fechaInicioHasta) ");
             params.put("fechaInicioHasta", fecha);
        }
        
        if (dto.getIdComite() != null) {
        	hql.append(" and ses.comite.id = " + dto.getIdComite());
   		}

        return hql;
	}

    private boolean emtpyString(String str) {
        return (str == null) || (str.trim().equals(""));
    }
    
	/**
     * Genera una cadena con el listado de perfiles del usuario
     * @param dto
     * @return
     */
	private String getListadoZonas(Usuario usuarioLogado) {
		HashMap<Long, Long> controlZonas = new HashMap<Long, Long>();
        for (DDZona z : usuarioLogado.getZonas()) {
            Long idZona =z.getId();
            if (!controlZonas.containsKey(idZona)) controlZonas.put(idZona, idZona);
        }
        String listado = controlZonas.keySet().toString();
        listado = listado.substring(1, listado.length() - 1);
        return listado;
	}

	public void setPaginationManager(PaginationManager bean) {
		paginationManager = bean;
	}
	
}
