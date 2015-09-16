package es.capgemini.pfs.termino;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.termino.dao.CamposTerminoTipoAcuerdoDao;
import es.capgemini.pfs.termino.dao.TerminoOperacionesDao;
import es.capgemini.pfs.termino.dto.TerminoOperacionesDto;
import es.capgemini.pfs.termino.model.CamposTerminoTipoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoOperaciones;
import es.pfsgroup.commons.utils.Checks;

@Component
public class TerminoOperacionesManager implements TerminoOperacionesApi {

	@Autowired
	TerminoOperacionesDao terminoOperacionesDao;
	
	@Autowired
	CamposTerminoTipoAcuerdoDao camposTerminoTipoAcuerdoDao;
	

    @BusinessOperation(ACUERDO_TERMINO_OPERACIONES_CREAR)
    @Transactional(readOnly = false)
	@Override
	public TerminoOperaciones creaTerminoOperaciones(TerminoOperacionesDto terminoOperacionesDto) throws ParseException {
        
        TerminoOperaciones terminoOperaciones = new TerminoOperaciones();
        
        final String DATE_FORMAT = "dd/MM/yyyy";
        
        DateFormat df = new SimpleDateFormat(DATE_FORMAT);
        
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
        if(!Checks.esNulo(terminoOperacionesDto.getFechaPago())){
        	terminoOperaciones.setFechaPago(df.parse(terminoOperacionesDto.getFechaPago()));
        }
        if(!Checks.esNulo(terminoOperacionesDto.getFechaPlanPago())){
        	terminoOperaciones.setFechaPlanPago(df.parse(terminoOperacionesDto.getFechaPlanPago()));}
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

//    @BusinessOperation(ACUERDO_TERMINO_OPERACIONES_GET_OPERACIONES_POR_TIPO_ACUERDO)
//    @Transactional(readOnly = false)
//	@Override
//	public List<HashMap<String, Object>> getOperacionesPorTipoAcuerdo(TerminoOperaciones terminoOperaciones) {
//		
//    	List<HashMap<String, Object>> lista = new ArrayList<HashMap<String,Object>>();
//    	
//    	String codigo = terminoOperaciones.getTermino().getTipoAcuerdo().getCodigo();
//		
//		if(codigo.equals("01") || codigo.equals("03") || codigo.equals("10")){
//			
//			HashMap<String, Object> map = new HashMap<String, Object>();
//			
//			map.put("nombre","cargasPosteriores");
//			map.put("valor",terminoOperaciones.getCargasPosteriores());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","solicitarAlquiler");
//			map.put("valor",terminoOperaciones.getSolicitarAlquiler());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","liquidez");
//			map.put("valor",terminoOperaciones.getLiquidez());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","tasacion");
//			map.put("valor",terminoOperaciones.getTasacion());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","numExpediente");
//			map.put("valor",terminoOperaciones.getNumExpediente());
//			lista.add(map);
//			
//		}
//		
//		
//		if(codigo.equals("04") || codigo.equals("08")){
//			
//			HashMap<String, Object> map = new HashMap<String, Object>();
//			
//			map.put("nombre","pagoPrevioFormalizacion");
//			map.put("valor",terminoOperaciones.getPagoPrevioFormalizacion());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","plazosPagosPrevioFormalizacion");
//			map.put("valor",terminoOperaciones.getPlazosPagosPrevioFormalizacion());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","carencia");
//			map.put("valor",terminoOperaciones.getCarencia());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","cuotaAsumible");
//			map.put("valor",terminoOperaciones.getCuotaAsumible());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","cargasPosteriores");
//			map.put("valor",terminoOperaciones.getCargasPosteriores());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","garantiasExtras");
//			map.put("valor",terminoOperaciones.getGarantiasExtras());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","numExpediente");
//			map.put("valor",terminoOperaciones.getNumExpediente());
//			lista.add(map);
//			
//		}
//		
//		if(codigo.equals("05")){
//			
//			HashMap<String, Object> map = new HashMap<String, Object>();
//			
//			map.put("nombre","importeQuita");
//			map.put("valor",terminoOperaciones.getImporteQuita());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","porcentajeQuita");
//			map.put("valor",terminoOperaciones.getPorcentajeQuita());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","importeVencido");
//			map.put("valor",terminoOperaciones.getImporteVencido());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","importeNoVencido");
//			map.put("valor",terminoOperaciones.getImporteNoVencido());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","interesesMoratorios");
//			map.put("valor",terminoOperaciones.getInteresesMoratorios());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","interesesOrdinarios");
//			map.put("valor",terminoOperaciones.getInteresesOrdinarios());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","comision");
//			map.put("valor",terminoOperaciones.getComision());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","gastos");
//			map.put("valor",terminoOperaciones.getGastos());
//			lista.add(map);
//		}
//		
//		if(codigo.equals("11")){
//			
//			HashMap<String, Object> map = new HashMap<String, Object>();
//			
//			map.put("nombre","nombreCesionario");
//			map.put("valor",terminoOperaciones.getNombreCesionario());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","relacionCesionarioTitular");
//			map.put("valor",terminoOperaciones.getRelacionCesionarioTitular());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","solvenciaCesionario");
//			map.put("valor",terminoOperaciones.getSolvenciaCesionario());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","importeCesion");
//			map.put("valor",terminoOperaciones.getImporteCesion());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","fechaPago");
//			map.put("valor",terminoOperaciones.getFechaPago());
//			lista.add(map);
//			
//		}
//		
//		if(codigo.equals("13") || codigo.equals("14") || codigo.equals("17")){
//			
//			HashMap<String, Object> map = new HashMap<String, Object>();
//			
//			map.put("nombre","fechaPlanPago");
//			map.put("valor",terminoOperaciones.getFechaPlanPago());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","frecuenciaPlanpago");
//			map.put("valor",terminoOperaciones.getFrecuenciaPlanpago());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","numeroPagosPlanpago");
//			map.put("valor",terminoOperaciones.getNumeroPagosPlanpago());
//			lista.add(map);
//			
//			map = new HashMap<String, Object>();
//			map.put("nombre","importePlanpago");
//			map.put("valor",terminoOperaciones.getImportePlanpago());
//			lista.add(map);
//			
//		}
//		
//		if(codigo.equals("15")){
//			
//			HashMap<String, Object> map = new HashMap<String, Object>();
//			
//			map.put("nombre","analisiSolvencia");
//			map.put("valor",terminoOperaciones.getAnalisiSolvencia());
//			lista.add(map);
//			
//		}
//		
//		if(codigo.equals("16")){
//			
//			HashMap<String, Object> map = new HashMap<String, Object>();
//			
//			map.put("nombre","descripcionAcuerdo");
//			map.put("valor",terminoOperaciones.getDescripcionAcuerdo());
//			lista.add(map);
//			
//		}
//		
//		return lista;
//	}
    
    
    @BusinessOperation(ACUERDO_TERMINO_OPERACIONES_GET_OPERACIONES_POR_TIPO_ACUERDO)
    @Transactional(readOnly = false)
	@Override
	public List<HashMap<String, Object>> getOperacionesPorTipoAcuerdo(TerminoOperaciones terminoOperaciones) {
    
    	List<HashMap<String, Object>> lista = new ArrayList<HashMap<String,Object>>();
    	
    	if(!Checks.esNulo(terminoOperaciones.getTermino()) && !Checks.esNulo(terminoOperaciones.getTermino().getTipoAcuerdo())){
    		
    		List<CamposTerminoTipoAcuerdo> cmps = camposTerminoTipoAcuerdoDao.getCamposTerminosPorTipoAcuerdo(terminoOperaciones.getTermino().getTipoAcuerdo().getId());
    		
    		for(CamposTerminoTipoAcuerdo campo : cmps){
    			lista.add(valorDelCampo(terminoOperaciones,campo.getNombreCampo()));
    		}
    		
    	}
    	
    	return lista;
    }
    
    private HashMap<String, Object> valorDelCampo(TerminoOperaciones terminoOperaciones, String nombreCampo){
    	
    	HashMap<String, Object> map = new HashMap<String, Object>();
    	
        final String DATE_FORMAT = "dd/MM/yyyy";
        
        DateFormat df = new SimpleDateFormat(DATE_FORMAT);
    	
    	if(nombreCampo.equals("pagoPrevioFormalizacion")){
			map.put("nombre","pagoPrevioFormalizacion");
			map.put("valor",terminoOperaciones.getPagoPrevioFormalizacion());
    	}
    		
    	if(nombreCampo.equals("plazosPagosPrevioFormalizacion")){
			map.put("nombre","plazosPagosPrevioFormalizacion");
			map.put("valor",terminoOperaciones.getPlazosPagosPrevioFormalizacion());
    	}
    	
    	if(nombreCampo.equals("carencia")){
			map.put("nombre","carencia");
			map.put("valor",terminoOperaciones.getCarencia());
    	}	
    		
    	if(nombreCampo.equals("cuotaAsumible")){
			map.put("nombre","cuotaAsumible");
			map.put("valor",terminoOperaciones.getCuotaAsumible());
    	}
    	
    	if(nombreCampo.equals("cargasPosteriores")){
			map.put("nombre","cargasPosteriores");
			map.put("valor",terminoOperaciones.getCargasPosteriores());
    	}
    	
    	if(nombreCampo.equals("garantiasExtras")){
			map.put("nombre","garantiasExtras");
			map.put("valor",terminoOperaciones.getGarantiasExtras());
    	}
    	
    	if(nombreCampo.equals("numExpediente")){
			map.put("nombre","numExpediente");
			map.put("valor",terminoOperaciones.getNumExpediente());
    	}
    	
    	if(nombreCampo.equals("solicitarAlquiler")){
    		map.put("nombre","solicitarAlquiler");
    		map.put("valor",terminoOperaciones.getSolicitarAlquiler());
    	}
    	
    	if(nombreCampo.equals("liquidez")){
    		map.put("nombre","liquidez");
    		map.put("valor",terminoOperaciones.getLiquidez());
    	}
    	
    	if(nombreCampo.equals("tasacion")){
    		map.put("nombre","tasacion");
    		map.put("valor",terminoOperaciones.getTasacion());
    	}
    	
    	if(nombreCampo.equals("importeQuita")){
    		map.put("nombre","importeQuita");
    		map.put("valor",terminoOperaciones.getImporteQuita());
    	}
    	
    	if(nombreCampo.equals("porcentajeQuita")){
    		map.put("nombre","porcentajeQuita");
    		map.put("valor",terminoOperaciones.getPorcentajeQuita());
    	}
    	
    	if(nombreCampo.equals("importeVencido")){
    		map.put("nombre","importeVencido");
    		map.put("valor",terminoOperaciones.getImporteVencido());
    	}
    	
    	if(nombreCampo.equals("importeNoVencido")){
    		map.put("nombre","importeNoVencido");
    		map.put("valor",terminoOperaciones.getImporteNoVencido());
    	}
    	
    	if(nombreCampo.equals("interesesMoratorios")){
    		map.put("nombre","interesesMoratorios");
    		map.put("valor",terminoOperaciones.getInteresesMoratorios());
    	}
    	
    	if(nombreCampo.equals("interesesOrdinarios")){
    		map.put("nombre","interesesOrdinarios");
    		map.put("valor",terminoOperaciones.getInteresesOrdinarios());
    	}

    	if(nombreCampo.equals("comision")){
    		map.put("nombre","comision");
    		map.put("valor",terminoOperaciones.getComision());
    	}
    	
    	if(nombreCampo.equals("gastos")){
    		map.put("nombre","gastos");
    		map.put("valor",terminoOperaciones.getGastos());
    	}
    	
    	if(nombreCampo.equals("nombreCesionario")){
    		map.put("nombre","nombreCesionario");
    		map.put("valor",terminoOperaciones.getNombreCesionario());
    	}
    	
    	if(nombreCampo.equals("relacionCesionarioTitular")){
    		map.put("nombre","relacionCesionarioTitular");
    		map.put("valor",terminoOperaciones.getRelacionCesionarioTitular());
    	}
    	
    	if(nombreCampo.equals("solvenciaCesionario")){
    		map.put("nombre","solvenciaCesionario");
    		map.put("valor",terminoOperaciones.getSolvenciaCesionario());
    	}

    	if(nombreCampo.equals("importeCesion")){
    		map.put("nombre","importeCesion");
    		map.put("valor",terminoOperaciones.getImporteCesion());
    	}
    	
    	if(nombreCampo.equals("fechaPago")){
    		map.put("nombre","fechaPago");
    		if (terminoOperaciones.getFechaPago()==null){
    			map.put("valor", null);
    		}
    		else {
    			map.put("valor",df.format(terminoOperaciones.getFechaPago()));
    		}
    	} 
    	
    	if(nombreCampo.equals("fechaPlanPago")){
    		map.put("nombre","fechaPlanPago");
    		if (terminoOperaciones.getFechaPlanPago()==null){
    			map.put("valor", null);
    		}
    		else {
    			map.put("valor",df.format(terminoOperaciones.getFechaPlanPago()));
    		}
    	}
    	
    	if(nombreCampo.equals("frecuenciaPlanpago")){
    		map.put("nombre","frecuenciaPlanpago");
    		map.put("valor",terminoOperaciones.getFrecuenciaPlanpago());
    	}
    	
    	if(nombreCampo.equals("numeroPagosPlanpago")){
    		map.put("nombre","numeroPagosPlanpago");
    		map.put("valor",terminoOperaciones.getNumeroPagosPlanpago());
    	}
    	
    	if(nombreCampo.equals("importePlanpago")){
    		map.put("nombre","importePlanpago");
    		map.put("valor",terminoOperaciones.getImportePlanpago());
    	}
    	
    	if(nombreCampo.equals("analisiSolvencia")){
    		map.put("nombre","analisiSolvencia");
    		map.put("valor",terminoOperaciones.getAnalisiSolvencia());
    	}
    	
    	if(nombreCampo.equals("descripcionAcuerdo")){
			map.put("nombre","descripcionAcuerdo");
			map.put("valor",terminoOperaciones.getDescripcionAcuerdo());
    	}
    	

    	
    	return map;
    }

    
    @BusinessOperation(ACUERDO_TERMINO_CAMPOS_OPERACIONES_POR_TIPO_ACUERDO)
    @Transactional(readOnly = false)
	@Override
	public List<CamposTerminoTipoAcuerdo> getCamposOperacionesPorTipoAcuerdo(Long idTipoAcuerdo) {
    	return camposTerminoTipoAcuerdoDao.getCamposTerminosPorTipoAcuerdo(idTipoAcuerdo);
	}	  	 

}
