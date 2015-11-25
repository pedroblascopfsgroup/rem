package es.pfsgroup.recovery.cajamar.manager;

import java.util.Calendar;
import java.util.Date;

import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.concursal.concurso.ConcursoManager;
import es.pfsgroup.concursal.concurso.dto.DtoConcurso;
import es.pfsgroup.concursal.concurso.dto.DtoContratoConcurso;
import es.pfsgroup.concursal.credito.model.Credito;

@Component
public class BPMManager {
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	ProcedimientoManager procedimientoManager;
	
	@Autowired
	ConcursoManager concursoManager;

	public String dameFechaSiguienteVencimientoCreditoContingente(String fechaVencimientoActual, Long idProcedimiento) 
	{
		try {
			long idAsunto = procedimientoManager.getProcedimiento(idProcedimiento).getAsunto().getId();
			Date fechaVencimiento = null, proximaFechaVencimiento = null;
			if (fechaVencimientoActual != null) {
				fechaVencimiento = FormatUtils.strADate(fechaVencimientoActual, "yyyy-MM-dd");
			}
			
			for (DtoConcurso concurso : concursoManager.listadoFaseComun(idAsunto)) {
				if(concurso.getContratos() != null) {
					for(DtoContratoConcurso contrato : concurso.getContratos()) {
						if(contrato.getCreditos() != null) {
							for (Credito credito : contrato.getCreditos()) {
								
								if(credito.getTipoDefinitivo() != null && credito.getTipoDefinitivo().getCodigo().equals("7")) {
									if((fechaVencimiento == null || fechaVencimiento.before(credito.getFechaVencimiento()))
										&& (proximaFechaVencimiento == null || proximaFechaVencimiento.after(credito.getFechaVencimiento()))) {
											proximaFechaVencimiento = credito.getFechaVencimiento();
									}																			
								}								
							}
						}
					}						
				}
				else {
					return null;
				}
			}
			
			if(proximaFechaVencimiento != null) {					
				return DateFormatUtils.format(proximaFechaVencimiento, "yyyy-MM-dd");
			}
			else {
				return null;
			}		
		}
		catch(Exception e) {
			logger.error("Error en el método dameFechaSiguienteVencimientoCreditoContingente de la clase BPMManager: " + e.getMessage());
			throw new FrameworkException(e); 
		}
	}	
	
	public boolean compruebaPlazoCumplido(String fecha, int plazo) 
	{
		try {
			Date dFecha = FormatUtils.strADate(fecha, "yyyy-MM-dd");
			Calendar cal = java.util.Calendar.getInstance();
			cal.setTime(new java.util.Date());
			cal.add(Calendar.DATE, -plazo);
			Date dateBeforeDays = cal.getTime();
			
			if (dFecha.before(dateBeforeDays)) {
				return true;
			}
			else {
				return false;
			}
		}
		catch(Exception e) {
			logger.error("Error en el método compruebaPlazoCumplido de la clase BPMManager: " + e.getMessage());
			throw new FrameworkException(e); 
		}	
	}
	
	public boolean existenCreditosContingentesReconocidos(Long idProcedimiento) 
	{
		try {
			boolean enc = false;
			
			long idAsunto = procedimientoManager.getProcedimiento(idProcedimiento).getAsunto().getId();
			
			for (DtoConcurso concurso : concursoManager.listadoFaseComun(idAsunto)) {
				if(concurso.getContratos() != null) {
					for(DtoContratoConcurso contrato : concurso.getContratos()) {
						if(contrato.getCreditos() != null) {
							for (Credito credito : contrato.getCreditos()) {
								
								if(credito.getTipoDefinitivo() != null && credito.getTipoDefinitivo().getCodigo().equals("7") 
										&& credito.getEstadoCredito() != null && credito.getEstadoCredito().getCodigo().equals("2")) {
									enc = true;
									break;
								}								
							}
						}
					}						
				}
			}
			
			return enc;	
		}
		catch(Exception e) {
			logger.error("Error en el método existenCreditosContingentesReconocidos de la clase BPMManager: " + e.getMessage());
			throw new FrameworkException(e); 
		}
	}
}
