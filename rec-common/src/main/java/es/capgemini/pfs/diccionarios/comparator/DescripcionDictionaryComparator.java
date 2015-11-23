package es.capgemini.pfs.diccionarios.comparator;

import java.text.Collator;

import es.capgemini.pfs.diccionarios.Dictionary;

public class DescripcionDictionaryComparator implements
		IDictionaryComparator {

	private Collator collator;
	
	public DescripcionDictionaryComparator(Collator c) 
	{
		this.collator = c;
	}
	
	@Override
	public int compare(Dictionary o1, Dictionary o2) 
	{
		return collator.compare(o1.getDescripcion(), o2.getDescripcion());
	}
}
