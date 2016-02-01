package es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dao.PTEPlazoTareaExternaPlazaDao;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto.PTEDtoBusquedaPlazo;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto.PTEDtoPlazoTarea;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.model.PTEPlazoTareaExternaPlaza;

@Repository("PTEPlazoTareaExternaPlazaDao")
public class PTEPlazoTareaExternaPlazaDaoImpl extends AbstractEntityDao<PTEPlazoTareaExternaPlaza, Long>
 implements PTEPlazoTareaExternaPlazaDao{

	@Override
	public List<PTEPlazoTareaExternaPlaza> findPlazos(PTEDtoBusquedaPlazo dto) {
		HQLBuilder hb = new HQLBuilder("from PTEPlazoTareaExternaPlaza ptep");
		hb.appendWhere("ptep.auditoria.borrado=false");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ptep.tareaProcedimiento.tipoProcedimiento.id", dto.getFiltroProcedimiento());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ptep.tareaProcedimiento.id", dto.getIdTareaProcedimiento());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ptep.tipoJuzgado.id", dto.getIdTipoJuzgado());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ptep.tipoPlaza.codigo", dto.getIdTipoPlaza());
		
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<PTEPlazoTareaExternaPlaza> compruebaExistePlazo(PTEDtoPlazoTarea dto) {
		HQLBuilder hb = new HQLBuilder("from PTEPlazoTareaExternaPlaza ptep");
		hb.appendWhere("ptep.auditoria.borrado=false");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ptep.tareaProcedimiento.tipoProcedimiento.id", dto.getIdProcedimiento());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ptep.tareaProcedimiento.id", dto.getIdTareaProcedimiento());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ptep.tipoJuzgado.id", dto.getIdTipoJuzgado());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ptep.tipoPlaza.codigo", dto.getIdTipoPlaza());
		
		return HibernateQueryUtils.list(this, hb);
	}

}
