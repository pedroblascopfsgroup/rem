package es.pfsgroup.plugin.recovery.mejoras.acuerdos.manager;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.acuerdo.EXTAcuerdoManager;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

@Service
public class PropuestaManager implements PropuestaApi {
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private GenericABMDao genericDao;

	@BusinessOperation(BO_PROPUESTA_GET_LISTADO_PROPUESTAS)
	public List<EXTAcuerdo> listadoPropuestasByExpedienteId(Long idExpediente) {
        
        Order order = new Order(OrderType.ASC, "id");
        return  genericDao.getListOrdered(EXTAcuerdo.class,order, genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente));
	}

	
}
