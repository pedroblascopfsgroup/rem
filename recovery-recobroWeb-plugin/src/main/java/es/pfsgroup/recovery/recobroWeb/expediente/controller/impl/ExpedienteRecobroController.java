package es.pfsgroup.recovery.recobroWeb.expediente.controller.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.AcuerdoContrato;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.RecobroDDTipoPalanca;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.SituacionIncidencia;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.TipoIncidencia;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.acuerdo.AcuerdoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.politica.model.DDMotivo;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.api.GestorEntidadApi;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.api.RecobroAgenciaApi;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroCarteraEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.AcuerdoExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.ExpedienteRecobroDto;
import es.pfsgroup.recovery.recobroCommon.expediente.manager.ExpedienteRecobroApi;
import es.pfsgroup.recovery.recobroCommon.motivos.model.DDMotivoBaja;
import es.pfsgroup.recovery.recobroWeb.expediente.controller.api.ExpedienteRecobroControllerApi;
import es.pfsgroup.recovery.recobroWeb.expediente.dto.ContratoDto;
import es.pfsgroup.recovery.recobroWeb.utils.RecobroWebConstants.RecobroWebExpedienteConstants;

@Controller
public class ExpedienteRecobroController implements	ExpedienteRecobroControllerApi {

	@Autowired
	private ExpedienteRecobroApi expedienteRecobroApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private Executor executor;
	
	@Override
	@RequestMapping
	public String getCabeceraExpedienteRecobro(Long id, ModelMap map) {
		ExpedienteRecobroDto expedienteRecobroDto = expedienteRecobroApi.getCabeceraExpedienteRecobro(id);
		map.put("cabeceraRecobro",expedienteRecobroDto);
		
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_CABECERA_JSON;
	}

	@Override
	@RequestMapping
	public String getListCarteras(Long idEsquema, ModelMap map) {		
		RecobroEsquema esquema = proxyFactory.proxy(RecobroEsquemaApi.class).getRecobroEsquema(idEsquema);
		if (!Checks.esNulo(esquema)) {
			List<RecobroCartera> carteras = new ArrayList<RecobroCartera>();
			
			for (RecobroCarteraEsquema recobroCarteraEsquema : esquema.getCarterasEsquema()) {
				carteras.add(recobroCarteraEsquema.getCartera());
			}
			RecobroCartera empty = new RecobroCartera();
			empty.setId(Long.valueOf(-1));
			empty.setNombre("---");
			carteras.add(0,empty);
			map.put("data", carteras);
		}
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_NOM_JSON;
		
	}

	@Override
	@RequestMapping
	public String getListSubCarteras(Long idEsquema, Long idCartera, ModelMap map) {
		RecobroCarteraEsquema carteraEsquema = proxyFactory.proxy(RecobroCarteraEsquemaApi.class).getRecobroCarteraEsquema(idEsquema, idCartera);
		if (!Checks.esNulo(carteraEsquema)) {
			List<RecobroSubCartera> subCarteras = (List<RecobroSubCartera>) proxyFactory.proxy(RecobroEsquemaApi.class).getSubcarterasCarteraEsquema(carteraEsquema.getId());
			RecobroSubCartera empty = new RecobroSubCartera();
			empty.setId(Long.valueOf(-1));
			empty.setNombre("---");
			subCarteras.add(0,empty);
			map.put("data", subCarteras);
		}
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_NOM_JSON;
		
	}

	@Override
	@RequestMapping
	public String getListEsquemas(ModelMap map) {
		List<RecobroEsquema> recobroEsquemas = proxyFactory.proxy(RecobroEsquemaApi.class).getListaEsquemas();		
		RecobroEsquema empty = new RecobroEsquema();
		empty.setId(Long.valueOf(-1));
		empty.setNombre("---");
		recobroEsquemas.add(0,empty);
		map.put("data", recobroEsquemas);
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_NOM_JSON; 
	}
	
	@Override
	@RequestMapping
	public String getTipoIncidencia(ModelMap map) {	
		List<TipoIncidencia> tipoIncidencia = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(TipoIncidencia.class);
		TipoIncidencia empty = new TipoIncidencia();
		empty.setId(Long.valueOf(-1));
		empty.setCodigo("---");
		empty.setDescripcion("---");
		tipoIncidencia.add(0,empty);
		map.put("data", tipoIncidencia);
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_DICCIONARIO_JSON; 
	}
	
	
	@Override
	@RequestMapping
	public String getSituacionIncidencia(ModelMap map) {	
		List<SituacionIncidencia> situacionIncidencia = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(SituacionIncidencia.class);
		SituacionIncidencia empty = new SituacionIncidencia();
		empty.setId(Long.valueOf(-1));
		empty.setCodigo("---");
		empty.setDescripcion("---");
		situacionIncidencia.add(0,empty);
		map.put("data", situacionIncidencia);
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_DICCIONARIO_JSON; 
	}
	
	@Override
	@RequestMapping
	public String getTipoAcuerdo(ModelMap map) {	
		List<RecobroDDTipoPalanca> tipoAcuerdo = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDTipoPalanca.class);
		RecobroDDTipoPalanca empty = new RecobroDDTipoPalanca();
		empty.setId(Long.valueOf(-1));
		empty.setCodigo("---");
		empty.setDescripcion("---");
		tipoAcuerdo.add(0,empty);
		map.put("data", tipoAcuerdo);
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_DICCIONARIO_JSON; 
	}
	
	@Override
	@RequestMapping
	public String getSolicitante(ModelMap map) {	
		List<DDSolicitante> solicitante = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDSolicitante.class);
		DDSolicitante empty = new DDSolicitante();
		empty.setId(Long.valueOf(-1));
		empty.setCodigo("---");
		empty.setDescripcion("---");
		solicitante.add(0,empty);
		map.put("data", solicitante);
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_DICCIONARIO_JSON; 
	}
	
	@Override
	@RequestMapping
	public String getEstadoAcuerdo(ModelMap map) {	
		List<DDEstadoAcuerdo> estadoAcuerdo = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDEstadoAcuerdo.class);
		DDEstadoAcuerdo empty = new DDEstadoAcuerdo();
		empty.setId(Long.valueOf(-1));
		empty.setCodigo("---");
		empty.setDescripcion("---");
		estadoAcuerdo.add(0,empty);
		map.put("data", estadoAcuerdo);
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_DICCIONARIO_JSON; 
	}

	@Override
	@RequestMapping
	public String getListMotivosBaja(ModelMap map) {
		List<DDMotivoBaja> motivosBaja = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDMotivo.class);
		DDMotivoBaja empty = new DDMotivoBaja();
		empty.setId(Long.valueOf(-1));
		empty.setCodigo("---");
		empty.setDescripcion("---");
		motivosBaja.add(0,empty);
		map.put("data", motivosBaja);
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_DES_JSON;
	}

	@Override
	@RequestMapping
	public String getListAgencias(ModelMap map) {
		List<RecobroAgencia> agencias = proxyFactory.proxy(ExpedienteRecobroApi.class).getAgenciasRecobroUsuario();
		RecobroAgencia empty = new RecobroAgencia();
		empty.setId(Long.valueOf(-1));
		empty.setNombre("---");
		agencias.add(0,empty);
		map.put("data", agencias);		
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_NOM_JSON;
	}

	@Override
	@RequestMapping
	public String getListSupervisores(ModelMap map) {
		EXTDDTipoGestor tipoGestor = (EXTDDTipoGestor) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(EXTDDTipoGestor.class, EXTDDTipoGestor.CODIGO_TIPO_SUPERVISOR_AGENCIA_RECOBRO);
		
		if (!Checks.esNulo(tipoGestor)) {		
			List<Usuario> usuarios = proxyFactory.proxy(GestorEntidadApi.class).getListUsuariosGestoresExpedientePorTipo(tipoGestor.getId());
			Usuario empty = new Usuario();
			empty.setId(Long.valueOf(-1));
			empty.setNombre("---");
			usuarios.add(0,empty);
			map.put("data", usuarios);
		}
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_SUPERVISORES_JSON;
	}

	
	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	@Override
	@RequestMapping
	public String getListSupervisoresAgencia(Long idAgencia, ModelMap map) {
		RecobroAgencia agencia = proxyFactory.proxy(RecobroAgenciaApi.class).getAgencia(idAgencia);
		List<Usuario> usuarios = new ArrayList<Usuario>();
		if (!Checks.esNulo(agencia)) {
			List<GestorDespacho> gestoresDespacho = (List<GestorDespacho>) executor.execute("ADMDespachoExternoManager.getSupervisoresDespacho", agencia.getDespacho().getId());
			for (GestorDespacho gestorDespacho : gestoresDespacho) {
				usuarios.add(gestorDespacho.getUsuario());
			}
		}

		map.put("data", usuarios);
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LIST_SUPERVISORES_JSON;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	public String abreAltaAcuerdo(Long idExpediente, ModelMap map) {
		List<DDSolicitante> solicitantes = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDSolicitante.class);
		List<RecobroDDTipoPalanca> palancasPermitidas = proxyFactory.proxy(ExpedienteRecobroApi.class).buscaPalancasPermitidasExpediente(idExpediente);
		List<DDEstadoAcuerdo> estados = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDEstadoAcuerdo.class);
		Expediente expediente = proxyFactory.proxy(ExpedienteRecobroApi.class).getExpediente(idExpediente);
		
		List<DespachoExterno> despachosExterno = getDespachosRecobroUsuario();
		
		List<ContratoDto> contratos = new ArrayList<ContratoDto>();
		
	    //Obtenemos todos los contratos con riesgo >=0 --> BCFI-492
		List<Contrato> contratosRiesgo = new ArrayList<Contrato>();
		for (Contrato c : expediente.getTodosLosContratos()){
			
			if(c != null && c.getLastMovimiento() != null && c.getLastMovimiento().getRiesgo() >=0 ){
				contratosRiesgo.add(c);
			}
		}
		
		for (Contrato c : contratosRiesgo){
			ContratoDto dto = new ContratoDto();
			dto.setId(c.getId());
			dto.setCodigo(c.getId().toString());
			dto.setDescripcion(c.getCodigoContrato());
			dto.setDescripcionLarga(c.getCodigoContrato());
			contratos.add(dto);
		}
		
		map.put("solicitantes", solicitantes);
		map.put("palancasPermitidas", palancasPermitidas);
		map.put("estados", estados);
		map.put("idExpediente", idExpediente);
		map.put("contratos", contratos);
		map.put("despachosExterno", despachosExterno);
		
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_ALTA_ACUERDO;
	}

	private List<DespachoExterno> getDespachosRecobroUsuario() {
		List<DespachoExterno> despachosExterno = new ArrayList<DespachoExterno>();
		
		Usuario u =proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();		
		if (u.getUsuarioExterno()) {
			List<GestorDespacho> gestores =  (List<GestorDespacho>) executor.execute("despachoExternoManager.buscaDespachosPorUsuarioYTipo", u.getId(), DDTipoDespachoExterno.CODIGO_AGENCIA_RECOBRO);
		
			for (GestorDespacho d : gestores){
				despachosExterno.add(d.getDespachoExterno());
			}
		} else {
			despachosExterno =  (List<DespachoExterno>) executor.execute("despachoExternoManager.getDespachosPorTipoZona", convertirEnStringComas(u.getZonas()), DDTipoDespachoExterno.CODIGO_AGENCIA_RECOBRO);
		}

		return despachosExterno;
	}
	
	private Object convertirEnStringComas(List<DDZona> zonas) {
		String r = null;
		for (DDZona z : zonas){
			if (!Checks.esNulo(r)){
				r = r + ',' + z.getCodigo();
			}else{
				r = z.getCodigo();
			}
		}
		return r;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	public String getAcuerdosExpediente(Long idExpediente, ModelMap map) {
		List<Acuerdo> acuerdos = proxyFactory.proxy(ExpedienteRecobroApi.class).getAcuerdosExpediente(idExpediente);
		map.put("acuerdos", acuerdos);
		
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_LISTAACUERDOS_JSON;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	public String guardarAcuerdoExpediente(AcuerdoExpedienteDto dto,
			ModelMap map) {
		proxyFactory.proxy(ExpedienteRecobroApi.class).guardarAcuerdoExpediente(dto);
		return "default";
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	public String proponerAcuerdo(Long idAcuerdo, ModelMap map) {
		proxyFactory.proxy(ExpedienteRecobroApi.class).proponerAcuerdo(idAcuerdo);
		return "default";
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	public String cancelarAcuerdo(Long idAcuerdo, ModelMap map) {
		proxyFactory.proxy(ExpedienteRecobroApi.class).cancelarAcuerdo(idAcuerdo);
		return "default";
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	public String abreEdicionAcuerdo(Long idExpediente, Long idAcuerdo,
			ModelMap map) {
		List<DDSolicitante> solicitantes = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDSolicitante.class);
		List<RecobroDDTipoPalanca> palancasPermitidas = proxyFactory.proxy(ExpedienteRecobroApi.class).buscaPalancasPermitidasExpediente(idExpediente);
		List<DDEstadoAcuerdo> estados = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(DDEstadoAcuerdo.class);
		Expediente expediente = proxyFactory.proxy(ExpedienteRecobroApi.class).getExpediente(idExpediente);
		
		List<DespachoExterno> despachosExterno = getDespachosRecobroUsuario();
		
		 //Obtenemos todos los contratos con riesgo >=0 --> BCFI-492
		List<Contrato> contratosRiesgo = new ArrayList<Contrato>();
		for (Contrato c : expediente.getTodosLosContratos()){
			
			if(c != null && c.getLastMovimiento() != null && c.getLastMovimiento().getRiesgo() >=0 ){
				contratosRiesgo.add(c);
			}
		}
		
		List<ContratoDto> contratos = new ArrayList<ContratoDto>();
		for (Contrato c : contratosRiesgo){
			ContratoDto dto = new ContratoDto();
			dto.setId(c.getId());
			dto.setCodigo(c.getId().toString());
			dto.setDescripcion(c.getCodigoContrato());
			dto.setDescripcionLarga(c.getCodigoContrato());
			contratos.add(dto);
		}
		Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(idAcuerdo);
		String contratosAcuerdo="";
		if (!Checks.esNulo(acuerdo.getContratos()) && !Checks.estaVacio(acuerdo.getContratos())){
			for (AcuerdoContrato ac : acuerdo.getContratos()){
				if (contratosAcuerdo.equals("")){
					contratosAcuerdo=contratosAcuerdo+ac.getContrato().getId();
				} else {
					contratosAcuerdo=contratosAcuerdo+","+ac.getContrato().getId();
				}
			}
		}
		
		map.put("solicitantes", solicitantes);
		map.put("palancasPermitidas", palancasPermitidas);
		map.put("estados", estados);
		map.put("idExpediente", idExpediente);
		map.put("contratos", contratos);
		map.put("acuerdo", acuerdo);
		map.put("contratosAcuerdo", contratosAcuerdo);
		map.put("despachosExterno", despachosExterno);
		
		return RecobroWebExpedienteConstants.RECOBROWEB_EXPEDIENTERECOBRO_ALTA_ACUERDO;
	}

}
