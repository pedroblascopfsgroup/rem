package es.capgemini.devon.binding;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.convert.converters.Converter;
import org.springframework.binding.convert.converters.ObjectToCollection;
import org.springframework.binding.convert.converters.StringToBigDecimal;
import org.springframework.binding.convert.converters.StringToBigInteger;
import org.springframework.binding.convert.converters.StringToBoolean;
import org.springframework.binding.convert.converters.StringToByte;
import org.springframework.binding.convert.converters.StringToCharacter;
import org.springframework.binding.convert.converters.StringToDate;
import org.springframework.binding.convert.converters.StringToDouble;
import org.springframework.binding.convert.converters.StringToFloat;
import org.springframework.binding.convert.converters.StringToInteger;
import org.springframework.binding.convert.converters.StringToLabeledEnum;
import org.springframework.binding.convert.converters.StringToLocale;
import org.springframework.binding.convert.converters.StringToLong;
import org.springframework.binding.convert.converters.StringToShort;
import org.springframework.binding.convert.service.DefaultConversionService;

import es.capgemini.devon.utils.PropertyUtils;

/** Servicio de conversión de datos en el proceso de binding (datos de la request a objetos).
 * 
 * Depende del bean appProperties para configurar ciertos parámetros, como el formato de fecha
 * @author amarinso
 *
 */
//@Component("conversionService")
public class ConversionService extends DefaultConversionService {

    @Autowired(required = false)
    private List<Converter> converters = new ArrayList<Converter>();

    @Override
    protected void addDefaultConverters() {
        addConverter(new StringToByte());
        addConverter(new StringToBoolean());
        addConverter(new StringToCharacter());
        addConverter(new StringToShort());
        addConverter(new StringToInteger());
        addConverter(new StringToLong());
        addConverter(new StringToFloat());
        addConverter(new StringToDouble());
        addConverter(new StringToBigInteger());
        addConverter(new StringToBigDecimal());
        addConverter(new StringToLocale());
        //addConverter(new StringToDate());
        addConverter(new StringToLabeledEnum());
        addConverter(new ObjectToCollection(this));

        //este conversor lo configuramos desde las propiedades
        StringToDate stringToDate = new StringToDate();
        stringToDate.setPattern(PropertyUtils.getAppProperties().getProperty("dateFormat", "yyyyMMdd"));
        addConverter("fecha", stringToDate);
    }

    //    @Resource
    //    public void setParentConversionService(org.springframework.binding.convert.ConversionService appConversionService) {
    //        setParent(appConversionService);
    //    }

    @PostConstruct
    public void registrarConversores() {
        for (Converter c : converters) {
            if (c instanceof Alias) {
                addConverter(((Alias) c).getAlias(), c);
            } else {
                addConverter(c);
            }
        }

    }
}
