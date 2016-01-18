package es.pfsgroup.plugin.precontencioso.burofax.manager;

import java.io.File;
import java.io.InputStream;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.dao.ContratoPersonaManualDao;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.contrato.model.ContratoPersonaManual;
import es.capgemini.pfs.contrato.model.DDTipoIntervencion;
import es.capgemini.pfs.contrato.model.DDTipoProductoEntidad;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.direccion.api.DireccionApi;
import es.capgemini.pfs.direccion.dto.DireccionAltaDto;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.persona.dao.PersonaManualDao;
import es.capgemini.pfs.persona.dto.DtoPersonaManual;
import es.capgemini.pfs.persona.model.DDPropietario;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.persona.model.PersonaManual;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContext;
import es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi;
import es.pfsgroup.plugin.precontencioso.burofax.api.DocumentoBurofaxApi;
import es.pfsgroup.plugin.precontencioso.burofax.dao.BurofaxDao;
import es.pfsgroup.plugin.precontencioso.burofax.dto.ContratosPCODto;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxEnvioIntegracionPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDEstadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDResultadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDTipoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.ProcedimientoBurofaxTipoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ProcedimientoPcoApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.LiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.manager.LiquidacionManager;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienEntidad;
import es.pfsgroup.recovery.geninformes.GENINFInformesManager;

@Service
public class BurofaxManager implements BurofaxApi {

	@Autowired
	private BurofaxDao burofaxDao;
	
	@Autowired
	private LiquidacionManager liquidacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GENINFInformesManager informesManager;
	
	@Autowired
	PrecontenciosoProjectContext precontenciosoContext;
	
	@Autowired
	ProcedimientoManager procedimientoManager;
	
	@Autowired
	ProcedimientoPcoApi procedimientoPcoApi;
	
	@Autowired
	LiquidacionDao liquidacionDao; 
	
	@Autowired
	ParametrizacionDao parametrizacionDao;
	
	@Autowired
	private PersonaManualDao personaManualDao;
	
	@Autowired
	private ContratoPersonaManualDao contratoPersonaManualDao;
	
	@Autowired 
	private DictionaryManager dictionaryManager;

	@Autowired
	DocumentoBurofaxApi docBurManager;
	
	@Autowired
	private DireccionApi direccionApi;

	@Resource
	private MessageService messageService;
	
	private final Log logger = LogFactory.getLog(getClass());
	private final String DIRECTORIO_PDF_BUROFAX_PCO = "directorioPdfBurofaxPCO";
	private final String FICHERO_DOCUMENTO_RANKIA = "RBANKIA"; 

	@Override
	@BusinessOperation(TIPO_BUROFAX_DEFAULT)
	public DDTipoBurofaxPCO getTipoBurofaxPorDefecto(Long idProcedimientoPCO,Long idContrato){
		
		ProcedimientoBurofaxTipoPCO  procedimientoBurofaxTipoPCO=null;
		
		try{
		
			Contrato contrato=null;
			
			//1ºObtengo el procedimiento a partir de su id
			//Procedimiento procedimiento=proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idProcedimientoPCO);
			ProcedimientoPCO procedimientoPCO=(ProcedimientoPCO) genericDao.get(ProcedimientoPCO.class,filtro);
			
			Procedimiento procedimiento=procedimientoPCO.getProcedimiento();
			
			//2ºObtenemos una lista de ProcedimientosContratosExpedientes
			List<ProcedimientoContratoExpediente> listaPrcCntExp=null;
			if(!Checks.esNulo(procedimiento)){
				listaPrcCntExp=procedimiento.getProcedimientosContratosExpedientes();
			}
			
			//3ºObtengo el contrato a partir de su id
			if(!Checks.esNulo(listaPrcCntExp)){
				for(ProcedimientoContratoExpediente prcCntExp : listaPrcCntExp){
					if(prcCntExp.getExpedienteContrato().getContrato().getId().equals(idContrato)){
						contrato=prcCntExp.getExpedienteContrato().getContrato();
						break;
					}
					
				}
			}
			
			//4ºObtenemos el dd_tpe_id
			DDTipoProductoEntidad tipoProductoEntidad=null;
			if(!Checks.esNulo(contrato)){
				tipoProductoEntidad=contrato.getTipoProductoEntidad();
			}
			
			//5ºObtenemos el tipo de burofax
			if(!Checks.esNulo(procedimiento) && !Checks.esNulo(procedimiento.getTipoProcedimiento()) && !Checks.esNulo(tipoProductoEntidad)){
				Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.id", procedimiento.getTipoProcedimiento().getId());
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoProductoEntidad.id", tipoProductoEntidad.getId());
				
				procedimientoBurofaxTipoPCO=(ProcedimientoBurofaxTipoPCO) genericDao.get(ProcedimientoBurofaxTipoPCO.class,filtro1, filtro2);
			}

		}catch(Exception e){
			logger.error("getTipoBurofaxPorDefecto: " + e);
		}
		
		if(!Checks.esNulo(procedimientoBurofaxTipoPCO)){
			return procedimientoBurofaxTipoPCO.getTipoBurofax();
		}
		else
		{
			return null;
		}
	}
	
	@Override
	@BusinessOperation(OBTENER_CONTRATO)
	public Contrato getContrato(Long idContrato){
		
		Contrato contrato=null;
		
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idContrato);
			
			contrato=genericDao.get(Contrato.class,filtro1);
		}catch(Exception e){
			logger.error("getContrato: " + e);
		}
		
		return contrato;
	}
	
	@Override
	@BusinessOperation(OBTENER_LISTA_BUROFAX)
	@Transactional(readOnly = false)
	public List<BurofaxPCO> getListaBurofaxPCO(Long idProcedimiento){
		List<BurofaxPCO> listaBurofax=null;
		
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "procedimientoPCO.id", idProcedimiento); //original
			
			listaBurofax=(List<BurofaxPCO>) genericDao.getList(BurofaxPCO.class,filtro1); //original
		}catch(Exception e){
			logger.error("getListaBurofaxPCO: " + e);
		}
		return listaBurofax;
	}
	
	@Override
	public List<ContratosPCODto> getContratosProcPersona(Long idProcedimientoPCO, Long idPersona, Boolean manual) {
		return burofaxDao.getContratosProcPersona(idProcedimientoPCO, idPersona, manual);
	}
	
	@Override
	@BusinessOperation(GUARDA_DIRECCION)
	public Long guardaDireccion(DireccionAltaDto dto){
		
		Long idDireccion=null;
		
		try {
			idDireccion = proxyFactory.proxy(DireccionApi.class).guardarDireccionRetornaId(dto);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("guardaDireccion: " + e);
		}
		return idDireccion;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(DICCIONARIO_TIPO_BUROFAX)
	public List<DDTipoBurofaxPCO> getTiposBurofaxex(){
		List<DDTipoBurofaxPCO> dicionarioBurofax=new ArrayList<DDTipoBurofaxPCO>();
		try {
			dicionarioBurofax = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDTipoBurofaxPCO.class);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("getTiposBurofaxex: " + e);
		}
		
		return dicionarioBurofax;
		
	}
	
	@Transactional(readOnly = false)
	@BusinessOperation(CONFIGURA_TIPO_BUROFAX)
	@Override
	public List<EnvioBurofaxPCO> configurarTipoBurofax(Long idTipoBurofax,String[] arrayIdDirecciones,String[] arrayIdBurofax,String[] arrayIdEnvios, Long idDocumento){
			
		List<EnvioBurofaxPCO> listaEnvioBurofax=new ArrayList<EnvioBurofaxPCO>(); 
		Filter borrado = genericDao.createFilter(FilterType.EQUALS, "borrado", false);
						
		try{
			
			for(int i=0;i<arrayIdDirecciones.length;i++){
				
				if(!Checks.esNulo(arrayIdDirecciones[i])){
				
					Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoBurofaxPCO.NO_NOTIFICADO);
					DDEstadoBurofaxPCO estadoBurofaxPCO=(DDEstadoBurofaxPCO) genericDao.get(DDEstadoBurofaxPCO.class,filtro1, borrado);
					
					Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoBurofaxPCO.ESTADO_PREPARADO);
					DDResultadoBurofaxPCO resultadoBurofaxPCO=(DDResultadoBurofaxPCO) genericDao.get(DDResultadoBurofaxPCO.class,filtro2, borrado);
					
					Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "id", idTipoBurofax);
						DDTipoBurofaxPCO tipoBurofax=(DDTipoBurofaxPCO) genericDao.get(DDTipoBurofaxPCO.class,filtro3, borrado);
					
					Filter filtro4 = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(arrayIdBurofax[i]));
						BurofaxPCO burofax=(BurofaxPCO) genericDao.get(BurofaxPCO.class,filtro4, borrado);
					
					Filter filtro5 = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(arrayIdDirecciones[i]));
						Direccion direccion=(Direccion) genericDao.get(Direccion.class,filtro5, borrado);
					
					burofax.setEstadoBurofax(estadoBurofaxPCO);
					
					EnvioBurofaxPCO envio=null;
					//Si id Envio Existe actualizamos el envio
					if(!Checks.esNulo(arrayIdEnvios) && !arrayIdEnvios[i].equals("-1")){
						Filter filtro6 = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(arrayIdEnvios[i]));
							envio=(EnvioBurofaxPCO) genericDao.get(EnvioBurofaxPCO.class,filtro6, borrado);
						
					}
					
					//Si idEnvio=-1 Creamos un nuevo envio
					else{
						envio=new EnvioBurofaxPCO();	
						
					}
					//Comun
					envio.setBurofax(burofax);
					envio.setDireccion(direccion);
					envio.setTipoBurofax(tipoBurofax);	
					//envio.setContenidoBurofax(tipoBurofax.getPlantilla());
						envio.setContenidoBurofax(docBurManager.replaceVariablesGeneracionBurofax(burofax.getId(),tipoBurofax.getPlantilla()));
					envio.setResultadoBurofax(resultadoBurofaxPCO);
					
					//Guardamos nuevo envio
					genericDao.save(EnvioBurofaxPCO.class,envio);
					listaEnvioBurofax.add(envio);
				}
			}	
			
			
			
		}catch(Exception e){
			logger.error("configurarTipoBurofax: " + e);
		}
		
		return listaEnvioBurofax;
		
	}
	
	@Override
	@BusinessOperation(OBTENER_CONTENIDO_BUROFAX)
	public String obtenerContenidoBurofax(Long idEnvio){
		
			String contenido="";
		
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idEnvio);
			EnvioBurofaxPCO envioBurofax=(EnvioBurofaxPCO) genericDao.get(EnvioBurofaxPCO.class,filtro1);
			
			contenido= envioBurofax.getContenidoBurofax();
			
		}catch(Exception e){
			logger.error("obtenerContenidoBurofax: " + e);
		}
		
		return contenido;
		
	}
	
	@Transactional(readOnly = false)
	@Override
	@BusinessOperation(CONFIGURAR_CONTENIDO_BUROFAX)
	public void configurarContenidoBurofax(Long idEnvio,String contenido){
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idEnvio);
			EnvioBurofaxPCO envioBurofax=(EnvioBurofaxPCO) genericDao.get(EnvioBurofaxPCO.class,filtro1);
			contenido = contenido.replace("<br>", "<br/>");
			envioBurofax.setContenidoBurofax(contenido);
			
			genericDao.save(EnvioBurofaxPCO.class,envioBurofax);
		}catch(Exception e){
			logger.error("configurarContenidoBurofax: " + e);
		}
	}
	
	@Override
	@BusinessOperation(OBTENER_PERSONA)
	public Persona getPersonaById(Long idPersona){
		
		Persona persona=null;
		
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idPersona);
			persona=(Persona) genericDao.get(Persona.class,filtro1);
			
		}catch(Exception e){
			logger.error("getPersonaById: "+ e);
		}
		
		return persona;
	}
	
	@BusinessOperation(CANCELAR_EST_PREPARADO)
	@Transactional(readOnly = false)
	public void cancelarEnEstPrep(Long idEnvio, Long idCliente){
		try{
			genericDao.deleteById(EnvioBurofaxPCO.class, idEnvio);
			
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "envioId", idEnvio);
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			for(BurofaxEnvioIntegracionPCO envioIntegracionPCO : genericDao.getList(BurofaxEnvioIntegracionPCO.class, filtro1, filtro2)) {
				envioIntegracionPCO.getAuditoria().setBorrado(true);
				envioIntegracionPCO.getAuditoria().setFechaBorrar(new Date());
				envioIntegracionPCO.getAuditoria().setUsuarioBorrar(SecurityUtils.getCurrentUser().getUsername());
				
				genericDao.save(BurofaxEnvioIntegracionPCO.class, envioIntegracionPCO);
			}
		}
		catch(Exception e){
			logger.error(e);
		}
	}
	
	@SuppressWarnings("unchecked")
	@BusinessOperation(DESCARTAR_PERSONA_ENVIO)
	@Transactional(readOnly = false)
	public void descartarPersona(Long idBurofax){
		List<BurofaxPCO> listaBurofax=null;
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoBurofaxPCO.DESCARTADA);
		DDEstadoBurofaxPCO estadoBurofax=(DDEstadoBurofaxPCO) genericDao.get(DDEstadoBurofaxPCO.class,filtro1);
		try{
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idBurofax);
			listaBurofax=(List<BurofaxPCO>) genericDao.getList(BurofaxPCO.class,filtro);
			Iterator<BurofaxPCO> it=listaBurofax.iterator();
			BurofaxPCO burofax = new BurofaxPCO();
			int total = listaBurofax.size();
			for(int i=0; i<total; i++){
				burofax=listaBurofax.get(i);
				burofax.setEstadoBurofax(estadoBurofax);
				burofaxDao.save(burofax);
			}
		}catch(Exception e){
			logger.error(e);
		}
	}
	
	public boolean saberOrigen(Long idDireccion){
		boolean variable = false;
		try{
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idDireccion);
			Direccion direccion = (Direccion)  genericDao.get(Direccion.class, filtro);
			if(direccion.getOrigen().equalsIgnoreCase("Manual")){
				variable = true;
			}
		}catch(Exception e){
			logger.error(e);
		}
		return variable;
	}
	@BusinessOperation(BORRAR_DIRECCION_MANUAL_BUROFAX)
	@Transactional(readOnly = false)
	public void borrarDireccionManualBurofax(Long idDireccion){
		try{
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idDireccion);
			Direccion direccion = (Direccion)  genericDao.get(Direccion.class, filtro);
			if(direccion.getOrigen().equalsIgnoreCase("Manual")){//si es manual hay que borrarla
				genericDao.deleteById(Direccion.class, idDireccion);
			}else{
				throw new UserException(messageService.getMessage("plugin.precontencioso.grid.burofax.mensaje.noBorrarAutomatica", null));
			}
			
		}catch(Exception e){
			logger.error("borrarDireccionManualBurofax: " + e);
		}
		
	}
	
	@BusinessOperation(GUARDA_PERSONA)
	@Transactional(readOnly = false)
	public void guardaPersonaCreandoBurofax(Long idPersona,Long idProcedimiento){
		try{
			
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idPersona);
			Persona persona=(Persona) genericDao.get(Persona.class,filtro1);
			
			filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento);
			ProcedimientoPCO procedimientoPCO=(ProcedimientoPCO) genericDao.get(ProcedimientoPCO.class,filtro1);
			
			filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoBurofaxPCO.NO_NOTIFICADO);
			DDEstadoBurofaxPCO estado=(DDEstadoBurofaxPCO) genericDao.get(DDEstadoBurofaxPCO.class,filtro1);
			
			for(ContratoPersona contratoPersona : persona.getContratosPersona()){
			
				BurofaxPCO burofax=new BurofaxPCO();
				burofax.setDemandado(persona);
				burofax.setProcedimientoPCO(procedimientoPCO);
				burofax.setEstadoBurofax(estado);
				burofax.setContrato(contratoPersona.getContrato());
				burofax.setTipoIntervencion(contratoPersona.getTipoIntervencion());
				burofaxDao.save(burofax);
			}
			
			
		}catch(Exception e){
			logger.error("guardaPersonaCreandoBurofax: " + e);
		}
	}
	
	
	@Override
	@BusinessOperation(OBTENER_PERSONAS_CON_DIRECCION)
	public Collection<? extends Persona> getPersonasConDireccion(String query){
		return burofaxDao.getPersonasConDireccion(query);
	}
	
	@Override
	@BusinessOperation(OBTENER_PERSONAS)
	public Collection<? extends Persona> getPersonas(String query){
		return burofaxDao.getPersonas(query);
	}
	
	@Override
	@BusinessOperation(OBTENER_PERSONAS_CON_CONTRATO)
	public Collection<DtoPersonaManual> getPersonasConContrato(String query){
		return burofaxDao.getPersonasConContrato(query);
	}
	
	@Override
	public Collection<DtoPersonaManual> getPersonasConContrato(String query, boolean addManuales){
		return burofaxDao.getPersonasConContrato(query, addManuales);
	}	
	
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(GUARDAR_ENVIO_BUROFAX)
	public void guardarEnvioBurofax(Boolean certificado,List<EnvioBurofaxPCO> listaEnvioBurofaxPCO){
		
		try{

			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoBurofaxPCO.ESTADO_SOLICITADO);
			DDResultadoBurofaxPCO resultado=(DDResultadoBurofaxPCO) genericDao.get(DDResultadoBurofaxPCO.class,filtro1);
			
			for(EnvioBurofaxPCO envioBurofax : listaEnvioBurofaxPCO){
				
				String contenidoParseadoIntermedio = "";
				
				if(Checks.esNulo(envioBurofax.getResultadoBurofax()) || 
						(!Checks.esNulo(envioBurofax.getResultadoBurofax()) && !envioBurofax.getResultadoBurofax().getCodigo().equals(DDResultadoBurofaxPCO.ESTADO_PREPARADO))){
					contenidoParseadoIntermedio = docBurManager.replaceVariablesGeneracionBurofax(envioBurofax.getBurofax().getId(), envioBurofax.getTipoBurofax().getPlantilla());
				} else {
					contenidoParseadoIntermedio = envioBurofax.getContenidoBurofax();
				}
				envioBurofax.setResultadoBurofax(resultado);
				envioBurofax.setFechaSolicitud(new Date());
				HashMap<String, Object> mapeoVariables = docBurManager.obtenerMapeoVariables(envioBurofax);
				
				String contenidoParseadoFinal = docBurManager.parseoFinalBurofax(contenidoParseadoIntermedio, mapeoVariables);
				
				envioBurofax.setContenidoBurofax(contenidoParseadoFinal);
				genericDao.save(EnvioBurofaxPCO.class, envioBurofax);
				
				BurofaxEnvioIntegracionPCO envioIntegracion=new BurofaxEnvioIntegracionPCO();
				envioIntegracion.setEnvioId(envioBurofax.getId());
				envioIntegracion.setBurofaxId(envioBurofax.getBurofax().getId());
				envioIntegracion.setDireccionId(envioBurofax.getDireccion().getId());
				envioIntegracion.setPersonaId(envioBurofax.getBurofax().getDemandado().getId());
				
				envioIntegracion.setCliente(envioBurofax.getBurofax().getDemandado().getApellidoNombre());
				envioIntegracion.setDireccion(envioBurofax.getDireccion().getDomicilio());
				if(!Checks.esNulo(envioBurofax.getBurofax().getContrato())){
					envioIntegracion.setContrato(envioBurofax.getBurofax().getContrato().getNroContrato());
				} else {
					envioIntegracion.setContrato(null);
				}
				envioIntegracion.setTipoBurofax(envioBurofax.getTipoBurofax().getDescripcion());
				envioIntegracion.setFechaSolicitud(new Date());
				envioIntegracion.setFechaEnvio(new Date());
				envioIntegracion.setFechaAcuse(new Date());
				envioIntegracion.setCertificado(certificado);
				
				envioIntegracion.setContenido(contenidoParseadoFinal);
		
				if (precontenciosoContext.isGenerarArchivoBurofax()) {
					//Obtener cabecera 
					String cabecera = docBurManager.obtenerCabecera(mapeoVariables);
					// Obtener plantilla
					InputStream plantillaBurofax = docBurManager.obtenerPlantillaBurofax();
					// Obtener nombre de fichero
					String nombreFichero = obtenerNombreFichero();
					//Generar documento a partir de la plantilla y de los campos HTML cabecera y contenido
					FileItem archivoBurofax = docBurManager.generarDocumentoBurofax(plantillaBurofax, nombreFichero, cabecera, contenidoParseadoFinal);
					// Transformar el archivo docx en PDF
					String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PDF_BUROFAX_PCO).getValor();
					String nombreFicheroPdf = docBurManager.obtenerNombreFicheroPdf(nombreFichero);
					File archivoBurofaxPDF = docBurManager.convertirAPdf(archivoBurofax, directorio + File.separator + nombreFicheroPdf);
					FileItem fi = new FileItem();
					fi.setFile(archivoBurofaxPDF);
					fi.setFileName(nombreFicheroPdf);
					fi.setContentType("application/pdf");
					fi.setLength(archivoBurofaxPDF.length());
					
					//envioIntegracion.setArchivoBurofax(fi);
					envioIntegracion.setNombreFichero(nombreFicheroPdf);
					envioIntegracion.setIdAsunto(envioBurofax.getBurofax().getProcedimientoPCO().getProcedimiento().getAsunto().getId());
					
				} else {
					//envioIntegracion.setArchivoBurofax(new FileItem(File.createTempFile("TMP", ".log")));
					envioIntegracion.setContenido(envioBurofax.getContenidoBurofax());
				}

				genericDao.save(BurofaxEnvioIntegracionPCO.class, envioIntegracion);
			}
		} catch (Exception e) {
			logger.error("guardarEnvioBurofax: " + e);
		}
		
	}
	
	private String obtenerNombreFichero() {
		Long secuencia = burofaxDao.obtenerSecuenciaFicheroDocBurofax();
		return FICHERO_DOCUMENTO_RANKIA+String.format("%011d", secuencia)+".docx";
	}
	

	
	public FileItem generarDocumentoBurofax(EnvioBurofaxPCO envioBurofax){
		
		FileItem archivoBurofax=null;
		
		try{
		
			String nombre="";
			if(!Checks.esNulo(envioBurofax.getBurofax().getDemandado().getNombre())){
				nombre=envioBurofax.getBurofax().getDemandado().getNombre();
			}
			String apellido1="";
			if(!Checks.esNulo(envioBurofax.getBurofax().getDemandado().getApellido1())){
				apellido1=envioBurofax.getBurofax().getDemandado().getApellido1();
			}
			String apellido2="";
			if(!Checks.esNulo(envioBurofax.getBurofax().getDemandado().getApellido2())){
				apellido2=envioBurofax.getBurofax().getDemandado().getApellido2();
			}
			String domicilio=envioBurofax.getDireccion().toString();
			InputStream is = null;
			if("BANKIA".equals(precontenciosoContext.getRecovery())){
				is=informesManager.createPdfFileFromHtmlText(
						"<table width='60%' style='font-size:12px'>"
						+ "<tr>"
						+ "<td width='40' style='border:1px solid black'>BANKIA S.A<br />PASEO DE LA CASTELLANA, 189<br />28046 Madrid</td>"
						+ "<td width='20' style='border-style: hidden'></td>"
						+ "<td width='40' style='border:1px solid black'>"+nombre.concat(" "+apellido1).concat(" "+apellido2)+"<br />"+domicilio+"</td>"
						+ "</tr>"
						+ "</table><br />"
						+ "<table width='60%' style='font-size:12px'>"
						+ "<tr>"
						+ "<td style='border:1px solid black'>"+envioBurofax.getContenidoBurofax()+"</td>"
						+ "</tr>"
						+ "</table>",
						envioBurofax.getBurofax().getDemandado().getApellidoNombre());
			} else {
				is=informesManager.createPdfFileFromHtmlText(					
						"<table width='60%' style='font-size:12px'>"
						+ "<tr>"
						+ "<td style='border:1px solid black'>"+envioBurofax.getContenidoBurofax()+"</td>"
						+ "</tr>"
						+ "</table>",
						envioBurofax.getBurofax().getDemandado().getApellidoNombre());
			}
			
	
			String nombreFichero=envioBurofax.getBurofax().getDemandado().getApellidoNombre();
		
		
			HashMap<String, Object> mapaVariables=new HashMap<String, Object>();
			
			if(!Checks.esNulo(envioBurofax.getBurofax().getContrato()) && !Checks.esNulo(envioBurofax.getBurofax().getContrato().getAplicativoOrigen())){
				mapaVariables.put("origenContrato",envioBurofax.getBurofax().getContrato().getAplicativoOrigen().getDescripcion());
			}
			else{
				mapaVariables.put("origenContrato","[ERROR - No existe valor]");
			}
			if(!Checks.esNulo(envioBurofax.getBurofax().getContrato().getNroContratoFormat())){
				mapaVariables.put("numeroContrato", envioBurofax.getBurofax().getContrato().getNroContratoFormat());
			}
			else{
				mapaVariables.put("numeroContrato","[ERROR - No existe valor]");
			}
			if(!Checks.esNulo(envioBurofax.getBurofax().getContrato()) && !Checks.esNulo(envioBurofax.getBurofax().getContrato().getFirstMovimiento())
					&& !Checks.esNulo(envioBurofax.getBurofax().getContrato().getFirstMovimiento().getFechaPosVencida())){
				SimpleDateFormat fechaFormat = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY,MessageUtils.DEFAULT_LOCALE);
				mapaVariables.put("fechaPosicionVencida",fechaFormat.format(envioBurofax.getBurofax().getContrato().getFirstMovimiento().getFechaPosVencida()));
			}
			else{
				mapaVariables.put("fechaPosicionVencida","[ERROR - No existe valor]");
			}
			if(!Checks.esNulo(envioBurofax.getBurofax().getTipoIntervencion())){
				mapaVariables.put("tipoIntervencion",envioBurofax.getBurofax().getTipoIntervencion().getDescripcion());
			}
			else{
				mapaVariables.put("tipoIntervencion","[ERROR - No existe valor]");
			}
			if(!Checks.esNulo(envioBurofax.getBurofax().getContrato()) && !Checks.esNulo(envioBurofax.getBurofax().getContrato().getEntidadOrigen())){
				mapaVariables.put("entidadOrigen",envioBurofax.getBurofax().getContrato().getEntidadOrigen());
			}
			else{
				mapaVariables.put("entidadOrigen","[ERROR - No existe valor]");
			}
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "contrato.id", envioBurofax.getBurofax().getContrato().getId());
			LiquidacionPCO liquidacion = genericDao.get(LiquidacionPCO.class, filtro);
			
			if(!Checks.esNulo(liquidacion) && !Checks.esNulo(liquidacion.getFechaConfirmacion())){
				SimpleDateFormat fechaFormat = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY,MessageUtils.DEFAULT_LOCALE);
				mapaVariables.put("fechaLiquidacion",fechaFormat.format(liquidacion.getFechaConfirmacion()));
			}
			else{
				mapaVariables.put("fechaLiquidacion","[ERROR - No existe valor]");
			}
			
			if(!Checks.esNulo(liquidacion) && !Checks.esNulo(liquidacion.getTotal())){
				mapaVariables.put("totalLiq",NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(liquidacion.getTotal()));
			}
			else{
				mapaVariables.put("totalLiq","[ERROR - No existe valor]");
			}
			
			///Variables especificas BANKIA
			LiquidacionPCO liquPCO = liquidacionDao.getLiquidacionDelContrato(envioBurofax.getBurofax().getContrato().getId());
			
			if(!Checks.esNulo(envioBurofax.getBurofax().getContrato().getNroContratoFormat())){
				mapaVariables.put("CODIGO_DE_CONTRATO_DE_17_DIGITOS", envioBurofax.getBurofax().getContrato().getNroContratoFormat());
			}
			else{
				mapaVariables.put("CODIGO_DE_CONTRATO_DE_17_DIGITOS","[ERROR - No existe valor]");
			}
			
			
			if(!Checks.esNulo(envioBurofax.getBurofax().getContrato().getMovimientos())){
				List<Movimiento> movimientos = envioBurofax.getBurofax().getContrato().getMovimientos(); 
				if(movimientos.size()>0 && !Checks.esNulo(movimientos.get(movimientos.size() - 1).getFechaPosVencida())){
					SimpleDateFormat fechaFormat = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY,MessageUtils.DEFAULT_LOCALE);
					mapaVariables.put("MOV_FECHA_POS_VIVA_VENCIDA", fechaFormat.format(movimientos.get(movimientos.size() - 1).getFechaPosVencida()));	
				}else{
					mapaVariables.put("MOV_FECHA_POS_VIVA_VENCIDA","[ERROR - No existe valor]");
				}
			}
			else{
				mapaVariables.put("MOV_FECHA_POS_VIVA_VENCIDA","[ERROR - No existe valor]");
			}
			
			if(!Checks.esNulo(liquPCO) && !Checks.esNulo(liquPCO.getFechaCierre())){
				SimpleDateFormat fechaFormat = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY,MessageUtils.DEFAULT_LOCALE);
				mapaVariables.put("FECHA_CIERRE_LIQUIDACION",fechaFormat.format(liquPCO.getFechaCierre()));
			}
			else{
				mapaVariables.put("FECHA_CIERRE_LIQUIDACION","[ERROR - No existe valor]");
			}
			
			
			if(!Checks.esNulo(liquPCO) && (!Checks.esNulo(liquPCO.getTotal()) || !Checks.esNulo(liquPCO.getTotalOriginal()))){
				if(!Checks.esNulo(liquPCO.getTotal())){
					mapaVariables.put("TOTAL_LIQUIDACION",NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(liquPCO.getTotal()));
				}else{
					mapaVariables.put("TOTAL_LIQUIDACION",NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(liquPCO.getTotalOriginal()));
				}
			}
			else{
				mapaVariables.put("TOTAL_LIQUIDACION","[ERROR - No existe valor]");
			}
			
			
			if(!Checks.esNulo(envioBurofax.getBurofax().getContrato()) && !Checks.esNulo(envioBurofax.getBurofax().getContrato().getContratoAnterior()) && !envioBurofax.getBurofax().getContrato().getContratoAnterior().equals("0")){
				mapaVariables.put("NUM_CUENTA_ANTERIOR",envioBurofax.getBurofax().getContrato().getContratoAnterior());
			}
			else{
				mapaVariables.put("NUM_CUENTA_ANTERIOR","[ERROR - No existe valor]");
			}
			
			
			if(!Checks.esNulo(envioBurofax.getBurofax().getContrato()) && envioBurofax.getBurofax().getContrato().getContratoPersonaOrdenado().size()>0 ){
				
				ContratoPersona cntPers = envioBurofax.getBurofax().getContrato().getContratoPersonaOrdenado().get(0);
				mapaVariables.put("TITULAR_ORDEN_MENOR_CONTRATO",cntPers.getPersona().getNombre()+" "+cntPers.getPersona().getApellido1()+" "+cntPers.getPersona().getApellido2());
			}
			else{
				mapaVariables.put("TITULAR_ORDEN_MENOR_CONTRATO","[ERROR - No existe valor]");
			}
			
			if(envioBurofax.getBurofax().getTipoIntervencion().getCodigo().equals(DDTipoIntervencion.CODIGO_TITULAR_REGISTRAL)){
				List<Bien> bienes = procedimientoManager.getBienesDeUnProcedimiento(envioBurofax.getBurofax().getProcedimientoPCO().getProcedimiento().getId());
				List<NMBBienEntidad> bienesNMBBienEntidad = new ArrayList<NMBBienEntidad>();
				
				for(Bien bien : bienes){
					NMBBien nmb = genericDao.get(NMBBien.class, genericDao.createFilter(FilterType.EQUALS, "id", bien.getId()));
					if(!Checks.esNulo(nmb.getBienEntidad())){
						bienesNMBBienEntidad.add(nmb.getBienEntidad());
					}
				}
				
				mapaVariables.put("bienesEnt",bienesNMBBienEntidad);
				
			}else{
				mapaVariables.put("bienes","[ERROR - No existe valor]");
			}
			
			
			archivoBurofax=informesManager.generarEscritoConVariables(mapaVariables,nombreFichero,is);
	       
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return archivoBurofax;
	}
	
	
	@Override
	@BusinessOperation(OBTENER_TIPO_BUROFAX_BY_ENVIO)
	public DDTipoBurofaxPCO getTipoBurofaxByIdEnvio(Long idEnvio){
			EnvioBurofaxPCO envioBurofax=null;
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idEnvio);
			envioBurofax=(EnvioBurofaxPCO) genericDao.get(EnvioBurofaxPCO.class,filtro1);
		}catch(Exception e){
			logger.error("getTipoBurofaxByIdEnvio: " + e);
		}
		
		return envioBurofax.getTipoBurofax();
		
	}
	
	@Override
	@BusinessOperation(OBTENER_TIPO_BUROFAX_BY_CODIGO)
	public DDTipoBurofaxPCO getTipoBurofaxByCodigo(String codigo){
		DDTipoBurofaxPCO tipoBurofax=null;
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			tipoBurofax=(DDTipoBurofaxPCO) genericDao.get(DDTipoBurofaxPCO.class,filtro1);
		}catch(Exception e){
			logger.error("getTipoBurofaxByCodigo: " + e);
		}
	
		return tipoBurofax;
	
	}
	
	@Override
	@BusinessOperation(OBTENER_ENVIO_BY_ID)
	public EnvioBurofaxPCO getEnvioBurofaxById(Long idEnvio){
		EnvioBurofaxPCO envioBurofax=null;
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idEnvio);
			envioBurofax=(EnvioBurofaxPCO) genericDao.get(EnvioBurofaxPCO.class,filtro1);
		}catch(Exception e){
			logger.error("getEnvioBurofaxById: " + e);
		}
	
		return envioBurofax;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(OBTENER_ESTADOS_BUROFAX)
	public List<DDEstadoBurofaxPCO> getEstadosBurofax(){
		
		List<DDEstadoBurofaxPCO> dicionarioEstadoBurofax=new ArrayList<DDEstadoBurofaxPCO>();
		try {
			dicionarioEstadoBurofax = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDEstadoBurofaxPCO.class);
		} catch (Exception e) {
			logger.error("getEstadosBurofax: "+ e);
		}
		
		return dicionarioEstadoBurofax;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(GUARDAR_INFORMACION_ENVIO)
	public void guardaInformacionEnvio(String[] arrayIdEnvio,Long idResultadoEnvio,Date fechaEnvio,Date fechaAcuse){
		
		try{
			for(int i=0;i<arrayIdEnvio.length;i++){
				EnvioBurofaxPCO envio=getEnvioBurofaxById(Long.valueOf(arrayIdEnvio[i]));
				
				DDResultadoBurofaxPCO resultadoBurofax = getResultadoBurofaxPCOById(idResultadoEnvio);
				
				String codigoEstado = "";
				if(resultadoBurofax.getImplicaNotif() != null && resultadoBurofax.getImplicaNotif()) {
					codigoEstado = DDEstadoBurofaxPCO.NOTIFICADO;
				}else{
					codigoEstado = DDEstadoBurofaxPCO.NO_NOTIFICADO;
				}
				
				envio.getBurofax().setEstadoBurofax(getEstadoBurofaxByCod(codigoEstado));
				envio.setResultadoBurofax(resultadoBurofax);
				envio.setFechaAcuse(fechaAcuse);
				envio.setFechaEnvio(fechaEnvio);
				
				genericDao.save(EnvioBurofaxPCO.class,envio);
			}
		}catch(Exception e){
			logger.error("guardaInformacionEnvio: " + e);
		}
		
		
	}
	
	private DDEstadoBurofaxPCO getEstadoBurofaxByCod(String codigo) {
		return (DDEstadoBurofaxPCO) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoBurofaxPCO.class, codigo);
	}
	
	private DDResultadoBurofaxPCO getResultadoBurofaxPCOById(Long id) {
		DDResultadoBurofaxPCO resultadoBurofax=null;
		
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", id);
			resultadoBurofax=(DDResultadoBurofaxPCO) genericDao.get(DDResultadoBurofaxPCO.class,filtro1);
		}catch(Exception e){
			logger.error("getResultadoBurofaxPCOById: " + e);
		}
		
		return resultadoBurofax;
		
	}
	
	@Override
	@BusinessOperation(OBTENER_ESTADO_BUROFAX_BY_ID)
	public DDEstadoBurofaxPCO getEstadoBurofaxById(Long idEstado){
		
		DDEstadoBurofaxPCO estadoBurofax=null;
		
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idEstado);
			estadoBurofax=(DDEstadoBurofaxPCO) genericDao.get(DDEstadoBurofaxPCO.class,filtro1);
		}catch(Exception e){
			logger.error("getEstadoBurofaxById: " + e);
		}
		
		return estadoBurofax;
	}
	
	
	@Override
	@BusinessOperation(OBTENER_BUROFAX_ENVIO_INTE)
	public BurofaxEnvioIntegracionPCO getBurofaxEnvioIntegracionByIdEnvio(Long idEnvio){
		
		 BurofaxEnvioIntegracionPCO burofaxEnvio=null;
		
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "envioId", idEnvio);
			burofaxEnvio=(BurofaxEnvioIntegracionPCO) genericDao.get(BurofaxEnvioIntegracionPCO.class,filtro1);
		}catch(Exception e){
			logger.error("getBurofaxEnvioIntegracionByIdEnvio: " + e);
		}
		
		return burofaxEnvio;
	}

	
	@Override
	@Transactional(readOnly = false)
	public PersonaManual guardaPersonaManual(String dni, String nombre, String app1, String app2, String propietarioCodigo, Long codClienteEntidad){
		
		PersonaManual persMan = null;
		boolean existePersonaManual = false;
		
		if(!Checks.esNulo(propietarioCodigo) && !Checks.esNulo(codClienteEntidad)){
			///Comprobamos si ya se ha creado una persona manual para una persona
			persMan = genericDao.get(PersonaManual.class, genericDao.createFilter(FilterType.EQUALS, "propietario.codigo", propietarioCodigo), genericDao.createFilter(FilterType.EQUALS, "codClienteEntidad", codClienteEntidad));
			if(!Checks.esNulo(persMan)){
				existePersonaManual = true;
			}
		}
		 
		if(!existePersonaManual){
			persMan = new PersonaManual();
			persMan.setDocId(dni);
			persMan.setNombre(nombre);
			persMan.setApellido1(app1);
			persMan.setApellido2(app2);
			persMan.setAuditoria(Auditoria.getNewInstance());
			persMan.setVersion(0);
			if(!Checks.esNulo(propietarioCodigo)){
				DDPropietario propietario = (DDPropietario) dictionaryManager.getByCode(DDPropietario.class, propietarioCodigo);
				persMan.setPropietario(propietario);
			}
			if(!Checks.esNulo(codClienteEntidad)){
				persMan.setCodClienteEntidad(codClienteEntidad);
			}
			personaManualDao.save(persMan);	
		}	
		
		return persMan;
	}
	
	@Override
	@Transactional(readOnly = false)
	public ContratoPersonaManual guardaContratoPersonaManual(Long idPersonaManual, Long idContrato, String codigoTipoIntervencion){
		
		if(!Checks.esNulo(idPersonaManual) && !Checks.esNulo(idContrato) && !Checks.esNulo(codigoTipoIntervencion)){
			
			///Comprobamos si la relacion CONTRATO - PERSONA MANUAL EXISTE
			ContratoPersonaManual contratosPersonaMan = genericDao.get(ContratoPersonaManual.class, genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato), genericDao.createFilter(FilterType.EQUALS, "personaManual.id", idPersonaManual));
			
			if(!Checks.esNulo(contratosPersonaMan)){
				
				DDTipoIntervencion tipoIntervencion = genericDao.get(DDTipoIntervencion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoIntervencion));
				contratosPersonaMan.setTipoIntervencion(tipoIntervencion);
				contratoPersonaManualDao.saveOrUpdate(contratosPersonaMan);
				return contratosPersonaMan;
				
			}else{
				PersonaManual personaManual = genericDao.get(PersonaManual.class, genericDao.createFilter(FilterType.EQUALS, "id", idPersonaManual));
				Contrato contrato = genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "id", idContrato));
				Order order = new Order(OrderType.DESC, "orden");
				List<ContratoPersona> contratosPersona = genericDao.getListOrdered(ContratoPersona.class, order ,genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato));
				long orden = 1;
				if(contratosPersona.size()>0){
					orden = contratosPersona.get(0).getOrden() + 1;
				}
				DDTipoIntervencion tipoIntervencion = genericDao.get(DDTipoIntervencion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoIntervencion));
				
				if(!Checks.esNulo(personaManual) && !Checks.esNulo(contrato) && !Checks.esNulo(tipoIntervencion)){
					ContratoPersonaManual cntPersMan = new ContratoPersonaManual();
					cntPersMan.setPersonaManual(personaManual);
					cntPersMan.setContrato(contrato);
					cntPersMan.setTipoIntervencion(tipoIntervencion);
					cntPersMan.setOrden(orden);
					cntPersMan.setAuditoria(Auditoria.getNewInstance());
					cntPersMan.setVersion(0);
					contratoPersonaManualDao.save(cntPersMan);
					return cntPersMan;
				}
			}
			
		}
		
		return null;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void crearBurofaxPersonaManual(Long idPersonaManual,Long idProcedimiento, Long idContratoPersonaManual){
		try{
			
			PersonaManual personaManual = genericDao.get(PersonaManual.class, genericDao.createFilter(FilterType.EQUALS, "id", idPersonaManual));
			
			ContratoPersonaManual contratoPersonaManual = genericDao.get(ContratoPersonaManual.class, genericDao.createFilter(FilterType.EQUALS, "id", idContratoPersonaManual));
			
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento);
			ProcedimientoPCO procedimientoPCO=(ProcedimientoPCO) genericDao.get(ProcedimientoPCO.class,filtro1);
			
			filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoBurofaxPCO.NO_NOTIFICADO);
			DDEstadoBurofaxPCO estado=(DDEstadoBurofaxPCO) genericDao.get(DDEstadoBurofaxPCO.class,filtro1);
			
			BurofaxPCO burofax=new BurofaxPCO();
			burofax.setDemandadoManual(personaManual);
			burofax.setProcedimientoPCO(procedimientoPCO);
			burofax.setEstadoBurofax(estado);
			burofax.setContrato(contratoPersonaManual.getContrato());
			burofax.setTipoIntervencion(contratoPersonaManual.getTipoIntervencion());
			burofax.setEsPersonaManual(true);
			burofaxDao.save(burofax);
			
			
		}catch(Exception e){
			logger.error(e);
		}
	}
	
	@Override
	@Transactional(readOnly = false)
	public void crearBurofaxPersona(Long idPersona,Long idProcedimiento, Long idContratoPersona){
		try{
			
			Persona persona = genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", idPersona));
			
			ContratoPersona contratoPersona = genericDao.get(ContratoPersona.class, genericDao.createFilter(FilterType.EQUALS, "id", idContratoPersona));
			
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento);
			ProcedimientoPCO procedimientoPCO=(ProcedimientoPCO) genericDao.get(ProcedimientoPCO.class,filtro1);
			
			filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoBurofaxPCO.NO_NOTIFICADO);
			DDEstadoBurofaxPCO estado=(DDEstadoBurofaxPCO) genericDao.get(DDEstadoBurofaxPCO.class,filtro1);
			
			BurofaxPCO burofax=new BurofaxPCO();
			burofax.setDemandado(persona);
			burofax.setProcedimientoPCO(procedimientoPCO);
			burofax.setEstadoBurofax(estado);
			burofax.setContrato(contratoPersona.getContrato());
			burofax.setTipoIntervencion(contratoPersona.getTipoIntervencion());
			burofaxDao.save(burofax);
			
			
		}catch(Exception e){
			logger.error(e);
		}
	}

	@Override
	public void actualizaDireccion(DireccionAltaDto dto, Long idDireccion){
		direccionApi.actualizarDireccion(dto, idDireccion);
	}
	
	public Direccion getDireccion(Long idDireccion) {
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idDireccion);
		Direccion direccion=genericDao.get(Direccion.class,filtro1);
		return direccion;
	}

	public boolean resultadoMostrarBoton(Long idProcedimiento, List<String> codigosTiposGestores) {
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento);
    	ProcedimientoPCO procedimientoPco=(ProcedimientoPCO) genericDao.get(ProcedimientoPCO.class,filtro1);
    	Procedimiento procedimiento=procedimientoPco.getProcedimiento();
    	Long idProcedimientoEnvio = procedimiento.getId();
    	
		boolean mostrarBoton = procedimientoPcoApi.mostrarSegunCodigos(idProcedimientoEnvio, codigosTiposGestores);
		return mostrarBoton;
	}
	
	@Override
	@Transactional(readOnly = false)
	public PersonaManual updatePersonaManual(String dni, String nombre, String app1, String app2, Long idPersonaManual){
		 
		PersonaManual persMan = genericDao.get(PersonaManual.class, genericDao.createFilter(FilterType.EQUALS, "id", idPersonaManual));
		persMan.setDocId(dni);
		persMan.setNombre(nombre);
		persMan.setApellido1(app1);
		persMan.setApellido2(app2);

		personaManualDao.saveOrUpdate(persMan);	
		
		return persMan;
	}
}
