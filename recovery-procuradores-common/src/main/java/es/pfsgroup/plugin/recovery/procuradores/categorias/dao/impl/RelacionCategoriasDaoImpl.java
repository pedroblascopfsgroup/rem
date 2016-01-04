package es.pfsgroup.plugin.recovery.procuradores.categorias.dao.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dao.RelacionCategoriasDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;

/**
 * Implementación del Dao de {@link RelacionCategorias}
 * @author anahuac
 *
 */
@Repository("RelacionCategoriasDao")
public class RelacionCategoriasDaoImpl extends AbstractEntityDao<RelacionCategorias, Long> implements RelacionCategoriasDao {
	
	
	@Autowired
	private GenericABMDao genericDao;
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.dao.RelacionCategoriasDao#getListaRelacionCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto)
	 */
	@Override
	public List<RelacionCategorias> getListaRelacionCategorias(RelacionCategoriasDto dto) {

		HQLBuilder hb = new HQLBuilder(" from RelacionCategorias rel ");	
		if(dto.getTipoRelacion() != null && !dto.getTipoRelacion().equalsIgnoreCase("")){	
			hb.appendWhere(resuelveTipoRelacion(dto));	
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "rel.categoria.id", dto.getIdcategoria());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "rel.categoria.categorizacion.id", dto.getIdcategorizacion());
		if(dto.getTipoRelacion() != null && RelacionCategoriasDto.TIPO_RELACION_TAREASPROC.equals(dto.getTipoRelacion())){
			HQLBuilder.addFiltroIgualQue(hb, "rel.tareaProcedimiento.auditoria.borrado", false);
			hb.orderBy("rel.tareaProcedimiento.descripcion", HQLBuilder.ORDER_ASC);
		}
		if(dto.getTipoRelacion() != null && RelacionCategoriasDto.TIPO_RELACION_TIPORESOL.equals(dto.getTipoRelacion())){	
			HQLBuilder.addFiltroIgualQue(hb, "rel.tipoResolucion.auditoria.borrado", false);
			hb.orderBy("rel.tipoResolucion.descripcion", HQLBuilder.ORDER_ASC);		
		}
		return HibernateQueryUtils.list(this, hb);
	}

	
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.dao.RelacionCategoriasDao#deleteRelacionCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias)
	 */
	@Override
	@Transactional(readOnly = true)
	public void deleteRelacionCategorias(RelacionCategorias relCategoria) {

		String hqlPrevio = "from RelacionCategorias rel where rel.id = ?";
        getHibernateTemplate().deleteAll(getHibernateTemplate().find(hqlPrevio, new Object[] {relCategoria.getId()}));

	}
	
	
	
	
	
	private String resuelveTipoRelacion(RelacionCategoriasDto dto) {
		String where = "";	
		if(dto.getTipoRelacion() != null && !dto.getTipoRelacion().equalsIgnoreCase("")){				
			if (RelacionCategoriasDto.TIPO_RELACION_TAREASPROC.equals(dto.getTipoRelacion())) {			
				if(dto.getIdtramite() != null){
					where += " rel.tareaProcedimiento.tipoProcedimiento = "+dto.getIdtramite().toString();					
				}
				if(dto.getIdtap()!=  null){
					where += " rel.tareaProcedimiento.id = "+dto.getIdtap().toString();					
				}
			}
	
			if (RelacionCategoriasDto.TIPO_RELACION_TIPORESOL.equals(dto.getTipoRelacion())) {
				if(dto.getIdtramite() != null){
					where += " rel.tipoResolucion.tipoJuicio.tipoProcedimiento = "+dto.getIdtramite().toString();					
				}
				if(dto.getIdtiporesolucion() != null){
					where = " rel.tipoResolucion.id = "+dto.getIdtiporesolucion().toString();					
				}
			}
		}
		return where;
	}

}
