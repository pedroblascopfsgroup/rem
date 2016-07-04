package es.pfsgroup.recovery.adjunto.haya;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDtoImpl;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.dao.AdjuntoContratoDao;
import es.capgemini.pfs.contrato.dao.ContratoDao;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.core.api.parametrizacion.ParametrizacionApi;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.AdjuntoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.dao.AdjuntoPersonaDao;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.AdjuntoPersona;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tipoFicheroAdjuntoEntidad.DDTipoAdjuntoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalMaestroApi;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalServicioDocumentosApi;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalServicioExpedientesApi;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoOutputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CabeceraPeticionRestClientDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearDocumentoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DocumentosExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.RecoveryToGestorDocAssembler;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.UsuarioPasswordDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearPropuestaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.RecoveryToGestorExpAssembler;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.IdentificacionDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCrearDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.context.CajamarHreProjectContext;
import es.pfsgroup.recovery.ext.impl.adjunto.dao.EXTAdjuntoAsuntoDao;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;
import es.pfsgroup.recovery.haya.contenedor.model.ContenedorGestorDocumental;
import es.pfsgroup.recovery.haya.gestorDocumental.GestorDocToRecoveryAssembler;
import es.pfsgroup.tipoContenedor.dao.MapeoTipoContenedorDao;
import es.pfsgroup.tipoContenedor.model.MapeoTipoContenedor;

@Component
public class AdjuntoHayaManager {
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private Executor executor;
    
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GestorDocumentalServicioDocumentosApi gestorDocumentalServicioDocumentosApi;
	
	@Autowired
	private GestorDocumentalServicioExpedientesApi gestorDocumentalServicioExpedientesApi;
	
	@Autowired
	private GestorDocumentalMaestroApi gestorDocumentalMaestroApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private PersonaDao personaDao;
	
	@Autowired
    private AdjuntoPersonaDao adjuntoPersonaDao;
    
	@Autowired
    private ExpedienteDao expedienteDao;
    
	@Autowired
    private ContratoDao contratoDao;
	
	@Autowired
    private AdjuntoContratoDao adjuntoContratoDao;
	
	@Autowired
	private CajamarHreProjectContext cajamarHreProjectContext;    
	
	@Autowired
	private EXTAdjuntoAsuntoDao extAdjuntoAsuntoDao;
	
	@Autowired
	private MapeoTipoContenedorDao mapeoTipoContenedorDao;
	
    @Resource
    Properties appProperties;
	
    // Adjuntos del ASUNTO
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
    	Asunto asun = genericDao.get(Asunto.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
    	for(Procedimiento prc : asun.getProcedimientos()) {
    		if(crearPropuesta(prc)) {
    			return null;
    		}
		}
    	List<EXTAdjuntoDto> adjuntosAsunto = new ArrayList<EXTAdjuntoDto>();
		for(String claseExpediente : getDistinctTipoProcedimientoFromAsunto(asun)) {
			getAdjuntoAsunto(id, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExpediente, adjuntosAsunto);
		}
		return adjuntosAsunto;
	}
	
	// Adjuntos del PROCEDIMIENTO
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
		if(crearPropuesta(prc)){
			return null;			
		}
		String claseExpediente = getClaseExpedienteByProcedimientoPadre(prc);
		return getAdjuntoAsunto(prc.getAsunto().getId(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExpediente, new ArrayList<EXTAdjuntoDto>());
	}
	
	private List<EXTAdjuntoDto> getAdjuntoAsunto(Long id, String tipoExp, String claseExp, List<EXTAdjuntoDto> adjuntosAsunto) {
		IdentificacionDocumento[] idsDocumento = documentosExpediente(id, tipoExp, claseExp);
		
		List<Integer> idsDoc = new ArrayList<Integer>();
		List<AdjuntoAsunto> listAdjAsu = new ArrayList<AdjuntoAsunto>();
		
		if(!Checks.esNulo(idsDocumento)) {
			for(IdentificacionDocumento iden : idsDocumento) {
				idsDoc.add(iden.getIdentificadorNodo());
			}			
			Set<AdjuntoAsunto> list = extAdjuntoAsuntoDao.getAdjuntoAsuntoByIdDocumentoAndPrcId(idsDoc, null);
			listAdjAsu.addAll(list);
			rellenarAdjuntosAsunto(id, listAdjAsu, idsDocumento);
		}
		
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		Set<AdjuntoAsunto> set = new HashSet<AdjuntoAsunto>(listAdjAsu);
		adjuntosAsunto.addAll(creaObjetosEXTAsuntos(set, usuario, false));
		return adjuntosAsunto;
	}
	
	private List<AdjuntoAsunto> rellenarAdjuntosAsunto(Long idAsunto, List<AdjuntoAsunto> adjuntos, IdentificacionDocumento[] idsDocumento) {
		List<AsuntoIdentificacionDocumento> listIden = new ArrayList<AsuntoIdentificacionDocumento>();
		List<Long> adjuntosIdsNodo = new ArrayList<Long>();
		for(IdentificacionDocumento iden :  idsDocumento) {
			adjuntosIdsNodo.add(new Long(iden.getIdentificadorNodo()));
		}
		for(IdentificacionDocumento iden :  idsDocumento) {
			for (AdjuntoAsunto adjAsu : adjuntos) {
				if(adjAsu.getServicerId().equals(new Long(iden.getIdentificadorNodo()))) {
					adjuntosIdsNodo.set(adjuntosIdsNodo.indexOf(adjAsu.getServicerId()), null);					
				}
			}
		}
		
		for(IdentificacionDocumento iden :  idsDocumento){
			if(adjuntosIdsNodo.contains(new Long(iden.getIdentificadorNodo()))) {
				AsuntoIdentificacionDocumento aid = new AsuntoIdentificacionDocumento();
				aid.setIdentificacionDocumento(iden);
				Asunto asunto = genericDao.get(Asunto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAsunto));
				aid.setAsunto(asunto);
				listIden.add(aid);		
			}
		}
		
		for(AsuntoIdentificacionDocumento asuIdenDoc : listIden) {
			adjuntos.add(rellenarAdjuntoAsuntoAssembler(asuIdenDoc));
		}
		return adjuntos;
	}
	
	private AdjuntoAsunto rellenarAdjuntoAsuntoAssembler(AsuntoIdentificacionDocumento idenDoc) {
		EXTAdjuntoAsunto adjAsu = new EXTAdjuntoAsunto();
		adjAsu.setNombre(idenDoc.getIdentificacionDocumento().getNombreNodo());
		adjAsu.setAsunto(idenDoc.getAsunto());
		String matricula = idenDoc.getIdentificacionDocumento().getTipoExpediente() + "-" + idenDoc.getIdentificacionDocumento().getSerieDocumental() + "-" + idenDoc.getIdentificacionDocumento().getTdn1() + "-" + idenDoc.getIdentificacionDocumento().getTdn2();
		List<MapeoTipoContenedor> mapeo = genericDao.getList(MapeoTipoContenedor.class, genericDao.createFilter(FilterType.EQUALS, "codigoTDN2", matricula));
		if(Checks.estaVacio(mapeo)) {
			adjAsu.setTipoFichero(null);
		}else{
			adjAsu.setTipoFichero(mapeo.get(0).getTipoFichero());			
		}
		adjAsu.setServicerId(new Long(idenDoc.getIdentificacionDocumento().getIdentificadorNodo()));
		Adjunto adj = new Adjunto();
		adj.setId(1L);
		adjAsu.setAdjunto(adj);
		Auditoria.save(adjAsu);
		return adjAsu;
	}
	
	// Adjuntos CONTRATO del Asunto
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(id);
		List<Contrato> contratos = new ArrayList<Contrato>();
		contratos.addAll(asunto.getContratos());
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();
		for (Contrato cnt : contratos) {
			adjuntosMapeados.add(getExtAdjuntoGenericoDtoContratoInterfaz(cnt));
		}
		return adjuntosMapeados;
	}
		
	// Adjuntos del CONTRATO en el Expediente
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		List<ExpedienteContrato> listExpCnt = genericDao.getList(ExpedienteContrato.class, genericDao.createFilter(FilterType.EQUALS, "contrato.id", id));
		List<ExtAdjuntoGenericoDto> adjuntosMapeado = new ArrayList<ExtAdjuntoGenericoDto>();
		for (ExpedienteContrato expCnt : listExpCnt) {
			adjuntosMapeado.add(getExtAdjuntoGenericoDtoContratoDto(expCnt.getContrato()));
		}
		return adjuntosMapeado;
	}

	// Adjuntos del CONTRATO en Contrato
	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id){
		Contrato contrato = contratoDao.get(id);
		IdentificacionDocumento[] idsDocumento = documentosExpediente(getIdActivoHaya(contrato), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ACTIVOS_FINANCIEROS, GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_ACTIVOS_FINANCIERO);
		List<AdjuntoDto> adjuntosConBorrado = new ArrayList<AdjuntoDto>();
		if(Checks.esNulo(idsDocumento)) { 
			return null;
		}
		List<Integer> idsDoc = new ArrayList<Integer>();
		List<AdjuntoContrato> adjuntos = new ArrayList<AdjuntoContrato>();
		
		if(!Checks.esNulo(idsDocumento)) {
			for(IdentificacionDocumento iden : idsDocumento) {
				idsDoc.add(iden.getIdentificadorNodo());
			}			
			adjuntos.addAll(adjuntoContratoDao.getAdjuntoContratoByIdDocumento(idsDoc));
			rellenarAdjuntosContratos(contrato, adjuntos, idsDocumento);
		}
		
		Collections.sort(adjuntos, comparatorAdjuntoContrato());
		for (final AdjuntoContrato aa : adjuntos) {
			AdjuntoDto dto = new AdjuntoDto() {
				@Override
				public Boolean getPuedeBorrar() {
					return false;
				}

				@Override
				public Object getAdjunto() {
					return aa;
				}

				@Override
				public String getRefCentera() {
					if(Checks.esNulo(aa.getServicerId())) {
						return null;
					}
					return aa.getServicerId().toString();
				}

				@Override
				public String getNombreTipoDoc() {
					if(aa.getTipoAdjuntoEntidad() != null) {
						return aa.getTipoAdjuntoEntidad().getDescripcion();
					}
					return "";
				}
				
				@Override
				public Long getIdAdjuntoBlob() {
					if(aa.getAdjunto() != null) {
						return aa.getAdjunto().getId();
					}
					return null;
				}
				
			};
			adjuntosConBorrado.add(dto);
		}
		
		return adjuntosConBorrado;
	}
	
	private ExtAdjuntoGenericoDto getExtAdjuntoGenericoDtoContratoInterfaz(final Contrato cnt) {
		IdentificacionDocumento[] idsDocumento = documentosExpediente(getIdActivoHaya(cnt), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ACTIVOS_FINANCIEROS,GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_ACTIVOS_FINANCIERO);
		List<Integer> idsDoc = new ArrayList<Integer>();
		final List<AdjuntoContrato> adjuntos = new ArrayList<AdjuntoContrato>();
		if(!Checks.esNulo(idsDocumento)) {
			for(IdentificacionDocumento iden : idsDocumento) {
				idsDoc.add(iden.getIdentificadorNodo());
			}			
			adjuntos.addAll(adjuntoContratoDao.getAdjuntoContratoByIdDocumento(idsDoc));
			rellenarAdjuntosContratos(cnt, adjuntos, idsDocumento);
			for(AdjuntoContrato adjCnt : adjuntos) {
				adjCnt.setRefCentera(adjCnt.getServicerId().toString());
			}
		}
		Collections.sort(adjuntos, comparatorAdjuntoContrato());
		ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

			@Override
			public Long getId() {
				return cnt.getId();
			}
			
			@Override
			public String getDescripcion() {
				return cnt.getDescripcion();
			}

			@Override
			public List getAdjuntosAsList() {
				return adjuntos;
			}

			@Override
			public List getAdjuntos() {
				return adjuntos;
			}
		};
		return dto;
	}
	
	private ExtAdjuntoGenericoDto getExtAdjuntoGenericoDtoContratoDto(Contrato cnt) {
		IdentificacionDocumento[] idsDocumento = documentosExpediente(getIdActivoHaya(cnt), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ACTIVOS_FINANCIEROS,GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_ACTIVOS_FINANCIERO);
		List<Integer> idsDoc = new ArrayList<Integer>();
		List<AdjuntoContrato> adjuntos = new ArrayList<AdjuntoContrato>();
		if(!Checks.esNulo(idsDocumento)) {
			for(IdentificacionDocumento iden : idsDocumento) {
				idsDoc.add(iden.getIdentificadorNodo());
			}			
			adjuntos.addAll(adjuntoContratoDao.getAdjuntoContratoByIdDocumento(idsDoc));
			rellenarAdjuntosContratos(cnt, adjuntos, idsDocumento);
		}
		Collections.sort(adjuntos, comparatorAdjuntoContrato());
		ExtAdjuntoGenericoDtoImpl dto = new ExtAdjuntoGenericoDtoImpl();
		dto.setId(cnt.getId());
		dto.setDescripcion(cnt.getDescripcion());
		dto.setAdjuntosAsList(adjuntos);
		dto.setAdjuntos(adjuntos);
		return dto;
	}
	
	private Comparator<AdjuntoContrato> comparatorAdjuntoContrato () {
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
		return comparador;
	}
	
	private List<AdjuntoContrato> rellenarAdjuntosContratos(Contrato cnt, List<AdjuntoContrato> adjuntos, IdentificacionDocumento[] idsDocumento) {
		List<ContratoIdentificacionDocumento> listIden = new ArrayList<ContratoIdentificacionDocumento>();
		List<Long> adjuntosIdsNodo = new ArrayList<Long>();
		for(IdentificacionDocumento iden :  idsDocumento) {
			adjuntosIdsNodo.add(new Long(iden.getIdentificadorNodo()));
		}
		for(IdentificacionDocumento iden :  idsDocumento) {
			for (AdjuntoContrato adjCnt : adjuntos) {
				if(adjCnt.getServicerId().equals(new Long(iden.getIdentificadorNodo()))) {
					adjuntosIdsNodo.set(adjuntosIdsNodo.indexOf(adjCnt.getServicerId()), null);					
				}
			}
		}
		
		for(IdentificacionDocumento iden :  idsDocumento){
			if(adjuntosIdsNodo.contains(new Long(iden.getIdentificadorNodo()))) {
				ContratoIdentificacionDocumento cid = new ContratoIdentificacionDocumento();
				cid.setIdentificacionDocumento(iden);
				cid.setContrato(cnt);
				listIden.add(cid);		
			}
		}

		for(ContratoIdentificacionDocumento cntIdenDoc : listIden) {
			adjuntos.add(rellenarAdjuntoContratoAssembler(cntIdenDoc));
		}
		return adjuntos;
	}
	
	private AdjuntoContrato rellenarAdjuntoContratoAssembler(ContratoIdentificacionDocumento idenDoc) {
		AdjuntoContrato adjCnt = new AdjuntoContrato();
		adjCnt.setId(new Long(idenDoc.getIdentificacionDocumento().getIdentificadorNodo()));
		adjCnt.setNombre(idenDoc.getIdentificacionDocumento().getNombreNodo());
		adjCnt.setContrato(idenDoc.getContrato());
		String matricula = idenDoc.getIdentificacionDocumento().getTipoExpediente() + "-" + idenDoc.getIdentificacionDocumento().getSerieDocumental() + "-" + idenDoc.getIdentificacionDocumento().getTdn1() + "-" + idenDoc.getIdentificacionDocumento().getTdn2();
		DDTipoAdjuntoEntidad tipoAdjEnt = genericDao.get(DDTipoAdjuntoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", matricula));
		adjCnt.setTipoAdjuntoEntidad(tipoAdjEnt);
		adjCnt.setServicerId(new Long(idenDoc.getIdentificacionDocumento().getIdentificadorNodo()));
		Auditoria.save(adjCnt);
		return adjCnt;
	}
	
	// Adjuntos PERSONA del Asunto
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		List<Persona> personas = proxyFactory.proxy(AsuntoApi.class).obtenerPersonasDeUnAsunto(id);
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();
		for (Persona per : personas) {
			adjuntosMapeados.add(getExtAdjuntoGenericoDtoPersonaInterfaz(per, getClaseExpPersona(per)));
		}
		return adjuntosMapeados;
	}
	
	// Adjuntos de PERSONAS en el Expediente
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {	
		List<Persona> personas = expedienteDao.findPersonasContratosExpediente(id);
		List<ExtAdjuntoGenericoDto> adjuntosMapeado = new ArrayList<ExtAdjuntoGenericoDto>();
		for (Persona per : personas) {
			adjuntosMapeado.add(getExtAdjuntoGenericoDtopersonaDto(per, getClaseExpPersona(per)));
		}
		return adjuntosMapeado;
	}

	// Adjuntos de la PERSONA en Persona
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		Persona persona = proxyFactory.proxy(PersonaApi.class).get(id);
		IdentificacionDocumento[] idsDocumento = documentosExpediente(getIdClienteHaya(persona), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ENTIDADES, getClaseExpPersona(persona));
		
		List<Integer> idsDoc = new ArrayList<Integer>();
		final List<AdjuntoPersona> adjuntosPersona = new ArrayList<AdjuntoPersona>();
		if(!Checks.esNulo(idsDocumento)) {
			for(IdentificacionDocumento iden : idsDocumento) {
				idsDoc.add(iden.getIdentificadorNodo());
			}			
			adjuntosPersona.addAll(adjuntoPersonaDao.getAdjuntoPersonaByIdDocumento(idsDoc));
			rellenarAdjuntosPersonas(persona, adjuntosPersona, idsDocumento);
		}
		
		List<AdjuntoDto> adjuntosConBorrado = new ArrayList<AdjuntoDto>();

		Collections.sort(adjuntosPersona, comparatorAdjuntoPersona());
		for (final AdjuntoPersona aa : adjuntosPersona) {
			AdjuntoDto dto = new AdjuntoDto() {
				@Override
				public Boolean getPuedeBorrar() {
					return false;
				}

				@Override
				public Object getAdjunto() {
					return aa;
				}

				@Override
				public String getRefCentera() {
					if(Checks.esNulo(aa.getServicerId())) {
						return null;
					}
					return aa.getServicerId().toString();
				}

				@Override
				public String getNombreTipoDoc() {
					if(aa.getTipoAdjuntoEntidad() != null) {
						return aa.getTipoAdjuntoEntidad().getDescripcion();
					}
					return "";
				}

				@Override
				public Long getIdAdjuntoBlob() {
					if(aa.getAdjunto() != null) {
						return aa.getAdjunto().getId();
					}
					return null;
				}
			};
			adjuntosConBorrado.add(dto);
		}
		return adjuntosConBorrado;
	}
	
	private String getClaseExpPersona(Persona per) {
		String claseExpe = "";
		if(DDTipoPersona.CODIGO_TIPO_PERSONA_FISICA.equals(per.getTipoPersona().getCodigo())) {
			claseExpe = GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_PERSONA_FISICA;
		}else{
			claseExpe = GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_PERSONA_JURIDICA;
		}
		return claseExpe;
	}
	
	private ExtAdjuntoGenericoDto getExtAdjuntoGenericoDtoPersonaInterfaz(final Persona per, String claseExpe) {
		IdentificacionDocumento[] idsDocumento = documentosExpediente(getIdClienteHaya(per), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ENTIDADES, claseExpe);
		List<Integer> idsDoc = new ArrayList<Integer>();
		final List<AdjuntoPersona> adjuntos = new ArrayList<AdjuntoPersona>();
		if(!Checks.esNulo(idsDocumento)) {
			for(IdentificacionDocumento iden : idsDocumento) {
				idsDoc.add(iden.getIdentificadorNodo());
			}			
			adjuntos.addAll(adjuntoPersonaDao.getAdjuntoPersonaByIdDocumento(idsDoc));
			rellenarAdjuntosPersonas(per, adjuntos, idsDocumento);
			for(AdjuntoPersona adjPer : adjuntos) {
				adjPer.setRefCentera(adjPer.getServicerId().toString());
			}
		}
		
		Collections.sort(adjuntos, comparatorAdjuntoPersona());
		ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

			@Override
			public Long getId() {
				return per.getId();
			}

			@Override
			public String getDescripcion() {
				return per.getDescripcion();
			}

			@Override
			public List getAdjuntosAsList() {
				return adjuntos;
			}

			@Override
			public List getAdjuntos() {
				return adjuntos;
			}
		};
		return dto;
	}
	
	private ExtAdjuntoGenericoDto getExtAdjuntoGenericoDtopersonaDto(Persona per, String claseExp) {
		IdentificacionDocumento[] idsDocumento = documentosExpediente(getIdClienteHaya(per), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ENTIDADES, claseExp);
		List<Integer> idsDoc = new ArrayList<Integer>();
		List<AdjuntoPersona> adjuntos = new ArrayList<AdjuntoPersona>();
		if(!Checks.esNulo(idsDocumento)) {
			for(IdentificacionDocumento iden : idsDocumento) {
				idsDoc.add(iden.getIdentificadorNodo());
			}			
			adjuntos.addAll(adjuntoPersonaDao.getAdjuntoPersonaByIdDocumento(idsDoc));
			rellenarAdjuntosPersonas(per, adjuntos, idsDocumento);
		}
		Collections.sort(adjuntos, comparatorAdjuntoPersona());
		ExtAdjuntoGenericoDtoImpl dto = new ExtAdjuntoGenericoDtoImpl();
		dto.setId(per.getId());
		dto.setDescripcion(per.getDescripcion());
		dto.setAdjuntosAsList(adjuntos);
		dto.setAdjuntos(adjuntos);
		return dto;
	}
	
	private List<AdjuntoPersona> rellenarAdjuntosPersonas(Persona per, List<AdjuntoPersona> adjuntos, IdentificacionDocumento[] idsDocumento) {
		List<PersonaIdentificacionDocumento> listIden = new ArrayList<PersonaIdentificacionDocumento>();
		List<Long> adjuntosIdsNodo = new ArrayList<Long>();
		for(IdentificacionDocumento iden :  idsDocumento) {
			adjuntosIdsNodo.add(new Long(iden.getIdentificadorNodo()));
		}
		for(IdentificacionDocumento iden :  idsDocumento) {
			for (AdjuntoPersona adjCnt : adjuntos) {
				if(adjCnt.getServicerId().equals(new Long(iden.getIdentificadorNodo()))) {
					adjuntosIdsNodo.set(adjuntosIdsNodo.indexOf(adjCnt.getServicerId()), null);					
				}
			}
		}
		
		for(IdentificacionDocumento iden :  idsDocumento){
			if(adjuntosIdsNodo.contains(new Long(iden.getIdentificadorNodo()))) {
				PersonaIdentificacionDocumento pid = new PersonaIdentificacionDocumento();
				pid.setIdentificacionDocumento(iden);
				pid.setPersona(per);
				listIden.add(pid);		
			}
		}

		for(PersonaIdentificacionDocumento perIdenDoc : listIden) {
			adjuntos.add(rellenarAdjuntoPersonaAssembler(perIdenDoc));
		}
		return adjuntos;
	}
	
	private AdjuntoPersona rellenarAdjuntoPersonaAssembler(PersonaIdentificacionDocumento idenDoc) {
		AdjuntoPersona adjPer = new AdjuntoPersona();
		adjPer.setId(new Long(idenDoc.getIdentificacionDocumento().getIdentificadorNodo()));
		adjPer.setNombre(idenDoc.getIdentificacionDocumento().getNombreNodo());
		adjPer.setPersona(idenDoc.getPersona());
		String matricula = idenDoc.getIdentificacionDocumento().getTipoExpediente() + "-" + idenDoc.getIdentificacionDocumento().getSerieDocumental() + "-" + idenDoc.getIdentificacionDocumento().getTdn1() + "-" + idenDoc.getIdentificacionDocumento().getTdn2();
		DDTipoAdjuntoEntidad tipoAdjEnt = genericDao.get(DDTipoAdjuntoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", matricula));
		adjPer.setTipoAdjuntoEntidad(tipoAdjEnt);
		adjPer.setServicerId(new Long(idenDoc.getIdentificacionDocumento().getIdentificadorNodo()));
		Auditoria.save(adjPer);
		return adjPer;
	}
	
	private Comparator<AdjuntoPersona> comparatorAdjuntoPersona() {
		Comparator<AdjuntoPersona> comparador = new Comparator<AdjuntoPersona>() {
			@Override
			public int compare(AdjuntoPersona o1, AdjuntoPersona o2) {
				if (Checks.esNulo(o1) && Checks.esNulo(o2)) {
					return 0;
				} else if (Checks.esNulo(o1)) {
					return -1;
				} else if (Checks.esNulo(o2)) {
					return 1;
				} else {
					return o2.getAuditoria().getFechaCrear().compareTo(o1.getAuditoria().getFechaCrear());
				}
			}
		};
		return comparador;
	}	
	
	private IdentificacionDocumento[] documentosExpediente(Long id, String tipoExpediente, String claseExpediente) {
		logger.info("[AdjuntoHayaManager.documentosExpediente]: " + id + ", tipoExpediente: " + tipoExpediente + ", claseExpediente: " + claseExpediente);
		if(Checks.esNulo(id)) {
			return null;
		}
		UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), null);

		CabeceraPeticionRestClientDto cabecera = RecoveryToGestorDocAssembler.getCabeceraPeticionRestClient(id.toString(), tipoExpediente, claseExpediente);
		DocumentosExpedienteDto docExpDto = RecoveryToGestorDocAssembler.getDocumentosExpedienteDto(usuPass);
		try {
			RespuestaDocumentosExpedientes respuesta = gestorDocumentalServicioDocumentosApi.documentosExpediente(cabecera, docExpDto);
			if(respuesta.getDocumentos() != null && respuesta.getDocumentos().length == 0) {
				return null;
			}
			return respuesta.getDocumentos();
		} catch (GestorDocumentalException e) {
			logger.error("documentosExpediente error: " + e);
		}
		return null;
	}
	
	private boolean crearPropuesta(Procedimiento prc) {
		boolean creando = false;
		if(buscarTPRCsinContenedor(prc)) {
			String idAsunto=prc.getAsunto().getId().toString();
			String claseExpe = cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
			UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), null);
			CrearPropuestaDto crearPropuesta = RecoveryToGestorExpAssembler.getCrearPropuestaDto(idAsunto, claseExpe, usuPass);
			
			try {
				RespuestaCrearExpediente respuesta = gestorDocumentalServicioExpedientesApi.crearPropuesta(crearPropuesta);
				if(respuesta != null) {
					insertarContenedor(respuesta.getIdExpediente(), prc.getAsunto(), null, null, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExpe);
					creando = true;					
				}
			} catch (GestorDocumentalException e) {
				logger.error("crearPropuesta error: " + e);
			}		
		}
		return creando;
	}

    private List<String> getDistinctTipoProcedimientoFromAsunto(Asunto asun) {
    	List<String> listTipoProcedimiento = new ArrayList<String>();
    	for (Procedimiento prc : asun.getProcedimientos()) {
    		String claseExpe = cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
    		if(!listTipoProcedimiento.contains(claseExpe) && !Checks.esNulo(claseExpe)) {
    			listTipoProcedimiento.add(claseExpe);
    		}
    	}
    	return listTipoProcedimiento;
    }

	public String upload(WebFileItem uploadForm) {
		String retorno = null;
		if(mapeoTipoContenedorDao.existeMapeoByFicheroAdjunto(uploadForm.getParameter("comboTipoFichero"))) {
			if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){			
				Long idAsunto = Long.parseLong(uploadForm.getParameter("id"));
				if (!Checks.esNulo(uploadForm.getParameter("prcId"))){
					retorno = uploadProcedimiento(uploadForm, idAsunto);
				}else{
					retorno = uploadAsunto(uploadForm, idAsunto);
				}
			}		
		}
		else {
			return GestorDocumentalConstants.ERROR_NO_EXISTE_MAPEO_TIPO_ARCHIVO;
		}
		
		return retorno;
	}
	
	private String uploadAsunto(WebFileItem uploadForm, Long idAsunto) {
		boolean contenedorEncontrado = false;
		
		List<String> listaContenedores = getContenedoresByAsunto(idAsunto, uploadForm);	
		
		for(String claseExpe : listaContenedores) {
			if(!Checks.esNulo(claseExpe)) {
				RespuestaCrearDocumento respuesta = uploadGestorDoc(idAsunto, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExpe, uploadForm, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, uploadForm.getParameter("comboTipoFichero"));
				if(respuesta == null) {
					return GestorDocumentalConstants.ERROR_NO_EXISTE_CONTENEDOR;
				}
				if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getIdDocumento())) {
					contenedorEncontrado = true;
					break;
				}
			}
		}
		
		if(!contenedorEncontrado) {
			return GestorDocumentalConstants.ERROR_NO_EXISTE_CONTENEDOR;
		}
		return null;
	}
	
	private String uploadProcedimiento(WebFileItem uploadForm, Long idAsunto) {
		Long idProcedimiento = Long.parseLong(uploadForm.getParameter("prcId"));
		boolean contenedorEncontrado = false;
		
		List<String> listaContenedores = getContenedoresByAsunto(idAsunto,uploadForm);
			
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento));
		String claseExp = getClaseExpedienteByProcedimientoPadre(prc);
		
		//Se va a comprobar la claseExp encontrada por el prc (o por los padres del prc), con los contenedores existentes en el asunto, y debe haber uno que coincida.
		for(String claseExpExistente : listaContenedores) {
			if(!Checks.esNulo(claseExpExistente) && claseExpExistente.equals(claseExp) ){
				RespuestaCrearDocumento respuesta = uploadGestorDoc(idAsunto, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExp, uploadForm, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, uploadForm.getParameter("comboTipoFichero"));
				if(respuesta == null) {
					return GestorDocumentalConstants.ERROR_NO_EXISTE_CONTENEDOR;
				}
				if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getIdDocumento())) {
					contenedorEncontrado = true;
					break;
				}
			}
		}
		
		if(!contenedorEncontrado) {
			return GestorDocumentalConstants.ERROR_NO_EXISTE_CONTENEDOR;
		}
		return null;
	}
	
	public String uploadPersona(WebFileItem uploadForm) {
		Persona persona = personaDao.get(Long.parseLong(uploadForm.getParameter("id")));
		
		String claseExpe = "";
		if(DDTipoPersona.CODIGO_TIPO_PERSONA_FISICA.equals(persona.getTipoPersona().getCodigo())) {
			claseExpe = GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_PERSONA_FISICA;
		}else{
			claseExpe = GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_PERSONA_JURIDICA;
		}
		if(Checks.esNulo(getIdClienteHaya(persona))) {
			return GestorDocumentalConstants.ERROR_NO_EXISTE_CONTENEDOR_MAESTRO;
		}else{
			RespuestaCrearDocumento respuesta = uploadGestorDoc(getIdClienteHaya(persona), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ENTIDADES, claseExpe, uploadForm, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, uploadForm.getParameter("comboTipoDoc"));			
			if(respuesta == null) {
				return GestorDocumentalConstants.ERROR_NO_EXISTE_CONTENEDOR_MAESTRO;
			}
		}

		return null;
	}

	public String uploadExpediente(WebFileItem uploadForm) {
		uploadGestorDoc(1L, "tipo", "clase", uploadForm, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, uploadForm.getParameter("comboTipoDoc"));
		return null;
	}

	public String uploadContrato(WebFileItem uploadForm) {
		Contrato contrato = contratoDao.get(Long.parseLong(uploadForm.getParameter("id")));
		if(Checks.esNulo(getIdActivoHaya(contrato))) {
			return GestorDocumentalConstants.ERROR_NO_EXISTE_CONTENEDOR_MAESTRO;
		}else{
			RespuestaCrearDocumento respuesta = uploadGestorDoc(getIdActivoHaya(contrato),  GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ACTIVOS_FINANCIEROS,GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_ACTIVOS_FINANCIERO, uploadForm, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, uploadForm.getParameter("comboTipoDoc"));
			if(respuesta == null) {
				return GestorDocumentalConstants.ERROR_NO_EXISTE_CONTENEDOR_MAESTRO;
			}
		}
		return null;
	}

	
	private RespuestaCrearDocumento uploadGestorDoc(Long idExpediente,String tipoExp, String claseExp, WebFileItem uploadForm, String tipoEntidad, String tipoFichero) {
		logger.info("[AdjuntoHayaManager.uploadGestorDoc]: " + idExpediente + ", claseExp: " + claseExp + ", tipoEntidad: " + tipoEntidad + " , tipoFichero: " + tipoFichero);
		RespuestaCrearDocumento respuesta = null;
		CabeceraPeticionRestClientDto cabecera = RecoveryToGestorDocAssembler.getCabeceraPeticionRestClient(idExpediente.toString(), tipoExp, claseExp);	
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), usuario.getUsername());
		String nameFile = uploadForm.getFileItem().getFile().toString();
		String newFileName = uploadForm.getFileItem().getFileName();
		String newFile = nameFile.substring(0, nameFile.lastIndexOf(File.separator)) + File.separator + newFileName;
		File file = new File(newFile);
		CrearDocumentoDto crearDoc = RecoveryToGestorDocAssembler.getCrearDocumentoDto(file, newFileName, usuPass, obtenerMatricula(tipoExp, claseExp, tipoFichero));
		try {
			respuesta = gestorDocumentalServicioDocumentosApi.crearDocumento(cabecera, crearDoc);
			if(respuesta != null) {
				uploadDoc(tipoEntidad, uploadForm, new Long(respuesta.getIdDocumento()));				
			}
		} catch (GestorDocumentalException e) {
			logger.error("upload error: " + e);
		}
		return respuesta;
	}
	
	private String obtenerMatricula(String tipoExp, String claseExp, String tipoFichero){
		StringBuilder sb = new StringBuilder();
		if (tipoExp.equals(GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS)) {
			//Recogemos el mapeo filtrado por el TFA y el codigo TDN2
			MapeoTipoContenedor mapeo = mapeoTipoContenedorDao.getMapeoByTfaAndTdn2(tipoExp, claseExp, tipoFichero);
			if(!Checks.esNulo(mapeo)){
				sb.append(tipoExp);
				sb.append("-");
				sb.append(claseExp);
				sb.append("-");
				sb.append(mapeo.getCodigoTDN2().substring(6));
			}
		} else {
			//Para Activos Financieros y Personas el tipoFichero coincide con la matrícula
			sb.append(tipoFichero);
		}
		return sb.toString();
	}
	
	private String getClaseExpedienteByProcedimientoPadre(Procedimiento prc) {
		String claseExp = cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
		Procedimiento padre = prc.getProcedimientoPadre();
		if(!Checks.esNulo(padre)) {
			while(Checks.esNulo(claseExp)) {
				if(cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(padre.getTipoProcedimiento().getCodigo()) == null){
					padre = padre.getProcedimientoPadre();
				}else{
					claseExp = cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(padre.getTipoProcedimiento().getCodigo());
				}
			}
		}
		return claseExp;
	}
	
	/**
	 * Se filtran los contenedores por el Tipo de Documento a subir, con los contenedores creados del Asunto.
	 * Si devuelve varios, estarán ordenados por fechacreacion descendente.
	 * @param uploadForm
	 * @param listaContenedores
	 * @return
	*/
	private List<String> contenedoresAdecuadosYOrdenados(WebFileItem uploadForm, List<String> listaContenedores) {
		String codTFA = uploadForm.getParameters().get("comboTipoFichero");

		List<String> listContenedoresPorTipoPrc = new ArrayList<String>();
		List<MapeoTipoContenedor> tipoContenedorAndFichero = genericDao.getList(MapeoTipoContenedor.class,genericDao.createFilter(FilterType.EQUALS, "tipoFichero.codigo", codTFA));
		for(MapeoTipoContenedor tipoFichMapeado : tipoContenedorAndFichero) {
			String categoria = tipoFichMapeado.getCodigoTDN2().substring(3, 5);
			if(!Checks.esNulo(categoria) && !listContenedoresPorTipoPrc.contains(categoria)) {
				listContenedoresPorTipoPrc.add(categoria);
			}
		}
		for(String tipoContenedor : listaContenedores) {
			if(!listContenedoresPorTipoPrc.contains(tipoContenedor)) {
				listaContenedores.set(listaContenedores.indexOf(tipoContenedor),null);
			}
		}
		
		return listaContenedores;
	} 
	
	public FileItem bajarAdjunto(String adjuntoId) {
		logger.info("[AdjuntoHayaManager.bajarAdjunto] adjuntoId: " + adjuntoId);
		RespuestaDescargarDocumento respuesta = null;
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), usuario.getUsername());
		try {
			respuesta = gestorDocumentalServicioDocumentosApi.descargarDocumento(Long.valueOf(adjuntoId), usuPass);
		} catch (NumberFormatException e) {
			logger.error("bajarAdjuntoAsunto error: " + e);
		} catch (GestorDocumentalException e) {
			logger.error("bajarAdjuntoAsunto error: " + e);
		}
		try {
			return GestorDocToRecoveryAssembler.getFileItem(respuesta);
		} catch (IOException e) {
			logger.error("bajarAdjuntoAsunto error: " + e);
		}
		return null;
	}
	
	private String getUsuarioGestorDocumental() {
		return proxyFactory.proxy(ParametrizacionApi.class).buscarParametroPorNombre(Parametrizacion.GESTOR_DOCUMENTAL_REST_CLIENT_USUARIO).getValor();
	}
	
	private String getPasswordGestorDocumental() {
		return proxyFactory.proxy(ParametrizacionApi.class).buscarParametroPorNombre(Parametrizacion.GESTOR_DOCUMENTAL_REST_CLIENT_PASSWORD).getValor();
	}
	
	/**
	 * Busca si NO hay contenedor para el tipo de prc.
	 * @param prc
	 *  @return false - No se ha de crear contenedor ||| true - Hay que crear un contenedor para el TIPO de prc
	 */
	public boolean buscarTPRCsinContenedor(Procedimiento prc) {
		boolean resultado = false;
		String claseExpe = cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
		if(!Checks.esNulo(claseExpe)) {
			List<ContenedorGestorDocumental> contenedor = genericDao.getList(ContenedorGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "asunto", prc.getAsunto()), genericDao.createFilter(FilterType.EQUALS, "codigoClase", claseExpe));
			if(Checks.estaVacio(contenedor)) {
				resultado = true;	
			}
		}
		return resultado;		
	}
	
	/**
	 * Devuelve un lista de la clase de expediente que contiene el asunto ordenada por su fecha de creación
	 * @param asu
	 * @return
	 */
	private List<String> getContenedoresByAsunto(Long idAsunto, WebFileItem uploadForm) {
		Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
		List<ContenedorGestorDocumental> listaContenedor = genericDao.getListOrdered(ContenedorGestorDocumental.class, order ,genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto));
		List<String> listaClaseExp = new ArrayList<String>();
		
		for(ContenedorGestorDocumental contenedor : listaContenedor) {
			listaClaseExp.add(contenedor.getCodigoClase());
		}
		
		return contenedoresAdecuadosYOrdenados(uploadForm, listaClaseExp);
	}
	
	 private String uploadDoc(String tipoEntidad, WebFileItem uploadForm, Long idDocumento) {
		String tipoDocumento = "";
		
		Integer max = getLimiteFichero(tipoEntidad);
		if (uploadForm.getFileItem().getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }
		
		if(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad) || DDTipoEntidad.CODIGO_ENTIDAD_PERSONA.equals(tipoEntidad) || DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad)) {
			tipoDocumento = uploadForm.getParameter("comboTipoDoc");
			DDTipoAdjuntoEntidad tpoAdjEnt = genericDao.get(DDTipoAdjuntoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
			if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
				Expediente expediente = expedienteDao.get(Long.parseLong(uploadForm.getParameter("id")));
				AdjuntoExpediente adjuntoexp = new AdjuntoExpediente(uploadForm.getFileItem(), tpoAdjEnt);
//				adjuntoexp.setServicerId(idDocumento);
				adjuntoexp.setExpediente(expediente);
				genericDao.save(AdjuntoExpediente.class, adjuntoexp);
			} else if (DDTipoEntidad.CODIGO_ENTIDAD_PERSONA.equals(tipoEntidad)) {
				Persona persona = personaDao.get(Long.parseLong(uploadForm.getParameter("id")));
				AdjuntoPersona adjPers = new AdjuntoPersona(uploadForm.getFileItem(),tpoAdjEnt);
				adjPers.setServicerId(idDocumento);
				adjPers.setPersona(persona);
				genericDao.save(AdjuntoPersona.class, adjPers);
			} else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad)) {
				Contrato contrato = contratoDao.get(Long.parseLong(uploadForm.getParameter("id")));
				AdjuntoContrato adjCnt = new AdjuntoContrato(uploadForm.getFileItem(),tpoAdjEnt);
				adjCnt.setServicerId(idDocumento);
				adjCnt.setContrato(contrato);
				genericDao.save(AdjuntoContrato.class, adjCnt);
			}
		}else{
			tipoDocumento = uploadForm.getParameter("comboTipoFichero");
			DDTipoFicheroAdjunto tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
			EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(uploadForm.getFileItem());
			adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
			adjuntoAsunto.setServicerId(idDocumento);
			if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad)) {
				Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(Long.parseLong(uploadForm.getParameter("id")));
				adjuntoAsunto.setAsunto(asunto);
			} else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad)) {
				Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(Long.parseLong(uploadForm.getParameter("prcId")));
				adjuntoAsunto.setAsunto(prc.getAsunto());
				adjuntoAsunto.setProcedimiento(prc);
			}
			genericDao.save(EXTAdjuntoAsunto.class, adjuntoAsunto);
		}
		return null;
	}
	 
	 private Integer getLimiteFichero(String tipoEntidad) {
		 String limite = "";
		 if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad) || DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad)) {
			 limite = Parametrizacion.LIMITE_FICHERO_ASUNTO;
		 }else if(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
			 limite = Parametrizacion.LIMITE_FICHERO_EXPEDIENTE;
		 }else if(DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad)) {
			 limite = Parametrizacion.LIMITE_FICHERO_CONTRATO;
		 }else if(DDTipoEntidad.CODIGO_ENTIDAD_PERSONA.equals(tipoEntidad)) {
			 limite = Parametrizacion.LIMITE_FICHERO_PERSONA;
		 }
			 
		try {
		    Parametrizacion param = (Parametrizacion) executor.execute(
		            ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, limite);
		    return Integer.valueOf(param.getValor());
		} catch (Exception e) {
		    logger.warn("No esta parametrizado el límite máximo del fichero en bytes para asuntos, se toma un valor por defecto (2Mb)");
		    return new Integer(2 * 1024 * 1024);
		}
	 }
	
	 private Set<EXTAdjuntoDto> creaObjetosEXTAsuntos(final Set<AdjuntoAsunto> adjuntos, final Usuario usuario, final Boolean borrarOtrosUsu) {
			if (adjuntos == null)
				return null;

			HashSet<EXTAdjuntoDto> result = new HashSet<EXTAdjuntoDto>();

			for (final AdjuntoAsunto aa : adjuntos) {
				EXTAdjuntoDto dto = new EXTAdjuntoDto() {
					@Override
					public Boolean getPuedeBorrar() {
						return (borrarOtrosUsu || aa.getAuditoria().getUsuarioCrear().equals(usuario.getUsername()));
					}

					@Override
					public AdjuntoAsunto getAdjunto() {
						return (AdjuntoAsunto) aa;
					}

					@Override
					public String getTipoDocumento() {
						if (aa instanceof EXTAdjuntoAsunto) {
							if (((EXTAdjuntoAsunto) aa).getTipoFichero() != null){
								return ((EXTAdjuntoAsunto) aa).getTipoFichero().getDescripcion();
							}
						}
						return "";
					}

					@Override
					public Long prcId() {
						if (aa instanceof EXTAdjuntoAsunto) {
							if(((EXTAdjuntoAsunto) aa).getProcedimiento() != null){
								return ((EXTAdjuntoAsunto) aa).getProcedimiento().getId();
							}
						}
						return null;
					}

					@Override
					public String getRefCentera() {
						if(aa.getServicerId() != null) {
							return aa.getServicerId().toString();
						}
						return null;
					}

					@Override
					public String getNombreTipoDoc() {
						return null;
					}

					@Override
					public Long getIdAdjuntoBlob() {
						if(aa.getAdjunto() != null) {
							return aa.getAdjunto().getId();
						}
						return null;
					}
					
				};
				result.add(dto);
			}
			return result;
		}	

	 private Long getIdActivoHaya(Contrato contrato) {
			List<ContenedorGestorDocumental> contenedor = genericDao.getList(ContenedorGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "contrato.id", contrato.getId()));

			if(Checks.estaVacio(contenedor)) {
				ActivoInputDto input = new ActivoInputDto();
				input.setEvent(ActivoInputDto.EVENTO_IDENTIFICADOR_ACTIVO_ORIGEN);
				input.setIdActivoOrigen(contrato.getNroContrato().substring(17, 27));
				input.setIdOrigen(ActivoInputDto.ID_ORIGEN_SAREB);
				input.setIdCliente(ActivoInputDto.ID_CLIENTE_NOS);
				input.setIdTipoActivo(ActivoInputDto.ID_TIPO_ACTIVO_RED);
				ActivoOutputDto output = gestorDocumentalMaestroApi.ejecutarActivo(input);
				
				if(output == null || (output != null && output.getIdActivoHaya() == null)) {
					return null;
				}
				insertarContenedor(Integer.valueOf(output.getIdActivoHaya()), null, contrato, null, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ACTIVOS_FINANCIEROS, GestorDocumentalConstants.CODIGO_CLASE_EXPEDIENTE_ACTIVOS_FINANCIERO);
				return new Long(output.getIdActivoHaya());
			}
			return contenedor.get(0).getIdExterno();
			
	 }
	 
	 
	 private Long getIdClienteHaya(Persona persona) {

		 List<ContenedorGestorDocumental> contenedor = genericDao.getList(ContenedorGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "persona.id", persona.getId()));
			
			if(Checks.estaVacio(contenedor)) {
				PersonaInputDto input = new PersonaInputDto();
				input.setEvent(PersonaInputDto.EVENTO_IDENTIFICADOR_PERSONA_ORIGEN);
				input.setIdPersonaOrigen(persona.getDocId());
				input.setIdOrigen(PersonaInputDto.ID_ORIGEN_NOS);
				input.setIdCliente(PersonaInputDto.ID_CLIENTE_SAREB);
				
				PersonaOutputDto output = gestorDocumentalMaestroApi.ejecutarPersona(input);
				
				if(output == null || (output != null && output.getIdIntervinienteHaya() == null)) {
					return null;
				}
				insertarContenedor(Integer.valueOf(output.getIdIntervinienteHaya()), null, null, persona, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_ENTIDADES, getClaseExpPersona(persona));
				return new Long(output.getIdIntervinienteHaya());
			}
			return contenedor.get(0).getIdExterno();
	 }
	 
	 private void insertarContenedor(Integer idExpediente, Asunto asun, Contrato contrato, Persona persona, String tipoExp, String claseExp) {
	    	ContenedorGestorDocumental contenedor = new ContenedorGestorDocumental();
			contenedor.setIdExterno(new Long(idExpediente));
			contenedor.setAsunto(asun);
			contenedor.setPersona(persona);
			contenedor.setContrato(contrato);
			contenedor.setCodigoTipo(tipoExp);
			contenedor.setCodigoClase(claseExp);
			Auditoria.save(contenedor);
			genericDao.save(ContenedorGestorDocumental.class, contenedor);
    } 
	 
	 private class PersonaIdentificacionDocumento {
		private IdentificacionDocumento identificacionDocumento;
		private Persona persona;
		
		public Persona getPersona() {
			return persona;
		}
		
		public void setPersona(Persona persona) {
			this.persona = persona;
		}
		
		
		public IdentificacionDocumento getIdentificacionDocumento() {
			return identificacionDocumento;
		}
		
		public void setIdentificacionDocumento(
				IdentificacionDocumento identificacionDocumento) {
			this.identificacionDocumento = identificacionDocumento;
		}
	}
	 
	 private class ContratoIdentificacionDocumento {
			private IdentificacionDocumento identificacionDocumento;
			private Contrato contrato;
			
			public Contrato getContrato() {
				return contrato;
			}
			
			public void setContrato(Contrato contrato) {
				this.contrato = contrato;
			}
			
			public IdentificacionDocumento getIdentificacionDocumento() {
				return identificacionDocumento;
			}
			
			public void setIdentificacionDocumento(
					IdentificacionDocumento identificacionDocumento) {
				this.identificacionDocumento = identificacionDocumento;
			}
		}
	 
	 private class AsuntoIdentificacionDocumento {
			private IdentificacionDocumento identificacionDocumento;
			private Asunto asunto;
			
			public Asunto getAsunto() {
				return asunto;
			}
			
			public void setAsunto(Asunto asunto) {
				this.asunto = asunto;
			}
			
			public IdentificacionDocumento getIdentificacionDocumento() {
				return identificacionDocumento;
			}
			
			public void setIdentificacionDocumento(
					IdentificacionDocumento identificacionDocumento) {
				this.identificacionDocumento = identificacionDocumento;
			}
		}
	
}
