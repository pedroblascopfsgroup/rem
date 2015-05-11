package es.pfsgroup.plugin.recovery.mejoras.gestorDespacho.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.mejoras.gestorDespacho.dao.MEJGestorDespachoDao;
import es.pfsgroup.plugin.recovery.mejoras.gestorDespacho.dto.MEJDtoComboGestores;

@Repository("MEJGestorDespachoDao")
public class MEJGestorDespachoDaoImpl extends AbstractEntityDao<GestorDespacho, Long>
	implements MEJGestorDespachoDao{

	@Override
	public Page findByDescyDesp(MEJDtoComboGestores dto) {
		HQLBuilder hb = new HQLBuilder("from GestorDespacho d");
		hb.appendWhere("d.auditoria.borrado=false");
		hb.appendWhere("d.despachoExterno.auditoria.borrado=false");
		hb.appendWhere("d.usuario.auditoria.borrado=false");
		hb.appendWhere("d.supervisor=false");
	
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "d.despachoExterno.id", dto.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "d.despachoExterno.tipoDespacho.codigo", dto.getTipoDespacho());
		//HQLBuilder.addFiltroLikeSiNotNull(hb, "d.usuario.username", dto.getQuery(), true);
		
		
		if(!Checks.esNulo( dto.getQuery())){
			hb.appendWhere("upper(concat (d.usuario.nombre, d.usuario.apellido1, d.usuario.apellido2, d.usuario.username)) like '%" +dto.getQuery().trim().toUpperCase()+ "%'");
		}
		hb.orderBy("d.usuario.nombre", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);
		
	}
	
	public List<GestorDespacho>  findByDescyDespComboPaginado(MEJDtoComboGestores dto) {
		HQLBuilder hb = new HQLBuilder("from GestorDespacho d");
		hb.appendWhere("d.auditoria.borrado=false");
		hb.appendWhere("d.despachoExterno.auditoria.borrado=false");
		hb.appendWhere("d.usuario.auditoria.borrado=false");
		hb.appendWhere("d.supervisor=false");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "d.despachoExterno.id", dto.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "d.despachoExterno.tipoDespacho.codigo",dto.getTipoDespacho());
		
		if(!Checks.esNulo( dto.getQuery())){
			hb.appendWhere("upper(concat (d.usuario.nombre, d.usuario.apellido1, d.usuario.apellido2, d.usuario.username)) like '%" +dto.getQuery().trim().toUpperCase()+ "%'");
		}
		
		hb.orderBy("d.usuario.nombre", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.list(this, hb);
		
	}
	

}
