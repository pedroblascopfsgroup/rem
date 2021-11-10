package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoConfiguracionRecomendacion;

public interface RecomendacionApi {

	public List<DtoConfiguracionRecomendacion> getConfiguracionesRecomendacion();

	public boolean saveConfigRecomendacion(DtoConfiguracionRecomendacion dtoConfiguracionRecomendacion);
	
	public boolean deleteConfigRecomendacion(DtoConfiguracionRecomendacion dtoConfiguracionRecomendacion);

}
