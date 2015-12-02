package es.pfsgroup.recovery.ext.impl.contrato;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.dao.EXTContratoDao;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.ObjetoResultado;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.api.contrato.EXTContratoApi;
import es.pfsgroup.recovery.ext.api.contrato.model.EXTInfoAdicionalContratoInfo;
import es.pfsgroup.recovery.ext.impl.contrato.model.EXTInfoAdicionalContrato;
import es.pfsgroup.recovery.ext.api.contrato.dto.EXTBusquedaContratosDto;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component
public class EXTContratoManager implements EXTContratoApi {
	
	
	private static final String BO_CNT_MGR_BUSCAR_CONTRATOS_CLIENTE_UGAS = "plugin.coreextension.contrato.buscarContratosClienteUgas";

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private EXTContratoDao contratoDao;

	@Override
	@BusinessOperation(EXT_BO_CNT_GETINFO_BY_TIPO)
	@Transactional
	public EXTInfoAdicionalContratoInfo getInfoAdicionalContratoByTipo(
			long idContrato, String codigoTipo) {
		EventFactory.onMethodStart(this.getClass());

		EXTInfoAdicionalContrato infoAdicional = null;
		
		Filter fContrato = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
		Filter fTipo = genericDao.createFilter(FilterType.EQUALS, "tipoInfoContrato.codigo", codigoTipo);
		
		infoAdicional = genericDao.get(EXTInfoAdicionalContrato.class, fContrato, fTipo);
		
		EventFactory.onMethodStop(this.getClass());
		return infoAdicional;
	}

	@BusinessOperationDefinition(EXT_BO_CNT_GETCNT_CON_INFO)
	@Transactional
	@Override
	public List<Long> findIdContratosConInfoAdicional(
			EXTInfoAdicionalContratoInfo iac) {
		ArrayList<Long> ids = new ArrayList<Long>();
		Filter filtroValor = genericDao.createFilter(FilterType.EQUALS, "value", iac.getValue());
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "tipoInfoContrato.codigo", iac.getTipoInfoContrato().getCodigo());
		List<EXTInfoAdicionalContrato> infoList = genericDao.getList(EXTInfoAdicionalContrato.class, filtroTipo, filtroValor);
		
		for (EXTInfoAdicionalContrato info : infoList){
			ids.add(info.getContrato().getId());
		}
		return ids;
	}
	
	/**
     * Devuelve una lista con el contrato de pase del cliente.
     * @param dto dto de busqueda
     * @return una lista con el contrato de pase.
     */
    @BusinessOperation(BO_CNT_MGR_BUSCAR_CONTRATOS_CLIENTE_UGAS)
    public Page buscarContratosClienteUgas(DtoBuscarContrato dto) {
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
        if (!Checks.esNulo(mapa.get("posVivaVencida"))){
        	m.setPosVivaVencida(((Double) mapa.get("posVivaVencida")).floatValue());
        }
        if (!Checks.esNulo(mapa.get("saldoPasivo"))){
        	m.setSaldoPasivo(((Double) mapa.get("saldoPasivo")).floatValue());
        }
        if (!Checks.esNulo(mapa.get("posVivaNoVencida"))){
        	m.setPosVivaNoVencida(((Double) mapa.get("posVivaNoVencida")).floatValue());
        }
        ArrayList<Movimiento> movs = new ArrayList<Movimiento>();
        movs.add(m);
        c.setMovimientos(movs);
        c.setCodigoContrato("Total: ");
        List resultados = pagina.getResults();
        resultados.add(c);
        pagina.setResults(resultados);
    }
    
	@Override
	@BusinessOperation(overrides = PrimariaBusinessOperation.BO_CNT_MGR_BUSCAR_CONTRATOS)
	public Page buscarContratos(BusquedaContratosDto dto) {
		EventFactory.onMethodStart(this.getClass());
		
		dto.setCodigosZona(getCodigosDeZona(dto));
		dto.setEstadosContrato(getEstadosContrato(dto));
		Usuario usuLogado = (Usuario) executor
				.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		
		EventFactory.onMethodStop(this.getClass());
		return contratoDao.buscarContratosPaginados(dto, usuLogado);
	}
	private Set<String> getCodigosDeZona(BusquedaContratosDto dto) {
		Set<String> zonas;
		if (dto.getCodigoZona() != null
				&& dto.getCodigoZona().trim().length() > 0) {
			List<String> list = Arrays.asList((dto.getCodigoZona().split(",")));
			zonas = new HashSet<String>(list);
		} else {
			Usuario usuario = (Usuario) executor
					.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			zonas = usuario.getCodigoZonas();
		}
		return zonas;
	}

	/**
	 * Devuelve los estados de un contrato seleccionados en el form.
	 * 
	 * @param dto
	 * @return
	 */
	private Set<String> getEstadosContrato(BusquedaContratosDto dto) {
		Set<String> estados = null;
		if (dto.getStringEstadosContrato() != null
				&& dto.getStringEstadosContrato().trim().length() > 0) {
			List<String> list = Arrays.asList((dto.getStringEstadosContrato()
					.split(",")));
			estados = new HashSet<String>(list);
		}
		return estados;
	}

	/**
	 * PBO: 28/11/12
	 * Se usaba acoplado desde el plugin de UNNIM.
	 * Se copia desde el plugin de UNNIM y se adapta para poder desenchufarlo
	 */
	@BusinessOperation(EXT_BO_CNT_BUSCAR_CONTRATO_AVANZADO)
	@Override
	public Page buscarContratosAvanzado(EXTBusquedaContratosDto dto) {
		EventFactory.onMethodStart(this.getClass());
		
		Usuario usuLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		dto.setCodigosZona(getCodigosDeZonaAvanzado(dto, usuLogado));
		dto.setEstadosContrato(getEstadosContrato(dto));

		EventFactory.onMethodStop(this.getClass());
		return contratoDao.buscarContratosPaginadosAvanzado(dto, usuLogado);
	}
	
	/**
     * Verifica si no se supera el límite tolerado de resultados para el export a XLS de
     * la búsqueda de contratos. También verifica que el resultado no sea vacío.
     * @param dto contiene los filtros de la búsqueda.
     * @return lista de objetoResultado
     */
    @BusinessOperation(overrides = PrimariaBusinessOperation.BO_CNT_MGR_SUPERAR_LIMITE_EXPORT)
    public List<ObjetoResultado> superaLimiteExport(EXTBusquedaContratosDto dto) {
    	final Usuario usuLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
    	
    	
        //Seteamos las zonas del formulario o por defecto las zonas del usuario logado
        ObjetoResultado result = new ObjetoResultado();

        dto.setCodigosZona(getCodigosDeZona(dto));
        dto.setEstadosContrato(getEstadosContrato(dto));
        Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
                Parametrizacion.LIMITE_EXPORT_EXCEL);
        int limit = Integer.parseInt(param.getValor());
        dto.setLimit(limit + 2); // Se suma 2 al limite, 1 porque el limite es el índice,
        // no la cant. de registros, +1 para verificar que se
        // supero el límite
        int cant = contratoDao.buscarContratosPaginadosCount(dto, usuLogado);
        result.setResultados(new Long(cant));

        if (cant > limit) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            String mensaje = ms.getMessage("export.contratos.error.resultadoSuperaLimite", new Object[] { new Long(limit) },
                    MessageUtils.DEFAULT_LOCALE);

            result.setCodigoResultado(ObjetoResultado.RESULTADO_ERROR);
            result.setMensajeError(mensaje);

        } else if (cant == 0) {

            AbstractMessageSource ms = MessageUtils.getMessageSource();
            String mensaje = ms.getMessage("export.contratos.error.resultadoVacio", new Object[] {}, MessageUtils.DEFAULT_LOCALE);

            result.setCodigoResultado(ObjetoResultado.RESULTADO_ERROR);
            result.setMensajeError(mensaje);
        } else {
            result.setCodigoResultado(ObjetoResultado.RESULTADO_OK);
        }

        List<ObjetoResultado> l = new ArrayList<ObjetoResultado>(1);
        l.add(result);

        return l;
    }

	private Set<String> getCodigosDeZonaAvanzado(EXTBusquedaContratosDto dto, Usuario usuario) {
		Set<String> zonas;
		if (dto.getCodigoZona() != null
				&& dto.getCodigoZona().trim().length() > 0) {
			List<String> list = Arrays.asList((dto.getCodigoZona().split(",")));
			zonas = new HashSet<String>(list);
		} else {
			zonas = usuario.getCodigoZonas();
		}
		return zonas;
	}

	public Contrato getContraoByNroContrato(String nroContrato) {
		Filter fContrato = genericDao.createFilter(FilterType.EQUALS, "nroContrato", nroContrato);
		return genericDao.get(Contrato.class, fContrato);
	}
}
