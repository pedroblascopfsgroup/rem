package es.capgemini.pfs.sync.message;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.sync.SyncConnector;
import es.pfsgroup.commons.sync.SyncEntity;
import es.pfsgroup.commons.sync.SyncMsgFactoryBase;
import es.pfsgroup.commons.sync.SyncTranslator;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;

public class SyncMsgBPMTaskFactory extends SyncMsgFactoryBase<SyncMsgBPMTaskDto> {

	public final static String MSG_FACTORY_ID="BPM_TASK_MSG";

    @Autowired
    GenericABMDao genericDao;

    public SyncMsgBPMTaskFactory(List<SyncConnector> connectorList, SyncTranslator translator) {
		super(connectorList, translator);
	}

	@Override
	public SyncMsgBPMTaskDto createMessage() {
		return new SyncMsgBPMTaskDto();
	}

	@Override
	public String getID() {
		return MSG_FACTORY_ID;
	}

	@Override
	public Class<SyncMsgBPMTaskDto> getGenericType() {
		return SyncMsgBPMTaskDto.class;
	}

	public void syncProcedure(TareaNotificacion tarNotf, SyncEntity entidadSincronizada) {
		if (Checks.esNulo(entidadSincronizada.getReferenciaSincronizacion())) {
			String uuid = UUID.randomUUID().toString();
			entidadSincronizada.setReferenciaSincronizacion(uuid);
			genericDao.save(TareaNotificacion.class, entidadSincronizada);
		}
		// Sí, lo recupera usa
	
		// No, crea uno nuevo y le asigna ID de syncronización.
		
	}
	
	public void loadValores(TareaNo) {
		
	}
	
	
	@Override
	protected void doProcessMessage(SyncMsgBPMTaskDto message) {
		super.doProcessMessage(message);

		// Recupera el procedimiento
		Filter filtroTipoProc = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.codigo", message.getTipoProcedimiento());
		MEJProcedimiento procedimiento = genericDao.get(MEJProcedimiento.class, filtroTipoProc);
		
		
		// Con el procedimiento... existe Id tarea Notificación de sync?
		EXTTareaNotificacion tareaNotificacion = new EXTTareaNotificacion();

			// Sí, la recupera
		
			// No, crea una nueva, con el ID de syncronización
			
		
		
		
	}
}
