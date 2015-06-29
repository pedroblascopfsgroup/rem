package es.capgemini.pfs.integration.bpm.consumer;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.acuerdo.EXTAcuerdoManager;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.core.api.acuerdo.AcuerdoApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.integration.AsuntoPayload;
import es.capgemini.pfs.integration.ConsumerAction;
import es.capgemini.pfs.integration.Rule;
import es.capgemini.pfs.integration.bpm.DiccionarioDeCodigos;
import es.capgemini.pfs.integration.bpm.IntegracionBpmService;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoManager;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

/**
 * 
 * Inicia el procedimiento si no existe sincronizado según el padre (que debe existir).
 * 
 * Tareas asociadas según el tipo de mensaje:
 * 
 * 	- Da de alta una tarea en la bd (PRC_PROCEDIMIENTO) e inicia el procedimiento que se pasa.
 *  - Cancela una tarea
 *  - Finaliza una tarea.
 * 
 * @author gonzalo
 *
 */
public class AcuerdoConsumer extends ConsumerAction<AsuntoPayload> {

	protected final Log logger = LogFactory.getLog(getClass());
	
	private final DiccionarioDeCodigos diccionarioCodigos;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private EXTAsuntoManager extAsuntoManager;

	@Autowired
	private AcuerdoDao acuerdoDao;
	
	@Autowired
	private MEJAcuerdoManager mejAcuerdoManager;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	public AcuerdoConsumer(Rule<AsuntoPayload> rule, DiccionarioDeCodigos diccionarioCodigos) {
		super(rule);
		this.diccionarioCodigos = diccionarioCodigos; 
	}
	
	public AcuerdoConsumer(List<Rule<AsuntoPayload>> rules, DiccionarioDeCodigos diccionarioCodigos) {
		super(rules);
		this.diccionarioCodigos = diccionarioCodigos; 
	}

	@Override
	protected void doAction(AsuntoPayload payload) {
		if (payload.getTipo().equals(IntegracionBpmService.TIPO_PROPUESTA_ACUERDO)) {
			proponerAcuerdo(payload);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_RECHAZAR_ACUERDO)) {
			rechazarAcuerdo(payload);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_CIERRE_ACUERDO)) {
			cierreAcuerdo(payload);
		}

	}

	private String getAcuerdoGuid(AsuntoPayload payload) {
		return String.format("%d-EXT", payload.getIdOrigen().get("acu"));
		
	}
	private void cierreAcuerdo(AsuntoPayload payload) {
		// TODO Auto-generated method stub
		return;
	}

	private void rechazarAcuerdo(AsuntoPayload payload) {
		// TODO Auto-generated method stub
		return;
		
	}

	private void proponerAcuerdo(AsuntoPayload payload) {
		String acuerdoGuid = getAcuerdoGuid(payload);
		
		// Recupera valores:
		EXTAcuerdo acuerdo = mejAcuerdoManager.getAcuerdoByGuid(acuerdoGuid);
		DtoAcuerdo dtoAcuerdo = new DtoAcuerdo();
		if (acuerdo==null) {
			EXTAsunto asunto = extAsuntoManager.getAsuntoByGuid(payload.getGuidAsunto());
			dtoAcuerdo.setIdAsunto(asunto.getId());
		} else {
			dtoAcuerdo.setIdAcuerdo(acuerdo.getId());
		}
		

		//
		dtoAcuerdo.setTipoAcuerdo(payload.getCodigo().get("tipoAcuerdo"));
		dtoAcuerdo.setSolicitante(payload.getCodigo().get("solicitante"));
		dtoAcuerdo.setEstado(payload.getCodigo().get("estadoAcuerdo"));
		dtoAcuerdo.setTipoPago(payload.getCodigo().get("tipoPagoAcuerdo"));
		dtoAcuerdo.setPeriodicidad(payload.getCodigo().get("periodicidadAcuerdo"));

		dtoAcuerdo.setObservaciones(payload.getExtraInfo().get("periodicidadAcuerdo"));
		
		SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
		
		Date fecha = payload.getFecha().get("fechaCierre");
		if (fecha!=null) {
			dtoAcuerdo.setFechaCierre(sdf1.format(fecha));
		}
		fecha = payload.getFecha().get("fechaLimite");
		if (fecha!=null) {
			dtoAcuerdo.setFechaLimite(sdf1.format(fecha));
		}
		
		Double valorDbl = payload.getValDouble().get("importePago");
		if (valorDbl!=null) {
			dtoAcuerdo.setImportePago(valorDbl.toString());
		}
		dtoAcuerdo.setPeriodo(payload.getValLong().get("periodo"));

/*		
		newPayload.addFecha("fechaPropuesta", extAcuerdo.getFechaPropuesta());
		newPayload.addFecha("fechaEstado", extAcuerdo.getFechaEstado());
		newPayload.addFecha("fechaCierre", extAcuerdo.getFechaCierre());
		newPayload.addFecha("fechaResolucionPropuesta", extAcuerdo.getFechaResolucionPropuesta());
		newPayload.addFecha("fechaLimite", extAcuerdo.getFechaLimite());

		newPayload.addNumber("importePago", extAcuerdo.getImportePago());
		newPayload.addNumber("periodo", extAcuerdo.getPeriodo());
		newPayload.addNumber("porcentajeQuita", extAcuerdo.getPorcentajeQuita());
		*/
		
		// Guarda el acuerdo.
		Long idAcuerdo = mejAcuerdoManager.guardarAcuerdo(dtoAcuerdo);
		if (acuerdo==null) {
			acuerdo = mejAcuerdoManager.getAcuerdoById(idAcuerdo);
			acuerdo.setGuid(acuerdoGuid);
			acuerdoDao.saveOrUpdate(acuerdo);
		}
		
		// Crea tarea notif.
        Long idEntidad = acuerdo.getAsunto().getId();
        String tipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO;
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_ACUERDO_PROPUESTO;
        Long plazo = Long.parseLong(PlazoTareasDefault.CODIGO_ACUERDO_PROPUESTO);
        Boolean espera = true;
        String descripcion = null;
        DtoGenerarTarea dto = new DtoGenerarTarea(idEntidad, tipoEntidad, codigoSubtipoTarea, espera, false, plazo, descripcion);
        Long idTarea = proxyFactory.proxy(TareaNotificacionApi.class).crearTarea(dto);		
	}
	
}
