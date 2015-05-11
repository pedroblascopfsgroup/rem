package es.pfsgroup.recovery.recobroConfig.politicasDeAcuerdo.controller.api;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;

import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaAcuerdosPalancaDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaDeAcuerdosDto;

public interface RecobroPoliticaDeAcuerdosControllerApi {
	
	/**
	 * Método que devuelve el jsp de búsqueda, alta, baja y modificación de Políticas de acuerdos
	 * @param map
	 * @return
	 */
	String openABMPoliticas( ModelMap map);
	
	/**
	 * Dado un dto de búsqueda devuelve una página que contiene una lista de objetos RecobroPoliticaDeAcuerdos
	 * que cumplen los criterios de búsqueda
	 * @param dto
	 * @param map
	 * @return
	 */
	String buscaPoliticasAcuerdos(RecobroPoliticaDeAcuerdosDto dto, ModelMap map );
	
	/**
	 * Método que llamará al mánager de Políticas de acuerdos para borrar la política quee tenga el id 
	 * que se le pasa como 
	 * parámetro y todas sus relaciones de palancas. El borrado será un borrado lógico
	 * @param id
	 * @param map
	 * @return
	 */
	String borrarPoliticaAcuerdos(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	
	/**
	 * Método que devuelve el json donde se mapea el listado de palancas asociadas a la política cuyo 
	 * id coincide con el parámetro que se le pasa
	 * @param idPolitica
	 * @param map
	 * @return
	 */
	String buscaPalancasPolitica(@RequestParam(value = "idPolitica", required = true) Long idPolitica, ModelMap map);

	/**
	 * Abre la ventana de alta de políticas de acuerdo
	 * @param map
	 * @return
	 */
	String altaPoliticaAcuerdos(ModelMap map);
	
	/**
	 * Guarda una politica de acuerdos si le llega el id y si no crea una nueva.
	 * Una vez guardada se abrirá en una pestaña los datos de la política de acuerdos
	 * @param dto
	 * @param map
	 * @return
	 */
	String savePoliticaAcuerdos(RecobroPoliticaDeAcuerdosDto dto, ModelMap map);
	
	
	/**
	 * Abre una pestaña todos los datos correspondientes a la política de acuerdos cuyo id se le pasa como parámetro
	 * @param idPolitica
	 * @param map
	 * @return
	 */
	String abrirPoliticaAcuerdos(@RequestParam(value = "idPolitica", required = true) Long idPolitica, ModelMap map);

	/**
	 * Abre la ventana de alta de políticas pero con los datos de la política que queremos editar
	 * @param idPolitica
	 * @param map
	 * @return
	 */
	String editPoliticaAcuerdos(@RequestParam(value = "idPolitica", required = true) Long idPolitica, ModelMap map);
	
	/**
	 * Abre una ventana emergente para el alta de nuevas palancas asociadas a una política
	 * @param idPolitica
	 * @param map
	 * @return
	 */
	String addPalancaPolitica(@RequestParam(value = "idPolitica", required = true) Long idPolitica, ModelMap map);


	/**
	 * Guarda los datos de una palanca asociada a una política según los datos que se le pasan en el dto. 
	 * Si el id de palanca es null crea una nueva relación, si no modifica la ya existente
	 * @param dto
	 * @param map
	 * @return
	 */
	String savePalancaPolitica(RecobroPoliticaAcuerdosPalancaDto dto, ModelMap map);
	
	/**
	 * Borra la relación de una palanca con la política de acuerdos
	 * @param id
	 * @param map
	 * @return
	 */
	String borrarPalancaPoliticaAcuerdos(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Método que dado un código que tipo de palanca devuelve todos los subtipos de palanca que corresponden con ese tipo
	 * @param codigoTipoPalanca
	 * @param map
	 * @return
	 */
	String getSubtiposPalanca(String codigoTipoPalanca, ModelMap map);
	
	/**
	 * Abre la ventana de edición de palancas de políticas
	 * @param idPalanca
	 * @param map
	 * @return
	 */
	String editarPalancaPolitica(@RequestParam(value = "idPalanca", required = true) Long idPalanca, ModelMap map);

	/**
	 * Crea una nueva política de acuerdos que será una copia con todas sus dependencias de la que coincide 
	 * con el id que se le pasa como parámetro
	 * @param id
	 * @param map
	 * @return
	 */
	String copiarPoliticaAcuerdos(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Marca como Disponible una política de acuerdos que estaba en estado en Definición
	 * @param id
	 * @param map
	 * @return
	 */
	String liberarPoliticaAcuerdos(@RequestParam(value = "id", required = true) Long id, ModelMap map);
}
