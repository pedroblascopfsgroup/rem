package es.pfsgroup.plugin.rem.provisiongastos;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ProvisionGastosApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastos;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;
import es.pfsgroup.plugin.rem.model.ProvisionGastos;
import es.pfsgroup.plugin.rem.provisiongastos.dao.ProvisionGastosDao;


@Service("provisionGastosManager")
public class ProvisionGastosManager extends BusinessOperationOverrider<ProvisionGastosApi> implements  ProvisionGastosApi {
	
	
	protected static final Log logger = LogFactory.getLog(ProvisionGastosManager.class);
	
	private static final String COD_PEF_GESTORIA_ADMINISTRACION = "HAYAGESTADMT";
	
	@Autowired
	ProvisionGastosDao provisionGastosDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GestorActivoDao gestorActivoDao;

	@Override
	public String managerName() {
		return "provisionGastosManager";
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public DtoPage findAll(DtoProvisionGastosFilter dto) {
		
		Page page = null;
		
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		//Comprobar si el usuario logado es externo (no puede ver gastos)
		if(this.gestorActivoDao.isUsuarioGestorExterno(usuarioLogado.getId())) {
			// Si es externo, pero es gestoría de administración, puede ver gastos en los que conste como gestoría, si no es gestoriaAdm no puede verlos
			page = provisionGastosDao.findAllFilteredByProveedor(dto,genericAdapter.tienePerfil(COD_PEF_GESTORIA_ADMINISTRACION, usuarioLogado) ? usuarioLogado.getId() : null);
		}
		else {
			page = provisionGastosDao.findAll(dto);
		}
		
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
