package es.pfsgroup.plugin.rem.provisiongastos;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ProvisionGastosApi;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastos;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;
import es.pfsgroup.plugin.rem.model.ProvisionGastos;
import es.pfsgroup.plugin.rem.provisiongastos.dao.ProvisionGastosDao;


@Service("provisionGastosManager")
public class ProvisionGastosManager extends BusinessOperationOverrider<ProvisionGastosApi> implements  ProvisionGastosApi {
	
	
	protected static final Log logger = LogFactory.getLog(ProvisionGastosManager.class);
	
	@Autowired
	ProvisionGastosDao provisionGastosDao;

	@Override
	public String managerName() {
		return "provisionGastosManager";
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public DtoPage findAll(DtoProvisionGastosFilter dto) {
		
		Page page = provisionGastosDao.findAll(dto);
		
		List<ProvisionGastos> lista = (List<ProvisionGastos>) page.getResults();
		List<DtoProvisionGastos> provisiones = new ArrayList<DtoProvisionGastos>();
		
		for (ProvisionGastos provision: lista) {
			
			DtoProvisionGastos dtoProvisionGastos = provisionToDto(provision);
			provisiones.add(dtoProvisionGastos);
		}
		
		return new DtoPage(provisiones, page.getTotalCount());
		
		
	}

	private DtoProvisionGastos provisionToDto(ProvisionGastos provision) {
		
		DtoProvisionGastos dto = new DtoProvisionGastos();
		
		dto.setId(provision.getId());
		dto.setNumProvision(provision.getNumProvision());
		dto.setEstadoProvisionCodigo(provision.getEstadoProvision().getCodigo());
		dto.setEstadoProvisionDescripcion(provision.getEstadoProvision().getDescripcion());
		dto.setFechaAlta(provision.getFechaAlta());
		dto.setFechaEnvio(provision.getFechaEnvio());
		dto.setFechaRespuesta(provision.getFechaRespuesta());
		dto.setGestoria(provision.getGestoria().getNombre());
		
		return dto;	
	}

	
	
	

}