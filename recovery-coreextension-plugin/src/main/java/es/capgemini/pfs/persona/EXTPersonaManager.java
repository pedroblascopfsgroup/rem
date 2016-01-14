package es.capgemini.pfs.persona;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.parametrizacion.ParametrizacionApi;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.plazoTareasDefault.PlazoTareasDefaultApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.estadoFinanciero.model.DDSituacionEstadoFinanciero;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.dao.EXTPersonaDao;
import es.capgemini.pfs.persona.dto.DtoUmbral;
import es.capgemini.pfs.persona.dto.EXTDtoBuscarClientes;
import es.capgemini.pfs.persona.model.AdjuntoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

@Component
public class EXTPersonaManager extends BusinessOperationOverrider<PersonaApi> implements PersonaApi{

	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
    private Executor executor;
	
	@Autowired
	private EXTPersonaDao personaDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private final Log logger = LogFactory.getLog(getClass());

	
	@Override
	public String managerName() {
		return "personaManager";
	}

	@Override
	@Transactional(readOnly=false)
	@BusinessOperation(overrides=PrimariaBusinessOperation.BO_PER_MGR_UPDATE_UMBRAL)
	public void updateUmbral(DtoUmbral dtoUmbral) {
		PlazoTareasDefault plazoMaximo = proxyFactory.proxy(PlazoTareasDefaultApi.class).buscarPlazoPorDescripcion("Plazo maximo umbral");
		Date fechaActual= new Date();
		Long fechaActualLong = fechaActual.getTime();
		Date fechaMaxima =  new Date(fechaActualLong + plazoMaximo.getPlazo());
		Parametrizacion importeUmbralMaximo = proxyFactory.proxy(ParametrizacionApi.class).buscarParametroPorNombre("LimiteImporteUmbral");
		if (dtoUmbral.getPersona().getFechaUmbral().after(fechaMaxima)){
			throw new BusinessOperationException("El plazo se excede del m�ximo permitido");
		}
		
		if ( dtoUmbral.getPersona().getImporteUmbral()> Long.parseLong(importeUmbralMaximo.getValor()) ){
			throw new BusinessOperationException("El importe umbral es superior al m�ximo permitido");
		}
		
		parent().updateUmbral(dtoUmbral);
		
	}
	
	/**
     * Obtiene los clientes que puede ver un usuario con el perfil de proveedor de solvencia
     * @param clientes dto clientes
     * @return Pagina de personas
     */
    @BusinessOperation(BO_CORE_PERSONA_FINDCLIENTES_PROV_SOLVENCIA)
	@Override
	public Page findClientesProveedorSolvenciaPaginated(
			EXTDtoBuscarClientes clientes) {
    	clientes.setCodigoZonas(getCodigosDeZona(clientes));
    	Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
    	GestorDespacho gestor = buscarGestorDespachoByUsuario(usuario.getId());
        if (clientes.getIsBusquedaGV() != null && clientes.getIsBusquedaGV().booleanValue()) {
            clientes.setPerfiles(usuario.getPerfiles());
        }
        //convertirTipoSituacion(clientes);
        return personaDao.findClientesProveedorSolvenciaPaginated(clientes, gestor);
	}

    /**
     * Obtiene los clientes que puede ver un usuario con el perfil de proveedor de solvencia
     * @param clientes dto clientes
     * @return Pagina de personas
     */
    @BusinessOperation(BO_CORE_PERSONA_FINDCLIENTES_PROV_SOLVENCIA_EXCEL)
	@Override
	public List<Persona> findClientesProveedorSolvenciaExcel(EXTDtoBuscarClientes dto) {
    	dto.setCodigoZonas(getCodigosDeZona(dto));
    	Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
    	GestorDespacho gestor = buscarGestorDespachoByUsuario(usuario.getId());
        if (dto.getIsBusquedaGV() != null && dto.getIsBusquedaGV().booleanValue()) {
        	dto.setPerfiles(usuario.getPerfiles());
        }
        return personaDao.findClientesProveedorSolvenciaExcel(dto,gestor);
	}

	private GestorDespacho buscarGestorDespachoByUsuario(Long id) {
		Filter filtro=genericDao.createFilter(FilterType.EQUALS, "usuario.id", id);
		GestorDespacho gd= genericDao.get(GestorDespacho.class, filtro);
		return gd;
	}

	/**
	 * m�todo comentado por posible utilizaci�n en el futuro
	 * consiste en una pantalla que a�ade m�s campos al adjuntar un asunto de un cliente
	 */
//	@Override
//	@BusinessOperation(BO_CORE_PERSONA_CREAR_ADJUNTOS_AMPLIADOS)
//	@Transactional(readOnly=false)
//	public String crearAdjuntoPersonaAmpliado(WebFileItem uploadForm) {
//		FileItem fileItem = uploadForm.getFileItem();
//
//        //En caso de que el fichero est� vacio, no subimos nada
//        if (fileItem == null || fileItem.getLength() <= 0) { return null; }
//
//        Integer max = getLimiteFichero();
//
//        if (fileItem.getLength() > max) {
//            AbstractMessageSource ms = MessageUtils.getMessageSource();
//            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
//        }
//
//        Filter filtroPersona=genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(uploadForm.getParameter("id")));
//        Persona persona= genericDao.get(Persona.class, filtroPersona);
//        //persona.addAdjunto(fileItem);
//        EXTAdjuntoPersona adjunto= new EXTAdjuntoPersona(fileItem);
//        adjunto.setTipoDocumentoAdjunto(buscaTipoDocumento(uploadForm.getParameter("tipoDocumentoCombo")));
//        adjunto.setNombreNotario(uploadForm.getParameter("nombreNotario"));
//        adjunto.setCalleNotario(uploadForm.getParameter("calleNotario"));
//        adjunto.setNumeroNotario(uploadForm.getParameter("numeroNotario"));
//        adjunto.setCodigoPostalNotario(Long.parseLong(uploadForm.getParameter("codigoPostal")));
//        adjunto.setLocalidadNotario(uploadForm.getParameter("localidad"));
//        adjunto.setTelefono1Notario(Long.parseLong(uploadForm.getParameter("telefono1")));
//        adjunto.setTelefono2Notario(Long.parseLong(uploadForm.getParameter("telefono2")));
//        adjunto.setPersona(persona);
//        
//        genericDao.save(EXTAdjuntoPersona.class, adjunto);
//
//        return null;
//	}
	
	
//	private EXTDDTipoDocumentoAdjunto buscaTipoDocumento(String codigo) {
//		Filter filtro=genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
//		return genericDao.get(EXTDDTipoDocumentoAdjunto.class, filtro);
//	}

	@Override
	@BusinessOperation(BO_CORE_PERSONA_ADJUNTOSMAPEADOS)
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
			};
			adjuntosConBorrado.add(dto);
		}
		return adjuntosConBorrado;
	}
	
	@Override
    public List<Bien> getBienes(Long idPersona) {
    	return parent().getBienes(idPersona);
    }
	
	 private Set<String> getCodigosDeZona(DtoBuscarClientes clientes) {
	        Set<String> zonas;
	        if (clientes.getCodigoZona() != null && clientes.getCodigoZona().trim().length() > 0) {
	            List<String> list = Arrays.asList((clientes.getCodigoZona().split(",")));
	            zonas = new HashSet<String>(list);
	        } else {
	            Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
	            zonas = usuario.getCodigoZonas();
	        }
	        return zonas;
	    }
	
	 /**
     * Recupera el l�mite de tama�o de un fichero.
     * @return limite
     */
    @SuppressWarnings("unused")
	private Integer getLimiteFichero() {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.LIMITE_FICHERO_PERSONA);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
            logger.warn("No esta parametrizado el l�mite m�ximo del fichero en bytes para personas, se toma un valor por defecto (2Mb)");
            return new Integer(2 * 1025 * 1024);
        }
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
	public Persona get(Long id) {
		
		return personaDao.get(id);
	}

	@BusinessOperation(overrides=PrimariaBusinessOperation.BO_PER_MGR_FIND_CLIENTES_PAGINATED)
    public Page findClientesPaginated(DtoBuscarClientes clientes) {
		clientes.setCodigoZonas(getCodigosDeZona(clientes));
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        if (clientes.getIsBusquedaGV() != null && clientes.getIsBusquedaGV().booleanValue()) {
            
            clientes.setPerfiles(usuario.getPerfiles());
        }
      
        return personaDao.findClientesPaginated(clientes,usuario);
    }

	@BusinessOperation("getEstadosFinancieros")
	public List<DDSituacionEstadoFinanciero> getEstadosFinancieros(){
		List<DDSituacionEstadoFinanciero> lista = genericDao.getList(DDSituacionEstadoFinanciero.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		return lista;
	}
	
    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperation(overrides=PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO)
    public Long obtenerCantidadDeVencidosUsuario() {
        DtoBuscarClientes clientes = new DtoBuscarClientes();
        //DDEstadoItinerario estado = ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).get(0);
        clientes.setSituacion(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        clientes.setIsPrimerTitContratoPase(Boolean.TRUE);
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        clientes.setPerfiles(usuario.getPerfiles());
        clientes.setIsBusquedaGV(Boolean.TRUE);
        clientes.setCodigoGestion(DDTipoItinerario.ITINERARIO_RECUPERACION);
        return personaDao.obtenerCantidadDeVencidosUsuario(clientes, false, usuario);
    }
    
    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperation(overrides=PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO)
    public Long obtenerCantidadDeSeguimientoSistematicoUsuario() {
        DtoBuscarClientes clientes = new DtoBuscarClientes();
        //DDEstadoItinerario estado = ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).get(0);
        clientes.setSituacion(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        clientes.setIsPrimerTitContratoPase(Boolean.TRUE);
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        clientes.setPerfiles(usuario.getPerfiles());
        clientes.setIsBusquedaGV(Boolean.TRUE);

        clientes.setCodigoGestion(DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SISTEMATICO);
        Long contador = personaDao.obtenerCantidadDeVencidosUsuario(clientes, false, usuario);

        return contador;
    }

    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperation(overrides=PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO)
    public Long obtenerCantidadDeSeguimientoSintomaticoUsuario() {
        DtoBuscarClientes clientes = new DtoBuscarClientes();
        //DDEstadoItinerario estado = ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).get(0);
        clientes.setSituacion(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        clientes.setIsPrimerTitContratoPase(Boolean.TRUE);
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        clientes.setPerfiles(usuario.getPerfiles());
        clientes.setIsBusquedaGV(Boolean.TRUE);

        clientes.setCodigoGestion(DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SINTOMATICO);
        Long contador = personaDao.obtenerCantidadDeVencidosUsuario(clientes, false, usuario);

        return contador;
    }    

	@Override
	@BusinessOperation(BO_CORE_PERSONA_GET_BY_COD_CLIENTE_ENTIDAD)
	public Persona getPersonaByCodClienteEntidad(Long codClienteEntidad) {
		Persona persona = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codClienteEntidad", codClienteEntidad);
		persona = genericDao.get(Persona.class, filtro);
		
		return persona;
	}

	@Override
	public List<Persona> getPersonasByDni(String dni) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "docId", dni);
		List<Persona> personas = genericDao.getList(Persona.class, filtro);
		
		return personas;
	}
}
