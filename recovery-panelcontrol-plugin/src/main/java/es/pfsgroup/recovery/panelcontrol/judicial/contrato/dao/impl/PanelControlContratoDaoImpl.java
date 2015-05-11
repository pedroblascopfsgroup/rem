package es.pfsgroup.recovery.panelcontrol.judicial.contrato.dao.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.recovery.panelcontrol.judicial.contrato.dao.PanelControlContratoDao;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoDetallePanelControl;

@Repository
public class PanelControlContratoDaoImpl extends AbstractEntityDao<Contrato, Long> implements PanelControlContratoDao {

	@Resource
	private PaginationManager paginationManager;

	@Override
	public Page getListaContratos(DtoDetallePanelControl dto) {
		StringBuffer hql = generaHQLlistaContratos(dto); 
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql.toString(), dto);
	}

	@Override
	public Page getListaContratosIregulares(DtoDetallePanelControl dto,List<DDZona> listaZonas) {
		StringBuffer hql = generaHQLlistaContratosIrregulares(dto,listaZonas); 
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql.toString(), dto);
	}

	
	
	private StringBuffer generaHQLlistaContratos(DtoDetallePanelControl dto){
		StringBuffer hql = new StringBuffer();
		
		Long nivel = dto.getNivel();
		Long idNivel = dto.getIdNivel();
		
		hql.append("select c from Contrato c ");
		hql.append( "where ( c.auditoria.borrado = false and c.oficina.zona.nivel.id = " +nivel);
		
		if(nivel.equals(4L))
			hql.append(" or c.oficina.zona.nivel.id = 5 or c.oficina.zona.nivel.id = 2");
		if(nivel.equals(5L))
			hql.append(" or c.oficina.zona.nivel.id = 2");
		if(nivel.equals(3L))
			hql.append(" or c.oficina.zona.nivel.id = 4 or c.oficina.zona.nivel.id = 5 or c.oficina.zona.nivel.id = 2");
		
		hql.append(")");
		
		if(idNivel!=null){
			hql.append(" and (c.oficina.zona.id = "+idNivel);
			hql.append(" or c.oficina.zona.zonaPadre.id = "+idNivel);
			hql.append(")");
		}
		
		return hql;
	}
	
	
	private StringBuffer generaHQLlistaContratosIrregulares(DtoDetallePanelControl dto,List<DDZona> listaZonas){
		
		StringBuffer hql = new StringBuffer();
		
		
		hql.append("select distinct c from Contrato c, Movimiento mov ");
		hql.append(" where c.auditoria.borrado = false and mov.contrato = c");
		hql.append(" and mov.fechaExtraccion = c.fechaExtraccion"); 
		hql.append(" and mov.posVivaVencida <> 0 ");
		
		//FILTRAMOS POR ZONAS
        
		hql.append(" and ( ");
        	for(DDZona codZona:listaZonas){
        		hql.append(" (c.zona.codigo like '"+codZona.getCodigo()+"%') or");
        	}
        	hql.deleteCharAt(hql.length() - 1);
        	hql.deleteCharAt(hql.length() - 1);	
	        
        	hql.append(" ) ");
		
		
		return hql;
	}
}
