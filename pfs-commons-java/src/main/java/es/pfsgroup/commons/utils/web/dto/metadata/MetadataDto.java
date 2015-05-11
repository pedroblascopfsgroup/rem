package es.pfsgroup.commons.utils.web.dto.metadata;

import java.io.Serializable;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;


public interface MetadataDto<T extends Serializable> extends Serializable {

	public class ReadOnlyDtoError extends RuntimeException {
		private static final long serialVersionUID = -980379742702928483L;

	}

	public static final String FORM_OPTION_LABEL_ALIGN = "labelAlign";
	public static final String FORM_OPTION_LABEL_WIDTH = "labelWidth";
	
	List<Entry<String, Object>> getData();
	
	Object getValue(String key);
	
	Map<String, Object> getValues();
	
	Map<String, List<Serializable>> getDictionaries();
	
	HashMap<String, List<Serializable>> getDictionary();

	List<MetadataField> getFields();
	
	Map<String, MetadataField> getField();
	
	HashMap<String, Object> getFormConfig();
	
	/**
	 * Inicializa el DTO con los datos del objeto.
	 * @param o
	 * @throws Exception
	 */
	void loadObject(T o) throws Exception;
	
	/**
	 * Crea un objeto a partir del contenido del DTO
	 * @return Devuelve el objeto recién creado
	 */
	T createObject() throws Exception;
	
	/**
	 * Actualiza un objeto con el contenido del DTO
	 * @param o Objeto a actualizar
	 * @return Devuelve el objeto ya actualizado
	 * @throws Exception
	 */
	T mergeObject(T o) throws Exception;
	
	/**
	 * Activa o desactiva el modo sólo-lectura.
	 * @param option
	 * @throws ReadOnlyDtoError
	 */
	void setReadOnly(boolean option) throws ReadOnlyDtoError;
	
	/**
	 * Nos dice si el DTO está en modo sólo-lectura
	 * @return
	 */
	boolean isReadOnly();
	
}
