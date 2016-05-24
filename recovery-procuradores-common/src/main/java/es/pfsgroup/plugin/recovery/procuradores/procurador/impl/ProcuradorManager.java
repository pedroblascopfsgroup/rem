package es.pfsgroup.plugin.recovery.procuradores.procurador.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.procedimiento.ActualizarProcedimientoDtoInfo;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.api.ConfiguracionDespachoExternoApi;
import es.pfsgroup.plugin.recovery.procuradores.procurador.api.ProcuradorApi;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dao.ProcuradorDao;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dao.RelacionProcuradorProcedimientoDao;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.ProcuradorDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorProcedimiento;
import es.pfsgroup.recovery.api.UsuarioApi;

/**
 * Implementación de la api de {@link Procurador}
 * @author carlos
 *
 */
@Service("Procurador")
@Transactional(readOnly = false)
public class ProcuradorManager  implements ProcuradorApi {

	@Autowired
	private ProcuradorDao procuradorDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private ProcedimientoDao procedimientoDao;
	
	@Autowired
	private ConfiguracionDespachoExternoApi configuracionDespachoExternoApi;
	
	@Autowired
	private RelacionProcuradorProcedimientoDao relacionProcuradorProcedimientoDao;
	
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_PROCURADOR_GET_LISTA_PROCURADORES)
	public Page getListaProcuradores(ProcuradorDto dto) {
		
		return procuradorDao.getListadoProcuradores(dto);
	}
	
	@Override
	@BusinessOperation(PR_PROCURADORES_GET_PROCURADOR)
	public Procurador getProcurador(Long idProcurador) {
		
		return procuradorDao.getProcurador(idProcurador);
	}


	@Override
	@BusinessOperation(BO_PROCURADORES_GET_PROCURADOR_REAL)
	public String getProcuradorReal(Long idProcedimiento) {

		Long idUsuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getId();
		//Long idUsuario = procedimientoDao.get(idProcedimiento).getAsunto().getGestor().getUsuario().getId();
		if(!Checks.esNulo(idUsuario)){
			List<GestorDespacho> gestorDespacho = configuracionDespachoExternoApi.buscaDespachosPorUsuarioYTipo(idUsuario, DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
			if((!Checks.esNulo(gestorDespacho) && gestorDespacho.size()>0)){
				DespachoExterno despacho = gestorDespacho.get(0).getDespachoExterno();
				if (configuracionDespachoExternoApi.isDespachoIntegral(despacho.getId()) )
				{
					List<RelacionProcuradorProcedimiento> relacionPPR = relacionProcuradorProcedimientoDao.getProcuradorProcedimiento(idProcedimiento);
					if(relacionPPR.size()>0)
						return relacionPPR.get(0).getProcurador().getNombre();
				}
			}	
		}
		//Si no usa categorias o no es despacho integral
		if(!Checks.esNulo(procedimientoDao.get(idProcedimiento).getAsunto().getProcurador()))
				return procedimientoDao.get(idProcedimiento).getAsunto().getProcurador().getUsuario().getApellidoNombre();
		
		return "NO ESPECIFICADO";
	}
	
	@Override
	@BusinessOperation(SAVE_PROCEDIMIENTO_PROCURADOR)
	public void saveProcedimientoProcurador(WebRequest request) {
		
		///Actualizamos todos los datos
		ActualizarProcedimientoDtoInfo dto = DynamicDtoUtils.create(ActualizarProcedimientoDtoInfo.class, request);
		proxyFactory.proxy(ProcedimientoApi.class).actualizaProcedimiento(dto);
		
	}


	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_POR_CODIGO)
	public int getProcuradorPorCodigo(ProcuradorDto dto) {
		// TODO Auto-generated method stub 
		
		int pagina = 0;
		int i = 0;
		for (Procurador p : procuradorDao.getListadoProcuradoresLista(dto) ){
			if (p.getId().compareTo(dto.getId())==0) {
				pagina = i;
				break;				
			}
			i += 1;
		}	
		return pagina;
	}
	


}
