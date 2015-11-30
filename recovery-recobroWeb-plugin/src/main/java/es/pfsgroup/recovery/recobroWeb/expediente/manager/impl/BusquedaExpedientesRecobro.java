package es.pfsgroup.recovery.recobroWeb.expediente.manager.impl;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.expediente.BusquedaExpedienteFiltroDinamico;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.recobroWeb.expediente.dto.BusquedaExpRecobroDto;

@Component
public class BusquedaExpedientesRecobro implements BusquedaExpedienteFiltroDinamico{
	
	private static final String origenFiltros = "recobro";
	
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
		BusquedaExpRecobroDto dto = creaDtoParametros(paramsDinamicos);	
		filtro= calculaFiltro(dto);		
		return filtro.toString();
	}

	private StringBuilder calculaFiltro(BusquedaExpRecobroDto dto) {
		StringBuilder filtro = new StringBuilder();
		filtro.append(" SELECT distinct expRec.id FROM Expediente expRec ");		
		filtro.append(" WHERE expRec.id in( SELECT distinct cre.expediente.id FROM CicloRecobroExpediente cre WHERE 1=1 ");
		if (!Checks.esNulo(dto.getEsquema())){			
			filtro.append(" AND cre.esquema.id = " + dto.getEsquema() );			
		}
		if (!Checks.esNulo(dto.getCartera())){
			filtro.append(" AND cre.carteraEsquema.cartera.id = " + dto.getCartera() );
		}
		if (!Checks.esNulo(dto.getSubcartera())){
			filtro.append(" AND cre.subcartera.id = " + dto.getSubcartera() );
		}		
		if (!Checks.esNulo(dto.getAgencia())) {
			filtro.append(" AND cre.agencia.id = " + dto.getAgencia() );
		}
		if (!Checks.esNulo(dto.getMotivoBaja())) {
			filtro.append(" AND cre.motivoBaja.id = " + dto.getMotivoBaja() );
		}
		
		filtro.append(" ) ");
		
		if (!Checks.esNulo(dto.getSupervisor())) {
			filtro.append(" AND expRec.id in (SELECT distinct gae.expediente.id from GestorExpediente gae where gae.usuario.id = " + dto.getSupervisor() +") ");
		}
		
		
		return filtro;
	}

	private BusquedaExpRecobroDto creaDtoParametros(String paramsDinamicos) {
		BusquedaExpRecobroDto dto = new BusquedaExpRecobroDto();
		
		String[] parametros=paramsDinamicos.split(";");
		if(parametros != null && parametros.length > 0){
			for(String param:parametros){
				String[] paramV = param.split(":");
				if(paramV != null && paramV.length == 2 ){
					if(paramV[0].equalsIgnoreCase("esquema") && !paramV[1].equals("")){
						dto.setEsquema(paramV[1]);
					}
					if(paramV[0].equalsIgnoreCase("cartera") && !paramV[1].equals("")){
						dto.setCartera(paramV[1]);
					} 
					if (paramV[0].equalsIgnoreCase("subcartera") && !paramV[1].equals("")){
						dto.setSubcartera(paramV[1]);						
					}
					if(paramV[0].equalsIgnoreCase("motivoBaja") && !paramV[1].equals("")){
						dto.setMotivoBaja(paramV[1]);
					}
					if(paramV[0].equalsIgnoreCase("agencia") && !paramV[1].equals("")){
						dto.setAgencia(paramV[1]);
					} 
					if (paramV[0].equalsIgnoreCase("supervisor") && !paramV[1].equals("")){
						dto.setSupervisor(paramV[1]);			
					}
				}
			}		
		}
		
		return dto;
	}

	@Override
	public String obtenerFiltroRecobro(String paramsDinamicos) {
		StringBuilder filtro = new StringBuilder();				
		BusquedaExpRecobroDto dto = creaDtoParametros(paramsDinamicos);	
		filtro= calculaFiltroRecobro(dto);		
		return filtro.toString();
	}

	private StringBuilder calculaFiltroRecobro(BusquedaExpRecobroDto dto) {
		StringBuilder filtro = new StringBuilder();
//BKREC-943
//		filtro.append(" SELECT distinct expRec.id FROM Expediente expRec ");		
//		filtro.append(" WHERE expRec.id in( SELECT distinct cre.expediente.id FROM CicloRecobroExpediente cre WHERE 1=1 ");
		filtro.append(" SELECT cre.expediente as exp FROM CicloRecobroExpediente cre WHERE 1=1 ");                
		filtro.append(" AND cre.fechaBaja IS NULL");
                if (!Checks.esNulo(dto.getEsquema())){			
			filtro.append(" AND cre.esquema.id = " + dto.getEsquema() );			
		}
		if (!Checks.esNulo(dto.getCartera())){
			filtro.append(" AND cre.carteraEsquema.cartera.id = " + dto.getCartera() );
		}
		if (!Checks.esNulo(dto.getSubcartera())){
			filtro.append(" AND cre.subcartera.id = " + dto.getSubcartera() );
		}		
		if (!Checks.esNulo(dto.getAgencia())) {
			filtro.append(" AND cre.agencia.id = " + dto.getAgencia() );
		}
		if (!Checks.esNulo(dto.getMotivoBaja())) {
			filtro.append(" AND cre.motivoBaja.id = " + dto.getMotivoBaja() );
		}

//BKREC-943		
//		filtro.append(" ) ");
		
		if (!Checks.esNulo(dto.getSupervisor())) {
			filtro.append(" AND EXISTS (SELECT 1 from GestorExpediente gae where cre.expediente.id = gae.expediente.id and gae.usuario.id = " + dto.getSupervisor() +") ");
		}
		
		
		return filtro;
	}

}
