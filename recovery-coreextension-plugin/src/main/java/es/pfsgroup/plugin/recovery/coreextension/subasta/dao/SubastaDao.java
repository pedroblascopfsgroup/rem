package es.pfsgroup.plugin.recovery.coreextension.subasta.dao;

import java.util.HashMap;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.AcuerdoCierreDeudaDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarLotesSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchAcuerdoCierreDeuda;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchCDDResultadoNuse;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;

public interface SubastaDao extends AbstractDao<Subasta, Long>{
	
	public static final String CODIGO_TIPO_SUBASTA_BANKIA = "P401";
	public static final String CODIGO_TIPO_SUBASTA_SAREB = "P409";
	
	Page buscarSubastasPaginados(NMBDtoBuscarSubastas dto, Usuario usuLogado);
	List<HashMap<String, Object>> buscarSubastasExcel(NMBDtoBuscarSubastas dto, Usuario usuLogado, Boolean isCount);
	List<Subasta> getSubastasporIdBien (Long id);
	Page buscarLotesSubastasPaginados(NMBDtoBuscarLotesSubastas dto);
	Page buscarLotesSubastasPaginados(NMBDtoBuscarLotesSubastas dto,Usuario usuLogado);
	List<LoteSubasta> buscarLoteSubastasExcel(NMBDtoBuscarLotesSubastas dto);
	List<LoteSubasta> buscarLoteSubastasExcel(NMBDtoBuscarLotesSubastas dto,Usuario usuLogado);
	Integer buscarSubastasExcelCount(NMBDtoBuscarSubastas dto, Usuario usuLogado);
	List<BatchAcuerdoCierreDeuda> findBatchAcuerdoCierreDeuda(Long idAsunto, Long idProcedimiento, Long idBien);	
	void guardarBatchAcuerdoCierreDeuda(BatchAcuerdoCierreDeuda acuerdoCierreDeuda);
	void eliminarBatchAcuerdoCierreDeuda(BatchAcuerdoCierreDeuda acuerdoCierreDeuda);
        void eliminarBatchCDDResultadoNuse(BatchCDDResultadoNuse acuerdoCierreDeudaNuse);
	BatchAcuerdoCierreDeuda findBatchAcuerdoCierreDeuda(AcuerdoCierreDeudaDto acuerdo);
	
	Contrato getContratoByNroContrato(String nroContrato);

}
