package es.capgemini.pfs.contrato;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PageImpl;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.dao.AdjuntoContratoDao;
import es.capgemini.pfs.contrato.dao.ContratoDao;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.disposicion.model.Disposicion;
import es.capgemini.pfs.efectos.model.EfectoContrato;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.recibo.model.Recibo;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.ObjetoResultado;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

/**
 * Clase manager de la entidad Contrato.
 *
*/
@Service
public class ContratoManager {

    @Autowired
    private Executor executor;

    @Autowired
    private ContratoDao contratoDao;

    @Autowired
    private AdjuntoContratoDao adjuntoContratoDao;

    private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;
    /**
     * Busca expedientes para un contrato determinado.
     *
     * @param contrato DtoBuscarContrato
     * @return List
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_FIND_CONTRATO)
    public Contrato findContrato(DtoBuscarContrato contrato) {
        return contratoDao.get(contrato.getId());
    }

    /**
     * Busca expedientes para un contrato determinado.
     *
     * @param idContrato idContrato
     * @return List
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET)
    public Contrato get(Long idContrato) {
    	EventFactory.onMethodStart(this.getClass());
        return contratoDao.get(idContrato);
    }

    /**
     * Devuelve la última fecha de carga para la entidad.
     * @return la última fecha de carga.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_ULTIMA_FECHA_CARGA)
    public Date getUltimaFechaCarga() {
        return contratoDao.getUltimaFechaCarga();
    }

    /**
     * @param c Contrato
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(Contrato c) {
        contratoDao.saveOrUpdate(c);
    }

    /**
     * Devuelve una lista con el contrato de pase del expediente.
     * @param dto dto de busqueda
     * @return una lista con el contrato de pase.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_BUSCAR_CONTRATOS_EXPEDIENTE)
    public Page buscarContratosExpediente(DtoBuscarContrato dto) {
    	EventFactory.onMethodStart(this.getClass());
        return contratoDao.buscarContratosExpediente(dto);
    }

    /**
     * Devuelve una lista con el contrato de pase del cliente.
     * @param dto dto de busqueda
     * @return una lista con el contrato de pase.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_BUSCAR_CONTRATOS_CLIENTE)
    public Page buscarContratosCliente(DtoBuscarContrato dto) {
        PageImpl pagina = (PageImpl) contratoDao.buscarContratosCliente(dto);
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
    private void agregarTotalizadorCliente(DtoBuscarContrato dto, PageImpl pagina) {
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

    /**
     * Devuelve los que están relacionadas a alguno de los contratos que vine por parámetro.
     * @param contratos el listado de los ids de contratos, separados por "-".
     * @return la lista de los clientes asociados
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_PERSONAS_DE_LOS_CONTRATOS)
    public List<Persona> personasDeLosContratos(String contratos) {
        String[] idsContratos = contratos.split("-");
        if (idsContratos.length != 0 && !idsContratos[0].equals("")) { return contratoDao.buscarClientesDeContratos(idsContratos); }
        return new ArrayList<Persona>(); // Lista vacía
    }

    /**
     * Hace la búsqueda de contratos de acuerdo a los filtros que vienen en el DTO.
     * @param dto contiene los filtros de la búsqueda.
     * @return la lista de contratos que cumplen con los filtros.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_BUSCAR_CONTRATOS)
    public Page buscarContratos(BusquedaContratosDto dto) {
        //Seteamos las zonas del formulario o por defecto las zonas del usuario logado
    	EventFactory.onMethodStart(this.getClass());
        dto.setCodigosZona(getCodigosDeZona(dto));
        dto.setEstadosContrato(getEstadosContrato(dto));

        EventFactory.onMethodStop(this.getClass());
        return contratoDao.buscarContratosPaginados(dto);
    }

    /**
     * Hace la búsqueda de contratos de acuerdo a los filtros que vienen en el DTO,
     * pero para el export a PDF, validando antes que la cant. de resultados no
     * supere una determinada cant.
     * @param dto contiene los filtros de la búsqueda.
     * @return la lista de contratos que cumplen con los filtros.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_EXPORT_CONTRATOS)
    public Page exportContratos(BusquedaContratosDto dto) {
        //Seteamos las zonas del formulario o por defecto las zonas del usuario logado
        dto.setCodigosZona(getCodigosDeZona(dto));
        dto.setEstadosContrato(getEstadosContrato(dto));
        dto.setLimit(Integer.MAX_VALUE); // La verificación del topo la hace superaLimiteExport
        return contratoDao.buscarContratosPaginados(dto);
    }

    /**
     * Verifica si no se supera el límite tolerado de resultados para el export a XLS de
     * la búsqueda de contratos. También verifica que el resultado no sea vacío.
     * @param dto contiene los filtros de la búsqueda.
     * @return lista de objetoResultado
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_SUPERAR_LIMITE_EXPORT)
    public List<ObjetoResultado> superaLimiteExport(BusquedaContratosDto dto) {
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
        int cant = contratoDao.buscarContratosPaginadosCount(dto);
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

    /**
     * Devuelve los estados de un contrato seleccionados en el form.
     * @param dto
     * @return
     */
    private Set<String> getEstadosContrato(BusquedaContratosDto dto) {
        Set<String> estados = null;
        if (dto.getStringEstadosContrato() != null && dto.getStringEstadosContrato().trim().length() > 0) {
            List<String> list = Arrays.asList((dto.getStringEstadosContrato().split(",")));
            estados = new HashSet<String>(list);
        }
        return estados;
    }

    /**
     * Devuelve los codigos de zona en un set parseando la entrada o (si no existe) recogiendolos del usuario logado.
     * @param dto
     * @return
     */
    private Set<String> getCodigosDeZona(BusquedaContratosDto dto) {
        Set<String> zonas;
        if (dto.getCodigoZona() != null && dto.getCodigoZona().trim().length() > 0) {
            List<String> list = Arrays.asList((dto.getCodigoZona().split(",")));
            zonas = new HashSet<String>(list);
        } else {
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            zonas = usuario.getCodigoZonas();
        }
        return zonas;
    }

    /**
     * Marca un ExpedienteContrato como sin actuacion. Si el contrato o el
     * expedienteContrato tuviera procedimientos asociados, los da de baja.
     *
     * @param idContratos el id del contrato
     * @param idExpediente el id del expediente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_MARCAR_SIN_ACTUACION)
    @Transactional
    public void marcarSinActuacion(String idContratos, Long idExpediente) {
        String[] contratos = idContratos.split("-");
        for (int i = 0; i < contratos.length; i++) {
            Long idContrato = Long.decode(contratos[i]);
            //Busco el contrato
            ExpedienteContrato ec = contratoDao.buscarExpedienteContratoByContratoExpediente(idContrato, idExpediente);
            if (ec == null) { return; }
            if (ec.getProcedimientosActivos().size() > 0) {
                logger.warn("El contrato " + ec.getContrato().getId()
                        + " no puede ser marcado como sin actuación porque figura en algún procedimiento");
                throw new BusinessOperationException("expediente.sinActuacion.enProcedimiento", new Object[] { ec.getContrato().getCodigoContrato() });
            }
            //Agrego una lista de procedimientos vacía al contrato, para que no haya null pointers.
            ec.setProcedimientos(new ArrayList<Procedimiento>());
            //marco el contrato como sin actuación
            ec.setSinActuacion(Boolean.TRUE);
            //salvo
            executor.execute(InternaBusinessOperation.BO_EXP_MGR_UPDATE_EXPEDIENTE_CONTRATO, ec);
        }
    }

    /**
     * Elimina un procedimiento si el contrato que se pasa como parámetro era el único que tenía en él.
     * Se llama desde el batch, en MovimientosBatchManager.
     * @param idContrato el id del contrato que se está revisando.
     * @param idExpediente el id del expediente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_ELIMINAR_PROCEDIMIENTO_POR_CANCELACION)
    @Transactional
    public void eliminarProcedimientoPorCancelacion(Long idContrato, Long idExpediente) {
        ExpedienteContrato ec = contratoDao.buscarExpedienteContratoByContratoExpediente(idContrato, idExpediente);
        if (ec == null) { return; }
        Hibernate.initialize(ec);
        Hibernate.initialize(ec.getProcedimientosActivos());
        //Itero sobre los proceedimientos en los que figura el contrato
        if (ec.getProcedimientosActivos().size() > 0) {
            for (Procedimiento proc : ec.getProcedimientosActivos()) {
                Hibernate.initialize(proc);
                Hibernate.initialize(proc.getExpedienteContratos());
                Hibernate.initialize(proc.getAsunto());

                //Solamente puedo eliminar procedimientos en el caso en que el asunto esté propuesto
                if (proc.getAsunto().getEstaPropuesto()) {
                    //Itero sobre todos los contratos de cada procedimiento para sacar el contrato
                    for (ExpedienteContrato ec1 : proc.getExpedienteContratos()) {
                        Hibernate.initialize(ec1);
                        if (ec1.getContrato().getId().equals(idContrato)) {
                            //Si es el contrato lo saco de la lista de los contratos del procedimiento
                            proc.getExpedienteContratos().remove(ec);
                            break;
                        }
                    }
                    if (proc.getExpedienteContratos().size() == 0) {
                        //Si el procedimiento quedó vacío, lo borro.
                        logger.debug("\n\n\n\nElimino el procedimiento " + proc.getId() + " \n\n\n\n\n");
                        executor.execute(ExternaBusinessOperation.BO_PRC_MGR_DELETE, proc);
                    }
                }
            }
        }
    }

    /**
     * Upload de archivos asociados a una persona.
     * @param uploadForm WebFileItem
     * @return String
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_UPLOAD)
    @Transactional(readOnly = false)
    public String upload(WebFileItem uploadForm) {
        FileItem fileItem = uploadForm.getFileItem();

        //En caso de que el fichero esté vacio, no subimos nada
        if (fileItem == null || fileItem.getLength() <= 0) { return null; }

        Integer max = getLimiteFichero();

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }

        Contrato contrato = contratoDao.get(Long.parseLong(uploadForm.getParameter("id")));
        contrato.addAdjunto(fileItem);
        contratoDao.save(contrato);

        return null;
    }

    /**
     * Recupera el límite de tamaño de un fichero.
     * @return
     */
    private Integer getLimiteFichero() {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.LIMITE_FICHERO_CONTRATO);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
            logger.warn("No esta parametrizado el límite máximo del fichero en bytes para contratos, se toma un valor por defecto (2Mb)");
            return new Integer(2 * 1024 * 1024);
        }
    }

    /**
     * bajar un adjunto.
     * @param adjuntoId Long
     * @return FileItem
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_DOWNLOAD_ADJUNTO)
    public FileItem downloadAdjunto(Long adjuntoId) {
        return adjuntoContratoDao.get(adjuntoId).getAdjunto().getFileItem();
    }

    /**
     * Borra el adjunto.
     * @param personaId Long
     * @param adjuntoId Long
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_DELETE_ADJUNTO)
    @Transactional(readOnly = false)
    public void deleteAdjunto(Long personaId, Long adjuntoId) {
        Contrato contrato = contratoDao.get(personaId);
        AdjuntoContrato adj = contrato.getAdjunto(adjuntoId);
        if (adj == null) { return; }
        contrato.getAdjuntos().remove(adj);
        contratoDao.save(contrato);
    }

    /**
     * Busca los títulos de un contrato paginados.
     * @param dto contiene el id del contrato para el que se buscan los títulos.
     * @return el listado de títulos paginado
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_TITULOS_CNT_PAGINADO)
    public Page getTitulosContratoPaginado(DtoBuscarContrato dto) {
        return contratoDao.getTitulosContratoPaginado(dto);
    }

    /**
     * Busca los expedientes en los que esté o haya estado el contato.
     * @param idContrato el id del contrato
     * @return la lista de expedientes.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_EXPDIENTES_HISTORICOS_CONTRATO)
    public List<Expediente> getExpedientesHistoricosContrato(Long idContrato) {
        return contratoDao.buscarExpedientesHistoricosContrato(idContrato);
    }

    /**
     * Busca los contratos expedientes en los que esté o haya estado el contato.
     * @param idContrato el id del contrato
     * @return la lista de expedientes.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_CONTRATOS_EXPDIENTES_HISTORICOS_CONTRATO)
    public List<ExpedienteContrato> getContratosExpedientesHistoricosContrato(Long idContrato) {
        return contratoDao.buscarContratosExpedientesHistoricosContrato(idContrato);
    }

    /**
     * Devuelve los asuntos activos de un contrato.
     * @param idContrato el id del contrato
     * @return la lista de asuntos activos
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_ASUNTOS_CONTRATO)
    public List<Asunto> getAsuntosContrato(Long idContrato) {
        Contrato contrato = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato); //get(idContrato);
        return contrato.getAsuntosActivos();
    }

    /**
     * obtiene los contratos de la persona donde es titular.
     * @param idPersona idPersona
     * @return contratos
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_OBTENER_CONTRATOS_GENERACION_EXPEDIENTE_MANUAL)
    public List<Contrato> obtenerContratosGeneracionExpManual(Long idPersona) {
        return contratoDao.obtenerContratosPersonaParaGeneracionExpManual(idPersona);
    }

    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_OBTENER_CONTRATOS_PERSONA_GENERACION_EXPEDIENTE_MANUAL)
    public List<Contrato> obtenerContratosPersonaParaGeneracionExpManual(Long idPersona) {
        return contratoDao.obtenerContratosPersonaParaGeneracionExpManual(idPersona);
    }

    /**
     * obtiene el número de contratos de la persona donde es titular.
     * @param idPersona idPersona
     * @return contratos
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_OBTENER_NUMERO_CNT_GENERACION_EXPEDIENTE_MANUAL)
    public int obtenerNumContratosGeneracionExpManual(Long idPersona) {
        List<Contrato> list = contratoDao.obtenerContratosPersonaParaGeneracionExpManual(idPersona);
        if (list != null) { return list.size(); }

        return 0;
    }

    /**
     * @param ids String: ids separados por coma.
     * @return List Contrato: contratos con los ids pasados
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_CONTRATOS_BY_ID)
    public List<Contrato> getContratosById(String ids) {
        return contratoDao.getContratosById(ids);
    }

    /**
     * Devuelve los clientes que están relacionados con alguno de los contratos de la lista.
     * @param contratos la lista de contratos
     * @return List Persona: el listado de clientes.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_BUSCAR_CLIENTES_DE_CONTRATOS)
    public List<Persona> buscarClientesDeContratos(List<String> contratos) {
        return contratoDao.buscarClientesDeContratos(contratos.toArray(new String[] {}));
    }

	@BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_RECIBOS_DE_CONTRATO)
	public Page getRecibosContrato(Long idContrato) {
		try {
			EventFactory.onMethodStart(this.getClass());
//			List<Recibo> listaRetorno = new ArrayList<Recibo>();
			PaginationParams params = new PaginationParamsImpl();
			params.setSort(" fechaVencimiento ");
			params.setDir("DESC");
			params.setStart(0);
			params.setLimit(50);

			Filter filtro = (Filter) genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
			Filter filtro2 = (Filter) genericDao.createFilter(FilterType.EQUALS, "borrado", false);
			
			PageHibernate page = (PageHibernate) genericDao.getPage(Recibo.class, params,filtro, filtro2);
//			if (page != null) {
//				listaRetorno.addAll((List<Recibo>) page.getResults());
//				page.setResults(listaRetorno);
//			}
			EventFactory.onMethodStop(this.getClass());
			return page;
		} catch (Throwable t) {
			return null;
		}
	}
	
	@BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_DISPOSICIONES_DE_CONTRATO)
	public Page getDisposicionesContrato(Long idContrato) {
		try {
			EventFactory.onMethodStart(this.getClass());
			PaginationParams params = new PaginationParamsImpl();
			params.setSort(" fechaVencimiento ");
			params.setDir("DESC");
			params.setStart(0);
			params.setLimit(50);
			
			Filter filtro = (Filter) genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
			
			PageHibernate page = (PageHibernate) genericDao.getPage(Disposicion.class, params,filtro);
			EventFactory.onMethodStop(this.getClass());
			return page;
		} catch (Throwable t) {
			return null;
		}
	}
	
	@BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_EFECTOS_DE_CONTRATO)
	public Page getEfectosContrato(Long idContrato) {
		try {
			EventFactory.onMethodStart(this.getClass());
			PaginationParams params = new PaginationParamsImpl();
			params.setSort(" fechaVencimiento ");
			params.setDir("DESC");
			params.setStart(0);
			params.setLimit(50);
			
			Filter filtro = (Filter) genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
			
			PageHibernate page = (PageHibernate) genericDao.getPage(EfectoContrato.class, params,filtro);
			EventFactory.onMethodStop(this.getClass());
			return page;
		} catch (Throwable t) {
			return null;
		}
	}
	
	@BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_CONTADOR_REINCIDENCIAS)
	public Integer contadorReincidencias(Long idContrato){
		
		return contratoDao.contadorReincidencias(idContrato);
		
	}
	
	@BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_RIESGO)
	public HashMap<String, Object> obtenerRiesgoOperacionalContrato(Long cntId) throws IllegalAccessException, InvocationTargetException {
		// Esta funcion esta sobreescrita en el plugin recovery-procedimiento-bmpHaya
		return null;
	}
	
	@BusinessOperation(PrimariaBusinessOperation.BO_CNT_MGR_GET_VENCIDOS)
	public HashMap<String, Object> obtenerVencidosByCntId(Long cntId) throws IllegalAccessException, InvocationTargetException {
		// Esta funcion esta sobreescrita en el plugin recovery-procedimiento-bmpHaya		
		return null;
	}
}
