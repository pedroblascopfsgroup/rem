package es.pfsgroup.recovery.haya.bienes.manager;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBPersonasBien;
import es.pfsgroup.recovery.haya.bienes.api.BienHayaApi;

@Component
public class BienHayaManager implements BienHayaApi {

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired(required=false)
	private SolicitarTasacionWSApi tasacionWSApi;
	
	@Autowired
	private GenericABMDao genericDao;	
	
	@Override
	@BusinessOperation(SOLICITAR_TASACION)
	public void solicitarTasacion(Long idBien, Long cuenta, String personaContacto,
			Long telefono, String observaciones) {
	
		if(tasacionWSApi != null) {
			
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", idBien);
			NMBBien bien = genericDao.get(NMBBien.class, filter);
			
			Filter filterAuditoria = genericDao.createFilter(FilterType.EQUALS, "borrado", false);
			filter = genericDao.createFilter(FilterType.EQUALS, "bien.id", idBien);
			List<NMBPersonasBien> personasBien = genericDao.getList(NMBPersonasBien.class, filter, filterAuditoria);
			
			List<NMBContratoBien> contratosBien = genericDao.getList(NMBContratoBien.class, filter, filterAuditoria);
			
			tasacionWSApi.altaSolicitud(bien, personasBien, contratosBien, cuenta, personaContacto, telefono, observaciones);
		}
	}
}
