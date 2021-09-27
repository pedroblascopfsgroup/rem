package es.pfsgroup.plugin.rem.provisiongastos;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ProvisionGastosApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastos;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VBusquedaProvisionAgrupacionGastos;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.provisiongastos.dao.ProvisionAgrupacionGastosDao;
import es.pfsgroup.plugin.rem.provisiongastos.dao.ProvisionGastosDao;


@Service("provisionGastosManager")
public class ProvisionGastosManager extends BusinessOperationOverrider<ProvisionGastosApi> implements  ProvisionGastosApi {
	
	
	protected static final Log logger = LogFactory.getLog(ProvisionGastosManager.class);
	
	private static final String COD_PEF_GESTORIA_ADMINISTRACION = "HAYAGESTADMT";
	private static final String COD_PEF_GESTORIA_PLUSVALIA = "GESTOPLUS";
	private static final String COD_PEF_GESTORIA_POSTVENTA = "GTOPOSTV";
	private static final String COD_PEF_USUARIO_CERTIFICADOR = "HAYACERTI";
	private static final String COD_PEF_GESTOR_ADMINISTRACION = "HAYAADM";
	
	@Autowired
	ProvisionGastosDao provisionGastosDao;
	
	@Autowired
	ProvisionAgrupacionGastosDao provisionAgrupacionGastosDao;
	
	@Autowired
	ProveedoresDao proveedoresDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
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

		List<DtoProvisionGastos> provisiones = new ArrayList<DtoProvisionGastos>();
		
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		//Comprobar si el usuario logado es externo (no puede ver gastos)
		if(this.gestorActivoDao.isUsuarioGestorExterno(usuarioLogado.getId())) {
			dto.setIsExterno(true);
			// Si es externo, pero es gestoría de administración, plusvalia o certificación puede ver gastos en los que conste como gestoría, si no, no puede verlos
			
			Boolean isGestoria = genericAdapter.tienePerfil(COD_PEF_GESTORIA_ADMINISTRACION, usuarioLogado) 
					|| genericAdapter.tienePerfil(COD_PEF_GESTORIA_PLUSVALIA, usuarioLogado) || genericAdapter.tienePerfil(COD_PEF_GESTORIA_POSTVENTA, usuarioLogado)
					|| genericAdapter.tienePerfil(COD_PEF_USUARIO_CERTIFICADOR, usuarioLogado);			
			
			if(isGestoria){
				dto.setListaIdProveedor(proveedoresDao.getIdProveedoresByIdUsuario(usuarioLogado.getId()));
			}
			
			if(genericAdapter.tienePerfil(COD_PEF_GESTOR_ADMINISTRACION, usuarioLogado)){
				dto.setIsGestorAdministracion(true);
			}
		}
		
		page = provisionAgrupacionGastosDao.findAll(dto, usuarioLogado.getId());
		
		if(!Checks.esNulo(page)){
			List<VBusquedaProvisionAgrupacionGastos> lista = (List<VBusquedaProvisionAgrupacionGastos>) page.getResults();
			if(!Checks.esNulo(lista)){
				for (VBusquedaProvisionAgrupacionGastos provision: lista) {
					DtoProvisionGastos dtoProvisionGastos = provisionToDto(provision);
					provisiones.add(dtoProvisionGastos);
				}
			}
		}
		
		return new DtoPage(provisiones, page.getTotalCount());
	}
	
	
	


	private DtoProvisionGastos provisionToDto(VBusquedaProvisionAgrupacionGastos provision) {
		
		DtoProvisionGastos dto = new DtoProvisionGastos();
		dto.setId(provision.getId());
		dto.setNumProvision(provision.getNumProvision());		
		dto.setEstadoProvisionCodigo(provision.getCodEstadoProvision());
		dto.setEstadoProvisionDescripcion(provision.getDescEstadoProvision());
		dto.setFechaAlta(provision.getFechaAlta());
		dto.setFechaEnvio(provision.getFechaEnvio());
		dto.setFechaRespuesta(provision.getFechaRespuesta());
		dto.setFechaAnulacion(provision.getFechaAnulacion());
		dto.setIdProveedor(provision.getIdProveedor());
		dto.setCodREMProveedor(provision.getCodREMProveedor());
		dto.setNombreProveedor(provision.getNombreProveedor());
		dto.setNomPropietario(provision.getNomPropietario());
		dto.setNifPropietario(provision.getNifPropietario());
		dto.setCodCartera(provision.getCodCartera());
		dto.setDescCartera(provision.getDescCartera());
		dto.setImporteTotal(provision.getImporteTotal());
		
		return dto;	
	}

}
