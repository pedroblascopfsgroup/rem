package es.capgemini.pfs.embargoProcedimiento;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.dao.BienDao;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.embargoProcedimiento.dao.EmbargoProcedimientoDao;
import es.capgemini.pfs.embargoProcedimiento.dto.DtoEmbargoProcedimiento;
import es.capgemini.pfs.embargoProcedimiento.model.EmbargoProcedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;

/**
 * Creado el Thu Jan 08 09:32:16 CET 2009.
 *
 * @author: Lisandro Medrano
 */
@Service
public class EmbargoProcedimientoManager {

	@Autowired
	private EmbargoProcedimientoDao embargoProcedimientoDao;

	@Autowired
	private BienDao bienDao;

	@Autowired
	private ProcedimientoDao procedimientoDao;

	/**
	 * obtener embargos.
	 * @return embargos
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_EMBARGO_PRC_MGR_GET_LIST)
	public List<EmbargoProcedimiento> getList() {
		return embargoProcedimientoDao.getList();
	}

	/**
	 * get.
	 * @param id id
	 * @return embargo
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_EMBARGO_PRC_MGR_GET)
	public EmbargoProcedimiento get(Long id) {
		return embargoProcedimientoDao.get(id);
	}

	/**
	 * get by id bien.
	 * @param id id
	 * @return embargo
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_EMBARGO_PRC_MGR_GET_BY_ID_BIEN)
	public EmbargoProcedimiento getByIdBien(Long id) {
		return bienDao.get(id).getEmbargoProcedimiento();
	}

	/**
	 * PONER JAVADOC FO.
	 * @param idBien idBien
	 * @return embargo
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_EMBARGO_PRC_MGR_GET_INSTANCE)
	public EmbargoProcedimiento getInstance(Long idBien) {
		Bien bien = bienDao.get(idBien);
		EmbargoProcedimiento embargoProcedimiento = new EmbargoProcedimiento();
		embargoProcedimiento.setBien(bien);
		embargoProcedimiento.setAuditoria(Auditoria.getNewInstance());
		return embargoProcedimiento;
	}

	/**
	 * PONER JAVADOC FO.
	 * @param dtoEmbargoProcedimiento dto
	 * @param idBien idbien
	 * @param idProcedimiento idprocedimiento
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_EMBARGO_PRC_MGR_CREATE_OR_UPDATE)
	@Transactional(readOnly = false)
	public void createOrUpdate(DtoEmbargoProcedimiento dtoEmbargoProcedimiento, Long idBien, Long idProcedimiento) {
		EmbargoProcedimiento emb = dtoEmbargoProcedimiento.getEmbargoProcedimiento();
		if (emb.getId() == null) {
			Bien bien = bienDao.get(idBien);
			Procedimiento prc = procedimientoDao.get(idProcedimiento);
			emb.setBien(bien);
			emb.setProcedimiento(prc);
			bien.setEmbargoProcedimiento(emb);
		}
		embargoProcedimientoDao.saveOrUpdate(emb);
	}
}
