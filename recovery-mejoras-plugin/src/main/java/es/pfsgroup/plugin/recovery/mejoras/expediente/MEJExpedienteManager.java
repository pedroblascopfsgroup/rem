package es.pfsgroup.plugin.recovery.mejoras.expediente;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;
import es.capgemini.pfs.arquetipo.dao.ArquetipoDao;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.expediente.dao.ExpedienteContratoDao;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.dao.SancionDao;
import es.capgemini.pfs.expediente.dto.DtoInclusionExclusionContratoExpediente;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.DDDecisionSancion;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.capgemini.pfs.expediente.model.Sancion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.dao.ZonaDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.expediente.dao.MEJEventoDao;

@Component
public class MEJExpedienteManager implements MEJExpedienteApi {

    @Autowired
    private ApiProxyFactory proxyFactory;

    @Autowired
    DynamicElementManager tabManager;

    @Autowired
    private ExpedienteContratoDao expedienteContratoDao;

    @Autowired
    private Executor executor;

    @Autowired
    private ExpedienteDao expedienteDao;
    
    @Autowired
    private ArquetipoDao arquetipoDao;

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private MEJEventoDao eventoDao;
    
    @Autowired
    private ZonaDao zonaDao;
    
    @Autowired
    private SancionDao sancionDao;

    @Override
    @BusinessOperation(PluginMejorasBOConstants.MEJ_BO_EXPEDIENTE_BUTTONS_LEFT)
    public List<DynamicElement> getButtonsConsultaExpedienteLeft() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.mejoras.web.expediente.buttons.left", null);
        if (l == null)
            return new ArrayList<DynamicElement>();
        else
            return l;
    }

    @Override
    @BusinessOperation(PluginMejorasBOConstants.MEJ_BO_EXPEDIENTE_BUTTONS_RIGHT)
    public List<DynamicElement> getButtonsConsultaExpedienteRight() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.mejoras.web.expediente.buttons.right", null);
        if (l == null)
            return new ArrayList<DynamicElement>();
        else
            return l;
    }

    @Override
    @BusinessOperation(PluginMejorasBOConstants.MEJ_BO_EXPEDIENTE_BUTTONS_LEFT_FAST)
    public List<DynamicElement> getButtonsConsultaExpedienteLeftFast() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("entidad.expediente.buttons.left.fast", null);
        if (l == null)
            return new ArrayList<DynamicElement>();
        else
            return l;
    }

    @Override
    @BusinessOperation(PluginMejorasBOConstants.MEJ_BO_EXPEDIENTE_BUTTONS_RIGHT_FAST)
    public List<DynamicElement> getButtonsConsultaExpedienteRightFast() {
        List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("entidad.expediente.buttons.right.fast", null);
        if (l == null)
            return new ArrayList<DynamicElement>();
        else
            return l;
    }

    @Override
    @BusinessOperation(PluginMejorasBOConstants.MEJ_MGR_EXPEDIENTE_TABS_FAST)
    public List<DynamicElement> getTabsExpedienteFast() {
        return tabManager.getDynamicElements("tabs.expediente.fast", null);
    }

    /**
     * Incluye los contratos al expediente.
     * 
     * @param dto
     *            DtoExclusionContratoExpediente
     */
    @Override
    @BusinessOperation(PluginMejorasBOConstants.MEJ_MGR_INCLUIR_CONTRATOS_AL_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void incluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto) {
        List<Contrato> contratos = (List<Contrato>) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET_CONTRATOS_BY_ID, dto.getContratos());
        Expediente expediente = expedienteDao.get(dto.getIdExpediente());
        ExpedienteContrato cex;

        Contrato contrato;
        Cliente cliente;
        for (int i = 0; i < contratos.size(); i++) {
            cex = new ExpedienteContrato();
            contrato = contratos.get(i);
            cex.setContrato(contrato);
            cex.setExpediente(expediente);
            cex.setPase(0);
            DDAmbitoExpediente ambitoExpediente = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDAmbitoExpediente.class,
                    DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION);
            cex.setAmbitoExpediente(ambitoExpediente);
            expedienteContratoDao.save(cex);
            expediente.getContratos().add(cex);

            // Si el contrato es pase de algun cliente, marcamos al cliente como
            // cancelado
            // para que en la próxima carga del batch vuelva a generar el
            // cliente con el contrato
            // de pase que corresponda.
            cliente = (Cliente) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_FIND_CLIENTE_POR_CONTRATO_PASE_ID, contrato.getId());

            if (cliente != null) {
                executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLI_Y_BPM, cliente.getId());
            }

            for (ContratoPersona personaContratoInsertado : getPersonasTitularesContrato(contrato.getId())) {// for1
                if ((personaContratoInsertado.getPersona() != null) && (personaContratoInsertado.getPersona().getId() != null)) { // if1
                    Boolean encontrado = false;
                    for (ExpedientePersona pex : getExpedientePersonas(dto.getIdExpediente())) {// for2
                        if ((pex.getPersona() != null) && pex.getPersona().getId() != null) {
                            if (pex.getPersona().getId().equals(personaContratoInsertado.getPersona().getId())) {
                                encontrado = true;
                                break;
                            }
                        }
                    }// for2
                    if (!encontrado) {
                        incluirEnExpedientePersona(expediente, personaContratoInsertado.getPersona());
                    }
                }// if 1

            }// for1

        }
        expedienteDao.save(expediente);

    }

    /**
     * 
     * @param idExpediente
     * @param idPersona
     *            Incluye en ExpedientePersona los clientes asociados a los
     *            contratos añadidos
     */
    private void incluirEnExpedientePersona(Expediente expediente, Persona persona) {

        ExpedientePersona expedientePersona = new ExpedientePersona();
        expedientePersona.setExpediente(expediente);
        expedientePersona.setPersona(persona);
        // Nuevo método para obtener el arquetipo de una persona
        Arquetipo arq = arquetipoDao.getArquetipoPorPersona(persona.getId());
        DDAmbitoExpediente ambitoExpediente = arq.getItinerario().getAmbitoExpediente();
        expedientePersona.setAmbitoExpediente(ambitoExpediente);
        expedientePersona.setAuditoria(Auditoria.getNewInstance());

        genericDao.save(ExpedientePersona.class, expedientePersona);
    }

    /**
     * Excluye el contrato del expediente.
     * 
     * @param dto
     *            DtoExclusionContratoExpediente
     */
    @Override
    @BusinessOperation(PluginMejorasBOConstants.MEJ_MGR_EXCLUIR_CONTRATOS_AL_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void excluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto) {
        Long idContrato = Long.parseLong(dto.getContratos());
        ExpedienteContrato expedienteContrato = expedienteContratoDao.get(dto.getIdExpediente(), idContrato);
        expedienteContratoDao.delete(expedienteContrato);

        for (ContratoPersona personaContratoEliminado : getPersonasContrato(idContrato)) {// for1
            if ((personaContratoEliminado.getPersona() != null) && (personaContratoEliminado.getPersona().getId() != null)) {// if
                                                                                                                             // 1
                Boolean encontrado = false;
                for (ExpedienteContrato contratoExpediente : getContratosExpediente(dto.getIdExpediente())) {// for2
                    for (ContratoPersona personaContrato : getPersonasContrato(contratoExpediente.getContrato().getId())) {
                        if ((personaContrato.getPersona() != null) && (personaContrato.getPersona().getId() != null)) {
                            if (personaContrato.getPersona().getId().equals(personaContratoEliminado.getPersona().getId())) {
                                encontrado = true;
                                break;
                            }
                        }
                    }
                }// for2
                if (!encontrado) {
                    eventoDao.deletePersonaExpediente(dto.getIdExpediente(), personaContratoEliminado.getPersona().getId());
                }
            }// if 1
        }// for1
    }

    private List<ContratoPersona> getPersonasTitularesContrato(Long idContrato) {
        Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
        Filter filtro = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
        Filter filtroSoloTitulares = genericDao.createFilter(FilterType.EQUALS, "tipoIntervencion.titular", true);

        List<ContratoPersona> lista = genericDao.getList(ContratoPersona.class, filtro, filtroBorrado, filtroSoloTitulares);
        return lista;
    }

    private List<ContratoPersona> getPersonasContrato(Long idContrato) {
        Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
        Filter filtro = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);

        List<ContratoPersona> lista = genericDao.getList(ContratoPersona.class, filtro, filtroBorrado);
        return lista;
    }

    private List<ExpedienteContrato> getContratosExpediente(Long idExpediente) {
        Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
        Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);

        List<ExpedienteContrato> lista = genericDao.getList(ExpedienteContrato.class, filtro, filtroBorrado);

        return lista;
    }

    private List<ExpedientePersona> getExpedientePersonas(Long idExpediente) {
        Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
        Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);

        List<ExpedientePersona> lista = genericDao.getList(ExpedientePersona.class, filtro, filtroBorrado);
        return lista;
    }
    
    @BusinessOperation(OBTENER_ZONAS_JERARQUIA_BY_COD_OR_DESC)
    public List<DDZona> getZonasJerarquiaByCodDesc(Integer idNivel, String codDesc) {
        if (idNivel == null || idNivel.longValue() == 0) { return new ArrayList<DDZona>(); }
        Set<String> codigoZonasUsuario = ((Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO))
                .getCodigoZonas();
        return zonaDao.getZonasJerarquiaByCodDesc(idNivel, codigoZonasUsuario, codDesc);
    }

	@Override
	@Transactional(readOnly = false)
	public void guardaSancionExpediente(Long idExpediente, String codDecionSancion,String observaciones) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idExpediente);
		Expediente exp = genericDao.get(Expediente.class, filtro);
		
		if(!Checks.esNulo(exp)){
			
			Filter filtroSancion = genericDao.createFilter(FilterType.EQUALS, "codigo", codDecionSancion);
			DDDecisionSancion decision = genericDao.get(DDDecisionSancion.class, filtroSancion);
			
			Sancion sancion = new Sancion();
			if(!Checks.esNulo(exp.getSancion())){
				sancion = exp.getSancion();
			}
			
			sancion.setDecision(decision);
			sancion.setObservaciones(observaciones);
			sancion.setAuditoria(Auditoria.getNewInstance());
			sancionDao.saveOrUpdate(sancion);
			
			exp.setSancion(sancion);
			genericDao.save(Expediente.class, exp);
		}
		
		
	}

}
