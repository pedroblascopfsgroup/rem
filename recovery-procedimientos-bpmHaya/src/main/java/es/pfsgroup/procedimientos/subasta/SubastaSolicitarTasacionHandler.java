package es.pfsgroup.procedimientos.subasta;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBValoracionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;


public class SubastaSolicitarTasacionHandler extends PROBaseActionHandler {

	private static final long serialVersionUID = 1L;

	private static final long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000; //Milisegundos al día
	private static final int DIAS_LIMITE_TASACION_VALIDA = 540; //18 meses
	private static final String TRANSICION_FIN = "Fin";
	private static final String TRANSICION_ACTUALIZAR_TASACION = "actualizarTasacion";
	private static final String TIMER_NAME = "Espera Solicitar Tasacion";
	private static final String TIMER_DURATION_MASK = "%d days";
	
	@Autowired
	protected ApiProxyFactory proxyFactory;
	
    /**
     * Solicita un número de activo para cada bien.
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
    	
    	// Recupera la subasta de este procedimiento
		Procedimiento prc = getProcedimiento(executionContext);
		Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());

		// Si el procedimiento está acabado sale:
		if (prc.getEstadoProcedimiento().getCodigo() == DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO ||
				prc.getEstadoProcedimiento().getCodigo() == DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO) {
			executionContext.getToken().signal(TRANSICION_FIN);
			return;
		}
		
		// En caso de que el plazo hasta la fecha de celebración de la subasta sea mayor a 3 meses, 
		// las solicitudes de tasación hasta que no resten 3 meses para la subasta.
		Date fechaCelebracionSubasta = sub.getFechaSenyalamiento();
		Calendar fechaLimite = Calendar.getInstance();
		fechaLimite.setTime(fechaCelebracionSubasta);
		fechaLimite.add(Calendar.DATE, -DIAS_LIMITE_TASACION_VALIDA);

		Calendar today = Calendar.getInstance();
		if (today.before(fechaLimite)) {
			long diasComprobacion = (fechaLimite.getTimeInMillis()-today.getTimeInMillis())/MILLSECS_PER_DAY;
			String duration = String.format(TIMER_DURATION_MASK, diasComprobacion);
			if (logger.isDebugEnabled()) {
	            logger.debug("Timer creado: " + TIMER_NAME);
	            logger.debug("[subasta= " + sub.getId() + ", duration= " + duration + ", " + BPMContants.TRANSICION_AVANZA_BPM + " ]");
	        }
//			BPMUtils.createTimer (executionContext, TIMER_NAME, duration, BPMContants.TRANSICION_AVANZA_BPM);			
			BPMUtils.createTimer (executionContext, TIMER_NAME, duration, TRANSICION_ACTUALIZAR_TASACION);			
			return;
		}
		
		
		
		// Recorre los bienes de los lotes para enviar solicitud de tasación los que no tienen tasación válida.
		List<LoteSubasta> listaLotes = sub.getLotesSubasta();
		for (LoteSubasta lote : listaLotes) {
			List<Bien> bienes = lote.getBienes();
			for (Bien bien : bienes) {
				if (!(bien instanceof NMBBien)) {
					continue;
				}
				NMBBien nmbBien = (NMBBien)bien;
				NMBValoracionesBienInfo valoracion = nmbBien.getValoracionActiva();
				
				// TASACION_VALIDA: FechaCelebracionSubasta-3meses <= FechaValorTasacion <= hoy 
				boolean tasacionValida = ((valoracion.getFechaValorTasacion() != null && 
						valoracion.getFechaValorTasacion().after(fechaLimite.getTime())));
				
				if (!tasacionValida) {
					// llamada solicita_tasacion
					executionContext.getToken().signal(TRANSICION_ACTUALIZAR_TASACION);
					return;
				}				
			}
		}

		// En cualquier caso finaliza el trámite.
		executionContext.getToken().signal(TRANSICION_FIN);
    }

}