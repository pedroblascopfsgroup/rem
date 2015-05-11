package es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dao.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaDeAcuerdosDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;

public interface RecobroPoliticaDeAcuerdosDao extends AbstractDao<RecobroPoliticaDeAcuerdos, Long>{

	Page buscaPoliticas(RecobroPoliticaDeAcuerdosDto dto);

	/**
	 * Metodo que devuelve los modelos en estado Disponible o bloqueado
	 * @author Sergio
	 */
	List<RecobroPoliticaDeAcuerdos> getModelosDSPoBLQ();

}
