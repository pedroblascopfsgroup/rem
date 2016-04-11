package es.pfsgroup.procedimientos.subasta;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.TreeSet;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dao.SubastaDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDDecisionSuspension;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.procedimientos.context.api.ProcedimientosProjectContext;
import es.pfsgroup.recovery.ext.impl.asunto.model.DDGestionAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

/**
 * Esta clase se usa para calcular determinados parámetros de la subasta.
 *  
 * @author gonzalo
 *
 */
@Component(value="subastaCalculoManager")
public class SubastaCalculoManager {

	protected final Log logger = LogFactory.getLog(getClass());
	private final BigDecimal MILLON = new BigDecimal("1000000");
	private final BigDecimal FIFTEEN_THOUSAND = new BigDecimal("15000");
	
	@Autowired
	private ProcedimientosProjectContext procedimientosProjectContext;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private SubastaDao subastaDao;	
	
	@Autowired
	private Executor executor;
	
	@Resource
	private Properties appProperties;

    @Autowired
    private IntegracionBpmService bpmIntegracionService;
    
    @Autowired
    private UtilDiccionarioApi utilDiccionario;

	/**
	 * Actualiza la subasta con los datos del procedimiento, crea la subasta si no existe.
	 * 
	 * @param procedimiento
	 */
	public void crearSubasta(Procedimiento procedimiento) {

		// TODO Comprobar si no venimos de otra subasta, si fuera así, hay que
		// replicar la información
		// TODO si venimos de otra, hay que finalizar la anterior
		// para comprobar si venimos derivados desde otro tramite de subasta,
		// debe cumplir las siguientes condiciones:
		// -Que su prc_prc_id sea de tipo subasta
		// -Que su última tarea realizada sea Celebración de subasta, y que en
		// el combo haya seleccionado suspendida a terceros
		Subasta subastaDuplicada = new Subasta();
		Procedimiento prcPadre = null;

		boolean condicion1 = false;
		boolean condicion2 = false;
		boolean condicion3 = false;

		// condicion 1: tiene padre de tipo subasta
		if (!Checks.esNulo(procedimiento.getProcedimientoPadre())) {
			prcPadre = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", procedimiento.getProcedimientoPadre().getId()));
			if (procedimientosProjectContext.getTiposSubasta().contains(prcPadre.getTipoProcedimiento().getCodigo())) {
				// Condicion 1 cumplida. Continuamos
				condicion1 = true;
			}
		}

		// Condicion 2: última tarea ha seleccionado suspendida a terceros
		if (condicion1) {
			// Set<TareaNotificacion> tareas = prcPadre.getTareas();
			List<TareaNotificacion> tareas = genericDao.getList(TareaNotificacion.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcPadre.getId()));
			for (TareaNotificacion t : tareas) {
				if (procedimientosProjectContext.getTareasCelebracionSubasta().contains(t.getCodigo())) {
					TareaExterna tareaExterna = t.getTareaExterna();
					List<TareaExternaValor> valores = tareaExterna.getValores();
					for (TareaExternaValor tev : valores) {
						if (procedimientosProjectContext.getCamposSuspensionSubasta().contains(tev.getNombre())) {
							if (DDDecisionSuspension.TERCEROS.equals(tev.getValor())) {
								condicion2 = true;
								break;
							}
						}
					}
				}
			}
		}

		if (condicion2) {
			// duplicamos toda la información
			Subasta subastaOrigen = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prcPadre.getId());
			subastaDuplicada.setTipoSubasta(subastaOrigen.getTipoSubasta());

			subastaDuplicada.setProcedimiento(procedimiento);
			subastaDuplicada.setAsunto(procedimiento.getAsunto());
			subastaDuplicada.setNumAutos(procedimiento.getCodigoProcedimientoEnJuzgado());

			subastaDuplicada.setEstadoSubasta(genericDao.get(DDEstadoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false),
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoSubasta.PIN)));

			subastaDuplicada.setTipoSubasta(genericDao.get(DDTipoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false),
					genericDao.createFilter(FilterType.EQUALS, "codigo", determinarTipoSubasta(procedimiento))));

			subastaDuplicada = genericDao.save(Subasta.class, subastaDuplicada);

			// Ahora recorremos los lotes y bienes y asignamos a la nueva
			// subasta

			for (LoteSubasta ls : subastaOrigen.getLotesSubasta()) {

				LoteSubasta loteSubastaDuplicada = new LoteSubasta();
				// loteSubastaDuplicada.setSubasta(subastaDuplicada);
				// loteSubastaDuplicada = genericDao.save(LoteSubasta.class,
				// loteSubastaDuplicada);

				// for(Bien b: ls.getBienes()){

				BeanUtils.copyProperties(ls, loteSubastaDuplicada);
				loteSubastaDuplicada.setId(null);
				loteSubastaDuplicada.setSubasta(subastaDuplicada);
				List<Bien> bienes = new ArrayList<Bien>();
				bienes.addAll(ls.getBienes());
				loteSubastaDuplicada.setBienes(bienes);

				genericDao.save(LoteSubasta.class, loteSubastaDuplicada);

				// LoteBien loteBienDuplicado = new LoteBien();
				// loteBienDuplicado.setLote(loteSubastaDuplicada);
				// loteBienDuplicado.setBienes(ls.getBienes());
				// genericDao.save(LoteBien.class, loteBienDuplicado);

			}
			bpmIntegracionService.enviarDatos(subastaDuplicada);
		}
		
		//CONDICION 3
		//Tenemos que ver que no vengamos de una vuelta atrás desde Señalamiento de subasta
		//Si encontramos una subasta ya existente, no debemos hacer nada
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", procedimiento.getId()), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		if(!Checks.esNulo(sub)){
			condicion3=true;
		}

		if (condicion1 && condicion2) {
			// Finalizamos el procedimiento padre
			try {
				// jbpmUtil.finalizarProcedimiento(prcPadre.getId());
				prcPadre.setEstadoProcedimiento(genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO)));
				genericDao.save(Procedimiento.class, prcPadre);

			} catch (Exception e) {
				e.printStackTrace();
			}

			// FINALIZAMOS TODAS LAS TAREAS DEL PROCEDIMIENTO
			for (TareaNotificacion t : prcPadre.getTareas()) {
				if (!t.getAuditoria().isBorrado()) {
					if (t.getTareaFinalizada() == null || (t.getTareaFinalizada() != null && !t.getTareaFinalizada())) {
						t.setTareaFinalizada(true);
						genericDao.update(TareaNotificacion.class, t);
						HibernateUtils.merge(t);
					}
				}
			}

		} else if(condicion3){
			//No hacemos nada
		}
		else {		
			
			// Si no ha cumplido alguna de las dos condiciones, es que su origen
			// no es desde el trámite de subasta
			subastaDuplicada = new Subasta();

			subastaDuplicada.setProcedimiento(procedimiento);
			subastaDuplicada.setAsunto(procedimiento.getAsunto());
			subastaDuplicada.setNumAutos(procedimiento.getCodigoProcedimientoEnJuzgado());

			subastaDuplicada.setEstadoSubasta(genericDao.get(DDEstadoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false),
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoSubasta.PIN)));

			subastaDuplicada.setTipoSubasta(genericDao.get(DDTipoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false),
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoSubasta.DEL)));

			genericDao.save(Subasta.class, subastaDuplicada);
			
			actualizarTipoSubasta(procedimiento);
			bpmIntegracionService.enviarDatos(subastaDuplicada);
			
		}

	}

	
	/**
	 * Actualiza el tipo de subasta según las condiciones.
	 * 
	 * @param procedimiento
	 */
	public void actualizarTipoSubasta(Procedimiento procedimiento) {
		Subasta subasta = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(procedimiento.getId());
		
		subasta.setTipoSubasta(genericDao.get(DDTipoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false),
				genericDao.createFilter(FilterType.EQUALS, "codigo", determinarTipoSubasta(procedimiento))));
		
		genericDao.save(Subasta.class, subasta);
	}
	

	/**
	 * Determina el tipo por defecto.
	 * 
	 * Por defecto siempre es delegada, hay unas condiciones que pueden hacerla no delegada.
	 * 
	 * @param prc
	 * @return
	 */
	private String determinarTipoSubasta(Procedimiento prc) {

		// TODO: Quitar si las subastas sareb no deben cambiar el tipo de subasta
		if (procedimientosProjectContext.getTipoSubastaSareb().equals(prc.getTipoProcedimiento().getCodigo())) {
			return DDTipoSubasta.NDE;
		}
		// ------
		
		Asunto asunto = prc.getAsunto();
		Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());
		@SuppressWarnings("unchecked")
		List<Bien> listadoBienes = (List<Bien>)executor.execute("es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.getBienes", sub.getId());
		DDTiposAsunto tipoAsu = asunto.getTipoAsunto();
		boolean esConcursal = DDTiposAsunto.CONCURSAL.equals(tipoAsu.getCodigo());
		boolean esLitigio = DDTiposAsunto.LITIGIO.equals(tipoAsu.getCodigo());
		float deudaGlobal = getDeudaGlobal(asunto);
		float costesSubasta = getCostesSubasta(prc);
		float deudaTotal = deudaGlobal + costesSubasta;
		float totalImporteCargas = getTotalImporteCargas(listadoBienes);
		
		if (esConcursal) {
			return DDTipoSubasta.NDE;
		}
		if (esLitigio && deudaGlobal>=procedimientosProjectContext.getLimiteDeudaGlobal()) {
			return DDTipoSubasta.NDE;
		}
		int comparaVivHabitual = comparaDeudaViviendaHabitual(listadoBienes, deudaTotal);
		if (esLitigio && comparaVivHabitual>0) {
			return DDTipoSubasta.NDE;
		}
		float percentDeudaTotal = (float) (deudaTotal * 0.1);
		float diferenciaDeudas = (deudaTotal - totalImporteCargas);
		if (esLitigio && diferenciaDeudas<percentDeudaTotal && totalImporteCargas>=procedimientosProjectContext.getLimiteDeudaBien()) {
				return DDTipoSubasta.NDE;
		}
		return DDTipoSubasta.DEL;
	}
	
	/**
	 * Cálculo de la deuda global
	 * 
	 * @param asunto Asunto de este procedimiento
	 * @return
	 */
	private float getDeudaGlobal(Asunto asunto) {
		float acumulado = 0;
		List<Contrato> listaContratosAsunto = new ArrayList<Contrato>();
		if (!Checks.esNulo(asunto)) {
			listaContratosAsunto.addAll(asunto.getContratos());
		}
		for (Contrato contrato : listaContratosAsunto) {
			Movimiento mov = contrato.getLastMovimiento();
			if (mov==null) { 
				continue;
			}
			float posVivaVencida = (mov.getPosVivaVencida()!=null) ? mov.getPosVivaVencida() : 0;
			float posVivaNoVencida = (mov.getPosVivaVencida()!=null) ? mov.getPosVivaNoVencida() : 0;
			acumulado += posVivaVencida + posVivaNoVencida; 
		}
		return acumulado;
	}
	
	/**
	 * Cálculo de los costes de la subasta (Tarea señalamiento subasta)
	 * 
	 * @param prc Procedimiento
	 * @return
	 */
	private float getCostesSubasta(Procedimiento procedimiento) {
		float acumulado = 0;
		List<TareaNotificacion> tareas = genericDao.getList(TareaNotificacion.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", procedimiento.getId()));
		for (TareaNotificacion t : tareas) {
			if (t.getTareaExterna()!=null && t.getTareaExterna().getTareaProcedimiento()!=null && procedimientosProjectContext.getTareasSenyalamientoSubastas().contains(t.getTareaExterna().getTareaProcedimiento().getCodigo())){ 
				TareaExterna tareaExterna = t.getTareaExterna();
				List<TareaExternaValor> valores = tareaExterna.getValores();
				for (TareaExternaValor tev : valores) {
					if (procedimientosProjectContext.getCamposCostas().contains(tev.getNombre())) {
						float valor = 0;
						String valorStr = tev.getValor();
						try {
							valor = Float.parseFloat(valorStr);
						} catch (NumberFormatException nfe) {
							logger.error("Problema al convertir a float número: " + valorStr, nfe);
						}
						acumulado += valor;
					}
				}
			}
		}
		return acumulado;
	}
	
	/**
	 * -1 es < que cantidad
	 * 0 no ha encontrado nada.
	 * 1 es >=  a cantidad
	 * 
	 * @param listadoBienes Listado de los bienes para calcular
	 * @param deudaTotal deuda total
	 * @return
	 */
	private int comparaDeudaViviendaHabitual(List<Bien> listadoBienes, float deudaTotal) {
		for (Bien bien : listadoBienes) {
			if (!(bien instanceof NMBBien)) {
				continue;
			}
			NMBBien nmbBien = (NMBBien)bien;
			if (nmbBien.getTipoSubasta()==null) {
				continue;
			}
			float tipoSubasta = nmbBien.getTipoSubasta();
			tipoSubasta = (float) (tipoSubasta * 0.6);
			float diferenciaDeuda = (deudaTotal - tipoSubasta);
			if ("1".equals(nmbBien.getViviendaHabitual()) && diferenciaDeuda<procedimientosProjectContext.getLimiteDeudaBien()) {
				return -1;
			}
			if ("1".equals(nmbBien.getViviendaHabitual()) && diferenciaDeuda>=procedimientosProjectContext.getLimiteDeudaBien()) {
				return 1;
			}
		}
		// Recupera los bienes de la subasta.
		return 0;
	}

	/**
	 * Importe total de las cargas
	 * 
	 * @param listadoBienes Listado de bienes con los que va a calcular el importe.
	 * @return
	 */
	private float getTotalImporteCargas(List<Bien> listadoBienes) {
		float acumulado = 0;
		for (Bien bien : listadoBienes) {
			if (!(bien instanceof NMBBien)) {
				continue;
			}
			NMBBien nmbBien = (NMBBien)bien;
			for (NMBBienCargas carga : nmbBien.getBienCargas()) {
				DDTipoCarga tipoCarga = carga.getTipoCarga();
				if (procedimientosProjectContext.getCodigoCargaAnterior().equals(tipoCarga.getCodigo()) && carga.isEconomica()) {
					float importe = (carga.getImporteEconomico() != null) ? carga.getImporteEconomico() : 0;
					acumulado +=importe;
				}
			}
		}
		// Recupera los bienes de la subasta.
		return acumulado;
		
	}

	/**
	 * Determina el tipo de subasta tras la propuesta de lotes de subasta 
	 * 
	 * PRODUCTO-700 -> Logica para determinar si una subasta es delegada o no delegada.
	 * 
	 * @param prc
	 * @return
	 */
	public void determinarTipoSubastaTrasPropuesta(Subasta subasta) {

		// Las NO DELEGADAS no hace nada.
		if (subasta.getTipoSubasta() != null && DDTipoSubasta.NDE.equals(subasta.getTipoSubasta().getCodigo())) {
			loguear("Condicion 0", subasta.getId());
			return;
		}

		EXTAsunto asuntoSubasta = EXTAsunto.instanceOf(subasta.getAsunto());

		// Si la gestión del asunto donde está la subasta es Haya.
		if (asuntoSubasta.getGestionAsunto() != null && DDGestionAsunto.HAYA.equals(asuntoSubasta.getGestionAsunto().getCodigo())) {
			modificarTipoSubastaNoDelegada(subasta);
			loguear("Condicion 1", subasta.getId());
			return;
		}

		// Si el asunto donde está la subasta es un concurso.
		if (asuntoSubasta.getTipoAsunto() != null && DDTiposAsunto.CONCURSAL.equals(asuntoSubasta.getTipoAsunto().getCodigo())) {
			modificarTipoSubastaNoDelegada(subasta);
			loguear("Condicion 2", subasta.getId());
			return;
		}

		// Si existe algún bien en la subasta que tenga cargas anteriores.
		if (!"0".equals(subasta.getCargasAnteriores())) {
			modificarTipoSubastaNoDelegada(subasta);
			loguear("Condicion 3", subasta.getId());
			return;
		}

		// Si la deuda de las operaciones relacionadas con los bienes/garantías es mayor a 1 millon de €.
		if (deudaOperacionesRelacionadasMayor1M(subasta)) {
			modificarTipoSubastaNoDelegada(subasta);
			loguear("Condicion 4", subasta.getId());
			return;
		}

		// Si el riesgo de consignación supera el umbral.
		if (riesgoConsignacionSuperaUmbral(subasta)) {
			modificarTipoSubastaNoDelegada(subasta);
			loguear("Condicion 5", subasta.getId());
			return;
		}
	}

	public void loguear(String msg, Long id) {
		System.out.println("SUBASTA [" + id.toString() + "] - " + msg);
	}
	
	/**
	 * Cambia el tipo de subasta a no delegada
	 * @param subasta
	 */
	private void modificarTipoSubastaNoDelegada(Subasta subasta) {
		DDTipoSubasta tipoSubastaNoDelegada = (DDTipoSubasta) utilDiccionario.dameValorDiccionarioByCod(DDTipoSubasta.class, DDTipoSubasta.NDE);

		subasta.setTipoSubasta(tipoSubastaNoDelegada);
		genericDao.update(Subasta.class, subasta);
	}

	/**
	 * Si la deuda de las operaciones relacionadas con los bienes/garantías de la subasta es mayor a 1 millon de €.
	 * 
	 *		Sacamos todos los bienes de los lotes de la subasta.
	 *		Buscamos los contratos relacionados con los bienes anteriores, cuyo estado sea distinto de "No recibido".
	 *		Sumamos el importe de deuda irregular + capital no vencido de cada uno de esos contratos.
	 * 
	 * @param subasta
	 * @return
	 */
	private boolean deudaOperacionesRelacionadasMayor1M(Subasta subasta) {
		List<Bien> bienesSubasta = new ArrayList<Bien>();

		for (LoteSubasta lote : subasta.getLotesSubasta()) {
			bienesSubasta.addAll(lote.getBienes());
		}

		Set<Contrato> contratos = new TreeSet<Contrato>();
		for (Bien bien : bienesSubasta) {
			for (NMBContratoBien contratoBien : ((NMBBien) bien).getContratos()) {
				Contrato contrato = contratoBien.getContrato();

				// cuyo estado sea distinto de "No recibido".
				if (!DDEstadoContrato.ESTADO_CONTRATO_NORECIBIDO.equals(contrato.getEstadoContrato().getCodigo())) {
					contratos.add(contrato);
				}
			}
		}

		loguear("Condicion 4 - numero de contratos: " + contratos.size(), subasta.getId());

		BigDecimal sumatorioDeuda = BigDecimal.ZERO;
		for (Contrato contrato : contratos) {
			Movimiento ultimoMovimiento = contrato.getLastMovimiento();
			BigDecimal deudaIrregular = new BigDecimal(Float.toString(ultimoMovimiento.getDeudaIrregular()));
			BigDecimal capitalNoVencido = new BigDecimal(Float.toString(ultimoMovimiento.getPosVivaNoVencida()));

			sumatorioDeuda = sumatorioDeuda.add(deudaIrregular.add(capitalNoVencido));

			loguear("Condicion 4 - ContratoID:" + contrato.getId() + " DeudaIrre(" + deudaIrregular + ") + capitalNoVencido(" + capitalNoVencido + ") = sumatorioDeuda " + sumatorioDeuda, subasta.getId());
		}

		loguear("Condicion 4 - sumatorioDeuda " + sumatorioDeuda + " supera millon? " + (sumatorioDeuda.compareTo(MILLON) > 0), subasta.getId());

		return sumatorioDeuda.compareTo(MILLON) > 0;
	}

	private boolean riesgoConsignacionSuperaUmbral(Subasta subasta) {
		// Deuda entidad = vencido (deuda irregular) + no vencido de todas las operaciones del procedimiento + costas de letrado y procurador
		BigDecimal sumatorioDeudaEntidad = BigDecimal.ZERO;
		if (!Checks.esNulo(subasta.getCostasLetrado())){
			sumatorioDeudaEntidad = BigDecimal.valueOf(subasta.getCostasLetrado());
		}
		if (!Checks.esNulo(subasta.getCostasProcurador())){
			sumatorioDeudaEntidad = BigDecimal.valueOf(subasta.getCostasProcurador());
		}
		Set<Contrato> contratos = subasta.getProcedimiento().getAsunto().getContratos();
		
		loguear("Condicion 5 - numero de contratos: " + contratos.size(), subasta.getId());

		for (Contrato contrato : contratos) {
			Movimiento ultimoMovimiento = contrato.getLastMovimiento();

			BigDecimal deudaIrregular = BigDecimal.valueOf(ultimoMovimiento.getDeudaIrregular());
			BigDecimal capitalNoVencido = BigDecimal.valueOf(ultimoMovimiento.getPosVivaNoVencida());

			sumatorioDeudaEntidad = sumatorioDeudaEntidad.add(deudaIrregular.add(capitalNoVencido));

			loguear("Condicion 5 - ContratoID:" + contrato.getId() + " DeudaIrre(" + deudaIrregular + ") + capitalNoVencido(" + capitalNoVencido + ") = sumatorioDeudaEntidad " + sumatorioDeudaEntidad, subasta.getId());
		}
		
		BigDecimal pujaSinPostores = BigDecimal.ZERO;
		loguear("Condicion 5 - TOTAL sumatorioDeudaEntidad " + sumatorioDeudaEntidad, subasta.getId());
		
		loguear("Condicion 5 - nroLotesSubastas: " + subasta.getLotesSubasta().size(), subasta.getId());
		
		for (LoteSubasta lote : subasta.getLotesSubasta()) {
			if(!Checks.esNulo(lote.getInsPujaSinPostores())){
				pujaSinPostores = BigDecimal.valueOf(lote.getInsPujaSinPostores());
			}
	
			loguear("Condicion 5 - LoteId: " + lote.getId() + " - pujaSinPostores: " + pujaSinPostores, subasta.getId());
		
			// Donde Riesgo de Consignación = Puja sin postores - Deuda entidad
			BigDecimal riesgodeConsignacion = pujaSinPostores.subtract(sumatorioDeudaEntidad);
			
			loguear("Condicion 5 - LoteId: " + lote.getId() + " - riesgodeConsignacion: " + riesgodeConsignacion, subasta.getId());

			// 10% deuda entidad
			BigDecimal tenPercentDeudaEntidad = sumatorioDeudaEntidad.multiply(new BigDecimal("0.1"));
			
			loguear("Condicion 5 - LoteId: " + lote.getId() + " - tenPercentDeudaEntidad: " + tenPercentDeudaEntidad, subasta.getId());


			loguear("Condicion 5 - lote.getRiesgoConsignacion(): " + lote.getRiesgoConsignacion(), subasta.getId());
			loguear("Condicion 5 - !isNegative(riesgodeConsignacion): " + !isNegative(riesgodeConsignacion), subasta.getId());
			loguear("Condicion 5 - riesgodeConsignacion.compareTo(tenPercentDeudaEntidad) > 0 " + (riesgodeConsignacion.compareTo(tenPercentDeudaEntidad) > 0), subasta.getId());
			loguear("Condicion 5 - riesgodeConsignacion.compareTo(FIFTEEN_THOUSAND) > 0 " + (riesgodeConsignacion.compareTo(FIFTEEN_THOUSAND) > 0), subasta.getId());

			if (lote.getRiesgoConsignacion() 
					&& !isNegative(riesgodeConsignacion)
					&& (riesgodeConsignacion.compareTo(tenPercentDeudaEntidad) > 0  
							|| riesgodeConsignacion.compareTo(FIFTEEN_THOUSAND) > 0)) {
				return true;
			}
		}

		return false;
	}

    private boolean isNegative(BigDecimal b) {
        return b.signum() == -1;
    }
}
