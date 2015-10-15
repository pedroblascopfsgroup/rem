package es.pfsgroup.recovery.recobroWeb.expediente.manager.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.expediente.BusquedaExpedienteFiltroDinamico;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.recobroWeb.expediente.dto.BusquedaExpAcuerdoDto;

@Component
public class BusquedaExpedientesAcuerdo implements BusquedaExpedienteFiltroDinamico{
	
	private static final String origenFiltros = "acuerdo";
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Override
	public String getOrigenFiltros() {
		return origenFiltros;
	}

	@Override
	public boolean isValid(String paramsDinamicos) {
		String[] parametros = paramsDinamicos.split(";");		
		if(parametros != null && parametros.length > 0){
			String [] parametroOrigen = parametros[0].split(":");
			if(parametroOrigen != null && parametroOrigen.length == 2 ){
				if(parametroOrigen[0].equalsIgnoreCase("origen") && parametroOrigen[1].equalsIgnoreCase(origenFiltros))
					return true;
			}
		}
		return false;
	}

	@Override
	public String obtenerFiltro(String paramsDinamicos) {
		StringBuilder filtro = new StringBuilder();				
		BusquedaExpAcuerdoDto dto = creaDtoParametros(paramsDinamicos);	
		filtro= calculaFiltro(dto);		
		return filtro.toString();
	}

	private StringBuilder calculaFiltro(BusquedaExpAcuerdoDto dto) {
		StringBuilder filtro = new StringBuilder();
		filtro.append(" SELECT distinct expRec.id FROM Expediente expRec ");		
		filtro.append(" WHERE expRec.id in( SELECT distinct acu.expediente.id FROM Acuerdo acu WHERE 1=1 ");
		if (!Checks.esNulo(dto.getFechaDesdeAcuerdo())){			
			if (dto.getFechaDesdeAcuerdo() != null
					&& !"".equals(dto.getFechaDesdeAcuerdo())) {
				SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
				try {
					sdf1.parse(dto.getFechaDesdeAcuerdo());
					filtro.append(" AND acu.auditoria.fechaCrear >= TO_DATE('"+dto.getFechaDesdeAcuerdo() + "','dd/MM/rrrr')" );
				
				} catch (ParseException e) {
					logger.error("Error parseando la fecha desde", e);
				}
				
			}
		}
		if (!Checks.esNulo(dto.getFechaHastaAcuerdo())){
			if (dto.getFechaHastaAcuerdo() != null
					&& !"".equals(dto.getFechaHastaAcuerdo())) {
				SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
				try {
					sdf1.parse(dto.getFechaHastaAcuerdo());
					filtro.append(" AND acu.auditoria.fechaCrear <= TO_DATE('"+dto.getFechaHastaAcuerdo() + " 23:59:59','dd/MM/rrrr hh24:mi:ss')" );
				} catch (ParseException e) {
					logger.error("Error parseando la fecha hasta", e);
				}
				
			}
		}
		if (!Checks.esNulo(dto.getEstadoAcuerdo())){
			filtro.append(" AND acu.estadoAcuerdo.id = " + dto.getEstadoAcuerdo() );
		}		
		if (!Checks.esNulo(dto.getTipoAcuerdo())) {
			filtro.append(" AND acu.tipoPalanca.id = " + dto.getTipoAcuerdo() );
		}
		if (!Checks.esNulo(dto.getSolicitante())) {
			filtro.append(" AND acu.solicitante.id = " + dto.getSolicitante() );
		}
		if (!Checks.esNulo(dto.getMinImporteAcuerdo()) ) {
			filtro.append(" AND acu.importePago >= " + dto.getMinImporteAcuerdo() );
		}
		if ( !Checks.esNulo(dto.getMaxImporteAcuerdo()) ) {
			filtro.append(" AND acu.importePago <= " + dto.getMaxImporteAcuerdo() );
		}
		if (!Checks.esNulo(dto.getMinporcentajeQuita()) ) {
			filtro.append(" AND acu.porcentajeQuita >= " + dto.getMinporcentajeQuita() );
		}
		if ( !Checks.esNulo(dto.getMaxporcentajeQuita()) ) {
			filtro.append(" AND acu.porcentajeQuita <= " + dto.getMaxporcentajeQuita() );
		}
		
		filtro.append(" ) ");
				
		return filtro;
	}

	private BusquedaExpAcuerdoDto creaDtoParametros(String paramsDinamicos) {
		BusquedaExpAcuerdoDto dto = new BusquedaExpAcuerdoDto();
		
		String[] parametros=paramsDinamicos.split(";");
		if(parametros != null && parametros.length > 0){
			for(String param:parametros){
				String[] paramV = param.split(":");
				if(paramV != null && paramV.length == 2 ){
					if(paramV[0].equalsIgnoreCase("tipoAcuerdo") && !paramV[1].equals("")){
						dto.setTipoAcuerdo(paramV[1]);
					}
					if(paramV[0].equalsIgnoreCase("estadoAcuerdo") && !paramV[1].equals("")){
						dto.setEstadoAcuerdo(paramV[1]);
					} 
					if(paramV[0].equalsIgnoreCase("fechaDesdeAcuerdo") && !paramV[1].equals("")){
						dto.setFechaDesdeAcuerdo(paramV[1]);
					}
					if(paramV[0].equalsIgnoreCase("fechaHastaAcuerdo") && !paramV[1].equals("")){
						dto.setFechaHastaAcuerdo(paramV[1]);
					}
					if(paramV[0].equalsIgnoreCase("solicitante") && !paramV[1].equals("")){
						dto.setSolicitante(paramV[1]);
					}					
					if(paramV[0].equalsIgnoreCase("minporcentajeQuita") && !paramV[1].equals("")){
						dto.setMinporcentajeQuita(paramV[1]);
					}
					if(paramV[0].equalsIgnoreCase("maxporcentajeQuita") && !paramV[1].equals("")){
						dto.setMaxporcentajeQuita(paramV[1]);
					}
					if(paramV[0].equalsIgnoreCase("minImporteAcuerdo") && !paramV[1].equals("")){
						dto.setMinImporteAcuerdo(paramV[1]);
					}
					if(paramV[0].equalsIgnoreCase("maxImporteAcuerdo") && !paramV[1].equals("")){
						dto.setMaxImporteAcuerdo(paramV[1]);
					}	
				}
			}		
		}
		
		return dto;
	}

	@Override
	public String obtenerFiltroRecobro(String paramsDinamicos) {
		StringBuilder filtro = new StringBuilder();				
		BusquedaExpAcuerdoDto dto = creaDtoParametros(paramsDinamicos);	
		filtro= calculaFiltroRecobro(dto);		
		return filtro.toString();
	}

	private StringBuilder calculaFiltroRecobro(BusquedaExpAcuerdoDto dto) {
		StringBuilder filtro = new StringBuilder();

//BKREC-943
//                filtro.append(" SELECT distinct expRec.id FROM Expediente expRec ");		
//		filtro.append(" WHERE expRec.id in( SELECT distinct acu.expediente.id FROM Acuerdo acu WHERE 1=1 ");
		filtro.append(" SELECT acu.expediente as exp FROM Acuerdo acu WHERE 1=1 ");
		if (!Checks.esNulo(dto.getFechaDesdeAcuerdo())){			
			if (dto.getFechaDesdeAcuerdo() != null
					&& !"".equals(dto.getFechaDesdeAcuerdo())) {
				SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
				try {
					sdf1.parse(dto.getFechaDesdeAcuerdo());
					filtro.append(" AND acu.auditoria.fechaCrear >= TO_DATE('"+dto.getFechaDesdeAcuerdo() + "','dd/MM/rrrr')" );
				
				} catch (ParseException e) {
					logger.error("Error parseando la fecha desde", e);
				}
				
			}
		}
		if (!Checks.esNulo(dto.getFechaHastaAcuerdo())){
			if (dto.getFechaHastaAcuerdo() != null
					&& !"".equals(dto.getFechaHastaAcuerdo())) {
				SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
				try {
					sdf1.parse(dto.getFechaHastaAcuerdo());
					filtro.append(" AND acu.auditoria.fechaCrear <= TO_DATE('"+dto.getFechaHastaAcuerdo() + " 23:59:59','dd/MM/rrrr hh24:mi:ss')" );
				} catch (ParseException e) {
					logger.error("Error parseando la fecha hasta", e);
				}
				
			}
		}
		if (!Checks.esNulo(dto.getEstadoAcuerdo())){
			filtro.append(" AND acu.estadoAcuerdo.id = " + dto.getEstadoAcuerdo() );
		}		
		if (!Checks.esNulo(dto.getTipoAcuerdo())) {
			filtro.append(" AND acu.tipoPalanca.id = " + dto.getTipoAcuerdo() );
		}
		if (!Checks.esNulo(dto.getSolicitante())) {
			filtro.append(" AND acu.solicitante.id = " + dto.getSolicitante() );
		}
		if (!Checks.esNulo(dto.getMinImporteAcuerdo()) ) {
			filtro.append(" AND acu.importePago >= " + dto.getMinImporteAcuerdo() );
		}
		if ( !Checks.esNulo(dto.getMaxImporteAcuerdo()) ) {
			filtro.append(" AND acu.importePago <= " + dto.getMaxImporteAcuerdo() );
		}
		if (!Checks.esNulo(dto.getMinporcentajeQuita()) ) {
			filtro.append(" AND acu.porcentajeQuita >= " + dto.getMinporcentajeQuita() );
		}
		if ( !Checks.esNulo(dto.getMaxporcentajeQuita()) ) {
			filtro.append(" AND acu.porcentajeQuita <= " + dto.getMaxporcentajeQuita() );
		}

//BKREC-943
//		filtro.append(" ) ");
				
		return filtro;
	}

}
