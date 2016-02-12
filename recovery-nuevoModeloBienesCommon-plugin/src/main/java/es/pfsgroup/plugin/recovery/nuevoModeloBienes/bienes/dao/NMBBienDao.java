package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.NMBDtoBuscarBienes;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.NMBDtoBuscarClientes;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;

public interface NMBBienDao extends AbstractDao<NMBBien, Long>{
	
	/* Nombre que le damos al NMBbien buscado en la HQL */
	public static final String NAME_OF_ENTITY_NMB = "nmb";
		
	Page buscarBienesPaginados(NMBDtoBuscarBienes dto, Usuario usuLogado);

	Page buscarClientesPaginados(NMBDtoBuscarClientes dto);
	
	Page buscarContratosPaginados(BusquedaContratosDto dto);	
	
	void saveOrUpdateAdjudicados(NMBAdjudicacionBien adjudicacion);

	void saveOrUpdateAdicional(NMBAdicionalBien adicional);
	
	void saveOrUpdateCarga(NMBBienCargas carga);	
	
	List<NMBBien> getBienesPorCodigoInterno(Long codigo);

	List<NMBBien> getBienesPorId(Long id);

	List<NMBBien> getBienesPorNumFincaActivo(String numFinca, String numActivo);	
	
	List<ProcedimientoBien> getBienesPorProcedimientos(List<Long> idsProcedimiento);	
	
	List<Bien> getSolvenciasDeUnProcedimiento(Long idProcedimiento);
	
	Page buscarBienesExport(NMBDtoBuscarBienes dto, Usuario usuLogado);
	
}
