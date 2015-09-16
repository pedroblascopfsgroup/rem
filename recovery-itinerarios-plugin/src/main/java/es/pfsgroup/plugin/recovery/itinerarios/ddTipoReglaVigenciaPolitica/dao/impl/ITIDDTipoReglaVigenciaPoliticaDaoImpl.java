package es.pfsgroup.plugin.recovery.itinerarios.ddTipoReglaVigenciaPolitica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoReglaVigenciaPolitica.dao.ITIDDTipoReglaVigenciaPoliticaDao;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoReglaVigenciaPolitica.model.ITIDDTipoReglaVigenciaPolitica;

@Repository("ITIDDTipoReglaVigenciaPoliticaDao")
public class ITIDDTipoReglaVigenciaPoliticaDaoImpl extends AbstractEntityDao<ITIDDTipoReglaVigenciaPolitica, Long> 
 implements ITIDDTipoReglaVigenciaPoliticaDao{

	@Override
	public List<ITIDDTipoReglaVigenciaPolitica> getReglasConsenso() {
		HQLBuilder hb = new HQLBuilder("from ITIDDTipoReglaVigenciaPolitica ddrvp");
		hb.appendWhere("ddrvp.auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "ddrvp.categoriaConsenso", true);
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<ITIDDTipoReglaVigenciaPolitica> getReglasConsensoCE() {
		HQLBuilder hb = new HQLBuilder("from ITIDDTipoReglaVigenciaPolitica ddrvp");
		hb.appendWhere("ddrvp.auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "ddrvp.categoriaConsenso", true);
		HQLBuilder.addFiltroIgualQue(hb, "ddrvp.categoriaRevExp", false);
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<ITIDDTipoReglaVigenciaPolitica> getDDReglasExclusionCE() {
		HQLBuilder hb = new HQLBuilder("from ITIDDTipoReglaVigenciaPolitica ddrvp");
		hb.appendWhere("ddrvp.auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "ddrvp.categoriaConsenso", false);
		HQLBuilder.addFiltroIgualQue(hb, "ddrvp.categoriaRevExp", false);
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<ITIDDTipoReglaVigenciaPolitica> getDDReglasExclusionRE() {
		HQLBuilder hb = new HQLBuilder("from ITIDDTipoReglaVigenciaPolitica ddrvp");
		hb.appendWhere("ddrvp.auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "ddrvp.categoriaConsenso", false);
		HQLBuilder.addFiltroIgualQue(hb, "ddrvp.categoriaRevExp", true);
		return HibernateQueryUtils.list(this, hb);
	}

}
