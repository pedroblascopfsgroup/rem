package es.pfsgroup.recovery.recobroCommon.expediente.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;

public interface ExpedienteRecobroDao extends AbstractDao<ExpedienteRecobro, Long> {

	List<Contrato> obtenerContratosPersonaParaGeneracionExpManual(Long idPersona);

	List<RecobroModeloFacturacion> getModeloFacturacion();

	void deletePersonaExpediente(Long idExpediente, Long idPersona);

	Page buscarContratosRecobroPaginados(BusquedaContratosDto dto, Usuario usuLogado);

}
