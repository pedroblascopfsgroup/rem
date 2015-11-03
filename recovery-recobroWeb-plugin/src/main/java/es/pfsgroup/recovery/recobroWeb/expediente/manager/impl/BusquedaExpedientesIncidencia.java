package es.pfsgroup.recovery.recobroWeb.expediente.manager.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.expediente.BusquedaExpedienteFiltroDinamico;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.recobroWeb.expediente.dto.BusquedaExpIncidenciaDto;

@Component
public class BusquedaExpedientesIncidencia implements BusquedaExpedienteFiltroDinamico{
	
	private static final String origenFiltros = "incidencia";
	
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
		BusquedaExpIncidenciaDto dto = creaDtoParametros(paramsDinamicos);	
		filtro= calculaFiltro(dto);		
		return filtro.toString();
	}

	private StringBuilder calculaFiltro(BusquedaExpIncidenciaDto dto) {
		StringBuilder filtro = new StringBuilder();
		filtro.append(" SELECT distinct expRec.id FROM Expediente expRec ");		
		filtro.append(" WHERE expRec.id in( SELECT distinct ine.expediente.id FROM IncidenciaExpediente ine WHERE 1=1 ");
		if (!Checks.esNulo(dto.getFechaDesdeIncidencia())){			
			if (dto.getFechaDesdeIncidencia() != null
					&& !"".equals(dto.getFechaDesdeIncidencia())) {
				SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
				try {
					sdf1.parse(dto.getFechaDesdeIncidencia());
					filtro.append(" AND ine.auditoria.fechaCrear >= TO_DATE('"+dto.getFechaDesdeIncidencia() + "','dd/MM/rrrr')" );
				
				} catch (ParseException e) {
					logger.error("Error parseando la fecha desde", e);
				}
				
			}
		}
		if (!Checks.esNulo(dto.getFechaHastaIncidencia())){
			if (dto.getFechaHastaIncidencia() != null
					&& !"".equals(dto.getFechaHastaIncidencia())) {
				SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
				try {
					sdf1.parse(dto.getFechaHastaIncidencia());
					filtro.append(" AND ine.auditoria.fechaCrear <= TO_DATE('"+dto.getFechaHastaIncidencia() + " 23:59:59','dd/MM/rrrr hh24:mi:ss')" );
				} catch (ParseException e) {
					logger.error("Error parseando la fecha hasta", e);
				}
				
			}
		}
		if (!Checks.esNulo(dto.getSituacionIncidencia())){
			filtro.append(" AND ine.situacionIncidencia.id = " + dto.getSituacionIncidencia() );
		}		
		if (!Checks.esNulo(dto.getTipoIncidencia())) {
			filtro.append(" AND ine.tipoIncidencia.id = " + dto.getTipoIncidencia() );
		}

		filtro.append(" AND ine.auditoria.borrado = 0 ");
		filtro.append(" ) ");
				
		return filtro;
	}

	private BusquedaExpIncidenciaDto creaDtoParametros(String paramsDinamicos) {
		BusquedaExpIncidenciaDto dto = new BusquedaExpIncidenciaDto();
		
		String[] parametros=paramsDinamicos.split(";");
		if(parametros != null && parametros.length > 0){
			for(String param:parametros){
				String[] paramV = param.split(":");
				if(paramV != null && paramV.length == 2 ){
					if(paramV[0].equalsIgnoreCase("tipoIncidencia") && !paramV[1].equals("")){
						dto.setTipoIncidencia(paramV[1]);
					}
					if(paramV[0].equalsIgnoreCase("situacionIncidencia") && !paramV[1].equals("")){
						dto.setSituacionIncidencia(paramV[1]);
					} 
					if(paramV[0].equalsIgnoreCase("fechaDesdeIncidencia") && !paramV[1].equals("")){
						dto.setFechaDesdeIncidencia(paramV[1]);
					}
					if(paramV[0].equalsIgnoreCase("fechaHastaIncidencia") && !paramV[1].equals("")){
						dto.setFechaHastaIncidencia(paramV[1]);
					}
				}
			}		
		}
		
		return dto;
	}
        
	@Override
	public String obtenerFiltroRecobro(String paramsDinamicos) {
		StringBuilder filtro = new StringBuilder();				
		BusquedaExpIncidenciaDto dto = creaDtoParametros(paramsDinamicos);	
		filtro= calculaFiltroRecobro(dto);		
		return filtro.toString();
	}

	private StringBuilder calculaFiltroRecobro(BusquedaExpIncidenciaDto dto) {
		StringBuilder filtro = new StringBuilder();
//BKREC-943
//		filtro.append(" SELECT distinct expRec.id FROM Expediente expRec ");		
//		filtro.append(" WHERE expRec.id in( SELECT distinct ine.expediente.id FROM IncidenciaExpediente ine WHERE 1=1 ");
		filtro.append(" SELECT ine.expediente as exp FROM IncidenciaExpediente ine WHERE 1=1 ");
		if (!Checks.esNulo(dto.getFechaDesdeIncidencia())){			
			if (dto.getFechaDesdeIncidencia() != null
					&& !"".equals(dto.getFechaDesdeIncidencia())) {
				SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
				try {
					sdf1.parse(dto.getFechaDesdeIncidencia());
					filtro.append(" AND ine.auditoria.fechaCrear >= TO_DATE('"+dto.getFechaDesdeIncidencia() + "','dd/MM/rrrr')" );
				
				} catch (ParseException e) {
					logger.error("Error parseando la fecha desde", e);
				}
				
			}
		}
		if (!Checks.esNulo(dto.getFechaHastaIncidencia())){
			if (dto.getFechaHastaIncidencia() != null
					&& !"".equals(dto.getFechaHastaIncidencia())) {
				SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
				try {
					sdf1.parse(dto.getFechaHastaIncidencia());
					filtro.append(" AND ine.auditoria.fechaCrear <= TO_DATE('"+dto.getFechaHastaIncidencia() + " 23:59:59','dd/MM/rrrr hh24:mi:ss')" );
				} catch (ParseException e) {
					logger.error("Error parseando la fecha hasta", e);
				}
				
			}
		}
		if (!Checks.esNulo(dto.getSituacionIncidencia())){
			filtro.append(" AND ine.situacionIncidencia.id = " + dto.getSituacionIncidencia() );
		}		
		if (!Checks.esNulo(dto.getTipoIncidencia())) {
			filtro.append(" AND ine.tipoIncidencia.id = " + dto.getTipoIncidencia() );
		}

		filtro.append(" AND ine.auditoria.borrado = 0 ");
//BKREC-943
//		filtro.append(" ) ");
				
		return filtro;
	}

}
