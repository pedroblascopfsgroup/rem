package es.pfsgroup.plugin.recovery.masivo.api.impl;


import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.EstadoProcedimientoDao;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.persona.dao.EXTPersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcedimientoApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVBuscaProcedimientoDelContratoDto;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;

@Component
@Transactional(readOnly = false)
public class MSVProcedimientoManager implements MSVProcedimientoApi {

	@Autowired
	private ProcedimientoDao procedimientoDao;
	
	@Autowired
	private EXTPersonaDao personaDao;

	@Autowired
	private EstadoProcedimientoDao estadoProcedimientoDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	//TODO - Este c�digo est� duplicado en mejoras, pero el plugin no se copia al batch por lo extenso que es. 
	@Override
	@BusinessOperation(MSV_BO_CREA_PROCEDIMIENTO_HIJO)
	public Procedimiento creaProcedimientoHijoMasivo(TipoProcedimiento tipoProcedimiento, Procedimiento procPadre) {
			final String TPO_MONITORIO = "P70";
//			final String TPO_ETJ = "P72";
//			final String TPO_ETNJ = "P76";
			
			MEJProcedimiento procHijo = new MEJProcedimiento();

			/*TODO-Obtener la configuraci�n de las derivaciones de la entity
			 * Para ello, se ha de mover esta entity al corextension
			 */
//			Filter filtroProcOr = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimientoOrigen", procPadre.getTipoProcedimiento().getCodigo());
//			Filter filtroProcDest = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimientoDestino", tipoProcedimiento.getCodigo());
//			MEJConfiguracionDerivacionProcedimiento configuracion=genericDao.get(MEJConfiguracionDerivacionProcedimiento.class, filtroProcOr, filtroProcDest);

			
			procHijo.setAsunto(procPadre.getAsunto());
			procHijo.setDecidido(procPadre.getDecidido());
			procHijo.setExpedienteContratos(procPadre.getExpedienteContratos());
			procHijo.setFechaRecopilacion(procPadre.getFechaRecopilacion());
			procHijo.setTipoProcedimiento(tipoProcedimiento);
			procHijo.setProcedimientoPadre(procPadre);

			List<Persona> personas = new ArrayList<Persona>();
			for (Persona per : procPadre.getPersonasAfectadas()) {
				Persona p = personaDao.get(per.getId());
				personas.add(p);
			}
			procHijo.setPersonasAfectadas(personas);

			DDEstadoProcedimiento estadoProcedimiento = estadoProcedimientoDao.buscarPorCodigo(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
			procHijo.setEstadoProcedimiento(estadoProcedimiento);
				/*TODO - Obtener las derivaciones de la tabla de configuracion
				 * de momento, como solo se utiliza para el alta de lotes ETJ las ponemos a mano*/
			
//				if (!procPadre.getTipoProcedimiento().getCodigo().equals(TPO_MONITORIO) &&  
//						!((tipoProcedimiento.getCodigo().equals(TPO_ETJ)) ||
//							(tipoProcedimiento.getCodigo().equals(TPO_ETNJ)))) {
//					procHijo.setCodigoProcedimientoEnJuzgado(procPadre.getCodigoProcedimientoEnJuzgado());
//				}
				
				if (!procPadre.getTipoProcedimiento().getCodigo().equals(TPO_MONITORIO)) {
					procHijo.setCodigoProcedimientoEnJuzgado(procPadre.getCodigoProcedimientoEnJuzgado());
				}
				procHijo.setJuzgado(procPadre.getJuzgado());				
				procHijo.setObservacionesRecopilacion(procPadre.getObservacionesRecopilacion());
				procHijo.setPlazoRecuperacion(procPadre.getPlazoRecuperacion());
				procHijo.setTipoActuacion(tipoProcedimiento.getTipoActuacion());
				procHijo.setPorcentajeRecuperacion(procPadre.getPorcentajeRecuperacion());
				procHijo.setSaldoOriginalNoVencido(procPadre.getSaldoOriginalNoVencido());
				procHijo.setSaldoOriginalVencido(procPadre.getSaldoOriginalVencido());
				procHijo.setSaldoRecuperacion(procPadre.getSaldoRecuperacion());
				procHijo.setTipoReclamacion(procPadre.getTipoReclamacion());
			

			Long idProcedimiento = procedimientoDao.save(procHijo);// procedimientoManager.saveProcedimiento(procHijo);

			return procedimientoDao.get(idProcedimiento);// procedimientoManager.getProcedimiento(idProcedimiento);
		}
	
	@Override
	@BusinessOperation(MSV_BO_BUSCA_PRC_CONTRATO)
	public Procedimiento buscaProcedimientoDelContrato(String nroContrato, long tipoProcedimiento) {

		MSVBuscaProcedimientoDelContratoDto dto = new MSVBuscaProcedimientoDelContratoDto();
		try {
			dto.setNumeroCasoNova(Long.parseLong(nroContrato));
			dto.setTipoProcedimiento(tipoProcedimiento);
		} catch (Exception e) {
			throw new BusinessOperationException("El n�mero del contrato no es v�lido");
		}
		
		return buscaProcedimientoDelContrato(dto);
		
		
	}
	
	
	@Override
	@BusinessOperation(MSV_BO_BUSCA_PRC_CONTRATO_DTO)
	public Procedimiento buscaProcedimientoDelContrato(MSVBuscaProcedimientoDelContratoDto dto) {
		Procedimiento p = null;
		Procedimiento pBak = null;
		
		List<Procedimiento> listaProcedimientosActivos = getListaProcedimientosActivos(dto.getNumeroCasoNova());
		
		for(Procedimiento proc : listaProcedimientosActivos){
			//Se utiliza un proc. bak por si en el caso de que no cumpla ning�n requisito, por lo menos devolver el �ltimo.
			if (Checks.esNulo(pBak) || pBak.getId() < proc.getId()) {
					pBak = proc;
			}
			if (proc.getAsunto() != null	&& 
				(!Checks.esNulo(dto.getTipoProcedimiento()) ? proc.getTipoProcedimiento().getId().equals(dto.getTipoProcedimiento()) : true) &&
				(dto.getTieneCodigoProcEnJuzgado() ? proc.getCodigoProcedimientoEnJuzgado() != null : true) &&				
				(dto.getTieneJuzgado() ? !Checks.esNulo(proc.getJuzgado()) : true)
			) {
				if (Checks.esNulo(p) || p.getId() < proc.getId()) {
					p=proc;
				}
			}
		}
		
		return Checks.esNulo(p) ? pBak : p;
	}
	
	private List<Procedimiento> getListaProcedimientosActivos(Long casoNova) {
		Contrato c = genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "nroContrato", casoNova));
		
		List<Procedimiento> listaProcedimientosActivos = new ArrayList<Procedimiento>();
		
		for (ExpedienteContrato e : c.getExpedienteContratos()) {
			 for (Asunto a : e.getExpediente().getAsuntos()){
				 if ( a.getEstaAceptado() || MSVProcesoManager.ESTADO_ASUNTO_FM.equals(a.getEstadoAsunto().getCodigo()) || !a.getAuditoria().isBorrado()){
					 for (Procedimiento procedimiento : a.getProcedimientos()){
						 if (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO.equals(procedimiento.getEstadoProcedimiento().getCodigo()) || 
							DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO.equals(procedimiento.getEstadoProcedimiento().getCodigo())){
								listaProcedimientosActivos.add(procedimiento);
						 }
					 }
				 }
			 }
		 }
		
		return listaProcedimientosActivos;
	}

}
