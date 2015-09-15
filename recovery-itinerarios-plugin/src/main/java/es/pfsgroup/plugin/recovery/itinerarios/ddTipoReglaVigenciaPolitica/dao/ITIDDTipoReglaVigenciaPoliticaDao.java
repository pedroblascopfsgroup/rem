package es.pfsgroup.plugin.recovery.itinerarios.ddTipoReglaVigenciaPolitica.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoReglaVigenciaPolitica.model.ITIDDTipoReglaVigenciaPolitica;

public interface ITIDDTipoReglaVigenciaPoliticaDao extends AbstractDao<ITIDDTipoReglaVigenciaPolitica, Long>{

	public List<ITIDDTipoReglaVigenciaPolitica> getReglasConsenso();

	public List<ITIDDTipoReglaVigenciaPolitica> getReglasConsensoCE();

	public List<ITIDDTipoReglaVigenciaPolitica> getDDReglasExclusionCE();

	public List<ITIDDTipoReglaVigenciaPolitica> getDDReglasExclusionRE();

}
