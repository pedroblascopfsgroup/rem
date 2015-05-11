package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes;

import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.dao.NMBBienDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBEmbargoProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBPersonasBien;

/**
 * M�nager que implementa las operaciones de negocio para la edici�n del Bien.
 * @author bruno
 *
 */
@Component
public class EditBienManager implements EditBienApi{
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private NMBBienDao bienDao;

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_BORRAR_PESONA_BIEN)
	public void borrarRelacionPersonaBien(Long id) {
		NMBPersonasBien nmbPersonasBien;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", id);
		nmbPersonasBien = genericDao.get(NMBPersonasBien.class, f1);
		if (nmbPersonasBien!=null){
			genericDao.deleteById(NMBPersonasBien.class, id);
			//nmbPersonasBien.setBorrado(true);
		}
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_BORRAR_BIEN_CONTRATO)
	public void borrarRelacionBienContrato(Long id) {
		NMBContratoBien nmbContratoBien;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", id);
		nmbContratoBien = genericDao.get(NMBContratoBien.class, f1);
		if (nmbContratoBien!=null){
			genericDao.deleteById(NMBContratoBien.class, id);
			//nmbPersonasBien.setBorrado(true);
		}
	}	
	
	@Override
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_GET_EMBARGO_PROCEDIMIENTO)
	public NMBEmbargoProcedimiento getEmbargoProcedimiento(Long idEmbargo) {
		NMBEmbargoProcedimiento nmbEmbargoProcedimiento;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idEmbargo);
		nmbEmbargoProcedimiento = genericDao.get(NMBEmbargoProcedimiento.class, f1);
		return nmbEmbargoProcedimiento;
	}

	@Override
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_GET_BIEN)
	public NMBBien getBien(long idBien) {
		NMBBien bien;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idBien);
		bien = genericDao.get(NMBBien.class, f1);
		return bien;
	}

	@Override
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_GET_PROCEDIMIENTO)
	public Procedimiento getProcedimiento(long idProcedimiento) {
		Procedimiento procedimiento;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento);
		procedimiento = genericDao.get(Procedimiento.class, f1);
		return procedimiento;
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_GUARDA_EMBARGO_PROCEDIMIENTO)
	public void guardaEmbargoProcedimiento(
			NMBEmbargoProcedimiento nmbEmbargoProcedimiento) {
		genericDao.save(NMBEmbargoProcedimiento.class, nmbEmbargoProcedimiento);
		
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_GUARDAR_ADJUDICACION)
	public void guardarAdjudicacion(NMBAdjudicacionBien adjudicacion) {
		
		bienDao.saveOrUpdateAdjudicados(adjudicacion);
		
	}
	
	
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_GUARDAR_ADICIONAL)
	public void guardarRevisionCargas(NMBAdicionalBien adicional) {
		
		bienDao.saveOrUpdateAdicional(adicional);
		
	}
	
	@Override
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_GET_CARGA)
	public NMBBienCargas getCarga(long idCarga) {
		NMBBienCargas carga;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "idCarga", idCarga);
		carga = genericDao.get(NMBBienCargas.class, f1);
		return carga;
	}	
	
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_GUARDAR_CARGA)
	public void guardarCarga(NMBBienCargas carga) {
		
		bienDao.saveOrUpdateCarga(carga);
		
	}
	
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(PLUGIN_BIENES_EDIT_BIEN_API_BORRAR_CARGA)
	public void borrarCarga(Long id) {
		NMBBienCargas carga;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "idCarga", id);
		carga = genericDao.get(NMBBienCargas.class, f1);
		if (carga!=null){
			genericDao.deleteById(NMBBienCargas.class, id);
			//nmbPersonasBien.setBorrado(true);
		}
	}

}
