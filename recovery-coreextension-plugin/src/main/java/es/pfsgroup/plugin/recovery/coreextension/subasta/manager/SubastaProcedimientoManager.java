package es.pfsgroup.plugin.recovery.coreextension.subasta.manager;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.recovery.ext.impl.asunto.model.DDGestionAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

/**
 *
 */
@Service("subastaProcedimientoManager")
public class SubastaProcedimientoManager implements SubastaProcedimientoApi {

	@Autowired
	private GenericABMDao genericDao;	
	
    @Autowired
    private UtilDiccionarioApi utilDiccionario;
	
	@Autowired
	ProcedimientoManager procedimientoManager;
	
	protected final Log logger = LogFactory.getLog(getClass());
	private final BigDecimal MILLON = new BigDecimal("1000000");
	private final BigDecimal FIFTEEN_THOUSAND = new BigDecimal("15000");
	
	public LoteSubasta getLoteSubasta(Long idLote) {
		return genericDao.get(LoteSubasta.class, genericDao.createFilter(FilterType.EQUALS, "id", idLote), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_SUBASTA_CAMBIA_ESTADO_SUBASTA)
	public void cambiaEstadoSubasta(Long subId, String estado) {
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "id", subId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		DDEstadoSubasta esu = genericDao.get(DDEstadoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estado), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (!Checks.esNulo(sub) && !Checks.esNulo(esu)) {
			sub.setEstadoSubasta(esu);
			genericDao.save(Subasta.class, sub);
		}
	}

	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_MINIMO_BIEN_LOTE)
	public boolean comprobarMinimoBienLote(Long prcId) {

		Boolean enc = false;

		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (!Checks.esNulo(sub)) {
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (Checks.estaVacio(listadoLotes)) {
				// Si está vacío, es que la subasta no tiene lotes, por tanto,
				// no llega al mínimo
				enc = false;
			} else {
				for (LoteSubasta ls : listadoLotes) {
					if (Checks.estaVacio(ls.getBienes())) {
						// Si entre todos los lotes que tiene la
						// subasta, no hay
						// ningún bien, no llega al mínimo
						enc = false;
					}
					return true; // Hemos encontrado al menos un bien
				}
			}
		}

		return enc;
	}

	

	/**
	 * Devuelve true si las costas del letrado es mayor que el 5% del principal
	 * de la subasta
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_COSTAS_LETRADO_SUPERIOR_PRINCIPAL)
	public boolean comprobarCostasLetradoSuperiorPrincipal(Long prcId) {

		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
		BigDecimal importe = prc.getSaldoRecuperacion(); // FIXME principal???

		BigDecimal costas = BigDecimal.valueOf(sub.getCostasLetrado());
		BigDecimal importe5PorCiento = importe.multiply(new BigDecimal(5)).divide(new BigDecimal(100));

		if (costas.doubleValue() > importe5PorCiento.doubleValue()) {
			return true;
		}

		return false;
	}

	/**
	 * Método que comprueba si existe un adjunto de tipo informa subasta para el
	 * procedimiento específico
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_ADJUNTO_INFORME_SUBASTA)
	public boolean comprobarAdjuntoInformeSubasta(Long prcId) {

		// FIXME temporalmente, devolvemos siempre TRUE
		return true;

		// // TODO insertar en TFA los nuevos tipos de adjuntos
		// MEJAdjuntoAsunto ada = genericDao.get(MEJAdjuntoAsunto.class,
		// genericDao.createFilter(FilterType.EQUALS, "procedimiento.id",
		// prcId),
		// genericDao.createFilter(FilterType.EQUALS, "tipoFichero.codigo",
		// "INS"));
		// if (!Checks.esNulo(ada)) {
		// return true;
		// }
		//
		// return true;
		// return false;
	}

	/**
	 * instrucciones de subasta deben tener seteados: los importes para la puja
	 * sin postores, puja con postores desde y puja con postores hasta, y que
	 * este asociado al lote la instrucción.
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_INFORMACION_COMPLETA_INSTRUCCIONES)
	public boolean comprobarInformacionCompletaInstrucciones(Long prcId) {

		boolean enc = false;
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		if (!Checks.esNulo(sub)) {
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (!Checks.esNulo(ls.getInsValorSubasta()) && !Checks.esNulo(ls.getInsPujaPostoresDesde()) && !Checks.esNulo(ls.getInsPujaPostoresHasta())) {
						enc = true;
					} else {
						return false;
					}
				}
			}
		}

		return enc;
	}

	/**
	 * todos los lotes deben tener instrucción.
	 */
	@SuppressWarnings("unused")
	@Override
	@Deprecated
	@BusinessOperation(BO_SUBASTA_COMPROBAR_LOTES_CONTIENEN_INSTRUCCIONES)
	public boolean comprobarLotesContienenInstrucciones(Long prcId) {

		boolean enc = false;
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		if (!Checks.esNulo(sub)) {
			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = genericDao.getList(LoteSubasta.class, genericDao.createFilter(FilterType.EQUALS, "subasta.id", sub.getId()));
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {

				}
			}
		}

		return enc;
	}

	/**
	 * todos los bienes que vayan asociados a un lote deben tener su tasacion
	 * asignada y esta no debe estar obsoleta, esta obsoleta si su antiguedad es
	 * mayor a 3 meses antes de la fecha de celebración de la subasta
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_CADUCIDAD_BIENES_LOTE)
	public boolean comprobarCaducidadBienesLote(Long prcId) {

		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		Boolean noCaducado = true;

		if (!Checks.esNulo(sub)) {
			Date fechaCelebracion = sub.getFechaSenyalamiento();

			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							//TODO
							//Si no esta informado el tipo de Subasta
							//Boolean isTipoSubasta = (Boolean) executor.execute(SubastaProcedimientoDelegateApi.BO_SUBASTA_IS_BIEN_WITH_TIPO_SUBASTA,b.getId());
							//if (!isTipoSubasta){
								//return false;
							//}
							Long diferencia = restaFechas(b.getFechaVerificacion(), fechaCelebracion);
							if (diferencia.intValue() > 3) {
								return false; // En el momento que
												// encontremos una
												// tasación caducada, se
												// devuelve
												// FALSE
							}
						}
					}
				}
			}
		}

		return noCaducado;
	}

	private Long restaFechas(Date fechaMenor, Date fechaMayor) {
		long in = fechaMayor.getTime();
		long fin = fechaMenor.getTime();
		return (fin - in) / (1000 * 60 * 60 * 24);

	}

	/**
	 * Método que comprueba si existe un adjunto de tipo acta de subasta para el
	 * procedimiento específico
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_ADJUNTO_ACTA_SUBASTA)
	public boolean comprobarAdjuntoActaSubasta(Long prcId) {

		// TODO insertar en TFA los nuevos tipos de adjuntos
		// MEJAdjuntoAsunto ada = genericDao.get(MEJAdjuntoAsunto.class,
		// genericDao.createFilter(FilterType.EQUALS, "procedimiento.id",
		// prcId),
		// genericDao.createFilter(FilterType.EQUALS, "tipoFichero.codigo",
		// "ACS"));
		// if (!Checks.esNulo(ada)) {
		// return true;
		// }

		// FIXME temporalmente, devolvemos siempre TRUE
		return true;
		// return false;
	}

	/**
	 * Por cada bien, debe tener informado el importe y el resultado de la
	 * subasta
	 */
	@Override
	public boolean comprobarInfoBien(Long prcId) {
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (!Checks.esNulo(sub)) {

			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			if (!Checks.estaVacio(listadoLotes)) {
				for (LoteSubasta ls : listadoLotes) {
					if (Checks.estaVacio(ls.getBienes())) {
						for (Bien b : ls.getBienes()) {
							if (Checks.esNulo(b.getImporteCargas())) {
								return false;
							}
						}
					}
				}
			}
		}
		return true;
	}

	@Override
	@BusinessOperation(BO_SUBASTA_OBTENER_SUB_BY_PRC_ID)
	public Subasta obtenerSubastaByPrcId(Long prcId) {

		return genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

	}

	@Override
	@BusinessOperation(BO_SUBASTA_OBTENER_VALORES_TAREA_BY_TEX_ID)
	public List<EXTTareaExternaValor> obtenerValoresTareaByTexId(Long texId) {
		return genericDao.getList(EXTTareaExternaValor.class, genericDao.createFilter(FilterType.EQUALS, "tareaExterna.id", texId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	@BusinessOperation(BO_SUBASTA_IS_DEMANDADO_PER_JURIDICA)
	public boolean comprobarIsDemandadoPerJuridica(Long prcId) {
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId), genericDao.createFilter(FilterType.EQUALS,"borrado", false));
		for(Persona p: prc.getPersonasAfectadas()){
			if(!DDTipoPersona.CODIGO_TIPO_PERSONA_JURIDICA.equals(p.getTipoPersona().getCodigo())){
				//Se ha encontrado una persona NO jurídica
				return false;
			}
		}
		//Todas las personas son jurídicas
		return true;
	}

	@Override
	@BusinessOperation(BO_SUBASTA_OBTENER_PROPIEDAD_ASUNTO)
	public String obtenerPropiedadAsunto(Long prcId) {
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId), genericDao.createFilter(FilterType.EQUALS,"borrado", false));
		EXTAsunto asu = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", prc.getAsunto().getId()));
		if(!Checks.esNulo(asu.getPropiedadAsunto())){
			return asu.getPropiedadAsunto().getCodigo();
		}
		return null;
		
	}

	
	@Override
	@BusinessOperation(BO_SUBASTA_BPM_GET_VALORES_RAMAS_CELEBRACION)
	public Boolean[] bpmGetValoresRamasCelebracion(Procedimiento prc, TareaExterna tex){
		Boolean[] resultado = {false, false, false, false, false, false, false, false};
		
		List<TareaExternaValor> listadoValores = new ArrayList<TareaExternaValor>();

		String celebrada = "";
		String suspendida = "";
		String comboComite = "";
		boolean bienAdjuEntidad = false;
		boolean bienAdjuTerceroFondo = false;		
		
		// Obtenemos la lista de valores de esa tarea
		listadoValores = tex.getValores();
		for (TareaExternaValor val : listadoValores) {
			if ("comboCelebrada".equals(val.getNombre())){
				celebrada =  val.getValor();
			}
			else if ("comboSuspension".equals(val.getNombre())){
				suspendida =  val.getValor();
			}
			else if ("comboComite".equals(val.getNombre())){
				comboComite =  val.getValor();
			}
		}	
			
		
		/////////////////
		if("02".equals(celebrada)){		
			//A - suspendida terceros
			if("TER".equals(suspendida)){
				resultado[0] = true;
				return resultado;
			}			
			//B - suspendida entidad
			if("ENT".equals(suspendida)){
				resultado[1] = true;
				return resultado;
			}
		} else{
			
			//C - H

			Boolean cesionRemateRequierePreparacion = false;
			Boolean cesionRemateNoRequierePreparacion = false;
			Boolean todosBienesCesionRemate = true;
			List<Bien> listadoBienes = getBienesSubastaByPrcId(prc.getId());
			for(Bien b : listadoBienes){
				if(b instanceof NMBBien){
					NMBBien bien = (NMBBien) b;
					if(!Checks.esNulo(bien.getAdjudicacion()) && !Checks.esNulo(bien.getAdjudicacion().getCesionRemate()) && bien.getAdjudicacion().getCesionRemate() && "01".equals(comboComite)){
						cesionRemateRequierePreparacion = true;
					}
					if(!Checks.esNulo(bien.getAdjudicacion()) && !Checks.esNulo(bien.getAdjudicacion().getCesionRemate()) && bien.getAdjudicacion().getCesionRemate() && "02".equals(comboComite)){
						cesionRemateNoRequierePreparacion = true;
					}
					if(!Checks.esNulo(bien.getAdjudicacion()) && !Checks.esNulo(bien.getAdjudicacion().getEntidadAdjudicataria())){
						if(bien.getAdjudicacion().getEntidadAdjudicataria().getCodigo().compareTo(DDEntidadAdjudicataria.ENTIDAD) == 0){
							bienAdjuEntidad = true;
						}
						else{
							bienAdjuTerceroFondo = true;
						}
					}
					if(todosBienesCesionRemate && !Checks.esNulo(bien.getAdjudicacion()) && !Checks.esNulo(bien.getAdjudicacion().getCesionRemate()) && bien.getAdjudicacion().getCesionRemate()){
						todosBienesCesionRemate = true;
					}
					else{
						todosBienesCesionRemate = false;
					}
				}
			}
			
			//Cesion de remate
			
			//C - Preparar cesión remate
			//D - Cesión de remate
			if(todosBienesCesionRemate){
				if("01".equals(comboComite)){
					resultado[2] = true;
				}
				else if("02".equals(comboComite)){
					resultado[3] = true;
				}
			} else{
				if(cesionRemateRequierePreparacion){
					resultado[2] = true;
				}
				if(cesionRemateNoRequierePreparacion){
					resultado[3] = true;
				}
			}
			//E - Celebrada
			if("01".compareTo(celebrada)==0){
				resultado[4] = true;
			}			
			//F - Algún bien tiene adjudicación entidad sin cesión de remate
			//G - Por cada bien con adjudicación entidad un T. de adjudicación
			if(bienAdjuEntidad){
				resultado[5] = true;
				resultado[6] = true;
			}
			//H - Algún bien tiene adjudicación a tercero o fondo y sin cesión de remate
			if(bienAdjuTerceroFondo){
				resultado[7] = true;
			}
		}		
		
		return resultado;
	}
	
	public List<Bien> getBienesSubastaByPrcId(Long prcId){
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		
		List<Bien> bienes = new ArrayList<Bien>();
		
		if (!Checks.esNulo(sub)) {

			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			
			if (!Checks.estaVacio(listadoLotes)) {
				for(int i=0; i<listadoLotes.size(); i++){		
					bienes.addAll(listadoLotes.get(i).getBienes());
				}
			}
		}
		
		return bienes;
	}

	
	@Override
	@BusinessOperation(BO_SUBASTA_BPM_DAME_TIPO_SUBASTA)
	public String dameTipoSubasta(Long prcId){
		
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		
		if (!Checks.esNulo(sub)) {
			return sub.getTipoSubasta().getCodigo();
		}
		
		return null;
	}	
	
	@Override
	@BusinessOperation(BO_SUBASTA_BPM_PREPARAR_DECIDIR_PROPUESTA_SUBASTA)
	public String decidirPrepararPropuestaSubasta(Long prcId){
		
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (!Checks.esNulo(sub)) {
			determinarTipoSubasta(sub);
		
			if(DDTipoSubasta.NDE.equals(sub.getTipoSubasta().getCodigo())){
				return "subastaNoDelegada";
			}
		}
		else if(comprobarIsDemandadoPerJuridica(prcId)){
			return "subastaDelegadaPersonaJuridica";
		}
		
		return "subastaDelegada";
	}
	
	/**
	 * Función que valida si todos los bienes asociados al procedimiento de subasta que recibe como parámetro
	 * tienen informada la provincia, la localidad y el número de finca.
	 * @param prcId id procedimiento
	 * @return boolean en función de si pasa o no la validación
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_PROV_LOC_FIN_BIEN)
	public boolean comprobarProvLocFinBien(Long prcId) {

		List<Bien> listadoBienes = getBienesSubastaByPrcId(prcId);
		
		for(Bien bien: listadoBienes) {
			
			NMBBien nmbBien = (NMBBien) bien;
			
			if (Checks.esNulo(nmbBien.getLocalizacionActual())
					|| Checks.esNulo(nmbBien.getLocalizacionActual().getProvincia()) 
                    || Checks.esNulo(nmbBien.getLocalizacionActual().getLocalidad())
                    || Checks.esNulo(nmbBien.getDatosRegistralesActivo())
                    || Checks.esNulo(nmbBien.getDatosRegistralesActivo().getNumFinca())
                    || Checks.esNulo(nmbBien.getAdicional())
                    || Checks.esNulo(nmbBien.getAdicional().getTipoInmueble())
                    || Checks.esNulo(nmbBien.getAdicional().getTipoInmueble().getCodigo())) {
				return false;
			}

		}		

		return true;
	}

	/**
	 *	Función que valida si las costas del letrado introducidas en la tarea que recibe como parámetro
	 *  superan el 5% del principal para el caso de tener algún bien asociado al procedimiento de subasta que recibe como parámetro
	 *  @param prcId id procedimiento
	 *  @param texId id tarea
	 *  @return boolean en función de si pasa o no la validación
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_COSTAS_LETRADO_VIVIENDA_HABITUAL)
	public boolean comprobarCostasLetradoViviendaHabitual(Long prcId, Long texId) {
		
		// Averiguamos el importe principal
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
		BigDecimal principal = prc.getSaldoRecuperacion(); // FIXME principal???

		// Calculamos el 5% del principal
		BigDecimal princpal5PorCiento = principal.multiply(new BigDecimal(5)).divide(new BigDecimal(100));

		// Averiguamos las costas indicadas en la tarea
		String valueCostas = genericDao.get(EXTTareaExternaValor.class, genericDao.createFilter(FilterType.EQUALS, "tareaExterna.id", texId), genericDao.createFilter(FilterType.EQUALS, "borrado", false), genericDao.createFilter(FilterType.EQUALS, "nombre", "costasLetrado")).getValor();
		BigDecimal costas = Checks.esNulo(valueCostas) ? null : new BigDecimal(valueCostas);
			
		// Comprobamos si algún bien es vivienda habitual
		List<Bien> listadoBienes = getBienesSubastaByPrcId(prcId);		
		boolean isViviendaHabitual = false;
		
		for(Bien bien: listadoBienes) {
			
			NMBBien nmbBien = (NMBBien) bien;
			
			if ("1".equals(nmbBien.getViviendaHabitual())) {
				isViviendaHabitual=true;
			}
		}
		
		// Si hay algún bien que es vivienda habitual y las costas superan el 5% del principal se devuelve false para mostrar el error correspondiente.
		if (isViviendaHabitual && (!Checks.esNulo(costas) && costas.doubleValue() > princpal5PorCiento.doubleValue())) {
			return false;
		}		

		return true;
	}
	
	/**
	 * Funcion que valida si entre los bienes de una subasta adjudicados a terceros
	 * existe alguno que no sea vivienda habitual.
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_NO_VIVIENDA_HABITUAL_TERCEROS)
	public boolean isNotViviendaHabitualAdjTerceros(Long prcId){
		
		List<Bien> listadoBienes = getBienesSubastaByPrcId(prcId);
		for(Bien bien: listadoBienes) {
			
			NMBBien nmbBien = (NMBBien) bien;
			if(!Checks.esNulo(nmbBien.getAdjudicacion()) && 
					!Checks.esNulo(nmbBien.getAdjudicacion().getEntidadAdjudicataria()) &&
					DDEntidadAdjudicataria.TERCEROS.equals(nmbBien.getAdjudicacion().getEntidadAdjudicataria().getCodigo())){
				if (!("1".equals(nmbBien.getViviendaHabitual()))) {
					return true;
				}
			}
		}
		return false;
	}
	
	/**
	 * Determina el tipo de subasta tras la propuesta de lotes de subasta 
	 * 
	 * PRODUCTO-700 -> Logica para determinar si una subasta es delegada o no delegada.
	 * 
	 * @param prc
	 * @return
	 */
	public void determinarTipoSubasta(Subasta subasta) {

		// Las NO DELEGADAS no hace nada.
//		if (subasta.getTipoSubasta() != null && DDTipoSubasta.NDE.equals(subasta.getTipoSubasta().getCodigo())) {
//			loguear("Condicion 0", subasta.getId());
//			return;
//		}
		
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
		if (!Checks.esNulo(subasta.getCargasAnteriores()) && !"0".equals(subasta.getCargasAnteriores())) {
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
		
		// Si no cumple ninguna condición, seteamos a DELEGADA para cubrir el camino inverso
		// siempre y cuando la subasta no se encuentre ya en DELEGADA
		if(DDTipoSubasta.NDE.equals(subasta.getTipoSubasta().getCodigo())){
			modificarTipoSubastaDelegada(subasta);
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
	 * Cambia el tipo de subasta a no delegada
	 * @param subasta
	 */
	private void modificarTipoSubastaDelegada(Subasta subasta) {
		DDTipoSubasta tipoSubastaNoDelegada = (DDTipoSubasta) utilDiccionario.dameValorDiccionarioByCod(DDTipoSubasta.class, DDTipoSubasta.DEL);

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

		if(!Checks.esNulo(subasta.getLotesSubasta())){
			for (LoteSubasta lote : subasta.getLotesSubasta()) {
				bienesSubasta.addAll(lote.getBienes());
			}
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
			sumatorioDeudaEntidad = sumatorioDeudaEntidad.add(BigDecimal.valueOf(subasta.getCostasLetrado()));
		}
		if (!Checks.esNulo(subasta.getCostasProcurador())){
			sumatorioDeudaEntidad = sumatorioDeudaEntidad.add(BigDecimal.valueOf(subasta.getCostasProcurador()));
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
		
		if(!Checks.esNulo(subasta.getLotesSubasta())){
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
	
				if (!Checks.esNulo(lote.getRiesgoConsignacion()) 
						&& lote.getRiesgoConsignacion() 
						&& !isNegative(riesgodeConsignacion)
						&& (riesgodeConsignacion.compareTo(tenPercentDeudaEntidad) > 0  
								|| riesgodeConsignacion.compareTo(FIFTEEN_THOUSAND) > 0)) {
					return true;
				}
			}
		}

		return false;
	}
	
	private boolean isNegative(BigDecimal b) {
        return b.signum() == -1;
    }

}
