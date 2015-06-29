package es.capgemini.pfs.integration;


public class JsonAsuntoPayloadTransformer extends AbstractJsonPayloadTransformer {

    public JsonAsuntoPayloadTransformer(Translator translator) {
		super(translator);
	}

	@Override
	public Class<?> getDeserializedClass() {
		return AsuntoPayload.class;
	}	

}
