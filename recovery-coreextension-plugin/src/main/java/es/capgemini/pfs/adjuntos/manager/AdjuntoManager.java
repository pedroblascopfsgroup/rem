package es.capgemini.pfs.adjuntos.manager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.adjuntos.api.AdjuntoApi;
import es.capgemini.pfs.asunto.dao.AsuntoDao;
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
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.dao.AdjuntoExpedienteDao;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.AdjuntoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.iplus.IPLUSAdjuntoAuxDto;
import es.capgemini.pfs.iplus.IPLUSUtils;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.dao.AdjuntoPersonaDao;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.AdjuntoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tipoFicheroAdjuntoEntidad.DDTipoAdjuntoEntidad;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Service("adjuntoManagerImpl")
public class AdjuntoManager implements AdjuntoApi{

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired(required = false)
	private IPLUSUtils iplus;
	
	@Autowired
	private GenericABMDao genericdDao;
	
    @Autowired
    private Executor executor;
    
    @Autowired
    private AsuntoDao asuntoDao;
    
    @Autowired
    private PersonaDao personaDao;
    
    @Autowired
    private ExpedienteDao expedienteDao;
    
    @Autowired
    private ContratoDao contratoDao;
    
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private AdjuntoPersonaDao adjuntoPersonaDao;
	
	@Autowired
    private AdjuntoExpedienteDao adjuntoExpedienteDao;
	
	@Autowired
    private AdjuntoContratoDao adjuntoContratoDao;

	@Override
	@Transactional(readOnly = false)
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
		//List<EXTAdjuntoDto> adjuntosConBorrado = new ArrayList<EXTAdjuntoDto>();

		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		Boolean borrarOtrosUsu = true;
		
		if (iplus == null || !iplus.instalado()) {
			borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
		}

		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(id);
		List<EXTAdjuntoDto> adjuntosAsunto = new ArrayList<EXTAdjuntoDto>();
		
		if (iplus != null && iplus.instalado()) {
			Set<AdjuntoAsunto> setAdjuntos = obtieneAdjuntosIplus(asunto.getId());
			for (AdjuntoAsunto adjuntoAsunto : setAdjuntos) {
				adjuntoAsunto.setAsunto(asunto);
				IPLUSAdjuntoAuxDto dtoAux = iplus.completarInformacionAdjunto(asunto.getId(), adjuntoAsunto.getDescripcion());
				Procedimiento procedimiento = dtoAux.getProc();
				adjuntoAsunto.setProcedimiento(procedimiento);
				String contentType = dtoAux.getContentType();
				adjuntoAsunto.setContentType(contentType);
				Long longitud = dtoAux.getLongitud();
				adjuntoAsunto.setLength(longitud);
				//DDTipoFicheroAdjunto tipoFicheroAdjunto = dtoAux.getTipoDocumento();
				//adjuntoAsunto.setTipoDocumento(tipoDocumento);
			}
			adjuntosAsunto.addAll(creaObjetosEXTAsuntos(setAdjuntos, usuario, borrarOtrosUsu));
		}
		Set<EXTAdjuntoDto> adjuntosRecovery = creaObjetosEXTAsuntos(asunto.getAdjuntos(), usuario, borrarOtrosUsu);
		Set<EXTAdjuntoDto> adjuntosRecovery2 = null;
		if (iplus != null && iplus.instalado()) {
			adjuntosRecovery2 = iplus.eliminarRepetidos(adjuntosRecovery, adjuntosAsunto);
		} else {
			adjuntosRecovery2 = adjuntosRecovery;
		}
		adjuntosAsunto.addAll(adjuntosRecovery2);
		
		return ordenaListado(adjuntosAsunto);
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(id);
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();

		Comparator<AdjuntoContrato> comparador = new Comparator<AdjuntoContrato>() {
			@Override
			public int compare(AdjuntoContrato o1, AdjuntoContrato o2) {
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
		if (!Checks.esNulo(asunto)) {
			List<Contrato> contratos = new ArrayList<Contrato>();
			contratos.addAll(asunto.getContratos());
			for (final Contrato c : contratos) {
				final List<AdjuntoContrato> adjuntos = c.getAdjuntosAsList();
				Collections.sort(adjuntos, comparador);
				ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

					@Override
					public Long getId() {
						return c.getId();
					}

					@Override
					public String getDescripcion() {
						return c.getDescripcion();
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
				adjuntosMapeados.add(dto);
			}
		}
		return adjuntosMapeados;
	}
	
	

	@Override
	@Transactional(readOnly = false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		List<Persona> personas = proxyFactory.proxy(AsuntoApi.class).obtenerPersonasDeUnAsunto(id);
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();

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

		for (final Persona p : personas) {
			final List<AdjuntoPersona> adjuntos = p.getAdjuntosAsList();
			Collections.sort(adjuntos, comparador);
			ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

				@Override
				public Long getId() {
					return p.getId();
				}

				@Override
				public String getDescripcion() {
					return p.getDescripcion();
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
			adjuntosMapeados.add(dto);
		}

		return adjuntosMapeados;
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		final Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(id);
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();

		Comparator<AdjuntoExpediente> comparador = new Comparator<AdjuntoExpediente>() {
			@Override
			public int compare(AdjuntoExpediente o1, AdjuntoExpediente o2) {
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
		if (!Checks.esNulo(asunto) && !Checks.esNulo(asunto.getExpediente()) && !Checks.estaVacio(asunto.getExpediente().getAdjuntosAsList())) {
			final List<AdjuntoExpediente> adjuntosExp = asunto.getExpediente().getAdjuntosAsList();
			Collections.sort(adjuntosExp, comparador);

			ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

				@Override
				public Long getId() {
					return asunto.getExpediente().getId();
				}

				@Override
				public String getDescripcion() {
					return asunto.getExpediente().getDescripcion();
				}

				@Override
				public List getAdjuntosAsList() {
					return adjuntosExp;
				}

				@Override
				public List getAdjuntos() {
					return adjuntosExp;
				}
			};
			adjuntosMapeados.add(dto);
		}

		return adjuntosMapeados;
	}
	
	
	
	@Override
	@Transactional(readOnly = false)
	public String upload(WebFileItem uploadForm) {

		String comboTipoFichero = uploadForm.getParameter("comboTipoFichero");
		
		FileItem fileItem = uploadForm.getFileItem();

        //En caso de que el fichero est� vacio, no subimos nada
        if (fileItem == null || fileItem.getLength() <= 0) { return null; }
        
        logger.info(fileItem.getFileName() + ": " + fileItem.getContentType());
        
        Integer max = getLimiteFichero(Parametrizacion.LIMITE_FICHERO_ASUNTO);

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }

        Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(Long.parseLong(uploadForm.getParameter("id")));
        
        EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(fileItem);
        
        if (!Checks.esNulo(comboTipoFichero) && !comboTipoFichero.equals("")) {
			DDTipoFicheroAdjunto tipoFicheroAdjunto = genericdDao.get(DDTipoFicheroAdjunto.class, genericdDao.createFilter(FilterType.EQUALS, "codigo", comboTipoFichero));
			adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
		}
		
        adjuntoAsunto.setAsunto(asunto);
		
		//En caso de que estemos añadiendo un adjunto desde el propio procedimiento
        if (!Checks.esNulo(uploadForm.getParameter("prcId"))) {
			Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(Long.parseLong(uploadForm.getParameter("prcId")));
	        if(!Checks.esNulo(procedimiento)){
				adjuntoAsunto.setProcedimiento(procedimiento);
			}
        }
        
        Auditoria.save(adjuntoAsunto);
		asunto.getAdjuntos().add(adjuntoAsunto);

		// asunto.addAdjunto(fileItem);
		proxyFactory.proxy(AsuntoApi.class).saveOrUpdateAsunto(asunto);
        
        
//        Asunto asunto = asuntoDao.get(Long.parseLong(uploadForm.getParameter("id")));        
//        asunto.addAdjunto(fileItem);
//        asuntoDao.save(asunto);

		//Integracion con IPLUS, si está configurado el flag correspondiente en devon.properties
        if (iplus != null && iplus.instalado()) {
        	iplus.almacenar(asunto, adjuntoAsunto);
        }
        
        return null;
	}
	
	

	@Override
	@Transactional(readOnly = false)
	public String uploadPersona(WebFileItem uploadForm) {
        FileItem fileItem = uploadForm.getFileItem();

        //En caso de que el fichero est� vacio, no subimos nada
        if (fileItem == null || fileItem.getLength() <= 0) { return null; }

        Integer max = getLimiteFichero(Parametrizacion.LIMITE_FICHERO_PERSONA);

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }

        Persona persona = personaDao.get(Long.parseLong(uploadForm.getParameter("id")));
		AdjuntoPersona adjPers;
		
		if(!Checks.esNulo(uploadForm.getParameter("comboTipoDoc")) && !uploadForm.getParameter("comboTipoDoc").equals("")){
			DDTipoAdjuntoEntidad tpoAdjEnt = genericDao.get(DDTipoAdjuntoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", uploadForm.getParameter("comboTipoDoc")));
			adjPers = new AdjuntoPersona(uploadForm.getFileItem(),tpoAdjEnt);
		}else{
			adjPers = new AdjuntoPersona(uploadForm.getFileItem());
		}
		
		adjPers.setPersona(persona);
		Auditoria.save(adjPers);
		
		genericDao.save(AdjuntoPersona.class, adjPers);

        return null;
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public String uploadExpediente(WebFileItem uploadForm) {
        FileItem fileItem = uploadForm.getFileItem();

        //En caso de que el fichero est� vacio, no subimos nada
        if (fileItem == null || fileItem.getLength() <= 0) { return null; }

        Integer max = getLimiteFichero(Parametrizacion.LIMITE_FICHERO_EXPEDIENTE);

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }

        Expediente expediente = expedienteDao.get(Long.parseLong(uploadForm.getParameter("id")));
		AdjuntoExpediente adjuntoexp;
		
		if(!Checks.esNulo(uploadForm.getParameter("comboTipoDoc")) && !uploadForm.getParameter("comboTipoDoc").equals("")){
			DDTipoAdjuntoEntidad tpoAdjEnt = genericDao.get(DDTipoAdjuntoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", uploadForm.getParameter("comboTipoDoc")));
			adjuntoexp = new AdjuntoExpediente(uploadForm.getFileItem(), tpoAdjEnt);
		}else{
			adjuntoexp = new AdjuntoExpediente(uploadForm.getFileItem());
		}
		 
		adjuntoexp.setExpediente(expediente);
		Auditoria.save(adjuntoexp);
        
		genericDao.save(AdjuntoExpediente.class, adjuntoexp);

        return null;
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public String uploadContrato(WebFileItem uploadForm) {
        FileItem fileItem = uploadForm.getFileItem();

        //En caso de que el fichero est� vacio, no subimos nada
        if (fileItem == null || fileItem.getLength() <= 0) { return null; }

        Integer max = getLimiteFichero(Parametrizacion.LIMITE_FICHERO_CONTRATO);

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }

        Contrato contrato = contratoDao.get(Long.parseLong(uploadForm.getParameter("id")));
		AdjuntoContrato adjCnt;
		
		if(!Checks.esNulo(uploadForm.getParameter("comboTipoDoc")) && !uploadForm.getParameter("comboTipoDoc").equals("")){
			DDTipoAdjuntoEntidad tpoAdjEnt = genericDao.get(DDTipoAdjuntoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", uploadForm.getParameter("comboTipoDoc")));
			adjCnt = new AdjuntoContrato(uploadForm.getFileItem(),tpoAdjEnt);
		}else{
			adjCnt = new AdjuntoContrato(uploadForm.getFileItem());
		}
		
		adjCnt.setContrato(contrato);
		Auditoria.save(adjCnt);

		genericDao.save(AdjuntoContrato.class, adjCnt);

        return null;
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");

		Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
		List<EXTAdjuntoDto> adjuntosAsunto = new ArrayList<EXTAdjuntoDto>();

		adjuntosAsunto.addAll(creaObjetosEXTAsuntos(procedimiento.getAdjuntos(), usuario, borrarOtrosUsu));

		return ordenaListado(adjuntosAsunto);
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		List<AdjuntoDto> adjuntosConBorrado = new ArrayList<AdjuntoDto>();

		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class)
				.getUsuarioLogado();

		final Boolean borrarOtrosUsu = tieneFuncion(usuario,
				"BORRAR_ADJ_OTROS_USU");
		
		Expediente exp = getExpediente(id);
		List<AdjuntoExpediente> adjuntos= new ArrayList<AdjuntoExpediente>();
		if (!Checks.esNulo(exp)){
			adjuntos = exp.getAdjuntosAsList();
		}
		Comparator<AdjuntoExpediente> comparador = new Comparator<AdjuntoExpediente>() {
			@Override
			public int compare(AdjuntoExpediente o1, AdjuntoExpediente o2) {
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
		Collections.sort(adjuntos, comparador);
		for (final AdjuntoExpediente adj : adjuntos){
			AdjuntoDto dto = new AdjuntoDto() {
				
				@Override
				public Boolean getPuedeBorrar() {
					if (borrarOtrosUsu
							|| adj.getAuditoria().getUsuarioCrear().equals(
									usuario.getUsername())) {
						return true;
					} else {
						return false;
					}
				}
				
				@Override
				public Object getAdjunto() {
					return adj;
				}

				@Override
				public String getRefCentera() {
					return null;
				}
			};
			adjuntosConBorrado.add(dto);
		}
		return adjuntosConBorrado;
	}
	
	@Override
	@Transactional(readOnly = false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		List<Persona> personas =(List<Persona>) executor.execute("expedienteManager.findPersonasByExpedienteId",id);
		List<ExtAdjuntoGenericoDto> adjuntosMapeado=new ArrayList<ExtAdjuntoGenericoDto>();
		
		Comparator<AdjuntoPersona> comparador = new Comparator<AdjuntoPersona>() {
			@Override
			public int compare(AdjuntoPersona o1, AdjuntoPersona o2) {
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
		
		for(Persona p : personas){
			List<AdjuntoPersona> adjuntos = p.getAdjuntosAsList();
			Collections.sort(adjuntos, comparador);
			ExtAdjuntoGenericoDtoImpl dto =new ExtAdjuntoGenericoDtoImpl();
			dto.setId(p.getId());
			dto.setDescripcion(p.getDescripcion());
			dto.setAdjuntosAsList(adjuntos);
			dto.setAdjuntos(adjuntos);
			adjuntosMapeado.add(dto);
		}
		return adjuntosMapeado;
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		List<Contrato> contratos =(List<Contrato>) executor.execute("expedienteManager.findContratosRiesgoExpediente",id);
		List<ExtAdjuntoGenericoDto> adjuntosMapeado=new ArrayList<ExtAdjuntoGenericoDto>();
		
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
		
		for(Contrato c : contratos){
			List<AdjuntoContrato> adjuntos = c.getAdjuntosAsList();
			Collections.sort(adjuntos, comparador);
			ExtAdjuntoGenericoDtoImpl dto = new ExtAdjuntoGenericoDtoImpl();
			dto.setId(c.getId());
			dto.setDescripcion(c.getDescripcion());
			dto.setAdjuntosAsList(adjuntos);
			dto.setAdjuntos(adjuntos);
			adjuntosMapeado.add(dto);
		}
		return adjuntosMapeado;
	}
	
	@Override
	@Transactional(readOnly = false)
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

				@Override
				public String getRefCentera() {
					return null;
				}
			};
			adjuntosConBorrado.add(dto);
		}
		
		EventFactory.onMethodStop(this.getClass());
		return adjuntosConBorrado;
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		List<AdjuntoDto> adjuntosConBorrado = new ArrayList<AdjuntoDto>();

		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class)
				.getUsuarioLogado();

		final Boolean borrarOtrosUsu = tieneFuncion(usuario,
				"BORRAR_ADJ_OTROS_USU");

		Persona persona = proxyFactory.proxy(PersonaApi.class).get(id);
		List<AdjuntoPersona> adjuntosPersona = persona.getAdjuntosAsList();

		Comparator<AdjuntoPersona> comparador = new Comparator<AdjuntoPersona>() {
			@Override
			public int compare(AdjuntoPersona o1, AdjuntoPersona o2) {
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
		Collections.sort(adjuntosPersona, comparador);
		for (final AdjuntoPersona aa : adjuntosPersona) {
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

				@Override
				public String getRefCentera() {
					return null;
				}
			};
			adjuntosConBorrado.add(dto);
		}
		return adjuntosConBorrado;
	}
	
	@Override
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoAsunto(Long asuntoId, String adjuntoId) {
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, asuntoId); //get(asuntoId);
        return asunto.getAdjunto(Long.parseLong(adjuntoId)).getAdjunto().getFileItem();
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoPersona(String adjuntoId) {
		return adjuntoPersonaDao.get(Long.valueOf(adjuntoId)).getAdjunto().getFileItem();
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoExpediente(String adjuntoId) {
		return adjuntoExpedienteDao.get(Long.parseLong(adjuntoId)).getAdjunto().getFileItem();
	}
	
	@Override
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoContrato(String adjuntoId) {
		return adjuntoContratoDao.get(Long.parseLong(adjuntoId)).getAdjunto().getFileItem();
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
	
	private Set<AdjuntoAsunto> obtieneAdjuntosIplus(Long id) {
		String idProcedi = iplus.obtenerIdAsuntoExterno(id);
		Set<AdjuntoAsunto> adjuntos = iplus.listarAdjuntosIplus(idProcedi);
		return adjuntos;
	}
	
	private Set<EXTAdjuntoDto> creaObjetosEXTAsuntos(final Set<AdjuntoAsunto> adjuntos, final Usuario usuario, final Boolean borrarOtrosUsu) {
		if (adjuntos == null)
			return null;

		HashSet<EXTAdjuntoDto> result = new HashSet<EXTAdjuntoDto>();

		for (final AdjuntoAsunto aa : adjuntos) {
			EXTAdjuntoDto dto = new EXTAdjuntoDto() {
				@Override
				public Boolean getPuedeBorrar() {
					if (borrarOtrosUsu || aa.getAuditoria().getUsuarioCrear().equals(usuario.getUsername())) {
						return true;
					} else {
						return false;
					}
				}

				@Override
				public AdjuntoAsunto getAdjunto() {
					return (AdjuntoAsunto) aa;
				}

				@Override
				public String getTipoDocumento() {
					if (aa instanceof EXTAdjuntoAsunto) {
						if (((EXTAdjuntoAsunto) aa).getTipoFichero() != null)
							return ((EXTAdjuntoAsunto) aa).getTipoFichero().getDescripcion();
						else
							return "";
					} else
						return "";

				}

				@Override
				public Long prcId() {
					if (aa instanceof EXTAdjuntoAsunto) {
						if(((EXTAdjuntoAsunto) aa).getProcedimiento() != null)
							return ((EXTAdjuntoAsunto) aa).getProcedimiento().getId();
						else 
							return null;
					}
					else 
						return null;
				}

				@Override
				public String getRefCentera() {
					return null;
				}
			};
			result.add(dto);
		}
		return result;
	}
	
	private List<? extends EXTAdjuntoDto> ordenaListado(List<EXTAdjuntoDto> adjuntosAsunto) {
		Comparator<EXTAdjuntoDto> comparador = new Comparator<EXTAdjuntoDto>() {
			@Override
			public int compare(EXTAdjuntoDto o1, EXTAdjuntoDto o2) {
				if (Checks.esNulo(o1) && Checks.esNulo(o2)) {
					return 0;
				} else if (Checks.esNulo(o1)) {
					return -1;
				} else if (Checks.esNulo(o2)) {
					return 1;
				} else {
					AdjuntoAsunto a1 = (AdjuntoAsunto) o1.getAdjunto();
					AdjuntoAsunto a2 = (AdjuntoAsunto) o2.getAdjunto();
					if (Checks.esNulo(a1) && Checks.esNulo(a2)) {
						return 0;
					} else if (Checks.esNulo(a1)) {
						return -1;
					} else if (Checks.esNulo(a2)) {
						return 1;
					} else {
						return a2.getAuditoria().getFechaCrear().compareTo(a1.getAuditoria().getFechaCrear());
					}
				}
			}
			
		};
		Collections.sort(adjuntosAsunto, comparador);

		return adjuntosAsunto;
	}
	
    private Integer getLimiteFichero(String limite) {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, limite);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
            logger.warn("No esta parametrizado el l�mite m�ximo del fichero en bytes para asuntos, se toma un valor por defecto (2Mb)");
            return new Integer(2 * 1024 * 1024);
        }
    }
    
	private Expediente getExpediente(Long id) {
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "id", id);
		Expediente exp = genericDao.get(Expediente.class, filtroExpediente);
		return exp;
	}

	
}
