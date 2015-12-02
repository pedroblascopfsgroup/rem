package es.pfsgroup.plugin.recovery.coreextension.subasta.manager;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
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
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	ProcedimientoManager procedimientoManager;
	
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

}
