package es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.ReglasVigenciaPolitica;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dao.ITIReglasVigenciaPoliticaDao;
import es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dao.model.ITIReglasVigenciaPolitica;

@Repository("ITIReglasVigenciaPoliticaDao")
public class ITIReglasVigenciaPoliticaDaoImpl extends AbstractEntityDao<ITIReglasVigenciaPolitica, Long>
	implements ITIReglasVigenciaPoliticaDao{

	@Override
	public List<ReglasVigenciaPolitica> findByEstado(
			List<Estado> estadosItinerario) {
		//TODO
		return null;
		
	}

	@Override
	public ITIReglasVigenciaPolitica getReglasConsensoEstado(Long id) {
		HQLBuilder hb = new HQLBuilder("from ITIReglasVigenciaPolitica rvp");
		hb.appendWhere("rvp.auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "rvp.estadoItinerario.id", id);
		HQLBuilder.addFiltroIgualQue(hb, "rvp.tipoReglaVigenciaPolitica.categoriaConsenso", true);
		return HibernateQueryUtils.uniqueResult(this, hb);	
	}

	@Override
	public ITIReglasVigenciaPolitica getReglasExclusionEstado(Long id) {
		HQLBuilder hb = new HQLBuilder("from ITIReglasVigenciaPolitica rvp");
		hb.appendWhere("rvp.auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "rvp.estadoItinerario.id", id);
		HQLBuilder.addFiltroIgualQue(hb, "rvp.tipoReglaVigenciaPolitica.categoriaConsenso", false);
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	@Override
	public ITIReglasVigenciaPolitica createNewReglaVigenciaPolitica() {
		return new ITIReglasVigenciaPolitica();
	}

}
