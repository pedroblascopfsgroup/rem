package es.pfsgroup.plugin.recovery.itinerarios.itinerario.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.itinerarios.itinerario.dao.ITIItinerarioDao;
import es.pfsgroup.plugin.recovery.itinerarios.itinerario.dto.ITIDtoBusquedaItinerarios;

@Repository("ITIItinerarioDao")
public class ITIItinerarioDaoImpl extends AbstractEntityDao<Itinerario, Long> implements ITIItinerarioDao{

	@Override
	public Page buscaItinerarios(ITIDtoBusquedaItinerarios dto) {
		
		HQLBuilder b = new HQLBuilder("from Itinerario iti");
		
		b.appendWhere("iti.auditoria.borrado = 0");
		
		HQLBuilder.addFiltroLikeSiNotNull(b, "iti.nombre", 
				dto.getNombre(), true);
		HQLBuilder.addFiltroLikeSiNotNull(b, "iti.dDtipoItinerario.id",
				dto.getdDtipoItinerario());
		HQLBuilder.addFiltroLikeSiNotNull(b, "iti.ambitoExpediente.id",
				dto.getAmbitoExpediente());
		
		return HibernateQueryUtils.page(this, b, dto);
		
	}

	@Override
	public Itinerario createNewItinerario() {
		return new Itinerario();
	}

}
