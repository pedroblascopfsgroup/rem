package es.pfsgroup.recovery.panelcontrol.judicial.zonas.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.recovery.panelcontrol.judicial.zonas.dao.PanelControlZonaDao;

@Repository
public class PanelControlZonaDaoImpl extends AbstractEntityDao<DDZona, Long> implements PanelControlZonaDao {

	@Autowired
	private Executor executor;
	
//	@SuppressWarnings("unchecked")
//	public List<DDZona> getListaZonas(Long nivel, Long id,Boolean subConsulta){
//		StringBuffer queryString = new StringBuffer("Select z from DDZona z");
//		queryString.append(" where ( 1=1 ");
//		if(!id.equals(new Long(0))){
//			
//			if(subConsulta != null && subConsulta.booleanValue())
//				queryString.append(" and z.id = "+id);
//			else
//				queryString.append(" and z.zonaPadre.id = "+id);
//			queryString.append(" and (z.nivel.id = "+nivel);
//			if(nivel.equals(4L)){
//				queryString.append("  or z.nivel.id = 5 or z.nivel.id = 2) ");
//			}
//			if(nivel.equals(5L))
//				queryString.append(" or z.nivel.id = 2 )");
//			if(nivel.equals(3L))
//				queryString.append(" or z.nivel.id = 5 or z.nivel.id = 2 or z.nivel.id = 4) ");
//			if(nivel.equals(1L))
//				queryString.append(" or z.nivel.id = 3 or z.nivel.id = 5 or z.nivel.id = 2 or z.nivel.id = 4)");
//			
//			queryString.append(") ");
//		}
//		
//		
//		
//		
//		
//		
//		queryString.append(" and z.auditoria.borrado = false");
//		List<DDZona> lista = getHibernateTemplate().find(queryString.toString());
//		return lista;
//	}

//	@SuppressWarnings("unchecked")
//	@Override
//	public List<DDZona> getListaZonasNivel(Long nivel, String cod,Boolean subConsulta) {
//
//		
//		List<DDZona> lista = new ArrayList<DDZona>();
//		
//		Usuario usuario = (Usuario)executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
//		
//		if(subConsulta != null && subConsulta.booleanValue()){				
//			
//			for(ZonaUsuarioPerfil zup:usuario.getZonaPerfil()){
//				StringBuffer queryString = new StringBuffer("Select z from DDZona z");
//				queryString.append(" where ( 1=1 ");
//				queryString.append("  and z.codigo like '"+zup.getZona().getCodigo()+"_%'");
//				queryString.append(") ");
//				
//				queryString.append(" and z.auditoria.borrado = false");
//					
//				List<DDZona> listaAux = getHibernateTemplate().find(queryString.toString());
//				lista.addAll(listaAux);
//			}
//		}
//		else{
//			
//			for(ZonaUsuarioPerfil zup:usuario.getZonaPerfil()){
//				if(zup.getZona().getCodigo().equals("01")){
//					lista.clear();
//					StringBuffer queryString = new StringBuffer("Select z from DDZona z");
//					queryString.append(" where ( 1=1 ");
//					queryString.append("  and z.codigo like '"+zup.getZona().getCodigo()+"_%'");
//					queryString.append(") ");
//					
//					queryString.append(" and z.auditoria.borrado = false");
//						
//					List<DDZona> listaAux = getHibernateTemplate().find(queryString.toString());
//					lista.addAll(listaAux);
//				}
//				else
//					lista.add(zup.getZona());
//			}
//		}
//		
//		
//		
//		return lista;
//	}
//
//	@Override
//	public DDZona getZona(String cod) {
//		StringBuffer queryString = new StringBuffer("Select z from DDZona z where z.codigo like '"+cod+"'");
//		Query query = getSession().createQuery(queryString.toString());
//		return (DDZona)query.uniqueResult();
//	}

	@Override
	public List<DDZona> getListaZonasNivelLista(String cod) {

		List<DDZona> lista = new ArrayList<DDZona>();
		
		StringBuffer queryString = new StringBuffer("Select z from DDZona z");
		queryString.append(" where ( 1=1 ");
		queryString.append("  and z.codigo like '"+cod+"%'");
		queryString.append(") ");
		
		queryString.append(" and z.auditoria.borrado = false");
			
		List<DDZona> listaAux = getHibernateTemplate().find(queryString.toString());
		lista.addAll(listaAux); 
		
		return lista;
	}

	@Override
	public List<DDZona> getListaZonasParaVista(Long nivel, String cod) {
		List<DDZona> lista = new ArrayList<DDZona>();
		if(cod != null){ //VIENE DE SUBCONSULTA
			StringBuffer queryString = new StringBuffer("Select z from DDZona z");
			queryString.append(" where ( 1=1 ");
			queryString.append("  and z.codigo like '"+cod+"_%'");
			queryString.append(" and z.auditoria.borrado = false )");
				
			List<DDZona> listaAux = getHibernateTemplate().find(queryString.toString());
			lista.addAll(listaAux);
		}
		else{
			Usuario usuario = (Usuario)executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			for(ZonaUsuarioPerfil zup:usuario.getZonaPerfil()){
				StringBuffer queryString = new StringBuffer("Select z from DDZona z");
				queryString.append(" where ( 1=1 ");
				queryString.append("  and z.codigo like '"+zup.getZona().getCodigo()+"%'");
				queryString.append(" and z.nivel.id = "+nivel+") ");
				queryString.append(" and z.auditoria.borrado = false");
					
				List<DDZona> listaAux = getHibernateTemplate().find(queryString.toString());
				lista.addAll(listaAux);
			}
		}
		
		return lista;
	}
}
