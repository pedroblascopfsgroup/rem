package es.capgemini.pfs.cliente;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.antecedente.model.Antecedente;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.dao.ClienteContratoDao;
import es.capgemini.pfs.cliente.dao.ClienteDao;
import es.capgemini.pfs.cliente.dao.EstadoClienteDao;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.model.ClienteContrato;
import es.capgemini.pfs.cliente.model.EstadoCliente;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.Checks;

/**
 * Clase de servicios de acceso de datos del cliente.
 * @author Andrés Esteban
 *
 */
@Service
public class ClienteManager {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private Executor executor;

    @Autowired
    private ClienteDao clienteDao;

    @Autowired
    private ClienteContratoDao clienteContratoDao;

    @Autowired
    private EstadoClienteDao estadoClienteDao;

    /**
     * Obtiene los clientes paginados.
     * @param clientes dto clientes
     * @return Pagina de clientes
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_FIND_CLIENTES_PAGINATED)
    public Page findClientesPaginated(DtoBuscarClientes clientes) {
    	EventFactory.onMethodStart(this.getClass());
        return clienteDao.findClientesPaginated(clientes);
    }

    /**
     * Obtiene clientes por criterios.
     * @param clientes dto cliente
     * @return lista de clientes
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_FIND_CLIENTES)
    public List<Cliente> findClientes(DtoBuscarClientes clientes) {
        return clienteDao.findClientes(clientes);
    }

    /**
     * Obtiene el cliente por el nombre.
     * @param clientes dto cliente
     * @return Pagina de clientes
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_FIND_BY_NAME_CLIENTES)
    public Page findByNameClientes(DtoBuscarClientes clientes) {
        return clienteDao.findByName(clientes.getNombre(), clientes);
    }

    /**
     * Obtiene un cliente.
     * @param id id del cliente
     * @return entidad cliente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_GET)
    @Transactional
    public Cliente get(Long id) {
    	EventFactory.onMethodStart(this.getClass());
        return clienteDao.get(id);
    }

    /**
     * Obtiene un cliente.
     * @param id id del cliente
     * @return entidad cliente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_GET_WITH_ESTADOS)
    @Transactional
    public Cliente getWithEstado(Long id) {
        Cliente c = clienteDao.get(id);
        Hibernate.initialize(c.getArquetipo().getItinerario().getEstados());
        return c;
    }

    /**
     * Obtiene un cliente.
     * @param id id del cliente
     * @return entidad cliente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_GET_WITH_CONTRATOS)
    @Transactional
    public Cliente getWithContratos(Long id) {
        try {
            Cliente c = clienteDao.get(id);
            Hibernate.initialize(c.getContratos());
            if (c.getContratoPrincipal() != null) Hibernate.initialize(c.getContratoPrincipal().getMovimientos());
            Hibernate.initialize(c.getPersona());
            return c;
        } catch (Exception e) {
            throw new BusinessOperationException("No se puede obtener el cliente con id " + id, e);
        }
    }

    /**
     * graba un cliente.
     * @param cliente cliente
     * @return id cliente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_SAVE)
    public Long save(Cliente cliente) {
        return clienteDao.save(cliente);
    }

    /**
     * Graba o updatea un cliente.
     * @param cliente cliente.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(Cliente cliente) {
        clienteDao.saveOrUpdate(cliente);
    }

    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_TIENE_CONTRATOS_ACTIVOS)
	@SuppressWarnings("unchecked")    
    public Boolean tieneContratosActivos(Long idPersona) {
    	
    	Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
    	List<Contrato> contratos = (List<Contrato>)executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_OBTENER_CONTRATOS_GENERACION_EXPEDIENTE_MANUAL, idPersona);
    	//return (contratos!=null && contratos.size()>0);
    	
    	//Pero la persona debe ser titular en alguno de ellos
    	for (Contrato contrato : contratos) {
			if (contrato.getTitulares().contains(persona))
				return true;
		}
    	
    	/*Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
    	if (persona == null) return false;
    	
    	for (Contrato contrato : persona.getContratos()) {
			if (contrato.getEstadoContrato().getCodigo().equals(DDEstadoContrato.ESTADO_CONTRATO_ACTIVO))
				return true;
		}*/
    	
    	return false;
    }
    
    /**
     * Devuelve si la persona/cliente tiene contratos activos que ni estan en un expediente de recuperacion, ni en un asunto 
     * @param idPersona
     * @return
     */
    @SuppressWarnings("unchecked")
	@BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_TIENE_CONTRATOS_LIBRES)
    public Boolean tieneContratosLibres(Long idPersona) {
    	//Obtenemos los datos de la persona, pera obtener sus expedientes
    	Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
    	if (persona == null) return false;
    	
    	/*for (Contrato contrato : persona.getContratos()) {
    		if (contrato.getEstadoContrato().getCodigo().equals(DDEstadoContrato.ESTADO_CONTRATO_ACTIVO)) {
    			//Confirmamos que el contrato no tiene asuntos activos
    			if (contrato.getAsuntosActivos() == null || contrato.getAsuntosActivos().size() == 0) {
	    			//Buscamos si entre sus expedientes hay alguno de tipo recuperacion
    				if (!estaContratoEnAlgunExpedienteDeRecuperacion(contrato))
    					return true;
    			}
    		}
    	}*/

    	List<Contrato> contratos = (List<Contrato>)executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_OBTENER_CONTRATOS_GENERACION_EXPEDIENTE_MANUAL, idPersona);
    	
    	for (Contrato contrato : contratos) {
    		//Si el contrato es del titular
    		if (contrato.getTitulares().contains(persona)) {
	    		//Confirmamos que el contrato no tiene asuntos activos
				if (contrato.getAsuntosActivos() == null || contrato.getAsuntosActivos().size() == 0) {
					//Buscamos si entre sus expedientes hay alguno de tipo recuperacion
					if (!estaContratoEnAlgunExpedienteDeRecuperacion(contrato))
						return true;
				}
    		}
		}
   	
    	
    	//Si ningún contrato ha pasado las validaciones, devolvemos false
    	return false;
    }
    
    /**
     * Devuelve true, si algun expediente activo es de tipo recuperacion
     * @param contrato
     * @return
     */
    private boolean estaContratoEnAlgunExpedienteDeRecuperacion(Contrato contrato) {
    	//Validamos si algún expediente activo del contrato es de tipo recuperacion
    	
		for (ExpedienteContrato cex : contrato.getExpedienteContratos()) {
			if (cex.getExpediente().getEstaEstadoActivo() && cex.getExpediente().getRecuperacion()) {
				//Si el expediente es de tiop recuperacion devolvemos true
				return true;
			}
		}
		
		//Sino se ha encontrado ningun expediente activo de recuperación, devolvemos false
		return false;
    }
    
    /**
     * 
     * @param idPersona
     * @return
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_TIENE_CONTRATOS_CLIENTE)
    public Boolean tieneContratosParaGenerarExpediente(Long idPersona) {
        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
        if (persona == null) return false;

        //Si tiene un cliente es porque tiene algún contrato de pase
        if (persona.getClienteActivo() != null) return true;

        Long nContratos = (Long) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_NUMERO_CONTRATOS_PARA_FUTUROS_CLIENTES, 
        		persona.getId());

        return nContratos.longValue() > 0;
    }

    /**
     * Crea un cliente para el id de la persona indicada.
     * <br>Le asigna todos los contratos de la persona.
     * <br>Y genera los antecedentes para su futura carga
     * @param personaId Long
     * @param idJBPM idProceso
     * @param arquetipoId Long
     * @param manual manual/automatico
     * @return idCliente
     */
    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false)
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_CREAR_CLIENTE)
    public Long crearCliente(Long personaId, Long idJBPM, final Long arquetipoId, final Boolean manual) {
    	final DDEstadoItinerario estado = (DDEstadoItinerario) executor.execute(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_FIND_BY_CODE,
                DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA);
        return generaCliente(personaId, idJBPM, arquetipoId, manual, estado);
    }
    
    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false)
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_CREAR_CLIENTE_GEST_DEUDA)
    public Long crearClienteGestionDeuda(Long personaId, Long idJBPM, final Long arquetipoId, final Boolean manual) {
    	final DDEstadoItinerario estado = (DDEstadoItinerario) executor.execute(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_FIND_BY_CODE,
                DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
        return generaCliente(personaId, idJBPM, arquetipoId, manual, estado);
    }    
    
    /**
     * Crea un cliente para el id de la persona indicada.
     * <br>Le asigna todos los contratos de la persona.
     * <br>Y genera los antecedentes para su futura carga
     * @param personaId Long
     * @param idJBPM idProceso
     * @param arquetipoId Long
     * @param manual manual/automatico
     * @param estado 
     * @return idCliente
     */
    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false)
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_CREAR_CLIENTE_W_ESTADO)
    public Long crearClienteWestado(final Long personaId, final Long idJBPM, final Long arquetipoId, final Boolean manual, final DDEstadoItinerario estado) {
        return generaCliente(personaId, idJBPM, arquetipoId, manual, estado);
    }


    /**
     * Genera las entidas ClienteContrato con las entidades ContratoPersona, seteando el contrato que genera el pase.
     * @param contratosPersona lista
     * @param cliente cliente
     * @return lista de ordenada ClienteContrato
     */
    @Transactional
    private List<ClienteContrato> generarEntidadesClienteContrato(List<Contrato> contratos, Cliente cliente, Boolean isRecuperacion) {
        List<ClienteContrato> clienteContratos = new ArrayList<ClienteContrato>();

        StringBuilder listaContratos = new StringBuilder();
        Iterator<Contrato> it = contratos.iterator();
        Contrato contrato;
        Boolean isTitular;
        ClienteContrato cliContratoPase = null;

        while (it.hasNext()) {
            contrato = it.next();
            listaContratos.append(contrato.getId() + ",");

            isTitular = contrato.getTitulares().contains(cliente.getPersona());

            ClienteContrato cliContrato = new ClienteContrato();
            cliContrato.setContrato(contrato);
            cliContrato.setCliente(cliente);
            cliContrato.setPase(0);

            //Calculamos el contrato de pase
            //Por defecto el primer contrato es el de pase
            if (isTitular) {
                if (cliContratoPase == null) {
                    cliContratoPase = cliContrato;
                } else {
                    //Si es un arquetipo de recuperación se debe comprobar el de fecha de vencimiento más antigua
                    if (isRecuperacion) {
                        Date fechaPivote = cliContratoPase.getContrato().getLastMovimiento().getFechaPosVencida();
                        Date fechaNueva = contrato.getLastMovimiento().getFechaPosVencida();

                        //Si la fecha pivote es null (el contrato no es vencido)
                        //O las fechas no son null y el pivote es posterior a la fecha nueva
                        if (fechaPivote == null || (fechaNueva != null && fechaPivote.after(fechaNueva))) {
                            cliContratoPase = cliContrato;
                        }
                    } else {
                        //Si es de seguimiento se debe comprobar el de mayor riesgo
                    	Float riesgoPivote = null;
                    	Float riesgoNuevo = null;
                    	
                    	if (!Checks.esNulo(cliContratoPase.getContrato().getLastMovimiento())) { 
                    		riesgoPivote = cliContratoPase.getContrato().getLastMovimiento().getRiesgo();
                    	}
                    	if (!Checks.esNulo(contrato.getLastMovimiento())) {
                    		riesgoNuevo = contrato.getLastMovimiento().getRiesgo();
                    	}

                        if (riesgoPivote == null) {
                            riesgoPivote = 0f;
                        }
                        if (riesgoNuevo == null) {
                            riesgoNuevo = 0f;
                        }

                        if (riesgoPivote.floatValue() < riesgoNuevo.floatValue()) {
                            cliContratoPase = cliContrato;
                        }

                    }
                }
            }

            /*
             * En este caso hay que dejar la asiganción de la auditoria porque la entidad clienteContato
             * se salva indirectamente a través de cliente, por lo tanto, no se llama al save de su dao
             * y no se crea el objeto Auditoria de esa forma.
             * Tampoco se puede salvar explicitamente aquí, ya que el Cliente todavía no existe.
             */
            cliContrato.setAuditoria(Auditoria.getNewInstance());
            clienteContratos.add(cliContrato);

        }

        if (cliContratoPase == null) { throw new RuntimeException("Error en los contratos, no existe ningún contrato de pase para la persona "
                + cliente.getPersona().getId() + " de entre los siguientes contratos {" + listaContratos + "}"); }
        cliContratoPase.setPase(1);

        return clienteContratos;
    }

    /**
     * Elimina un cliente y sus contratos incluido su proceso BPM asociado.
     * @param idCliente id del cliente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLI_Y_BPM)
    @Transactional
    public void eliminarClienteyBPM(Long idCliente) {
        Cliente cliente = this.get(idCliente);

        //Cancelo el proceso BPM
        if (cliente.getProcessBPM() != null) {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, cliente.getProcessBPM());
        }

        eliminarCliente(idCliente);
    }

    /**
     * Elimina un cliente y sus contratos.
     * @param idCliente id del cliente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE)
    @Transactional
    public void eliminarCliente(Long idCliente) {
        Cliente cliente = this.get(idCliente);

        //Borro logicamente todos los contratos del cliente
        for (ClienteContrato c : cliente.getContratos()) {
            clienteContratoDao.delete(c);
        }

        //Borro el cliente
        cliente.setEstadoCliente(estadoClienteDao.getByCodigo(EstadoCliente.ESTADO_CLIENTE_CANCELADO));
        clienteDao.delete(cliente);

        //Borro las tareas asociadas al cliente
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_CLIENTE, idCliente);
        save(cliente);
    }

    /**
     * busca los clientes relacionados a un contrato.
     * @param idContrato id de contrato
     * @return clientes
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_BUSCAR_CLIENTES_POR_CONTRATO)
    public List<Cliente> buscarClientesPorContrato(Long idContrato) {
        return clienteDao.findClientesByContrato(idContrato);
    }

    /**
     * Busca los clientes titulares de un contrato determinado.
     * @param idContrato Long
     * @return List clientes
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_BUSCAR_CLIENTES_TITULARE_POR_CONTRATO)
    public List<Cliente> buscarClientesTitularesPorContrato(Long idContrato) {
        return clienteDao.findClientesTitularesByContrato(idContrato);
    }

    /**
     * cambia el estado del itinerario del cliente.
     * @param idCliente id del cliente
     * @param estadoItinerario estado
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_CAMBIAR_ESTADO_ITINERARIO_CLIENTE)
    public void cambiarEstadoItinerarioCliente(Long idCliente, String estadoItinerario) {
        DDEstadoItinerario estado = (DDEstadoItinerario) executor.execute(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_FIND_BY_CODE,
                estadoItinerario);

        Cliente cliente = this.get(idCliente);
        cliente.setEstadoItinerario(estado);

        this.saveOrUpdate(cliente);
    }

    /**
     * Recalcula los timers.
     * @param idCliente cliente
     * @param arquetipoNuevo arquetipo nuevo
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_RECALCULAR_TIMER_GESTION_VENCIDOS)
    public void recalcularTimersGestionVencidos(Long idCliente, Long arquetipoNuevo) {
        //Arquetipo arqAnt = arqMgr.getWithEstado(arquetipoAnt);
        Arquetipo arqNuevo = (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_WITH_ESTADO, arquetipoNuevo);

        Cliente cliente = this.get(idCliente);
        Long idJbpm = cliente.getProcessBPM();
        String codigoEstadoCliente = cliente.getEstadoItinerario().getCodigo();
        //Long plazoAnt = null;
        Long plazoNuevo = null;
        String timer = null;

        if (DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA.equals(codigoEstadoCliente)) {
            Long plazoPC = arqNuevo.getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA).getPlazo();

            plazoNuevo = plazoPC;
            timer = ClienteBPMConstants.TIMER_CARENCIA_CLIENTE;
        } else {
            Long plazoPC = arqNuevo.getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA).getPlazo();
            Long plazoGV = arqNuevo.getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).getPlazo();

            plazoNuevo = plazoPC + plazoGV;
            timer = ClienteBPMConstants.TIMER_GESTION_VENCIDO_CLIETE;
        }

        //jbpmUtil.recalculaTimer(idJbpm, timer, plazoNuevo);
        Date dueDate = new Date(cliente.getFechaCreacion().getTime() + plazoNuevo);
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_RECALCULAR_TIMER, idJbpm, timer, dueDate);
    }

    /**
     * Asigna al cliente indicado el arquetipo pasado como parámetro.
     *
     * @param idCliente Long
     * @param arqId Long
     */
    @Transactional
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_ASIGNAR_ARQUETIPO)
    public void asginarArquetipo(Long idCliente, Long arqId) {
        Cliente cliente = get(idCliente);
        cliente.setArquetipo((Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, arqId));
        saveOrUpdate(cliente);

        Persona per = cliente.getPersona();
        per.setArquetipo(arqId);
        executor.execute(PrimariaBusinessOperation.BO_PER_MGR_SAVE_OR_UPDATE, per);
    }

    /**
     * @param idContrato Long: id del contrato
     * @return Cliente: cliente generado por el contrato, <code>null</code> si el
     * contrato no genero clientes actualmente no borrados
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_CLI_MGR_FIND_CLIENTE_POR_CONTRATO_PASE_ID)
    public Cliente findClienteByContratoPaseId(Long idContrato) {
        return clienteDao.findClienteByContratoPaseId(idContrato);
    }
    
    private Long generaCliente(final Long personaId, final Long idJBPM, final Long arquetipoId, final Boolean manual, final DDEstadoItinerario estado) {
		logger.debug("Creando cliente para la persona con id: " + personaId);

        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET_WITH_CONTRATOS, personaId);
        
        Arquetipo arquetipo = null;
        
        if(arquetipoId != null)
        	arquetipo = (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, arquetipoId);
        
        Boolean isRecuperacion = true;
        //Boolean isRecuperacion = arquetipo.getItinerario().getdDtipoItinerario().getItinerarioRecuperacion();
        Boolean isGestDeuda = arquetipo.getItinerario().getdDtipoItinerario().getItinerarioGestionDeuda();
        

        //Comprobamos que esta persona no tiene ningún cliente activo
        Cliente c = persona.getClienteActivo();
        if (c != null && !c.getAuditoria().isBorrado() && c.getEstadoCliente() != null
                && c.getEstadoCliente().getCodigo() != EstadoCliente.ESTADO_CLIENTE_CANCELADO) { throw new RuntimeException("Esta persona ["
                + personaId + "] tiene como mínimo un cliente activo [" + c.getId() + "]"); }

        List<ContratoPersona> contratosPersona = persona.getContratosPersona();

        List<Long> contratosIds = new ArrayList<Long>();
        for (ContratoPersona contrato : contratosPersona) {
            contratosIds.add(contrato.getContrato().getId());
        }

        Cliente cliente = Cliente.getNewInstance();
        cliente.setPersona(persona);
        cliente.setProcessBPM(idJBPM);

        if (manual) {
            cliente.setEstadoCliente(estadoClienteDao.getByCodigo(EstadoCliente.ESTADO_CLIENTE_MANUAL));
        } else {
            cliente.setEstadoCliente(estadoClienteDao.getByCodigo(EstadoCliente.ESTADO_CLIENTE_ACTIVO));
        }

        //Recuperamos todos los contratos de la persona que no esté en otros asuntos / procedimientos
        List<Contrato> contratos = (List<Contrato>) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CONTRATOS_PARA_FUTUROS_CLIENTES,
                persona.getId());

        List<ClienteContrato> clienteContratos;
        if (isGestDeuda) {
        	clienteContratos = generarEntidadesClienteContrato(contratos, cliente, false);
        } else {
        	clienteContratos = generarEntidadesClienteContrato(contratos, cliente, isRecuperacion);
        }
        cliente.setContratos(clienteContratos);
        cliente.setEstadoItinerario(estado);
        cliente.setFechaEstado(new Date());
        cliente.setOficina(cliente.getContratoPrincipal().getOficina());

        Movimiento m = cliente.getContratoPrincipal().getMovimientos().iterator().next();
        if (!manual && m.getFechaPosVencida() != null) {
            cliente.setFechaCreacion(m.getFechaPosVencida());
        } else {
            cliente.setFechaCreacion(new Date());
        }

        if (persona.getAntecedente() == null) {
            Antecedente antecedente = new Antecedente();
            executor.execute(PrimariaBusinessOperation.BO_ANTECEDENTE_MGR_SAVE_OR_UPDATE, antecedente);

            persona.setAntecedente(antecedente);
        }
        cliente.setArquetipo(arquetipo);

        //Daba error si el arquetipo es null. 
        // Además el atributo arquetipo en persona está desactualizado, hay que ver si hace falta hacer esto
        // pero utilizando las tablas ARR_ARQ_RECUPERACION_PERSONA y ARP_ARQ_RECOBRO_PERSONA
        if (arquetipo!=null)
        	persona.setArquetipo(arquetipo.getId());
        
        executor.execute(PrimariaBusinessOperation.BO_PER_MGR_SAVE_OR_UPDATE, persona);
        save(cliente);

        logger.debug("Cliente creado con id: " + cliente.getId());
        return cliente.getId();
	}
}
