package es.pfsgroup.plugin.recovery.mejoras.contrato;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.contrato.dao.MEJContratoDao;
import es.pfsgroup.plugin.recovery.mejoras.contrato.dto.MEJBusquedaContratosDto;
import es.pfsgroup.recovery.ext.impl.contrato.model.AtipicoContrato;
import es.pfsgroup.recovery.ext.impl.contrato.model.EXTInfoAdicionalContrato;

@Component
public class MEJContratoManager extends
		BusinessOperationOverrider<MEJContratoApi> implements MEJContratoApi {

	@Autowired
	private MEJContratoDao contratoDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;


	@Override
	public String managerName() {
		return "contratoManager";
	}

	@Autowired
	private GenericABMDao genericDao;
		
	
	/**
     * Devuelve una lista con el contrato de pase del cliente.
     * @param dto dto de busqueda
     * @return una lista con el contrato de pase.
     */
    @BusinessOperation(overrides = PrimariaBusinessOperation.BO_CNT_MGR_BUSCAR_CONTRATOS_CLIENTE)
    public Page buscarContratosCliente(DtoBuscarContrato dto) {
    	
    	es.capgemini.devon.pagination.PageImpl pagina = (es.capgemini.devon.pagination.PageImpl) contratoDao.buscarContratosCliente(dto);
        int start = dto.getStart();
        int limit = dto.getLimit();
        int totalCount = pagina.getTotalCount();
        if ((start + limit) >= totalCount && totalCount > 0) {
            //Agregar total
            agregarTotalizadorCliente(dto, pagina);
        }
        return pagina;
    }
    
    /**
     * agrega el totalizador a la query en la ultima pagina.
     * @param dto params
     * @param pagina pagina
     */
    @SuppressWarnings("unchecked")
    private void agregarTotalizadorCliente(DtoBuscarContrato dto, es.capgemini.devon.pagination.PageImpl pagina) {
        HashMap<String, Object> mapa = contratoDao.buscarTotalContratosCliente(dto);
        Contrato c = new Contrato();
        Movimiento m = new Movimiento();
        m.setPosVivaVencida(((Double) mapa.get("posVivaVencida")).floatValue());
        m.setSaldoPasivo(((Double) mapa.get("saldoPasivo")).floatValue());
        m.setPosVivaNoVencida(((Double) mapa.get("posVivaNoVencida")).floatValue());
        ArrayList<Movimiento> movs = new ArrayList<Movimiento>();
        movs.add(m);
        c.setMovimientos(movs);
        c.setCodigoContrato("Total: ");
        List resultados = pagina.getResults();
        resultados.add(c);
        pagina.setResults(resultados);
    }

	@Override
	@BusinessOperation(MEJ_MGR_CONTRATO_ADJUNTOSMAPEADOS)
	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id) {
		EventFactory.onMethodStart(this.getClass());
		
		List<AdjuntoDto> adjuntosConBorrado = new ArrayList<AdjuntoDto>();

		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class)
				.getUsuarioLogado();

		final Boolean borrarOtrosUsu = tieneFuncion(usuario,
				"BORRAR_ADJ_OTROS_USU");

		Contrato cnt = contratoDao.get(id);
		ArrayList<AdjuntoContrato> adjuntosContrato = new ArrayList<AdjuntoContrato>();
		adjuntosContrato.addAll(cnt.getAdjuntos());

		Comparator<AdjuntoContrato> comparador = new Comparator<AdjuntoContrato>() {
			@Override
			public int compare(AdjuntoContrato o1, AdjuntoContrato o2) {
				if(Checks.esNulo(o1)&& Checks.esNulo(o2)){
					return 0;
				}
				else if (Checks.esNulo(o1)) {
					return -1;
				}
				else if (Checks.esNulo(o2)) {
					return 1;				
				}
				else{
					return o2.getAuditoria().getFechaCrear().compareTo(
						o1.getAuditoria().getFechaCrear());
				}	
			}
		};
		Collections.sort(adjuntosContrato, comparador);
		for (final AdjuntoContrato aa : adjuntosContrato) {
			AdjuntoDto dto = new AdjuntoDto() {
				@Override
				public Boolean getPuedeBorrar() {
					if (borrarOtrosUsu
							|| aa.getAuditoria().getUsuarioCrear().equals(
									usuario.getUsername())) {
						return true;
					} else {
						return false;
					}
				}

				@Override
				public Object getAdjunto() {
					return aa;
				}
			};
			adjuntosConBorrado.add(dto);
		}
		
		EventFactory.onMethodStop(this.getClass());
		return adjuntosConBorrado;
	}

	
	private boolean tieneFuncion(Usuario usuario, String codigo) {
		List<Perfil> perfiles = usuario.getPerfiles();
		for (Perfil per : perfiles) {
			for (Funcion fun : per.getFunciones()) {
				if (fun.getDescripcion().equals(codigo)) {
					return true;
				}
			}
		}

		return false;
	}
	
	@Override
	@BusinessOperation(BO_CNT_MGR_BUSCAR_CONTRATOS_EXPEDIENTE_SIN_ASIGNAR)
	public Page buscarContratosExpedienteSinAsignar(DtoBuscarContrato dto) {
		
		return contratoDao.buscarContratosExpedienteSinAsignar(dto);
		
	}

	/**
	 * PBO: Incorporado al desenchufar referencias a UNNIM
	 */
	@BusinessOperation(MEJ_CNT_BUSCAR_CONTRATO_SINASIGNAR)
	@Override
	public Page buscaContratosSinAsignar(Long idAsunto, MEJBusquedaContratosDto dto){
		Filter fAsunto = genericDao.createFilter(FilterType.EQUALS,"id", idAsunto);
		Asunto asunto = genericDao.get(Asunto.class, fAsunto);
		
		return contratoDao.buscaContratosSinAsignar(idAsunto,asunto.getProcedimientos(),dto);
	}
	
	/**
     * Busca los contratos atipicos en los que esté o haya estado el contato.
     * @param idContrato el id del contrato
     * @return la lista de atipicos.
     */
    @BusinessOperation(MEJ_BUSCAR_ATIPICOS_CONTRATO)
    public List<AtipicoContrato> getAtipicosContrato(Long idContrato) {
    	Filter fAtipico = genericDao.createFilter(FilterType.EQUALS,"contrato.id", idContrato);
    	List<AtipicoContrato> listAtipicosContrato = genericDao.getList(AtipicoContrato.class, fAtipico);
    	return listAtipicosContrato;
    }

}
