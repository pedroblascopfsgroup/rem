package es.pfsgroup.procedimientos.subasta;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

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
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDDecisionSuspension;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.procedimientos.context.api.ProcedimientosProjectContext;
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
	
	@Autowired
	private ProcedimientosProjectContext procedimientosProjectContext;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private Executor executor;
	
	@Resource
	private Properties appProperties;

    @Autowired
    private IntegracionBpmService bpmIntegracionService;
    
    @Autowired
    private SubastaProcedimientoApi subastaProcedimientoApi;

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
			Subasta subastaOrigen = subastaProcedimientoApi.obtenerSubastaByPrcId(prcPadre.getId());
			subastaDuplicada.setTipoSubasta(subastaOrigen.getTipoSubasta());

			subastaDuplicada.setProcedimiento(procedimiento);
			subastaDuplicada.setAsunto(procedimiento.getAsunto());
			subastaDuplicada.setNumAutos(procedimiento.getCodigoProcedimientoEnJuzgado());

			subastaDuplicada.setEstadoSubasta(genericDao.get(DDEstadoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false),
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoSubasta.PIN)));

			//subastaDuplicada.setTipoSubasta(genericDao.get(DDTipoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false), genericDao.createFilter(FilterType.EQUALS, "codigo", determinarTipoSubasta(procedimiento))));
			subastaProcedimientoApi.determinarTipoSubasta(subastaDuplicada);
			
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
			
			//actualizarTipoSubasta(procedimiento);
			bpmIntegracionService.enviarDatos(subastaDuplicada);
			
		}

	}

	
	/**
	 * Actualiza el tipo de subasta según las condiciones.
	 * 
	 * @param procedimiento
	 */
	public void actualizarTipoSubasta(Procedimiento procedimiento) {
		Subasta subasta = subastaProcedimientoApi.obtenerSubastaByPrcId(procedimiento.getId());
		
		subastaProcedimientoApi.determinarTipoSubasta(subasta);
		
	}
	

	/**
	 * Determina el tipo por defecto.
	 * 
	 * Por defecto siempre es delegada, hay unas condiciones que pueden hacerla no delegada.
	 * 
	 * @param prc
	 * @return
	 */
	@SuppressWarnings("unused")
	@Deprecated
	private String determinarTipoSubasta(Procedimiento prc) {

		// TODO: Quitar si las subastas sareb no deben cambiar el tipo de subasta
		if (procedimientosProjectContext.getTipoSubastaSareb().equals(prc.getTipoProcedimiento().getCodigo())) {
			return DDTipoSubasta.NDE;
		}
		// ------
		
		Asunto asunto = prc.getAsunto();
		Subasta sub = subastaProcedimientoApi.obtenerSubastaByPrcId(prc.getId());
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
}
