package es.pfsgroup.recovery.panelcontrol.judicial.cliente.dao.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.recovery.panelcontrol.judicial.cliente.dao.PanelControlClienteDao;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoDetallePanelControl;

@Repository
public class PanelControlClienteDaoImpl extends AbstractEntityDao<Cliente, Long> implements PanelControlClienteDao {

	@Resource
	private PaginationManager paginationManager;

	@Override
	public Page getListaClientes(DtoDetallePanelControl dto,List<DDZona> listaZonas) {
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				generaHQLlistaClientes(dto,listaZonas), dto);
	}
	
	private String generaHQLlistaClientes(DtoDetallePanelControl dto,List<DDZona> listaZonas){
		StringBuffer hql = new StringBuffer();
		
		
		
		hql.append("select cli from Cliente cli ");
		hql.append( "where ");
		
		//FILTRAMOS POR ZONAS
        
		hql.append(" ( ");
        	for(DDZona codZona:listaZonas){
        		hql.append(" (cli.oficina.zona.codigo like '"+codZona.getCodigo()+"%') or");
        	}
        	hql.deleteCharAt(hql.length() - 1);
        	hql.deleteCharAt(hql.length() - 1);	
	        
        	hql.append(" ) ");
		
		return hql.toString();
	}

}
