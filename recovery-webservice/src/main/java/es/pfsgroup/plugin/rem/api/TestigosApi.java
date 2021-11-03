package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoTestigoObligatorio;

public interface TestigosApi {

	public List<DtoTestigoObligatorio> getTestigosObligatorios();

	public boolean saveTestigoObligatorio(DtoTestigoObligatorio dtoTestigoObligatorio);
	
	public boolean updateTestigoObligatorio(DtoTestigoObligatorio dtoTestigoObligatorio);

	public boolean deleteTestigoObligatorio(DtoTestigoObligatorio dtoTestigoObligatorio);

}
