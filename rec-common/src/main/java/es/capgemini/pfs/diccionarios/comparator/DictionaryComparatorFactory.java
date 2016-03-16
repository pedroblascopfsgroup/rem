package es.capgemini.pfs.diccionarios.comparator;

import java.text.Collator;

import es.capgemini.devon.utils.MessageUtils;

public class DictionaryComparatorFactory {

	public static final String COMPARATOR_BY_CODIGO = "COMPARATOR_BY_CODIGO";
	public static final String COMPARATOR_BY_DESCRIPCION = "COMPARATOR_BY_DESCRIPCION";
	
	private static DictionaryComparatorFactory dictionaryComparatorFactory;
	
	public static synchronized DictionaryComparatorFactory getInstance() 
	{
		if(dictionaryComparatorFactory == null) {
			dictionaryComparatorFactory = new DictionaryComparatorFactory();
		}
		
		return dictionaryComparatorFactory;		
	}
	
	public IDictionaryComparator create(String tipoDiccionario) 
	{
		Collator c = Collator.getInstance(MessageUtils.DEFAULT_LOCALE);
		return this.create(tipoDiccionario, c);		
	}
	
	public IDictionaryComparator create(String tipoDiccionario, Collator c) 
	{
		if(tipoDiccionario.equals(COMPARATOR_BY_CODIGO)) {
			return new CodigoDictionaryComparator(c);
		}
		else if(tipoDiccionario.equals(COMPARATOR_BY_DESCRIPCION)) {
			return new DescripcionDictionaryComparator(c);
		}
		else {
			return null;
		}
	}
}
