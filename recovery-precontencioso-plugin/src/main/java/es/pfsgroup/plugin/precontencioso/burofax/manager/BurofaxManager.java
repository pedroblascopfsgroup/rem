package es.pfsgroup.plugin.precontencioso.burofax.manager;

import java.io.File;
import java.io.InputStream;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.contrato.model.DDTipoProductoEntidad;
import es.capgemini.pfs.direccion.api.DireccionApi;
import es.capgemini.pfs.direccion.dto.DireccionAltaDto;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContext;
import es.pfsgroup.plugin.precontencioso.burofax.api.BurofaxApi;
import es.pfsgroup.plugin.precontencioso.burofax.dao.BurofaxDao;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxEnvioIntegracionPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDEstadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDResultadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDTipoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.ProcedimientoBurofaxTipoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.manager.LiquidacionManager;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
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
	
	private final Log logger = LogFactory.getLog(getClass());

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
			logger.error(e);
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
			logger.error(e);
		}
		
		return contrato;
	}
	
	@Override
	@BusinessOperation(OBTENER_LISTA_BUROFAX)
	public List<BurofaxPCO> getListaBurofaxPCO(Long idProcedimiento){
		List<BurofaxPCO> listaBurofax=null;
		
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "procedimientoPCO.id", idProcedimiento);
			
			listaBurofax=(List<BurofaxPCO>) genericDao.getList(BurofaxPCO.class,filtro1);
		}catch(Exception e){
			logger.error(e);
		}
		
		return listaBurofax;
		
	}
	
	@Override
	@BusinessOperation(GUARDA_DIRECCION)
	public Long guardaDireccion(DireccionAltaDto dto){
		
		Long idDireccion=null;
		
		try {
			idDireccion = proxyFactory.proxy(DireccionApi.class).guardarDireccionRetornaId(dto);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error(e);
		}
		return idDireccion;
	}
	
	//No se está utilizando
	/*
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(GUARDA_DIRECCION_BUROFAX)
	public boolean guardaDireccionBurofax(Long idPersona,Long idDireccion,Long idProcedimiento,Long idContrato){
		
		try{
			
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(1));
			BurofaxPCO burofaxPCO=(BurofaxPCO) genericDao.get(BurofaxPCO.class,filtro1);
			
			filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idPersona);
			Persona demandado=(Persona) genericDao.get(Persona.class,filtro1);
			
			filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoBurofaxPCO.NO_NOTIFICADO);
			DDEstadoBurofaxPCO estadoBurofax=(DDEstadoBurofaxPCO) genericDao.get(DDEstadoBurofaxPCO.class,filtro1);
			
			filtro1 = genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento);
			ProcedimientoPCO procedimientoPCO=(ProcedimientoPCO) genericDao.get(ProcedimientoPCO.class,filtro1);
			
			filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idDireccion);
			Direccion direccion=(Direccion) genericDao.get(Direccion.class,filtro1);
			
			//BurofaxPCO burofaxPCO=new BurofaxPCO();
			burofaxPCO.setDemandado(demandado);
			burofaxPCO.setEstadoBurofax(estadoBurofax);
			burofaxPCO.setProcedimientoPCO(procedimientoPCO);
			
			
			EnvioBurofaxPCO envioBurofax=new EnvioBurofaxPCO();
			envioBurofax.setBurofax(burofaxPCO);
			envioBurofax.setDireccion(direccion);
			envioBurofax.setTipoBurofax(getTipoBurofaxPorDefecto(idProcedimiento, idContrato));
			envioBurofax.setAuditoria(Auditoria.getNewInstance());
			
			List<EnvioBurofaxPCO> listaEnvio=new ArrayList<EnvioBurofaxPCO>();
			listaEnvio.add(envioBurofax);
			burofaxPCO.setEnviosBurofax(listaEnvio);
			
			
			//genericDao.saveOrUpdate(BurofaxPCO.class, burofaxPCO);
			burofaxDao.saveOrUpdate(burofaxPCO);
		
		}catch(Exception e){
			logger.error(e);
		}
		return true;
	}*/
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(DICCIONARIO_TIPO_BUROFAX)
	public List<DDTipoBurofaxPCO> getTiposBurofaxex(){
		List<DDTipoBurofaxPCO> dicionarioBurofax=new ArrayList<DDTipoBurofaxPCO>();
		try {
			dicionarioBurofax = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDTipoBurofaxPCO.class);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.error(e);
		}
		
		return dicionarioBurofax;
		
	}
	
	@Transactional(readOnly = false)
	@BusinessOperation(CONFIGURA_TIPO_BUROFAX)
	@Override
	public List<EnvioBurofaxPCO> configurarTipoBurofax(Long idTipoBurofax,String[] arrayIdDirecciones,String[] arrayIdBurofax,String[] arrayIdEnvios){
			
		List<EnvioBurofaxPCO> listaEnvioBurofax=new ArrayList<EnvioBurofaxPCO>(); 
		
		try{
			
			for(int i=0;i<arrayIdDirecciones.length;i++){
			
				Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoBurofaxPCO.NO_NOTIFICADO);
				DDEstadoBurofaxPCO estadoBurofaxPCO=(DDEstadoBurofaxPCO) genericDao.get(DDEstadoBurofaxPCO.class,filtro1);
				
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoBurofaxPCO.ESTADO_PREPARADO);
				DDResultadoBurofaxPCO resultadoBurofaxPCO=(DDResultadoBurofaxPCO) genericDao.get(DDResultadoBurofaxPCO.class,filtro2);
				
				Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "id", idTipoBurofax);
				DDTipoBurofaxPCO tipoBurofax=(DDTipoBurofaxPCO) genericDao.get(DDTipoBurofaxPCO.class,filtro3);
				
				Filter filtro4 = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(arrayIdBurofax[i]));
				BurofaxPCO burofax=(BurofaxPCO) genericDao.get(BurofaxPCO.class,filtro4);
				
				Filter filtro5 = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(arrayIdDirecciones[i]));
				Direccion direccion=(Direccion) genericDao.get(Direccion.class,filtro5);
				
				burofax.setEstadoBurofax(estadoBurofaxPCO);
				
				EnvioBurofaxPCO envio=null;
				//Si id Envio Existe actualizamos el envio
				if(!Checks.esNulo(arrayIdEnvios) && !arrayIdEnvios[i].equals("-1")){
					Filter filtro6 = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(arrayIdEnvios[i]));
					envio=(EnvioBurofaxPCO) genericDao.get(EnvioBurofaxPCO.class,filtro6);
					
				}
				
				//Si idEnvio=-1 Creamos un nuevo envio
				else{
					envio=new EnvioBurofaxPCO();	
					
				}
				//Comun
				envio.setBurofax(burofax);
				envio.setDireccion(direccion);
				envio.setTipoBurofax(tipoBurofax);	
				envio.setContenidoBurofax(tipoBurofax.getPlantilla());
				envio.setResultadoBurofax(resultadoBurofaxPCO);
				
				//Guardamos nuevo envio
				genericDao.save(EnvioBurofaxPCO.class,envio);
				listaEnvioBurofax.add(envio);
			}	
			
			
			
		}catch(Exception e){
			logger.error(e);
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
			logger.error(e);
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
			envioBurofax.setContenidoBurofax(contenido);
			
			genericDao.save(EnvioBurofaxPCO.class,envioBurofax);
		}catch(Exception e){
			logger.error(e);
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
			logger.error(e);
		}
		
		return persona;
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
				burofaxDao.save(burofax);
			}
			
			
		}catch(Exception e){
			logger.error(e);
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
	public Collection<? extends Persona> getPersonasConContrato(String query){
		return burofaxDao.getPersonasConContrato(query);
	}
	
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(GUARDAR_ENVIO_BUROFAX)
	public void guardarEnvioBurofax(Boolean certificado,List<EnvioBurofaxPCO> listaEnvioBurofaxPCO){
		
		try{

			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", "ENVIADO");
			DDResultadoBurofaxPCO resultado=(DDResultadoBurofaxPCO) genericDao.get(DDResultadoBurofaxPCO.class,filtro1);
			
			for(EnvioBurofaxPCO envioBurofax : listaEnvioBurofaxPCO){
				
				envioBurofax.setResultadoBurofax(resultado);
				envioBurofax.setFechaSolicitud(new Date());
				
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
				}
				else{
					envioIntegracion.setContrato(null);
				}
				envioIntegracion.setTipoBurofax(envioBurofax.getTipoBurofax().getDescripcion());
				envioIntegracion.setFechaSolicitud(new Date());
				envioIntegracion.setFechaEnvio(new Date());
				envioIntegracion.setFechaAcuse(new Date());
				envioIntegracion.setCertificado(certificado);
				
				if(precontenciosoContext.isGenerarArchivoBurofax()){
					FileItem archivoBurofax=generarDocumentoBurofax(envioBurofax);
					envioIntegracion.setArchivoBurofax(archivoBurofax);
				}
				else{
					envioIntegracion.setArchivoBurofax(new FileItem(File.createTempFile("TMP", ".log")));
				}
				
				envioIntegracion.setContenido(envioBurofax.getContenidoBurofax());

				genericDao.save(BurofaxEnvioIntegracionPCO.class, envioIntegracion);
			}
		
		}catch(Exception e){
			logger.error(e);
		}
		
	}
	
	
	private FileItem generarDocumentoBurofax(EnvioBurofaxPCO envioBurofax){
		
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
				apellido1=envioBurofax.getBurofax().getDemandado().getApellido2();
			}
			String domicilio=envioBurofax.getDireccion().toString();
			
			InputStream is=informesManager.createDocxFileFromHtmlText(
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
			
	
			String nombreFichero=envioBurofax.getBurofax().getDemandado().getApellidoNombre();
		
		
			HashMap<String, String> mapaVariables=new HashMap<String, String>();
			
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
			if(!Checks.esNulo(envioBurofax.getBurofax().getContrato()) && !Checks.esNulo(envioBurofax.getBurofax().getContrato().getFirstMovimiento())){
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
			logger.error(e);
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
			logger.error(e);
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
			logger.error(e);
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
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.error(e);
		}
		
		return dicionarioEstadoBurofax;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(GUARDAR_INFORMACION_ENVIO)
	public void guardaInformacionEnvio(String[] arrayIdEnvio,Long idEstadoEnvio,Date fechaEnvio,Date fechaAcuse){
		
		try{
			for(int i=0;i<arrayIdEnvio.length;i++){
				EnvioBurofaxPCO envio=getEnvioBurofaxById(Long.valueOf(arrayIdEnvio[i]));
				
				envio.getBurofax().setEstadoBurofax(getEstadoBurofaxById(idEstadoEnvio));
				envio.setFechaAcuse(fechaAcuse);
				envio.setFechaEnvio(fechaEnvio);
				
				genericDao.save(EnvioBurofaxPCO.class,envio);
			}
		}catch(Exception e){
			logger.error(e);
		}
		
		
	}
	
	@Override
	@BusinessOperation(OBTENER_ESTADO_BUROFAX_BY_ID)
	public DDEstadoBurofaxPCO getEstadoBurofaxById(Long idEstado){
		
		DDEstadoBurofaxPCO estadoBurofax=null;
		
		try{
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idEstado);
			estadoBurofax=(DDEstadoBurofaxPCO) genericDao.get(DDEstadoBurofaxPCO.class,filtro1);
		}catch(Exception e){
			logger.error(e);
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
			logger.error(e);
		}
		
		return burofaxEnvio;
	}
		
	
}
