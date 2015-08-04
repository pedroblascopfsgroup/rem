package es.capgemini.pfs.termino;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.termino.dao.TerminoOperacionesDao;
import es.capgemini.pfs.termino.dto.TerminoOperacionesDto;
import es.capgemini.pfs.termino.model.TerminoOperaciones;
import es.pfsgroup.commons.utils.Checks;

@Component
public class TerminoOperacionesManager implements TerminoOperacionesApi {

	@Autowired
	TerminoOperacionesDao terminoOperacionesDao;
	

    @BusinessOperation(ACUERDO_TERMINO_OPERACIONES_CREAR)
    @Transactional(readOnly = false)
	@Override
	public TerminoOperaciones creaTerminoOperaciones(TerminoOperacionesDto terminoOperacionesDto) {
        
        TerminoOperaciones terminoOperaciones = new TerminoOperaciones();
        
        if(!Checks.esNulo(terminoOperacionesDto.getTermino())){terminoOperaciones.setTermino(terminoOperacionesDto.getTermino());}
        if(!Checks.esNulo(terminoOperacionesDto.getPagoPrevioFormalizacion())){terminoOperaciones.setPagoPrevioFormalizacion(terminoOperacionesDto.getPagoPrevioFormalizacion());}
        if(!Checks.esNulo(terminoOperacionesDto.getPlazosPagosPrevioFormalizacion())){terminoOperaciones.setPlazosPagosPrevioFormalizacion(terminoOperacionesDto.getPlazosPagosPrevioFormalizacion());}
        if(!Checks.esNulo(terminoOperacionesDto.getCarencia())){terminoOperaciones.setCarencia(terminoOperacionesDto.getCarencia());}
        if(!Checks.esNulo(terminoOperacionesDto.getCuotaAsumible())){terminoOperaciones.setCuotaAsumible(terminoOperacionesDto.getCuotaAsumible());}
        if(!Checks.esNulo(terminoOperacionesDto.getCargasPosteriores())){terminoOperaciones.setCargasPosteriores(terminoOperacionesDto.getCargasPosteriores());}
        if(!Checks.esNulo(terminoOperacionesDto.getGarantiasExtras())){terminoOperaciones.setGarantiasExtras(terminoOperacionesDto.getGarantiasExtras());}
        if(!Checks.esNulo(terminoOperacionesDto.getNumExpediente())){terminoOperaciones.setNumExpediente(terminoOperacionesDto.getNumExpediente());}
        if(!Checks.esNulo(terminoOperacionesDto.getSolicitarAlquiler())){terminoOperaciones.setSolicitarAlquiler(terminoOperacionesDto.getSolicitarAlquiler());}
        if(!Checks.esNulo(terminoOperacionesDto.getLiquidez())){terminoOperaciones.setLiquidez(terminoOperacionesDto.getLiquidez());}
        if(!Checks.esNulo(terminoOperacionesDto.getTasacion())){terminoOperaciones.setTasacion(terminoOperacionesDto.getTasacion());}
        if(!Checks.esNulo(terminoOperacionesDto.getImporteQuita())){terminoOperaciones.setImporteQuita(terminoOperacionesDto.getImporteQuita());}
        if(!Checks.esNulo(terminoOperacionesDto.getPorcentajeQuita())){terminoOperaciones.setPorcentajeQuita(terminoOperacionesDto.getPorcentajeQuita());}
        if(!Checks.esNulo(terminoOperacionesDto.getImporteVencido())){terminoOperaciones.setImporteVencido(terminoOperacionesDto.getImporteVencido());}
        if(!Checks.esNulo(terminoOperacionesDto.getImporteNoVencido())){terminoOperaciones.setImporteNoVencido(terminoOperacionesDto.getImporteNoVencido());}
        if(!Checks.esNulo(terminoOperacionesDto.getInteresesMoratorios())){terminoOperaciones.setInteresesMoratorios(terminoOperacionesDto.getInteresesMoratorios());}
        if(!Checks.esNulo(terminoOperacionesDto.getInteresesOrdinarios())){terminoOperaciones.setInteresesOrdinarios(terminoOperacionesDto.getInteresesOrdinarios());}
        if(!Checks.esNulo(terminoOperacionesDto.getComision())){terminoOperaciones.setComision(terminoOperacionesDto.getComision());}
        if(!Checks.esNulo(terminoOperacionesDto.getGastos())){terminoOperaciones.setGastos(terminoOperacionesDto.getGastos());}
        if(!Checks.esNulo(terminoOperacionesDto.getNombreCesionario())){terminoOperaciones.setNombreCesionario(terminoOperacionesDto.getNombreCesionario());}
        if(!Checks.esNulo(terminoOperacionesDto.getRelacionCesionarioTitular())){terminoOperaciones.setRelacionCesionarioTitular(terminoOperacionesDto.getRelacionCesionarioTitular());}
        if(!Checks.esNulo(terminoOperacionesDto.getSolvenciaCesionario())){terminoOperaciones.setSolvenciaCesionario(terminoOperacionesDto.getSolvenciaCesionario());}
        if(!Checks.esNulo(terminoOperacionesDto.getImporteCesion())){terminoOperaciones.setImporteCesion(terminoOperacionesDto.getImporteCesion());}
        if(!Checks.esNulo(terminoOperacionesDto.getFechaPago())){terminoOperaciones.setFechaPago(terminoOperacionesDto.getFechaPago());}
        if(!Checks.esNulo(terminoOperacionesDto.getFechaPlanPago())){terminoOperaciones.setFechaPlanPago(terminoOperacionesDto.getFechaPlanPago());}
        if(!Checks.esNulo(terminoOperacionesDto.getFrecuenciaPlanpago())){terminoOperaciones.setFrecuenciaPlanpago(terminoOperacionesDto.getFrecuenciaPlanpago());}
        if(!Checks.esNulo(terminoOperacionesDto.getNumeroPagosPlanpago())){terminoOperaciones.setNumeroPagosPlanpago(terminoOperacionesDto.getNumeroPagosPlanpago());}
        if(!Checks.esNulo(terminoOperacionesDto.getImportePlanpago())){terminoOperaciones.setImportePlanpago(terminoOperacionesDto.getImportePlanpago());}
        if(!Checks.esNulo(terminoOperacionesDto.getAnalisiSolvencia())){terminoOperaciones.setAnalisiSolvencia(terminoOperacionesDto.getAnalisiSolvencia());}
        if(!Checks.esNulo(terminoOperacionesDto.getDescripcionAcuerdo())){terminoOperaciones.setDescripcionAcuerdo(terminoOperacionesDto.getDescripcionAcuerdo());}
        if(!Checks.esNulo(terminoOperacionesDto.getVersion())){terminoOperaciones.setVersion(terminoOperacionesDto.getVersion());}
        if(!Checks.esNulo(terminoOperacionesDto.getAuditoria())){terminoOperaciones.setAuditoria(terminoOperacionesDto.getAuditoria());}
        
        return terminoOperaciones;
	}

    @BusinessOperation(ACUERDO_TERMINO_OPERACIONES_GUARDAR)
    @Transactional(readOnly = false)
	@Override
	public TerminoOperaciones guardaTerminoOperaciones(TerminoOperaciones terminoOperaciones) {
		 
    	terminoOperacionesDao.saveOrUpdate(terminoOperaciones);
    	return terminoOperaciones;
	}	  	 

}
