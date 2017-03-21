package es.pfsgroup.plugin.rem.activo.alta;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoFinanciero;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.service.AltaActivoService;

@Component
public class AltaActivoFinanciero implements AltaActivoService  {

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Autowired
	private GenericABMDao genericDao;
	
    @Autowired 
    private ActivoApi activoApi;

    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Override
	public String[] getKeys() {
		return this.getTipoAltaActivo();

	}

	@Override
	public String[] getTipoAltaActivo() {		
		return new String[]{AltaActivoService.CODIGO_ALTA_ACTIVO_FINANCIERO};
	}

	@Override
	public Boolean procesarAlta(DtoAltaActivoFinanciero dtoAAF) throws Exception {
		
		// Validaciones para el alta de activos Financieros
		validarAlta(dtoAAF);
		
		// Transferencia de datos a entidad Activo
		Activo activo = dtoToEntityActivo(dtoAAF);
		
		// Guardado de la nueva entidad Activo
		saveEntityActivo(activo);
		
		return null;
	}
	
	@Override
	public void validarAlta(DtoAltaActivoFinanciero dtoAAF) throws Exception{
		
	}
	
	@Override
	public Activo dtoToEntityActivo(DtoAltaActivoFinanciero dtoAAF) throws Exception{
		Activo activo = new Activo();
		
		// Setter generico
		beanUtilNotNull.copyProperties(activo, dtoAAF);
		
		// Setters adicionales
		beanUtilNotNull.copyProperty(activo, "cartera", utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, dtoAAF.getCarteraCodigo()));
		
		return activo;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void saveEntityActivo(Activo activo){
		
		activoApi.saveOrUpdate(activo);
	}
	
	
	
}