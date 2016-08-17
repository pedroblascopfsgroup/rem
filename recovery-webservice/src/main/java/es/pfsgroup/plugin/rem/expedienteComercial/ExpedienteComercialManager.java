package es.pfsgroup.plugin.rem.expedienteComercial;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.trabajo.TrabajoManager;


@Service("expedienteComercialManager")
public class ExpedienteComercialManager implements ExpedienteComercialApi {
	
	protected static final Log logger = LogFactory.getLog(ExpedienteComercialManager.class);
	
	public final String PESTANA_FICHA = "ficha";

	@Autowired
	private GenericABMDao genericDao;
	

	@Override
	public ExpedienteComercial findOne(Long id) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);

		return expediente;
	}

	@Override
	public Object getTabExpediente(Long id, String tab) {
		
		ExpedienteComercial expediente = findOne(id);
		
		WebDto dto = null;

		try {
			
			if(PESTANA_FICHA.equals(tab)){
				dto = expedienteToDtoFichaExpediente(expediente);
			}
			

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		return dto;

	}

	private DtoFichaExpediente expedienteToDtoFichaExpediente(ExpedienteComercial expediente) {

		DtoFichaExpediente dto = new DtoFichaExpediente();
		Oferta oferta = null;
		Activo activo = null;
		
		if(!Checks.esNulo(expediente)) {
			
			oferta = expediente.getOferta();
			if(!Checks.esNulo(oferta)) {
				activo = oferta.getActivoPrincipal();
			}
		
		
			if(!Checks.esNulo(oferta) && !Checks.esNulo(activo)) {		
			
				dto.setNumExpediente(expediente.getNumExpediente());	
				if(!Checks.esNulo(activo.getCartera())) {
					dto.setEntidadPropietariaDescripcion(activo.getCartera().getDescripcion());
				}		
				
				dto.setPropietario(activo.getFullNamePropietario());		
				if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
					dto.setMediador(activo.getInfoComercial().getMediadorInforme().getNombre());
				}
				
				dto.setImporte(oferta.getImporteOferta());
				if(!Checks.esNulo(expediente.getCompradorPrincipal())) {
					dto.setComprador(expediente.getCompradorPrincipal().getFullName());
				}
				
				if(!Checks.esNulo(expediente.getEstado())) {
					dto.setEstado(expediente.getEstado().getDescripcion());
				}		
				dto.setFechaAlta(expediente.getFechaAlta());
				dto.setFechaSancion(expediente.getFechaSancion());
				
				if(!Checks.esNulo(expediente.getReserva())) {
					dto.setFechaReserva(expediente.getReserva().getFechaEnvio());
				}
			}
		}
		
		return dto;
	}
	
	


}
