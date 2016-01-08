package es.capgemini.devon.binding;

import org.springframework.binding.convert.converters.Converter;

public interface Alias extends Converter {

    public String getAlias();
}
